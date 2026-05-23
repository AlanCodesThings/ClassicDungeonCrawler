// Visual-only: lerp toward grid position, tick flash
if (hit_flash > 0)       hit_flash--;
if (invincible_timer > 0) invincible_timer--;
x = lerp(x, grid_x * TILE_SIZE + TILE_SIZE / 2, 0.15);
y = lerp(y, grid_y * TILE_SIZE + TILE_SIZE / 2, 0.15);
if (hp <= 0 && !is_dead) {
	is_dead = true;
	global.boss_killed = true;
	instance_destroy();
}
