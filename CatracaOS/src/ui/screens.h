#ifndef EEZ_LVGL_UI_SCREENS_H
#define EEZ_LVGL_UI_SCREENS_H

#include <lvgl.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct _objects_t {
    lv_obj_t *main;
    lv_obj_t *load_screen;
    lv_obj_t *settings_screen;
    lv_obj_t *bluetooth_settings_screen_;
    lv_obj_t *settings_screen_btn;
    lv_obj_t *obj0;
    lv_obj_t *new_route_screen_btn;
    lv_obj_t *a;
    lv_obj_t *list_screen_btn;
    lv_obj_t *obj1;
    lv_obj_t *obj1__clock;
    lv_obj_t *obj1__gps_signal;
    lv_obj_t *obj1__baytery;
    lv_obj_t *load_bar;
    lv_obj_t *obj2;
    lv_obj_t *obj2__clock;
    lv_obj_t *obj2__gps_signal;
    lv_obj_t *obj2__baytery;
    lv_obj_t *back_settings_main_btn;
    lv_obj_t *bluetooth_panel_1;
    lv_obj_t *bluetooth_settings_btn;
    lv_obj_t *obj3;
    lv_obj_t *obj3__clock;
    lv_obj_t *obj3__gps_signal;
    lv_obj_t *obj3__baytery;
    lv_obj_t *back_settings_screen_btn;
    lv_obj_t *bt_settings_panel;
    lv_obj_t *bluetooth_name_panel_3;
    lv_obj_t *bluetooth_panel_2;
    lv_obj_t *bluetooth_swtich_1;
    lv_obj_t *obj4;
    lv_obj_t *bluetooth_name_label;
} objects_t;

extern objects_t objects;

enum ScreensEnum {
    SCREEN_ID_MAIN = 1,
    SCREEN_ID_LOAD_SCREEN = 2,
    SCREEN_ID_SETTINGS_SCREEN = 3,
    SCREEN_ID_BLUETOOTH_SETTINGS_SCREEN_ = 4,
};

void create_screen_main();
void tick_screen_main();

void create_screen_load_screen();
void tick_screen_load_screen();

void create_screen_settings_screen();
void tick_screen_settings_screen();

void create_screen_bluetooth_settings_screen_();
void tick_screen_bluetooth_settings_screen_();

void create_user_widget_header(lv_obj_t *parent_obj, int startWidgetIndex);
void tick_user_widget_header(int startWidgetIndex);

void create_screens();
void tick_screen(int screen_index);


#ifdef __cplusplus
}
#endif

#endif /*EEZ_LVGL_UI_SCREENS_H*/