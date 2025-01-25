#include <stdbool.h>
#include "actions.h"

lv_event_t g_eez_event = {};
bool g_eez_event_handled = false;

void action_button_action_handler(lv_event_t *e) {
    g_eez_event = *e;
    g_eez_event_handled = true;
}
