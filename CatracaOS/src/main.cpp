#include <lvgl.h>
#include "ui/ui.h"
#include <Arduino_GFX_Library.h>
#include <TAMC_GT911.h>

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
}

void loop() {
  lv_timer_handler();
  // Update EEZ-Studio UI
  ui_tick();

  if(g_eez_event_handled) {
    lv_obj_t * obj = lv_event_get_target(&g_eez_event);
    Serial.printf("Event handled:  %u\n", obj);
    g_eez_event_handled = false;


    if(obj == objects.settings_screen_btn)
      lv_scr_load(objects.settings_screen);
    else if(obj == objects.back_settings_main_btn)
      lv_scr_load(objects.main);
    else if(obj == objects.bluetooth_settings_btn)
      lv_scr_load(objects.bluetooth_settings_screen_);
    else if (obj == objects.back_settings_screen_btn)
      lv_scr_load(objects.settings_screen);
  }

}