// Visual-only: lerp toward grid position, tick hit flash
if (hit_flash > 0)       hit_flash--;
if (invincible_timer > 0) invincible_timer--;
x = lerp(x, grid_x * TILE_SIZE + TILE_SIZE / 2, 0.22);
y = lerp(y, grid_y * TILE_SIZE + TILE_SIZE / 2, 0.22);
