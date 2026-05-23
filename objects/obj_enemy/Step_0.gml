if (hit_flash > 0)        hit_flash--;
if (invincible_timer > 0) invincible_timer--;
x = lerp(x, grid_x * TILE_SIZE + TILE_SIZE / 2, 0.22);
y = lerp(y, grid_y * TILE_SIZE + TILE_SIZE / 2, 0.22);

if (pin_timer > 0) {
	pin_timer--;
} else if (ai_timer > 0) {
	ai_timer--;
} else {
	enemy_take_turn(id);
	ai_timer = ai_timer_max;
}
