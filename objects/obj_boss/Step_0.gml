if (hit_flash > 0)       hit_flash--;
if (invincible_timer > 0) invincible_timer--;
x = lerp(x, grid_x * TILE_SIZE + TILE_SIZE / 2, 0.15);
y = lerp(y, grid_y * TILE_SIZE + TILE_SIZE / 2, 0.15);
if (ai_timer > 0) {
	ai_timer--;
} else {
	boss_take_turn(id);
	ai_timer = ai_timer_max;
}
if (hp <= 0 && !is_dead) {
	is_dead = true;
	global.boss_killed = true;
	instance_destroy();
}
