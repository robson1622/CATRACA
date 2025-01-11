#include <lvgl.h>
#include <ui.h>
#include <Arduino_GFX_Library.h>

//#include "TouchScreen.h"

#define TFT_BL 27
#define GFX_BL DF_GFX_BL // Default backlight pin

// Display initialization
Arduino_DataBus *bus = new Arduino_ESP32SPI(2 /* DC */, 15 /* CS */, 14 /* SCK */, 13 /* MOSI */, GFX_NOT_DEFINED /* MISO */);
Arduino_GFX *gfx = new Arduino_ST7789(bus, -1 /* RST */, 0 /* rotation */, true /* IPS */);

static lv_disp_draw_buf_t draw_buf;
static lv_color_t *disp_draw_buf;
static lv_disp_drv_t disp_drv;

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
/*
void my_touchpad_read(lv_indev_drv_t * indev_driver, lv_indev_data_t * data)
{
  // TODO: Replace with your custom touch-screen handling logic!

  TSPoint p = ts.getPoint();
  touched = (p.z > 375 && p.z < 415);

  float x = 1.0f * p.x - 200.0f;
  float y = 1.0f * p.y - 135.0f;
  x = (x / 685.0f) * 240.0f;
  y = (y / 735.0f) * 320.0f;

  x = (x - 480.0f) * -1.0f - 240;
  y = (y - 640.0f) * -1.0f - 320;

  if(touched && !coordinatesSet)
  {
    data->state = LV_INDEV_STATE_PR;

    
    data->point.x = x;
    data->point.y = y;

    coordinatesSet = true; 
  }
  
  if (!touched)
  {
    data->state = LV_INDEV_STATE_REL;
    coordinatesSet = false;
  }
}*/

void setup()
{
  // Initialize display
  gfx->begin();
  gfx->fillScreen(BLACK);
#ifdef TFT_BL
  pinMode(TFT_BL, OUTPUT);
  digitalWrite(TFT_BL, HIGH);
#endif

  lv_init();

  disp_draw_buf = (lv_color_t *)malloc(sizeof(lv_color_t) * gfx->width() * gfx->height() / 2);
  lv_disp_draw_buf_init(&draw_buf, disp_draw_buf, NULL, gfx->width() * gfx->height() / 2);

  lv_disp_drv_init(&disp_drv);
  disp_drv.hor_res = gfx->width();
  disp_drv.ver_res = gfx->height();
  disp_drv.flush_cb = my_disp_flush;
  disp_drv.draw_buf = &draw_buf;
  lv_disp_drv_register(&disp_drv);

/*
  // Register the custom touch-input handler
  static lv_indev_drv_t indev_drv;
  lv_indev_drv_init( &indev_drv );
  indev_drv.type = LV_INDEV_TYPE_POINTER;
  indev_drv.read_cb = my_touchpad_read;
  lv_indev_drv_register( &indev_drv );
*/
  // Init EEZ-Studio UI
  ui_init();
}

void loop() {
  lv_timer_handler();
  // Update EEZ-Studio UI
  ui_tick();
}
