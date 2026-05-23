hp = 1000; max_hp = 1000;
damage = 20; armor = 0.0;
col_half_w = 40; col_half_h = 40;
invincible_timer = 0; hit_flash = 0;
phase = 1; is_dead = false; depth = -5;
// Grid position
grid_x = floor(x / TILE_SIZE);
grid_y = floor(y / TILE_SIZE);
x = grid_x * TILE_SIZE + TILE_SIZE / 2;
y = grid_y * TILE_SIZE + TILE_SIZE / 2;
// AI system
boss_type         = -1;
boss_turn_counter = 0;
move_interval     = 3;
ai_timer          = 60;  // 1s startup delay
ai_timer_max      = 20;  // acts every ~0.33s
on_phase2 = function() {};
global.boss_killed = false;
