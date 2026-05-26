x += dir_x * spd;
y += dir_y * spd;
dist_done += spd;

var tx = floor(x / TILE_SIZE);
var ty = floor(y / TILE_SIZE);
var out_of_bounds = (tx < 0 || ty < 0 || tx >= MAP_W || ty >= MAP_H);
var hit_wall = (!out_of_bounds && ds_grid_get(global.map_grid, tx, ty) == TILE_WALL);

if (dist_done >= max_dist || out_of_bounds || hit_wall) {
    instance_destroy();
}
