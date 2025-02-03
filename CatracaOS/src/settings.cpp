#include "settings.hpp"

/**
 * @brief Zoom Levels and Default zoom
 *
 */
uint8_t minZoom = 0;        // Min Zoom Level
uint8_t maxZoom = 0;        // Max Zoom Level
uint8_t defZoomRender = 15; // Default Zoom Level for render map
uint8_t defZoomVector = 2;  // Default Zoom Level for vector map
uint8_t zoom = 0;           // Actual Zoom Level

  static const float scale = 1.0f;

/**
 * @brief Global Variables definition for device preferences & config.
 *
 */
uint8_t defaultZoom = 0;      // Default Zoom Value
uint8_t defBright = 255;      // Default Brightness
bool isVectorMap = false;     // Map Type
bool isMapFullScreen = false; // Is Map Full Screen

/**
 * @brief Load stored preferences
 *
 */
void loadPreferences()
{
  cfg.init("CATRACA");
  isVectorMap = cfg.getBool(PKEYS::KMAP_VECTOR, false);
  defBright = cfg.getUInt(PKEYS::KDEF_BRIGT, 254);
  if (isVectorMap)
  {
    minZoom = 1;
    maxZoom = 4;
    defaultZoom = cfg.getUInt(PKEYS::KDEF_ZOOM, defZoomVector);
  }
  else
  {
    minZoom = 6;
    maxZoom = 17;
    defaultZoom = cfg.getUInt(PKEYS::KDEF_ZOOM, defZoomRender);
  }
  zoom = defaultZoom;
  isMapFullScreen = cfg.getBool(PKEYS::KMAP_MODE, true);

  printSettings();
}

/**
 * @brief Save default zoom value
 *
 * @param defaultZoom
 */
void saveDefaultZoom(uint8_t defaultZoom)
{
  cfg.saveUInt(PKEYS::KDEF_ZOOM, defaultZoom);
}

/**
 * @brief Save show compass in map
 *
 * @param showCompass
 */

/**
 * @brief Save Map Type
 *
 * @param vector
 */
void saveMapType(bool vector)
{
  cfg.saveBool(PKEYS::KMAP_VECTOR, vector);
}

/**
 * @brief Save Map Mode
 *
 * @param mapMOde
 */
void saveShowMap(bool mapMode)
{
  cfg.saveBool(PKEYS::KMAP_MODE, mapMode);
}

/**
 * @brief Save GPS GPIO's
 *
 * @param txGpio
 * @param rxGpio
 */

/**
 * @brief Save default Brightness
 *
 * @param status 
 */
void saveBrightness(uint8_t vb)
{
  cfg.saveUInt(PKEYS::KDEF_BRIGT, vb);
}

/**
 * @brief Utility to show all settings
 */
void printSettings() 
{
  log_v("%11s \t%s \t%s", "KEYNAME", "DEFINED", "VALUE");
  log_v("%11s \t%s \t%s", "=======", "=======", "=====");

  for (int i = 0; i < KCOUNT; i++) {
    if (i == PKEYS::KUSER) continue;
    String key = cfg.getKey((CONFKEYS)i);
    bool isDefined = cfg.isKey(key);
    String defined = isDefined ? "custom " : "default";
    String value = "";
    if (isDefined) value = cfg.getValue(key);
    log_v("%11s \t%s \t%s", key.c_str(), defined.c_str(), value.c_str());
  }
}
