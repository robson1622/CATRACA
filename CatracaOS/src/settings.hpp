#pragma once

#include <EasyPreferences.hpp>
#include <NMEAGPS.h>

extern uint8_t minZoom;        // Min Zoom Level
extern uint8_t maxZoom;        // Max Zoom Level
extern uint8_t defZoomRender;  // Default Zoom Level for render map
extern uint8_t defZoomVector;  // Default Zoom Level for vector map
extern uint8_t zoom;           // Actual Zoom Level
extern uint8_t defBright;      // Default brightness

extern uint8_t defaultZoom;   // Default Zoom Value
extern bool isVectorMap;      // Map type
extern bool isMapFullScreen;  // Is Map Full Screen
extern bool showToolBar;      // Show Map Toolbar

void loadPreferences();
void saveDefaultZoom(uint8_t defaultZoom);
void saveMapType(bool vector);
void saveShowMap(bool mapMode);
void saveBrightness(uint8_t vb);
void printSettings();

#endif
