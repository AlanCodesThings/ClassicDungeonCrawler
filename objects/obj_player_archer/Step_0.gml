event_inherited();
if (is_dead) exit;

// Enchanted quiver timer
if (ult_active && ult_timer > 0) {
	ult_timer--;
	if (ult_timer <= 0) { ult_active = false; }
}

// E — power shot (hold to charge, fires on release; blocks all input while charging)
if (keyboard_check_pressed(ord("E")) && ability_dmg_cd <= 0 && !charging) {
	charging = true; charge_timer = 0;
}
if (charging) {
	charge_timer = min(charge_timer + 1, 180);
	if (!keyboard_check(ord("E"))) {
		var lvl   = charge_timer div 30;
		var range = 5 + lvl * 3;
		var snap  = grid_snap_dir_8(aim_dx, aim_dy);
		var cells = grid_line_cells(grid_x, grid_y, snap.dx, snap.dy, range);
		for (var _i = 0; _i < array_length(cells); _i++) {
			var _hit = player_grid_attack(cells[_i].gx, cells[_i].gy,
			                              round(damage * (1 + lvl)), crit_chance, crit_mult);
			if (lvl >= 6) {
				player_grid_attack(cells[_i].gx + (-snap.dy), cells[_i].gy + snap.dx,
				                   round(damage * (1 + lvl)), crit_chance, crit_mult);
				player_grid_attack(cells[_i].gx + snap.dy,   cells[_i].gy + (-snap.dx),
				                   round(damage * (1 + lvl)), crit_chance, crit_mult);
			}
		}
		charging       = false;
		charge_timer   = 0;
		ability_dmg_cd = ability_dmg_max;
		move_cd = 6;
		exit;
	}
	exit; // hold E = block all other input
}

// Q — enchanted quiver
if (keyboard_check_pressed(ord("Q")) && ability_ult_cd <= 0) {
	ult_active     = true;
	ult_timer      = ult_timer_max;
	ability_ult_cd = ability_ult_max;
	move_cd = 6;
	exit;
}

// LMB / SPACE — instant ray shot
if ((mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_space)) && attack_cd <= 0) {
	var snap  = grid_snap_dir_8(aim_dx, aim_dy);
	var range = ult_active ? MAP_W : 12;
	var cells = grid_line_cells(grid_x, grid_y, snap.dx, snap.dy, range);
	for (var _i = 0; _i < array_length(cells); _i++) {
		var dist_bonus = 1.0 + _i * 0.1;
		var hit_dmg    = round(damage * min(dist_bonus, 2.0));
		var _hit_eid   = grid_cell_has_enemy(cells[_i].gx, cells[_i].gy);
		if (_hit_eid != noone) {
			deal_damage(_hit_eid, x, y, hit_dmg, crit_chance, crit_mult, 0);
			if (pin_shot_ready && variable_instance_exists(_hit_eid, "pin_timer")) {
				_hit_eid.pin_timer = 90; // pin for 1.5s
			}
			pin_shot_ready = false;
			if (!ult_active) break;
		}
	}
	attack_cd = 25;
	move_cd   = 6;
	exit;
}

// WASD movement
if (move_cd <= 0) {
	var _ix = (keyboard_check(ord("D"))||keyboard_check(vk_right)) - (keyboard_check(ord("A"))||keyboard_check(vk_left));
	var _iy = (keyboard_check(ord("S"))||keyboard_check(vk_down))  - (keyboard_check(ord("W"))||keyboard_check(vk_up));
	if (_ix != 0 || _iy != 0) {
		if (_ix != 0 && _iy != 0) _iy = 0;
		if (try_move_player(_ix, _iy)) move_cd = 10;
	}
}
