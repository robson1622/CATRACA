#include <lvgl.h>
#include "ui/ui.h"
#include <Arduino_GFX_Library.h>
#include <TAMC_GT911.h>
#include "SDInterface.h"
#include "TripData.h"
#include "ui/actions.h"
#include "TripInstructions.h"
#include "BluetoothReceiver.h" // Include the BluetoothReceiver class

#define STATIC_UI_MAX_INDEX 500 // Adjust this based on your static UI elements

// Global trips array
const int MAX_TRIPS = 5; // Adjust based on available memory
TripData trips[MAX_TRIPS];

#define TFT_BL 27
#define GFX_BL DF_GFX_BL // Default backlight pin

// Setup touch
#define TOUCH_GT911
#define TOUCH_GT911_SCL 32
#define TOUCH_GT911_SDA 33
#define TOUCH_GT911_INT -1
#define TOUCH_GT911_RST 25
#define TOUCH_GT911_ROTATION ROTATION_LEFT  //ROTATION_NORMAL
#define TOUCH_MAP_X1 320
#define TOUCH_MAP_X2 0
#define TOUCH_MAP_Y1 240
#define TOUCH_MAP_Y2 0

// Display initialization
Arduino_DataBus *bus = new Arduino_ESP32SPI(2 /* DC */, 15 /* CS */, 14 /* SCK */, 13 /* MOSI */, GFX_NOT_DEFINED /* MISO */);
Arduino_GFX *gfx = new Arduino_ST7789(bus, -1 /* RST */, ROTATION_LEFT /* rotation */, true /* IPS */);
TAMC_GT911 ts = TAMC_GT911(TOUCH_GT911_SDA, TOUCH_GT911_SCL, TOUCH_GT911_INT, TOUCH_GT911_RST, max(TOUCH_MAP_X1, TOUCH_MAP_X2), max(TOUCH_MAP_Y1, TOUCH_MAP_Y2));

static lv_disp_draw_buf_t draw_buf;
static lv_color_t *disp_draw_buf;
static lv_disp_drv_t disp_drv;

extern lv_event_t g_eez_event;
extern bool g_eez_event_handled;

SDInterface sd(SD_CS);

#define RXD2 22 
#define TXD2 27 
GPS *gps = new GPS(Serial2);

// Create an instance of BluetoothReceiver
BluetoothReceiver bluetoothReceiver;

void getBluetoothData() {
  if (bluetoothReceiver.isComplete()) {
    String response = bluetoothReceiver.getResponse();
    Serial.println("Received JSON: " + response);

    // Save the received JSON to trip.json on the SD card
    File file = SD.open("/trip.json", FILE_WRITE);
    if (file) {
      file.print(response);
      file.close();
      Serial.println("Data saved to trip.json");
      lv_obj_clear_flag(objects.go_to_trip_info_btn, LV_OBJ_FLAG_HIDDEN);
      lv_obj_add_flag(objects.previous_route, LV_OBJ_FLAG_HIDDEN);
      lv_obj_add_flag(objects.roda_ble, LV_OBJ_FLAG_HIDDEN);
    } else {
      Serial.println("Failed to open trip.json for writing");
    }

    // Clear the response for the next message
    bluetoothReceiver.clearResponse();
  }
}

void my_disp_flush(lv_disp_drv_t *disp, const lv_area_t *area, lv_color_t *color_p) {
  uint32_t w = (area->x2 - area->x1 + 1);
  uint32_t h = (area->y2 - area->y1 + 1);

#if (LV_COLOR_16_SWAP != 0)
  gfx->draw16bitBeRGBBitmap(area->x1, area->y1, (uint16_t *)&color_p->full, w, h);
#else
  gfx->draw16bitRGBBitmap(area->x1, area->y1, (uint16_t *)&color_p->full, w, h);
#endif

  lv_disp_flush_ready(disp);
}

void my_touchpad_read(lv_indev_drv_t *indev_driver, lv_indev_data_t *data) {
  ts.read();
  if (ts.isTouched) {
    data->state = LV_INDEV_STATE_PR;
    data->point.x = ts.points[0].x;
    data->point.y = ts.points[0].y;
  } else {
    data->state = LV_INDEV_STATE_REL;
  }
}

void setup() {
  // Initialize display
  gfx->begin();
  gfx->fillScreen(BLACK);
#ifdef TFT_BL
  pinMode(TFT_BL, OUTPUT);
  digitalWrite(TFT_BL, HIGH);
#endif

  ts.begin();
  ts.setRotation(1);

  lv_init();

  disp_draw_buf = (lv_color_t *)malloc(sizeof(lv_color_t) * gfx->width() * gfx->height() / 2);
  lv_disp_draw_buf_init(&draw_buf, disp_draw_buf, NULL, gfx->width() * gfx->height() / 2);

  lv_disp_drv_init(&disp_drv);
  disp_drv.hor_res = gfx->width();
  disp_drv.ver_res = gfx->height();
  disp_drv.flush_cb = my_disp_flush;
  disp_drv.draw_buf = &draw_buf;
  lv_disp_drv_register(&disp_drv);

  // Register the custom touch-input handler
  static lv_indev_drv_t indev_drv;
  lv_indev_drv_init(&indev_drv);
  indev_drv.type = LV_INDEV_TYPE_POINTER;
  indev_drv.read_cb = my_touchpad_read;
  lv_indev_drv_register(&indev_drv);

  // Init EEZ-Studio UI
  ui_init();

  Serial.begin(115200);

  // Initialize the SD card
  if (!sd.begin()) {
    Serial.println("SD Card initialization failed!");
    return;
  }
  Serial.println("SD Card initialized.");

  gps->begin(9600, RXD2, TXD2);

  // Initialize BLE
  bluetoothReceiver.setupBLE();
}

void cleanupHistoryPage() {
  lv_obj_t *child;
  while ((child = lv_obj_get_child(objects.history_container, NULL)) != NULL) {
    lv_obj_del(child);
  }
}

void loadAndDisplayTripHistory() {
  // Clean up existing widgets
  cleanupHistoryPage();

  // Load trip history from CSV
  int totalTrips = 0;

  File file = SD.open("/trips.csv");
  if (!file) {
    Serial.println("Failed to open trips.csv");
    return;
  }

  // Skip header line
  file.readStringUntil('\n');

  // Read and parse each line
  while (file.available() && totalTrips < MAX_TRIPS) {
    String line = file.readStringUntil('\n');
    trips[totalTrips].parseCSVLine(line);
    totalTrips++;
  }
  file.close();

  delay(100); // Wait for the file to close

  // Create UI components for each trip
  lv_coord_t yPos = 0; // Vertical position for each entry
  int widgetIndex = STATIC_UI_MAX_INDEX + 1; // Start index for widget objects (after static UI elements)

  for (int i = 0; i < totalTrips; i++) {
    // Create a container for the trip entry
    lv_obj_t *tripEntry = lv_obj_create(objects.history_container);
    lv_obj_set_size(tripEntry, 220, 70); // Match the size of the autogenerated containers
    lv_obj_set_pos(tripEntry, 10, yPos);
    lv_obj_set_style_pad_all(tripEntry, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(tripEntry, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(tripEntry, 0, LV_PART_MAIN | LV_STATE_DEFAULT);

    // Use the widget to create the trip container
    create_user_widget_trip_container(tripEntry, widgetIndex);

    // Helper function to truncate strings for display
    auto truncateForDisplay = [](const String &input, int maxLength) -> String {
      if (input.length() <= maxLength) {
        return input;
      }
      return input.substring(0, maxLength) + "...";
    };

    // Update widget labels with trip data (truncate start and end points if necessary)
    lv_label_set_text(((lv_obj_t **)&objects)[widgetIndex + 3], truncateForDisplay(trips[i].getEndPoint(), 8).c_str()); // end_point_label_1
    lv_label_set_text(((lv_obj_t **)&objects)[widgetIndex + 4], truncateForDisplay(trips[i].getStartPoint(), 8).c_str()); // start_point_lab_1
    lv_label_set_text(((lv_obj_t **)&objects)[widgetIndex + 1], trips[i].getDistance().c_str()); // distace_label_1
    lv_label_set_text(((lv_obj_t **)&objects)[widgetIndex + 2], trips[i].getDate().c_str()); // date_1

    // Add event callback to the trip_details button
    lv_obj_t *tripDetailsButton = ((lv_obj_t **)&objects)[widgetIndex + 0]; // Assuming trip_details button is at index 0
    lv_obj_add_event_cb(tripDetailsButton, action_trip_details_button, LV_EVENT_CLICKED, (void *)(intptr_t)i);

    yPos += 80; // Adjust spacing between entries
    widgetIndex += 5; // Increment widget index for the next trip
    delay(10); // Delay to allow the UI to update
  }
}

void updateGPSmainScree() {
  delay(100);
  // Update GPS data on the main screen
  lv_label_set_text(objects.altitude_label, String(gps->getAltitude()).c_str());
  lv_label_set_text(objects.latitude_label, String(gps->getLatitude(), 6).c_str());
  lv_label_set_text(objects.longitude_label, String(gps->getLongitude(), 6).c_str());
  lv_label_set_text(objects.speed_label, String(gps->getSpeed()).c_str()); 
  lv_label_set_text(objects.satellites_label, String(gps->getSatellites()).c_str());
  lv_label_set_text(objects.gps_fix_label, gps->getFix().c_str());
}

void loadSDScreen() {
  String files = sd.listDirToString("/", 0);
  String test_file = sd.readFileToString("/testeleituras.txt");

  uint64_t total_sd = 0;
  uint64_t used_sd = 0;
  sd.getCardInfo(total_sd, used_sd);
  lv_bar_set_range(objects.sd_bar, 0, total_sd);
  lv_bar_set_value(objects.sd_bar, used_sd, LV_ANIM_ON);

  float total_sd_gb = total_sd / (1024.0 * 1024.0 * 1024.0);
  float used_sd_gb = used_sd / (1024.0 * 1024.0 * 1024.0);
  float usage_sd = (used_sd_gb * 100.0) / total_sd_gb;

  char used_sd_str[10];
  char total_sd_str[10];
  char usage_sd_str[10];

  snprintf(used_sd_str, sizeof(used_sd_str), "%.2f GB", used_sd_gb);
  snprintf(total_sd_str, sizeof(total_sd_str), "%.2f GB", total_sd_gb);
  snprintf(usage_sd_str, sizeof(usage_sd_str), "%.1f %%", usage_sd);

  lv_label_set_text(objects.used_sd_info, used_sd_str);
  lv_label_set_text(objects.total_sd_info, total_sd_str);
  lv_label_set_text(objects.percentage_sd_info, usage_sd_str);

  lv_label_set_text(objects.files_label, files.c_str());
}

void loop() {
  lv_timer_handler();
  ui_tick();

  // If the current screen is the main screen, update GPS data
  if (lv_scr_act() == objects.main || lv_scr_act() == objects.instructions_screen) {
    gps->loop();
    updateGPSmainScree();
  }

  if (lv_scr_act() == objects.instructions_screen) {
    gps->loop();
    updateInstructions(gps->getLatitude(), gps->getLongitude(), *gps);
  }

  if (g_eez_event_handled) {
    lv_obj_t *obj = lv_event_get_target(&g_eez_event);
    Serial.printf("Event handled: %u\n", obj);
    g_eez_event_handled = false;

    if (obj == objects.settings_screen_btn) {
      lv_scr_load(objects.settings_screen);
    } else if (obj == objects.back_settings_main_btn) {
      lv_scr_load(objects.main);
    } else if (obj == objects.bluetooth_settings_btn) {
      lv_scr_load(objects.bluetooth_settings_screen_);
    } else if (obj == objects.back_settings_screen_btn) {
      lv_scr_load(objects.settings_screen);
    } else if (obj == objects.sd_card_settings_btn) {
      lv_scr_load(objects.sd_card_settings_screen);
      loadSDScreen();
    } else if (obj == objects.back_settings_screen_btn_1) {
      lv_scr_load(objects.settings_screen);
    } else if (obj == objects.trips_screen_button) {
      lv_scr_load(objects.trips_log_screen);
      loadAndDisplayTripHistory();
    } else if (obj == objects.backto_main_btn) {
      cleanupHistoryPage(); // Clean up before navigating away
      lv_scr_load(objects.main);
    } else if (obj == objects.back_to_log_button) {
      lv_scr_load(objects.trips_log_screen);
    } else if(obj == objects.new_route_btn) {
      lv_scr_load(objects.new_route);
      getBluetoothData();
      if (bluetoothReceiver.isComplete()) {
        lv_obj_clear_flag(objects.go_to_trip_info_btn, LV_OBJ_FLAG_HIDDEN);
        lv_obj_add_flag(objects.roda_ble, LV_OBJ_FLAG_HIDDEN);
      }
    } else if(obj == objects.new_route_back_main) {
      lv_scr_load(objects.main);
    } else if(obj == objects.go_to_trip_info_btn){
      lv_scr_load(objects.trips_info_page);
    } else if(obj == objects.go_back_new_route){
      lv_scr_load(objects.new_route);
    } else if(obj == objects.go_to_trip_btn || obj == objects.previous_route){
      lv_scr_load(objects.instructions_screen);
    } else if(obj == objects.cancel_trip){
      lv_scr_load(objects.main);
    }
  }
}