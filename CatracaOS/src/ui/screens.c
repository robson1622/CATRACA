#include <string.h>

#include "screens.h"
#include "images.h"
#include "fonts.h"
#include "actions.h"
#include "vars.h"
#include "styles.h"
#include "ui.h"

#include <string.h>

objects_t objects;
lv_obj_t *tick_value_change_obj;

void create_screen_main() {
    lv_obj_t *obj = lv_obj_create(0);
    objects.main = obj;
    lv_obj_set_pos(obj, 0, 0);
    lv_obj_set_size(obj, 240, 320);
    {
        lv_obj_t *parent_obj = obj;
        {
            lv_obj_t *obj = lv_obj_create(parent_obj);
            lv_obj_set_pos(obj, 41, 257);
            lv_obj_set_size(obj, 157, 60);
            lv_obj_clear_flag(obj, LV_OBJ_FLAG_CLICKABLE|LV_OBJ_FLAG_CLICK_FOCUSABLE|LV_OBJ_FLAG_GESTURE_BUBBLE|LV_OBJ_FLAG_PRESS_LOCK|LV_OBJ_FLAG_SCROLLABLE|LV_OBJ_FLAG_SCROLL_CHAIN_VER|LV_OBJ_FLAG_SCROLL_MOMENTUM|LV_OBJ_FLAG_SCROLL_WITH_ARROW|LV_OBJ_FLAG_SNAPPABLE);
            lv_obj_set_style_arc_rounded(obj, true, LV_PART_MAIN | LV_STATE_DEFAULT);
            {
                lv_obj_t *parent_obj = obj;
                {
                    // SettingsScreenBtn
                    lv_obj_t *obj = lv_btn_create(parent_obj);
                    objects.settings_screen_btn = obj;
                    lv_obj_set_pos(obj, 92, -5);
                    lv_obj_set_size(obj, 40, 40);
                    lv_obj_add_event_cb(obj, action_button_action_handler, LV_EVENT_RELEASED, (void *)0);
                    lv_obj_set_style_bg_color(obj, lv_color_hex(0xff39cb4f), LV_PART_MAIN | LV_STATE_DEFAULT);
                    {
                        lv_obj_t *parent_obj = obj;
                        {
                            lv_obj_t *obj = lv_label_create(parent_obj);
                            lv_obj_set_pos(obj, 1, 0);
                            lv_obj_set_size(obj, LV_SIZE_CONTENT, LV_SIZE_CONTENT);
                            lv_label_set_text(obj, "o");
                            lv_obj_set_style_text_font(obj, &lv_font_montserrat_18, LV_PART_MAIN | LV_STATE_DEFAULT);
                        }
                    }
                }
                {
                    lv_obj_t *obj = lv_btn_create(parent_obj);
                    objects.obj0 = obj;
                    lv_obj_set_pos(obj, 44, -5);
                    lv_obj_set_size(obj, 40, 40);
                    lv_obj_set_style_bg_color(obj, lv_color_hex(0xff39cb4f), LV_PART_MAIN | LV_STATE_DEFAULT);
                    {
                        lv_obj_t *parent_obj = obj;
                        {
                            // NewRouteScreenBtn
                            lv_obj_t *obj = lv_label_create(parent_obj);
                            objects.new_route_screen_btn = obj;
                            lv_obj_set_pos(obj, 1, 2);
                            lv_obj_set_size(obj, LV_SIZE_CONTENT, LV_SIZE_CONTENT);
                            lv_label_set_text(obj, "+");
                            lv_obj_set_style_text_font(obj, &lv_font_montserrat_18, LV_PART_MAIN | LV_STATE_DEFAULT);
                        }
                    }
                }
                {
                    // a
                    lv_obj_t *obj = lv_btn_create(parent_obj);
                    objects.a = obj;
                    lv_obj_set_pos(obj, -4, -5);
                    lv_obj_set_size(obj, 40, 40);
                    lv_obj_set_style_bg_color(obj, lv_color_hex(0xff39cb4f), LV_PART_MAIN | LV_STATE_DEFAULT);
                    {
                        lv_obj_t *parent_obj = obj;
                        {
                            // ListScreenBtn
                            lv_obj_t *obj = lv_label_create(parent_obj);
                            objects.list_screen_btn = obj;
                            lv_obj_set_pos(obj, -3, -2);
                            lv_obj_set_size(obj, LV_SIZE_CONTENT, LV_SIZE_CONTENT);
                            lv_label_set_text(obj, " =");
                            lv_obj_set_style_text_font(obj, &lv_font_montserrat_18, LV_PART_MAIN | LV_STATE_DEFAULT);
                        }
                        {
                            lv_obj_t *obj = lv_label_create(parent_obj);
                            lv_obj_set_pos(obj, -3, 7);
                            lv_obj_set_size(obj, LV_SIZE_CONTENT, LV_SIZE_CONTENT);
                            lv_label_set_text(obj, " =");
                            lv_obj_set_style_text_font(obj, &lv_font_montserrat_18, LV_PART_MAIN | LV_STATE_DEFAULT);
                        }
                    }
                }
            }
        }
        {
            lv_obj_t *obj = lv_obj_create(parent_obj);
            objects.obj1 = obj;
            lv_obj_set_pos(obj, 0, 0);
            lv_obj_set_size(obj, 240, 23);
            lv_obj_set_style_pad_left(obj, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
            lv_obj_set_style_pad_top(obj, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
            lv_obj_set_style_pad_right(obj, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
            lv_obj_set_style_pad_bottom(obj, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
            lv_obj_set_style_bg_opa(obj, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
            lv_obj_set_style_border_width(obj, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
            create_user_widget_header(obj, 10);
        }
    }
}

void tick_screen_main() {
    tick_user_widget_header(10);
}

void create_screen_settings_screen() {
    lv_obj_t *obj = lv_obj_create(0);
    objects.settings_screen = obj;
    lv_obj_set_pos(obj, 0, 0);
    lv_obj_set_size(obj, 240, 320);
    {
        lv_obj_t *parent_obj = obj;
        {
            lv_obj_t *obj = lv_obj_create(parent_obj);
            objects.obj2 = obj;
            lv_obj_set_pos(obj, 0, 0);
            lv_obj_set_size(obj, 240, 320);
            lv_obj_set_style_pad_left(obj, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
            lv_obj_set_style_pad_top(obj, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
            lv_obj_set_style_pad_right(obj, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
            lv_obj_set_style_pad_bottom(obj, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
            lv_obj_set_style_bg_opa(obj, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
            lv_obj_set_style_border_width(obj, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
            create_user_widget_header(obj, 14);
        }
        {
            lv_obj_t *obj = lv_obj_create(parent_obj);
            lv_obj_set_pos(obj, 90, 257);
            lv_obj_set_size(obj, 60, 60);
            lv_obj_clear_flag(obj, LV_OBJ_FLAG_CLICK_FOCUSABLE|LV_OBJ_FLAG_GESTURE_BUBBLE|LV_OBJ_FLAG_PRESS_LOCK|LV_OBJ_FLAG_SCROLLABLE|LV_OBJ_FLAG_SCROLL_CHAIN_HOR|LV_OBJ_FLAG_SCROLL_CHAIN_VER|LV_OBJ_FLAG_SCROLL_ELASTIC|LV_OBJ_FLAG_SCROLL_MOMENTUM|LV_OBJ_FLAG_SCROLL_WITH_ARROW|LV_OBJ_FLAG_SNAPPABLE);
            {
                lv_obj_t *parent_obj = obj;
                {
                    // BackSettingsMainBtn
                    lv_obj_t *obj = lv_btn_create(parent_obj);
                    objects.back_settings_main_btn = obj;
                    lv_obj_set_pos(obj, -5, -5);
                    lv_obj_set_size(obj, 40, 40);
                    lv_obj_add_event_cb(obj, action_button_action_handler, LV_EVENT_RELEASED, (void *)0);
                    lv_obj_set_style_bg_color(obj, lv_color_hex(0xff39cb4f), LV_PART_MAIN | LV_STATE_DEFAULT);
                    {
                        lv_obj_t *parent_obj = obj;
                        {
                            lv_obj_t *obj = lv_label_create(parent_obj);
                            lv_obj_set_pos(obj, 1, 2);
                            lv_obj_set_size(obj, LV_SIZE_CONTENT, LV_SIZE_CONTENT);
                            lv_label_set_text(obj, "<");
                            lv_obj_set_style_text_font(obj, &lv_font_montserrat_18, LV_PART_MAIN | LV_STATE_DEFAULT);
                        }
                    }
                }
            }
        }
        {
            lv_obj_t *obj = lv_label_create(parent_obj);
            lv_obj_set_pos(obj, 84, 22);
            lv_obj_set_size(obj, LV_SIZE_CONTENT, LV_SIZE_CONTENT);
            lv_label_set_text(obj, "Settings");
            lv_obj_set_style_text_font(obj, &lv_font_montserrat_18, LV_PART_MAIN | LV_STATE_DEFAULT);
        }
        {
            lv_obj_t *obj = lv_obj_create(parent_obj);
            lv_obj_set_pos(obj, 5, 47);
            lv_obj_set_size(obj, 230, 205);
            {
                lv_obj_t *parent_obj = obj;
                {
                    // bluetooth_panel_1
                    lv_obj_t *obj = lv_obj_create(parent_obj);
                    objects.bluetooth_panel_1 = obj;
                    lv_obj_set_pos(obj, -10, -4);
                    lv_obj_set_size(obj, 209, 53);
                    lv_obj_clear_flag(obj, LV_OBJ_FLAG_SCROLLABLE|LV_OBJ_FLAG_SCROLL_ELASTIC);
                    {
                        lv_obj_t *parent_obj = obj;
                        {
                            lv_obj_t *obj = lv_label_create(parent_obj);
                            lv_obj_set_pos(obj, -5, 4);
                            lv_obj_set_size(obj, LV_SIZE_CONTENT, LV_SIZE_CONTENT);
                            lv_label_set_text(obj, "Bluetooth");
                            lv_obj_set_style_text_font(obj, &lv_font_montserrat_14, LV_PART_MAIN | LV_STATE_DEFAULT);
                        }
                        {
                            // Bluetooth_settings_btn
                            lv_obj_t *obj = lv_btn_create(parent_obj);
                            objects.bluetooth_settings_btn = obj;
                            lv_obj_set_pos(obj, 149, -7);
                            lv_obj_set_size(obj, 38, 38);
                            lv_obj_add_event_cb(obj, action_button_action_handler, LV_EVENT_RELEASED, (void *)0);
                            lv_obj_set_style_bg_color(obj, lv_color_hex(0xff39cb4f), LV_PART_MAIN | LV_STATE_DEFAULT);
                            {
                                lv_obj_t *parent_obj = obj;
                                {
                                    lv_obj_t *obj = lv_label_create(parent_obj);
                                    lv_obj_set_pos(obj, 2, 3);
                                    lv_obj_set_size(obj, LV_SIZE_CONTENT, LV_SIZE_CONTENT);
                                    lv_label_set_text(obj, ">");
                                }
                            }
                        }
                    }
                }
            }
        }
        {
            // bluetooth_panel_3
            lv_obj_t *obj = lv_obj_create(parent_obj);
            objects.bluetooth_panel_3 = obj;
            lv_obj_set_pos(obj, 10, 123);
            lv_obj_set_size(obj, 209, 53);
            lv_obj_clear_flag(obj, LV_OBJ_FLAG_SCROLLABLE|LV_OBJ_FLAG_SCROLL_ELASTIC);
            {
                lv_obj_t *parent_obj = obj;
                {
                    lv_obj_t *obj = lv_label_create(parent_obj);
                    lv_obj_set_pos(obj, -5, 4);
                    lv_obj_set_size(obj, LV_SIZE_CONTENT, LV_SIZE_CONTENT);
                    lv_label_set_text(obj, "SD Card");
                    lv_obj_set_style_text_font(obj, &lv_font_montserrat_14, LV_PART_MAIN | LV_STATE_DEFAULT);
                }
                {
                    // sd_card_settings_btn
                    lv_obj_t *obj = lv_btn_create(parent_obj);
                    objects.sd_card_settings_btn = obj;
                    lv_obj_set_pos(obj, 149, -7);
                    lv_obj_set_size(obj, 38, 38);
                    lv_obj_add_event_cb(obj, action_button_action_handler, LV_EVENT_RELEASED, (void *)0);
                    lv_obj_set_style_bg_color(obj, lv_color_hex(0xff39cb4f), LV_PART_MAIN | LV_STATE_DEFAULT);
                    {
                        lv_obj_t *parent_obj = obj;
                        {
                            lv_obj_t *obj = lv_label_create(parent_obj);
                            lv_obj_set_pos(obj, 2, 3);
                            lv_obj_set_size(obj, LV_SIZE_CONTENT, LV_SIZE_CONTENT);
                            lv_label_set_text(obj, ">");
                        }
                    }
                }
            }
        }
    }
}

void tick_screen_settings_screen() {
    tick_user_widget_header(14);
}

void create_screen_bluetooth_settings_screen_() {
    lv_obj_t *obj = lv_obj_create(0);
    objects.bluetooth_settings_screen_ = obj;
    lv_obj_set_pos(obj, 0, 0);
    lv_obj_set_size(obj, 240, 320);
    {
        lv_obj_t *parent_obj = obj;
        {
            lv_obj_t *obj = lv_obj_create(parent_obj);
            objects.obj3 = obj;
            lv_obj_set_pos(obj, 0, 0);
            lv_obj_set_size(obj, 240, 320);
            lv_obj_set_style_pad_left(obj, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
            lv_obj_set_style_pad_top(obj, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
            lv_obj_set_style_pad_right(obj, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
            lv_obj_set_style_pad_bottom(obj, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
            lv_obj_set_style_bg_opa(obj, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
            lv_obj_set_style_border_width(obj, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
            create_user_widget_header(obj, 23);
        }
        {
            lv_obj_t *obj = lv_obj_create(parent_obj);
            lv_obj_set_pos(obj, 90, 257);
            lv_obj_set_size(obj, 60, 60);
            lv_obj_clear_flag(obj, LV_OBJ_FLAG_CLICK_FOCUSABLE|LV_OBJ_FLAG_GESTURE_BUBBLE|LV_OBJ_FLAG_PRESS_LOCK|LV_OBJ_FLAG_SCROLLABLE|LV_OBJ_FLAG_SCROLL_CHAIN_HOR|LV_OBJ_FLAG_SCROLL_CHAIN_VER|LV_OBJ_FLAG_SCROLL_ELASTIC|LV_OBJ_FLAG_SCROLL_MOMENTUM|LV_OBJ_FLAG_SCROLL_WITH_ARROW|LV_OBJ_FLAG_SNAPPABLE);
            {
                lv_obj_t *parent_obj = obj;
                {
                    // BackSettingsScreenBtn
                    lv_obj_t *obj = lv_btn_create(parent_obj);
                    objects.back_settings_screen_btn = obj;
                    lv_obj_set_pos(obj, -5, -5);
                    lv_obj_set_size(obj, 40, 40);
                    lv_obj_add_event_cb(obj, action_button_action_handler, LV_EVENT_RELEASED, (void *)0);
                    lv_obj_set_style_bg_color(obj, lv_color_hex(0xff39cb4f), LV_PART_MAIN | LV_STATE_DEFAULT);
                    {
                        lv_obj_t *parent_obj = obj;
                        {
                            lv_obj_t *obj = lv_label_create(parent_obj);
                            lv_obj_set_pos(obj, 1, 2);
                            lv_obj_set_size(obj, LV_SIZE_CONTENT, LV_SIZE_CONTENT);
                            lv_label_set_text(obj, "<");
                            lv_obj_set_style_text_font(obj, &lv_font_montserrat_18, LV_PART_MAIN | LV_STATE_DEFAULT);
                        }
                    }
                }
            }
        }
        {
            lv_obj_t *obj = lv_label_create(parent_obj);
            lv_obj_set_pos(obj, 76, 22);
            lv_obj_set_size(obj, LV_SIZE_CONTENT, LV_SIZE_CONTENT);
            lv_label_set_text(obj, "Bluetooth");
            lv_obj_set_style_text_font(obj, &lv_font_montserrat_18, LV_PART_MAIN | LV_STATE_DEFAULT);
        }
        {
            // bt_settings_panel
            lv_obj_t *obj = lv_obj_create(parent_obj);
            objects.bt_settings_panel = obj;
            lv_obj_set_pos(obj, 5, 47);
            lv_obj_set_size(obj, 230, 205);
            lv_obj_clear_flag(obj, LV_OBJ_FLAG_CLICK_FOCUSABLE|LV_OBJ_FLAG_SCROLL_CHAIN_VER|LV_OBJ_FLAG_SCROLL_ELASTIC);
            {
                lv_obj_t *parent_obj = obj;
                {
                    // bluetooth_name_panel_3
                    lv_obj_t *obj = lv_obj_create(parent_obj);
                    objects.bluetooth_name_panel_3 = obj;
                    lv_obj_set_pos(obj, -8, -3);
                    lv_obj_set_size(obj, 208, 53);
                    lv_obj_clear_flag(obj, LV_OBJ_FLAG_SCROLLABLE|LV_OBJ_FLAG_SCROLL_ELASTIC|LV_OBJ_FLAG_SCROLL_MOMENTUM);
                    {
                        lv_obj_t *parent_obj = obj;
                        {
                            lv_obj_t *obj = lv_label_create(parent_obj);
                            lv_obj_set_pos(obj, -5, 4);
                            lv_obj_set_size(obj, LV_SIZE_CONTENT, LV_SIZE_CONTENT);
                            lv_label_set_text(obj, "Device Name:");
                            lv_obj_set_style_text_font(obj, &lv_font_montserrat_14, LV_PART_MAIN | LV_STATE_DEFAULT);
                        }
                        {
                            lv_obj_t *obj = lv_label_create(parent_obj);
                            lv_obj_set_pos(obj, 105, 4);
                            lv_obj_set_size(obj, LV_SIZE_CONTENT, LV_SIZE_CONTENT);
                            lv_label_set_text(obj, "CATRACA");
                            lv_obj_set_style_text_font(obj, &lv_font_montserrat_14, LV_PART_MAIN | LV_STATE_DEFAULT);
                        }
                    }
                }
                {
                    // bluetooth_panel_2
                    lv_obj_t *obj = lv_obj_create(parent_obj);
                    objects.bluetooth_panel_2 = obj;
                    lv_obj_set_pos(obj, -8, 61);
                    lv_obj_set_size(obj, 208, 53);
                    lv_obj_clear_flag(obj, LV_OBJ_FLAG_SCROLLABLE|LV_OBJ_FLAG_SCROLL_ELASTIC|LV_OBJ_FLAG_SCROLL_MOMENTUM);
                    {
                        lv_obj_t *parent_obj = obj;
                        {
                            lv_obj_t *obj = lv_label_create(parent_obj);
                            lv_obj_set_pos(obj, -5, 4);
                            lv_obj_set_size(obj, LV_SIZE_CONTENT, LV_SIZE_CONTENT);
                            lv_label_set_text(obj, "Bluetooth");
                            lv_obj_set_style_text_font(obj, &lv_font_montserrat_14, LV_PART_MAIN | LV_STATE_DEFAULT);
                        }
                        {
                            // bluetooth_swtich_1
                            lv_obj_t *obj = lv_switch_create(parent_obj);
                            objects.bluetooth_swtich_1 = obj;
                            lv_obj_set_pos(obj, 131, -1);
                            lv_obj_set_size(obj, 50, 25);
                            lv_obj_add_state(obj, LV_STATE_CHECKED);
                            lv_obj_set_style_bg_color(obj, lv_color_hex(0xff39cb4f), LV_PART_INDICATOR | LV_STATE_DEFAULT);
                            lv_obj_set_style_bg_color(obj, lv_color_hex(0xff39cb4f), LV_PART_INDICATOR | LV_STATE_SCROLLED);
                            lv_obj_set_style_bg_color(obj, lv_color_hex(0xff39cb4f), LV_PART_INDICATOR | LV_STATE_EDITED);
                            lv_obj_set_style_bg_color(obj, lv_color_hex(0xff39cb4f), LV_PART_INDICATOR | LV_STATE_FOCUS_KEY);
                            lv_obj_set_style_bg_color(obj, lv_color_hex(0xff39cb4f), LV_PART_INDICATOR | LV_STATE_CHECKED);
                            lv_obj_set_style_bg_color(obj, lv_color_hex(0xff39cb4f), LV_PART_MAIN | LV_STATE_CHECKED);
                        }
                    }
                }
            }
        }
    }
}

void tick_screen_bluetooth_settings_screen_() {
    tick_user_widget_header(23);
}

void create_screen_sd_card_settings_screen() {
    lv_obj_t *obj = lv_obj_create(0);
    objects.sd_card_settings_screen = obj;
    lv_obj_set_pos(obj, 0, 0);
    lv_obj_set_size(obj, 240, 320);
    {
        lv_obj_t *parent_obj = obj;
        {
            lv_obj_t *obj = lv_obj_create(parent_obj);
            objects.obj4 = obj;
            lv_obj_set_pos(obj, 0, 0);
            lv_obj_set_size(obj, 240, 320);
            lv_obj_set_style_pad_left(obj, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
            lv_obj_set_style_pad_top(obj, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
            lv_obj_set_style_pad_right(obj, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
            lv_obj_set_style_pad_bottom(obj, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
            lv_obj_set_style_bg_opa(obj, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
            lv_obj_set_style_border_width(obj, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
            create_user_widget_header(obj, 32);
        }
        {
            lv_obj_t *obj = lv_obj_create(parent_obj);
            lv_obj_set_pos(obj, 90, 257);
            lv_obj_set_size(obj, 60, 60);
            lv_obj_clear_flag(obj, LV_OBJ_FLAG_CLICK_FOCUSABLE|LV_OBJ_FLAG_GESTURE_BUBBLE|LV_OBJ_FLAG_PRESS_LOCK|LV_OBJ_FLAG_SCROLLABLE|LV_OBJ_FLAG_SCROLL_CHAIN_HOR|LV_OBJ_FLAG_SCROLL_CHAIN_VER|LV_OBJ_FLAG_SCROLL_ELASTIC|LV_OBJ_FLAG_SCROLL_MOMENTUM|LV_OBJ_FLAG_SCROLL_WITH_ARROW|LV_OBJ_FLAG_SNAPPABLE);
            {
                lv_obj_t *parent_obj = obj;
                {
                    // BackSettingsScreenBtn_1
                    lv_obj_t *obj = lv_btn_create(parent_obj);
                    objects.back_settings_screen_btn_1 = obj;
                    lv_obj_set_pos(obj, -5, -5);
                    lv_obj_set_size(obj, 40, 40);
                    lv_obj_add_event_cb(obj, action_button_action_handler, LV_EVENT_RELEASED, (void *)0);
                    lv_obj_set_style_bg_color(obj, lv_color_hex(0xff39cb4f), LV_PART_MAIN | LV_STATE_DEFAULT);
                    {
                        lv_obj_t *parent_obj = obj;
                        {
                            lv_obj_t *obj = lv_label_create(parent_obj);
                            lv_obj_set_pos(obj, 1, 2);
                            lv_obj_set_size(obj, LV_SIZE_CONTENT, LV_SIZE_CONTENT);
                            lv_label_set_text(obj, "<");
                            lv_obj_set_style_text_font(obj, &lv_font_montserrat_18, LV_PART_MAIN | LV_STATE_DEFAULT);
                        }
                    }
                }
            }
        }
        {
            lv_obj_t *obj = lv_label_create(parent_obj);
            lv_obj_set_pos(obj, 85, 22);
            lv_obj_set_size(obj, LV_SIZE_CONTENT, LV_SIZE_CONTENT);
            lv_label_set_text(obj, "SD Card");
            lv_obj_set_style_text_font(obj, &lv_font_montserrat_18, LV_PART_MAIN | LV_STATE_DEFAULT);
        }
        {
            // bt_settings_panel_1
            lv_obj_t *obj = lv_obj_create(parent_obj);
            objects.bt_settings_panel_1 = obj;
            lv_obj_set_pos(obj, 5, 47);
            lv_obj_set_size(obj, 230, 205);
            lv_obj_clear_flag(obj, LV_OBJ_FLAG_CLICK_FOCUSABLE|LV_OBJ_FLAG_SCROLLABLE|LV_OBJ_FLAG_SCROLL_CHAIN_VER|LV_OBJ_FLAG_SCROLL_ELASTIC);
        }
        {
            lv_obj_t *obj = lv_obj_create(parent_obj);
            lv_obj_set_pos(obj, 13, 56);
            lv_obj_set_size(obj, 214, 63);
            lv_obj_clear_flag(obj, LV_OBJ_FLAG_SCROLLABLE);
            lv_obj_set_style_pad_row(obj, 8, LV_PART_MAIN | LV_STATE_DEFAULT);
            lv_obj_set_style_pad_column(obj, 8, LV_PART_MAIN | LV_STATE_DEFAULT);
            {
                lv_obj_t *parent_obj = obj;
                {
                    // used_sd_info
                    lv_obj_t *obj = lv_label_create(parent_obj);
                    objects.used_sd_info = obj;
                    lv_obj_set_pos(obj, -8, 24);
                    lv_obj_set_size(obj, LV_SIZE_CONTENT, LV_SIZE_CONTENT);
                    lv_label_set_text(obj, "3.23 GB");
                    lv_obj_set_style_align(obj, LV_ALIGN_OUT_LEFT_MID, LV_PART_MAIN | LV_STATE_DEFAULT);
                }
                {
                    // total_sd_info
                    lv_obj_t *obj = lv_label_create(parent_obj);
                    objects.total_sd_info = obj;
                    lv_obj_set_pos(obj, 130, 24);
                    lv_obj_set_size(obj, LV_SIZE_CONTENT, LV_SIZE_CONTENT);
                    lv_label_set_text(obj, "31.67 GB");
                }
                {
                    // percentage_sd_info
                    lv_obj_t *obj = lv_label_create(parent_obj);
                    objects.percentage_sd_info = obj;
                    lv_obj_set_pos(obj, 78, 24);
                    lv_obj_set_size(obj, LV_SIZE_CONTENT, LV_SIZE_CONTENT);
                    lv_label_set_text(obj, "23%");
                    lv_obj_set_style_align(obj, LV_ALIGN_OUT_BOTTOM_MID, LV_PART_MAIN | LV_STATE_DEFAULT);
                }
                {
                    // sd_bar
                    lv_obj_t *obj = lv_bar_create(parent_obj);
                    objects.sd_bar = obj;
                    lv_obj_set_pos(obj, -8, -3);
                    lv_obj_set_size(obj, 199, 20);
                    lv_bar_set_value(obj, 25, LV_ANIM_OFF);
                    lv_obj_set_style_bg_color(obj, lv_color_hex(0xff39cb4f), LV_PART_MAIN | LV_STATE_DEFAULT);
                    lv_obj_set_style_text_color(obj, lv_color_hex(0xff39cb4f), LV_PART_MAIN | LV_STATE_DEFAULT);
                    lv_obj_set_style_bg_color(obj, lv_color_hex(0xff39cb4f), LV_PART_INDICATOR | LV_STATE_DEFAULT);
                }
            }
        }
        {
            lv_obj_t *obj = lv_obj_create(parent_obj);
            lv_obj_set_pos(obj, 13, 128);
            lv_obj_set_size(obj, 214, 115);
            {
                lv_obj_t *parent_obj = obj;
                {
                    // files_label
                    lv_obj_t *obj = lv_label_create(parent_obj);
                    objects.files_label = obj;
                    lv_obj_set_pos(obj, -8, -6);
                    lv_obj_set_size(obj, LV_SIZE_CONTENT, LV_SIZE_CONTENT);
                    lv_label_set_text(obj, "Files");
                }
            }
        }
    }
}

void tick_screen_sd_card_settings_screen() {
    tick_user_widget_header(32);
}

void create_user_widget_header(lv_obj_t *parent_obj, int startWidgetIndex) {
    lv_obj_t *obj = parent_obj;
    {
        lv_obj_t *parent_obj = obj;
        {
            // clock
            lv_obj_t *obj = lv_label_create(parent_obj);
            ((lv_obj_t **)&objects)[startWidgetIndex + 0] = obj;
            lv_obj_set_pos(obj, 2, 2);
            lv_obj_set_size(obj, LV_SIZE_CONTENT, LV_SIZE_CONTENT);
            lv_label_set_text(obj, "10:30");
        }
        {
            // gps_signal
            lv_obj_t *obj = lv_label_create(parent_obj);
            ((lv_obj_t **)&objects)[startWidgetIndex + 1] = obj;
            lv_obj_set_pos(obj, 86, 2);
            lv_obj_set_size(obj, LV_SIZE_CONTENT, LV_SIZE_CONTENT);
            lv_label_set_text(obj, "No Signal");
        }
        {
            // baytery
            lv_obj_t *obj = lv_label_create(parent_obj);
            ((lv_obj_t **)&objects)[startWidgetIndex + 2] = obj;
            lv_obj_set_pos(obj, 205, 2);
            lv_obj_set_size(obj, LV_SIZE_CONTENT, LV_SIZE_CONTENT);
            lv_label_set_text(obj, "100%");
        }
    }
}

void tick_user_widget_header(int startWidgetIndex) {
}


void create_screens() {
    lv_disp_t *dispp = lv_disp_get_default();
    lv_theme_t *theme = lv_theme_default_init(dispp, lv_palette_main(LV_PALETTE_BLUE), lv_palette_main(LV_PALETTE_RED), false, LV_FONT_DEFAULT);
    lv_disp_set_theme(dispp, theme);
    
    create_screen_main();
    create_screen_settings_screen();
    create_screen_bluetooth_settings_screen_();
    create_screen_sd_card_settings_screen();
}

typedef void (*tick_screen_func_t)();

tick_screen_func_t tick_screen_funcs[] = {
    tick_screen_main,
    tick_screen_settings_screen,
    tick_screen_bluetooth_settings_screen_,
    tick_screen_sd_card_settings_screen,
    0,
};

void tick_screen(int screen_index) {
    tick_screen_funcs[screen_index]();
}
