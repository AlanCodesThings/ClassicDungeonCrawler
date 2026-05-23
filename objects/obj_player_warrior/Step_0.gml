event_inherited(); // visual lerp, timers, stairs
if (is_dead) exit;

// 2H mode — decrement timer each frame
if (two_hand_active) {
	two_hand_timer--;
	if (two_hand_timer <= 0) { two_hand_active = false; two_hand_timer = 0; }
}

// Shield / riposte — read button state every frame
shield_active    = mouse_check_button(mb_right) && !two_hand_active;
riposte_declared = mouse_check_button(mb_right) && two_hand_active;

// E — charge attack (hold to charge, fires on release; blocks movement while charging)
if (keyboard_check(ord("E")) && ability_dmg_cd <= 0) {
	charge_timer = min(charge_timer + 1, 180);
	exit; // lock movement while charging
}
if (keyboard_check_released(ord("E")) && ability_dmg_cd <= 0 && charge_timer > 0) {
	var lvl  = charge_timer div 30; // 0–6
	var snap = grid_snap_dir_8(aim_dx, aim_dy);
	var adx  = snap.dx; var ady = snap.dy;
	var cells = grid_line_cells(grid_x, grid_y, adx, ady, 1 + lvl);
	for (var _i = 0; _i < array_length(cells); _i++) {
		player_grid_attack(cells[_i].gx, cells[_i].gy, round(damage * (1 + lvl)), crit_chance, crit_mult);
	}
	if (array_length(cells) > 0) {
		var last = cells[array_length(cells) - 1];
		var rad  = 1 + lvl div 2;
		for (var _dy = -rad; _dy <= rad; _dy++) {
			for (var _dx2 = -rad; _dx2 <= rad; _dx2++) {
				if (abs(_dx2) + abs(_dy) <= rad)
					player_grid_attack(last.gx + _dx2, last.gy + _dy, round(damage * (1 + lvl)), crit_chance, crit_mult);
			}
		}
	}
	charge_timer   = 0;
	ability_dmg_cd = ability_dmg_max;
	move_cd = 6;
	exit;
}
if (!keyboard_check(ord("E"))) charge_timer = 0;

// Q — 2H sword ultimate
if (keyboard_check_pressed(ord("Q")) && ability_ult_cd <= 0) {
	two_hand_active = true;
	two_hand_timer  = two_hand_timer_max;
	ability_ult_cd  = ability_ult_max;
	move_cd = 6;
	exit;
}

// SPACE — shuffle (move 2 tiles, brief invincibility)
if (keyboard_check_pressed(vk_space) && ability_dash_cd <= 0) {
	var _ix = (keyboard_check(ord("D"))||keyboard_check(vk_right)) - (keyboard_check(ord("A"))||keyboard_check(vk_left));
	var _iy = (keyboard_check(ord("S"))||keyboard_check(vk_down))  - (keyboard_check(ord("W"))||keyboard_check(vk_up));
	if (_ix == 0 && _iy == 0) { _ix = round(aim_dx); _iy = round(aim_dy); }
	if (_ix != 0 && _iy != 0) _iy = 0;
	if (_ix != 0 || _iy != 0) {
		var moved = false;
		if (try_move_player(_ix, _iy)) {
			moved = true;
			try_move_player(_ix, _iy);
		}
		if (moved) {
			invincible_timer = 30;
			ability_dash_cd  = ability_dash_max;
			move_cd = 10;
			exit;
		}
	}
}

// LMB — basic attack (3-tile arc; 5-tile arc in 2H mode)
if (mouse_check_button_pressed(mb_left)) {
	var snap = grid_snap_dir_8(aim_dx, aim_dy);
	var adx  = snap.dx; var ady = snap.dy;
	var ang  = point_direction(0, 0, adx, ady);
	if (!two_hand_active) {
		var d0 = grid_snap_dir_8(lengthdir_x(1, ang),      lengthdir_y(1, ang));
		var d1 = grid_snap_dir_8(lengthdir_x(1, ang - 45), lengthdir_y(1, ang - 45));
		var d2 = grid_snap_dir_8(lengthdir_x(1, ang + 45), lengthdir_y(1, ang + 45));
		player_grid_attack(grid_x + d0.dx, grid_y + d0.dy, damage, crit_chance, crit_mult);
		player_grid_attack(grid_x + d1.dx, grid_y + d1.dy, damage, crit_chance, crit_mult);
		player_grid_attack(grid_x + d2.dx, grid_y + d2.dy, damage, crit_chance, crit_mult);
	} else {
		for (var _a = -90; _a <= 90; _a += 45) {
			var _d = grid_snap_dir_8(lengthdir_x(1, ang + _a), lengthdir_y(1, ang + _a));
			player_grid_attack(grid_x + _d.dx, grid_y + _d.dy, round(damage * 3), crit_chance, crit_mult);
		}
	}
	move_cd = 6;
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
