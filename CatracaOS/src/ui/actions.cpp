#include <stdbool.h>
#include "actions.h"
#include "screens.h"
#include "TripData.h" // Include the TripData header

lv_event_t g_eez_event = {};
bool g_eez_event_handled = false;

extern TripData trips[]; // Access the global trips array

void action_button_action_handler(lv_event_t *e) {
    g_eez_event = *e;
    g_eez_event_handled = true;
}

void updateTripDetailsScreen(int tripIndex) {
  // Load the trip data for the given index
  TripData trip = trips[tripIndex]; // Access the global trips array

  Serial.print("AQUI");

  // Update the trip details screen with the trip data
  lv_label_set_text(objects.trip_details_start_label, trip.getStartPoint().c_str());
  lv_label_set_text(objects.trip_details_end_label, trip.getEndPoint().c_str());
  lv_label_set_text(objects.trip_details_distance_label, trip.getDistance().c_str());
  lv_label_set_text(objects.trip_details_duration_label, trip.getDuration().c_str());
  lv_label_set_text(objects.trip_details_date_label, trip.getDate().c_str());
  lv_label_set_text(objects.trip_details_max_speed_label, trip.getMaxSpeed().c_str());
  lv_label_set_text(objects.trip_details_avg_speed_label, trip.getAverageSpeed().c_str());
}

void action_trip_details_button(lv_event_t *e) {
    lv_obj_t *obj = lv_event_get_target(e);
    int tripIndex = (int)(intptr_t)lv_event_get_user_data(e); // Retrieve the trip index from user data

    // Load the trip details screen
    lv_scr_load(objects.trip_details_screen);

    // Pass the trip data to the details screen
    updateTripDetailsScreen(tripIndex);
}