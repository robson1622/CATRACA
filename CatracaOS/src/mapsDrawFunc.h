#pragma once

#include "globalMapsDef.h"

// Images
#include "bruj.c"
#include "navigation.c"
#include "waypoint.c"
#include "compass.c"
#include "zoom.c"
#include "speed.c"
#include "expand.c"
#include "collapse.c"
#include "zoomin.c"
#include "zoomout.c"
#include "navfinish.c"
#include <cstdint>

bool isCoordInBounds(double lat, double lon, tileBounds bound);
void coords2map(double lat, double lon, tileBounds bound, int *pixelX, int *pixelY);

// Scale for map
static const char *map_scale[] PROGMEM = {"5000 Km", "2500 Km", "1500 Km",
                                          "700 Km", "350 Km", "150 Km",
                                          "100 Km", "40 Km", "20 Km",
                                          "10 Km", "5 Km", "2,5 Km",
                                          "1,5 Km", "700 m", "350 m",
                                          "150 m", "80 m", "40 m",
                                          "20 m", "10 m"};

/**
 * @brief Delete map screen sprites and release PSRAM
 *
 */
static void deleteMapScrSprites()
{
  sprArrow.deleteSprite();
  mapSprite.deleteSprite();
}

/**
 * @brief Create a map screen sprites
 *
 */
static void createMapScrSprites()
{
  // Map Sprite
  if (!isMapFullScreen)
     mapSprite.createSprite(MAP_WIDTH, MAP_HEIGHT);
  else
     mapSprite.createSprite(MAP_WIDTH, MAP_HEIGHT_FULL);
  // Arrow Sprite
  sprArrow.createSprite(16, 16);
  sprArrow.setColorDepth(16);
  sprArrow.pushImage(0, 0, 16, 16, (uint16_t *)navigation);
}

/**
 * @brief Display Map
 *
 * @param tileSize -> Tile Size to center map
 */
static void displayMap(uint16_t tileSize)
{
  if (!isMapFullScreen)
    mapSprite.pushSprite(0, 27); 
  else
    mapSprite.pushSprite(0,0);

  if (isMapFound)
  {
    navArrowPosition = coord2ScreenPos(gpsData.longitude, gpsData.latitude, zoom, tileSize);

    mapHeading = gpsData.heading;

    if (tileSize == RENDER_TILE_SIZE)
    {
      mapTempSprite.pushImage(wptPosX-8, wptPosY-8, 16 ,16 ,(uint16_t*)waypoint, TFT_BLACK);
      mapTempSprite.setPivot(tileSize + navArrowPosition.posX, tileSize + navArrowPosition.posY);
    }

    if (tileSize == VECTOR_TILE_SIZE)
    {
      mapTempSprite.pushImage(wptPosX-8, wptPosY-8, 16 ,16 ,(uint16_t*)waypoint, TFT_BLACK);
      mapTempSprite.setPivot(tileSize , tileSize );
    }

    mapTempSprite.pushRotated(&mapSprite, 360 - mapHeading, TFT_TRANSPARENT);
   
    sprArrow.pushRotated(&mapSprite, 0, TFT_BLACK);
    drawMapWidgets();
  }
  else
    mapTempSprite.pushSprite(&mapSprite, 0, 0, TFT_TRANSPARENT);
}

/**
 * @brief crop buffer image
 *
 * @param origBuff -> Original buffer
 * @param cropBuff -> Buffer cropped
 * @param xOffset -> X offset
 * @param yOffset -> Y offset
 * @param width -> Width crop
 * @param height -> Height crop
 */
static void cropImage(const uint16_t *origBuff, uint16_t *cropBuff, int xOffset, int yOffset, int width, int height)
{
  for (int y = 0; y < height; y++)
  {
    int yOrigin = y + yOffset;
    int xOrigin = xOffset;
    memcpy(cropBuff + y * width, origBuff + yOrigin * MAP_WIDTH + xOrigin, width * sizeof(uint16_t));
  }
}

#endif
