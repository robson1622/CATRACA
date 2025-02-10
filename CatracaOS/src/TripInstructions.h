#include <SD.h>
#include <SPI.h>
#include <ArduinoJson.h>
#include <math.h>
#include <vector>
#include "ui/ui.h"
#include <SPIFFS.h>
#include "GPSInterface.h"

#define EARTH_RADIUS 6371000 // Earth's radius in meters
#define JSON_FILE "/trip.json" // JSON file path on SD card

struct Step {
    String instruction;
    float startLat;
    float startLng;
    float endLat;
    float endLng;
    int distance;
};

float haversine(float lat1, float lon1, float lat2, float lon2);
void parseJSON();
void updateInstructions(float currentLat, float currentLng, GPS &gps);
