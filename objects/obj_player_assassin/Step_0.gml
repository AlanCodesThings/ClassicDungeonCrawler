event_inherited();
if (is_dead) exit;

// Vanish timer
if (invisible && vanish_timer > 0) {
	vanish_timer--;
	if (vanish_timer <= 0) { invisible = false; }
}

// Q — shadowstep: teleport adjacent to nearest enemy, hit 20 times
if (keyboard_check_pressed(ord("Q")) && ability_ult_cd <= 0) {
	var target = noone; var best = 99999;
	with (obj_enemy) { var _d = point_distance(x, y, mouse_x, mouse_y); if (_d < best) { best = _d; target = id; } }
	with (obj_boss)  { var _d = point_distance(x, y, mouse_x, mouse_y); if (_d < best) { best = _d; target = id; } }
	if (instance_exists(target)) {
		var _dirs = [[1,0],[-1,0],[0,1],[0,-1]];
		var _found = false;
		for (var _i = 0; _i < 4; _i++) {
			var _ngx = target.grid_x + _dirs[_i][0];
			var _ngy = target.grid_y + _dirs[_i][1];
			if (grid_is_walkable(_ngx, _ngy) && !grid_cell_occupied(_ngx, _ngy)) {
				grid_x = _ngx; grid_y = _ngy;
				x = grid_x * TILE_SIZE + TILE_SIZE / 2;
				y = grid_y * TILE_SIZE + TILE_SIZE / 2;
				_found = true;
				break;
			}
		}
		if (_found) {
			repeat (20) {
				if (!instance_exists(target)) break;
				target.invincible_timer = 0;
				deal_damage(target, x, y, damage, crit_chance, crit_mult, 0);
			}
			ability_ult_cd = ability_ult_max;
			move_cd = 6;
			exit;
		}
	}
}

// SPACE — vanish
if (keyboard_check_pressed(vk_space) && ability_dash_cd <= 0) {
	invisible    = true;
	vanish_timer = vanish_timer_max;
	invincible_timer = 30;
	ability_dash_cd  = ability_dash_max * 2; // 8s CD
	move_cd = 6;
	exit;
}

// RMB — smoke bomb
if (mouse_check_button_pressed(mb_right) && ability_util_cd <= 0) {
	for (var _sy = -1; _sy <= 1; _sy++) {
		for (var _sx = -1; _sx <= 1; _sx++) {
			array_push(global.smoke_tiles, { gx: grid_x + _sx, gy: grid_y + _sy, turns_left: 240 });
		}
	}
	smoke_active    = true;
	instance_create_layer(x, y, "Instances", obj_smoke_bomb);
	ability_util_cd = ability_util_max;
	move_cd = 6;
	exit;
}

// E — flurry (6 hits on aim tile)
if (keyboard_check_pressed(ord("E")) && ability_dmg_cd <= 0) {
	var snap = grid_snap_dir_8(aim_dx, aim_dy);
	var tx   = grid_x + snap.dx;
	var ty   = grid_y + snap.dy;
	for (var _i = 0; _i < 6; _i++) {
		var fc = 0.1 + _i * 0.15;
		player_grid_attack(tx, ty, damage, fc, crit_mult);
	}
	ability_dmg_cd = ability_dmg_max;
	move_cd = 6;
	exit;
}

// LMB — dual stab (aim tile + perpendicular flank); auto-crit if invisible
if (mouse_check_button_pressed(mb_left)) {
	var snap = grid_snap_dir_8(aim_dx, aim_dy);
	var tx   = grid_x + snap.dx;
	var ty   = grid_y + snap.dy;
	var cc   = crit_chance;
	var cm   = crit_mult;
	if (invisible) {
		cc = 1.0;
		invisible    = false;
		vanish_timer = 0;
	}
	player_grid_attack(tx, ty, damage, cc, cm);
	player_grid_attack(grid_x + (-snap.dy), grid_y + snap.dx, damage, cc, cm);
	move_cd = 6;
	exit;
}

// WASD movement (2 tiles if vanished)
if (move_cd <= 0) {
	var _ix = (keyboard_check(ord("D"))||keyboard_check(vk_right)) - (keyboard_check(ord("A"))||keyboard_check(vk_left));
	var _iy = (keyboard_check(ord("S"))||keyboard_check(vk_down))  - (keyboard_check(ord("W"))||keyboard_check(vk_up));
	if (_ix != 0 || _iy != 0) {
		if (_ix != 0 && _iy != 0) _iy = 0;
		var moved = try_move_player(_ix, _iy);
		if (moved && invisible) try_move_player(_ix, _iy);
		if (moved) move_cd = 10;
	}
}
