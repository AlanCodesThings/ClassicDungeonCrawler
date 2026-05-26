event_inherited();
if (is_dead) exit;

// Dagger stab timer
if (thrust_timer > 0) thrust_timer--;

// Vanish timer
if (invisible && vanish_timer > 0) {
	vanish_timer--;
	if (vanish_timer <= 0) { invisible = false; }
}

// Shadowstep charge recharge (parent already decremented ability_ult_cd)
if (ult_charges < ult_charge_max && ability_ult_cd <= 0) {
	ult_charges++;
	if (ult_charges < ult_charge_max) ability_ult_cd = ability_ult_max;
}

// Flurry channel — locks player for 2s, fires one hit every 20 frames
if (flurry_active) {
	if (flurry_timer mod 10 == 0 && flurry_hits_done < 6) {
		var _hit_target = grid_cell_has_enemy(grid_x + flurry_adx, grid_y + flurry_ady);
		if (instance_exists(_hit_target)) {
			_hit_target.invincible_timer = 0;
			deal_damage(_hit_target, x, y, damage, 0.1 + flurry_hits_done * 0.15, crit_mult, 0);
		}
		flurry_hits_done++;
	}
	flurry_timer--;
	if (flurry_timer < 0) {
		flurry_active  = false;
		flurry_timer   = 0;
		ability_dmg_cd = ability_dmg_max;
	}
	exit;
}

// Q — shadowstep: teleport adjacent to nearest enemy, hit 20 times
if (keyboard_check_pressed(ord("Q")) && ult_charges > 0) {
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
			ult_charges--;
			if (ult_charges < ult_charge_max && ability_ult_cd <= 0) {
				ability_ult_cd = ability_ult_max;
			}
			move_cd = 6;
			exit;
		}
	}
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

// E — flurry: 2s channel, 6 hits spread across duration
if (keyboard_check_pressed(ord("E")) && ability_dmg_cd <= 0) {
	var snap      = grid_snap_dir_8(aim_dx, aim_dy);
	flurry_active    = true;
	flurry_timer     = 60;
	flurry_hits_done = 0;
	flurry_adx       = snap.dx;
	flurry_ady       = snap.dy;
	exit;
}

// LMB / SPACE — dual stab (aim tile + perpendicular flank); auto-crit if invisible
if ((mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_space)) && attack_cd <= 0) {
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
	thrust_timer = 10;
	swing_ang_a  = point_direction(0, 0, snap.dx, snap.dy);
	swing_ang_b  = swing_ang_a;
	swing_adx    = aim_dx; swing_ady = aim_dy;
	attack_cd = 15;
	move_cd   = 6;
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
