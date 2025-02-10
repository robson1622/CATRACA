#include "TripInstructions.h"

std::vector<Step> steps;
size_t currentStep = 0;

float haversine(float lat1, float lon1, float lat2, float lon2) {
    float dLat = radians(lat2 - lat1);
    float dLon = radians(lon2 - lon1);
    float a = sin(dLat / 2) * sin(dLat / 2) +
              cos(radians(lat1)) * cos(radians(lat2)) *
              sin(dLon / 2) * sin(dLon / 2);
    float c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return EARTH_RADIUS * c;
}

// 🔹 Read JSON from SD Card and Parse Route
void parseJSON() {
    File file = SD.open(JSON_FILE);
    if (!file) {
        Serial.println("Failed to open JSON file!");
        return;
    }

    StaticJsonDocument<8192> doc;
    DeserializationError error = deserializeJson(doc, file);
    if (error) {
        Serial.println("Failed to parse JSON");
        file.close();
        return;
    }

    file.close();
    steps.clear();

    JsonArray routeSteps = doc["routes"][0]["legs"][0]["steps"];
    for (JsonObject stepObj : routeSteps) {
        Step step;
        step.instruction = stepObj["html_instructions"].as<String>();
        step.startLat = stepObj["start_location"]["lat"].as<float>();
        step.startLng = stepObj["start_location"]["lng"].as<float>();
        step.endLat = stepObj["end_location"]["lat"].as<float>();
        step.endLng = stepObj["end_location"]["lng"].as<float>();
        step.distance = stepObj["distance"]["value"].as<int>();

        steps.push_back(step);
    }
}

void updateInstructions(float currentLat, float currentLng, GPS &gps) {
    parseJSON();
    static unsigned long lastMillis = 0;
    static unsigned long elapsedSeconds = 0;
    static bool timerPaused = false;

    if (!timerPaused && millis() - lastMillis >= 1000) {
        lastMillis += 1000;
        elapsedSeconds++;

        unsigned long hours = elapsedSeconds / 3600;
        unsigned long minutes = (elapsedSeconds % 3600) / 60;
        unsigned long seconds = elapsedSeconds % 60;

        char timerStr[9];
        snprintf(timerStr, sizeof(timerStr), "%02lu:%02lu:%02lu", hours, minutes, seconds);
        lv_label_set_text(objects.timer_label, timerStr);
    }

    Serial.println("Updating instructions");

    if (currentStep >= steps.size()) {
        lv_label_set_text(objects.instruction_text_area, "You have reached your destination!");
        lv_label_set_text(objects.distance_label, "0 m");
        lv_label_set_text(objects.time_for_next_instruction, "0 min");
        return;
    }
    Serial.println("Updating instructions 2");
    float distanceToNextStep = haversine(currentLat, currentLng, steps[currentStep].startLat, steps[currentStep].startLng);
    char distanceStr[20];
    snprintf(distanceStr, sizeof(distanceStr), "%.1f m", distanceToNextStep);

    int estimatedTimeMin = (distanceToNextStep / 1.5) / 60;
    char timeStr[10];
    snprintf(timeStr, sizeof(timeStr), "%d min", estimatedTimeMin);
    Serial.println("Updating instructions 3");
    lv_label_set_text(objects.distance_label, distanceStr);
    lv_label_set_text(objects.time_for_next_instruction, timeStr);
    lv_label_set_text(objects.speed_label_trip, String(gps.getSpeed()).c_str());
    lv_textarea_set_text(objects.instruction_text_area, steps[currentStep].instruction.c_str());

    if (distanceToNextStep < 10) {
        currentStep++;
        if (currentStep < steps.size()) {
            lv_textarea_set_text(objects.instruction_text_area, steps[currentStep].instruction.c_str());
        }
    }
}