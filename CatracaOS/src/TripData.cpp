#include "TripData.h"

// Constructor
TripData::TripData()
  : startPoint(""), endPoint(""), distance(0.0), date(""), time(0), maxSpeed(0.0), averageSpeed(0.0) {}

// Getters
String TripData::getStartPoint() const { return startPoint; }
String TripData::getEndPoint() const { return endPoint; }
float TripData::getDistance() const { return distance; }
String TripData::getDate() const { return date; }
int TripData::getTime() const { return time; }
float TripData::getMaxSpeed() const { return maxSpeed; }
float TripData::getAverageSpeed() const { return averageSpeed; }

// Setters
void TripData::setStartPoint(const String &start) { startPoint = start; }
void TripData::setEndPoint(const String &end) { endPoint = end; }
void TripData::setDistance(float dist) { distance = dist; }
void TripData::setDate(const String &dt) { date = dt; }
void TripData::setTime(int t) { time = t; }
void TripData::setMaxSpeed(float max) { maxSpeed = max; }
void TripData::setAverageSpeed(float avg) { averageSpeed = avg; }

// Parse a CSV line into the TripData object
void TripData::parseCSVLine(const String &line) {
  int comma1 = line.indexOf(',');
  int comma2 = line.indexOf(',', comma1 + 1);
  int comma3 = line.indexOf(',', comma2 + 1);
  int comma4 = line.indexOf(',', comma3 + 1);
  int comma5 = line.indexOf(',', comma4 + 1);
  int comma6 = line.indexOf(',', comma5 + 1);

  startPoint = line.substring(0, comma1);
  endPoint = line.substring(comma1 + 1, comma2);
  distance = line.substring(comma2 + 1, comma3).toFloat();
  date = line.substring(comma3 + 1, comma4);
  time = line.substring(comma4 + 1, comma5).toInt();
  maxSpeed = line.substring(comma5 + 1, comma6).toFloat();
  averageSpeed = line.substring(comma6 + 1).toFloat();
}

// Display trip data as a formatted string
String TripData::toString() const {
  char buffer[256];
  snprintf(buffer, sizeof(buffer), "%s → %s | %.1f km | %s | %d sec | %.1f km/h (max) | %.1f km/h (avg)",
           startPoint.c_str(), endPoint.c_str(), distance, date.c_str(), time, maxSpeed, averageSpeed);
  return String(buffer);
}

String TripData::getStartPoint() {
  return startPoint;
}

String TripData::getEndPoint() {
  return endPoint;
}

String TripData::getDistance() {
  return String(distance) + " km";
}

String TripData::getDate() {
  return date;
}

String TripData::getDuration() {
  int hours = time / 3600;
  int minutes = (time % 3600) / 60;
  int seconds = time % 60;
  return String(hours) + "h " + String(minutes) + "m " + String(seconds) + "s";
}

String TripData::getMaxSpeed() {
  return String(maxSpeed) + " km/h";
}

String TripData::getAverageSpeed() {
  return String(averageSpeed) + " km/h";
}