#pragma once
#include <lvgl.h>
#include <vector>
#include <ReadBufferingStream.h>

// Keep original constants from your headers
#define MAPBLOCK_SIZE_BITS 12
#define MAPFOLDER_SIZE_BITS 4
#define MAPBLOCKS_MAX 6
#define MAX_ZOOM 4

typedef struct {
    lv_coord_t x;
    lv_coord_t y;
} lv_point16_t;

typedef struct {
    std::vector<lv_point16_t> points;
    lv_area_t bbox;
    lv_color_t color;
    uint8_t max_zoom;
} lv_polygon_t;

typedef struct {
    std::vector<lv_point16_t> points;
    lv_area_t bbox;
    lv_color_t color;
    uint8_t width;
    uint8_t max_zoom;
} lv_polyline_t;

class LVVectorMap {
public:
    LVVectorMap(lv_obj_t *parent);
    ~LVVectorMap();
    
    void setPosition(double lat, double lon);
    void setZoom(uint8_t zoom);
    void redraw();

private:
    void createCanvas();
    void loadMapData();
    void drawPolylines();
    void drawPolygons();
    void parseBlockFile(Stream &file);
    void parseCoords(Stream &file, std::vector<lv_point16_t> &points);
    int16_t parseInt16(Stream &file);
    void parseStrUntil(Stream &file, char terminator, String &str);
    
    lv_obj_t *canvas;
    lv_color_t *buffer;
    std::vector<lv_polygon_t> polygons;
    std::vector<lv_polyline_t> polylines;
    
    double current_lat;
    double current_lon;
    uint8_t current_zoom;
    tileBounds visible_bounds;
};