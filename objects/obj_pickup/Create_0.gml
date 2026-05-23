pickup_type = 0; // 0=hp, 1=damage_up, 2=speed_up (speed_up removed in grid mode, falls back to hp)
value = 30;
depth = -3;
bob_timer = 0;
grid_x = floor(x / TILE_SIZE);
grid_y = floor(y / TILE_SIZE);
x = grid_x * TILE_SIZE + TILE_SIZE / 2;
y = grid_y * TILE_SIZE + TILE_SIZE / 2;
