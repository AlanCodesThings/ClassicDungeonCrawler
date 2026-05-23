if (is_dead) exit;

// Tick cooldowns
if (ability_dash_cd > 0) ability_dash_cd--;
if (ability_util_cd > 0) ability_util_cd--;
if (ability_dmg_cd  > 0) ability_dmg_cd--;
if (ability_ult_cd  > 0) ability_ult_cd--;
if (invincible_timer > 0) invincible_timer--;
if (hit_flash > 0) hit_flash--;
if (ult_timer > 0) { ult_timer--; if (ult_timer <= 0) ult_active = false; }

// Knockback decay
knockback_x *= 0.78; knockback_y *= 0.78;
if (abs(knockback_x) < 0.15) knockback_x = 0;
if (abs(knockback_y) < 0.15) knockback_y = 0;

// Movement input or dash
if (attack_lock > 0) attack_lock--;
if (dash_timer > 0) {
	dash_timer--;
	move_x = dash_dx * dash_speed;
	move_y = dash_dy * dash_speed;
} else if (attack_lock > 0) {
	move_x = knockback_x;
	move_y = knockback_y;
} else {
	var ix = (keyboard_check(ord("D")) || keyboard_check(vk_right)) - (keyboard_check(ord("A")) || keyboard_check(vk_left));
	var iy = (keyboard_check(ord("S")) || keyboard_check(vk_down)) - (keyboard_check(ord("W")) || keyboard_check(vk_up));
	var spd = move_speed * speed_mult;
	if (ix != 0 && iy != 0) spd *= 0.707;
	move_x = ix * spd + knockback_x;
	move_y = iy * spd + knockback_y;
}

// Aim toward mouse
var mdx = mouse_x - x, mdy = mouse_y - y;
var ml = sqrt(mdx * mdx + mdy * mdy);
if (ml > 10) { aim_dx = mdx / ml; aim_dy = mdy / ml; }

// Apply movement with tile collision
var nx = x + move_x, ny = y + move_y;
if (can_move_to(nx, y, col_half_w, col_half_h)) x = nx;
if (can_move_to(x, ny, col_half_w, col_half_h)) y = ny;
x = clamp(x, col_half_w, room_width  - col_half_w);
y = clamp(y, col_half_h, room_height - col_half_h);

// Stairs detection
var do_descend = false;
with (obj_stairs) {
	if (point_distance(x, y, other.x, other.y) < 28) {
		if (!global.boss_floor || global.boss_killed) do_descend = true;
	}
}
if (do_descend) {
	global.floor_number++;
	if (global.floor_number > 50) {
		global.won = true;
		global.player_inst = noone;
		room_goto(rm_class_select);
		exit;
	}
	// Cleanup
	global.cleaning_up = true;
	with (obj_enemy)      instance_destroy();
	with (obj_boss)       instance_destroy();
	with (obj_stairs)     instance_destroy();
	with (obj_projectile) instance_destroy();
	with (obj_hitbox)     instance_destroy();
	with (obj_smoke_bomb) instance_destroy();
	with (obj_pickup)     instance_destroy();
	global.cleaning_up = false;
	// Regen dungeon
	with (obj_dungeon_manager) {
		generate_dungeon(global.floor_number);
		other.x = global.player_spawn_x;
		other.y = global.player_spawn_y;
		render_map_surface();
	}
	exit;
}
