#ifndef EEZ_LVGL_UI_SCREENS_H
#define EEZ_LVGL_UI_SCREENS_H

#include <lvgl.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct _objects_t {
    lv_obj_t *main;
    lv_obj_t *settings_screen;
    lv_obj_t *bluetooth_settings_screen_;
    lv_obj_t *sd_card_settings_screen;
    lv_obj_t *trips_log_screen;
    lv_obj_t *trip_details_screen;
    lv_obj_t *new_route;
    lv_obj_t *trips_info_page;
    lv_obj_t *instructions_screen;
    lv_obj_t *settings_screen_btn;
    lv_obj_t *new_route_btn;
    lv_obj_t *new_route_screen_btn;
    lv_obj_t *trips_screen_button;
    lv_obj_t *list_screen_btn;
    lv_obj_t *satellites_label;
    lv_obj_t *altitude_label;
    lv_obj_t *latitude_label;
    lv_obj_t *longitude_label;
    lv_obj_t *speed_label;
    lv_obj_t *gps_fix_label;
    lv_obj_t *obj0;
    lv_obj_t *obj0__clock;
    lv_obj_t *obj0__gps_signal;
    lv_obj_t *obj0__baytery_level;
    lv_obj_t *back_settings_main_btn;
    lv_obj_t *bluetooth_panel_1;
    lv_obj_t *bluetooth_settings_btn;
    lv_obj_t *bluetooth_panel_3;
    lv_obj_t *sd_card_settings_btn;
    lv_obj_t *obj1;
    lv_obj_t *obj1__clock;
    lv_obj_t *obj1__gps_signal;
    lv_obj_t *obj1__baytery_level;
    lv_obj_t *back_settings_screen_btn;
    lv_obj_t *bt_settings_panel;
    lv_obj_t *bluetooth_name_panel_3;
    lv_obj_t *bluetooth_panel_2;
    lv_obj_t *bluetooth_swtich_1;
    lv_obj_t *obj2;
    lv_obj_t *obj2__clock;
    lv_obj_t *obj2__gps_signal;
    lv_obj_t *obj2__baytery_level;
    lv_obj_t *back_settings_screen_btn_1;
    lv_obj_t *bt_settings_panel_1;
    lv_obj_t *used_sd_info;
    lv_obj_t *total_sd_info;
    lv_obj_t *percentage_sd_info;
    lv_obj_t *sd_bar;
    lv_obj_t *files_label;
    lv_obj_t *history_container;
    lv_obj_t *backto_main_btn;
    lv_obj_t *obj3;
    lv_obj_t *obj3__clock;
    lv_obj_t *obj3__gps_signal;
    lv_obj_t *obj3__baytery_level;
    lv_obj_t *back_to_log_button;
    lv_obj_t *obj4;
    lv_obj_t *trip_details_date_label;
    lv_obj_t *obj5;
    lv_obj_t *trip_details_end_label;
    lv_obj_t *trip_details_start_label;
    lv_obj_t *obj6;
    lv_obj_t *trip_details_duration_label;
    lv_obj_t *obj7;
    lv_obj_t *trip_details_distance_label;
    lv_obj_t *obj8;
    lv_obj_t *trip_details_max_speed_label;
    lv_obj_t *obj9;
    lv_obj_t *trip_details_avg_speed_label;
    lv_obj_t *obj10;
    lv_obj_t *new_route_back_main;
    lv_obj_t *go_to_trip_info_btn;
    lv_obj_t *obj11;
    lv_obj_t *go_back_new_route;
    lv_obj_t *obj12;
    lv_obj_t *trip_details_end_label_1;
    lv_obj_t *trip_details_start_label_1;
    lv_obj_t *obj13;
    lv_obj_t *estimated_distance_label;
    lv_obj_t *estimated_time_label;
    lv_obj_t *go_to_trip_btn;
    lv_obj_t *timer_label;
    lv_obj_t *speed_label_trip;
    lv_obj_t *instruction_text_area;
    lv_obj_t *settings_screen_btn_1;
    lv_obj_t *pause_trip;
    lv_obj_t *new_route_screen_btn_1;
    lv_obj_t *cancel_trip;
    lv_obj_t *list_screen_btn_1;
    lv_obj_t *distance_label;
    lv_obj_t *time_for_next_instruction;
} objects_t;

extern objects_t objects;

enum ScreensEnum {
    SCREEN_ID_MAIN = 1,
    SCREEN_ID_SETTINGS_SCREEN = 2,
    SCREEN_ID_BLUETOOTH_SETTINGS_SCREEN_ = 3,
    SCREEN_ID_SD_CARD_SETTINGS_SCREEN = 4,
    SCREEN_ID_TRIPS_LOG_SCREEN = 5,
    SCREEN_ID_TRIP_DETAILS_SCREEN = 6,
    SCREEN_ID_NEW_ROUTE = 7,
    SCREEN_ID_TRIPS_INFO_PAGE = 8,
    SCREEN_ID_INSTRUCTIONS_SCREEN = 9,
};

void create_screen_main();
void tick_screen_main();

void create_screen_settings_screen();
void tick_screen_settings_screen();

void create_screen_bluetooth_settings_screen_();
void tick_screen_bluetooth_settings_screen_();

void create_screen_sd_card_settings_screen();
void tick_screen_sd_card_settings_screen();

void create_screen_trips_log_screen();
void tick_screen_trips_log_screen();

void create_screen_trip_details_screen();
void tick_screen_trip_details_screen();

void create_screen_new_route();
void tick_screen_new_route();

void create_screen_trips_info_page();
void tick_screen_trips_info_page();

void create_screen_instructions_screen();
void tick_screen_instructions_screen();

void create_user_widget_header(lv_obj_t *parent_obj, int startWidgetIndex);
void tick_user_widget_header(int startWidgetIndex);

void create_user_widget_trip_container(lv_obj_t *parent_obj, int startWidgetIndex);
void tick_user_widget_trip_container(int startWidgetIndex);

void create_user_widget_trip_details(lv_obj_t *parent_obj, int startWidgetIndex);
void tick_user_widget_trip_details(int startWidgetIndex);

void create_screens();
void tick_screen(int screen_index);


#ifdef __cplusplus
}
#endif

#endif /*EEZ_LVGL_UI_SCREENS_H*/