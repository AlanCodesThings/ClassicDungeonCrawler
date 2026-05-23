event_inherited(); // visual lerp, timers, stairs
if (is_dead) exit;

// E — charge attack (real-time hold, fires as a turn action on release)
if (keyboard_check(ord("E")) && ability_dmg_cd <= 0) {
	charge_timer = min(charge_timer + 1, 180);
	exit; // lock movement while charging
}
if (keyboard_check_released(ord("E")) && ability_dmg_cd <= 0 && charge_timer > 0) {
	var lvl  = charge_timer div 30; // 0–6
	var snap = grid_snap_dir_8(aim_dx, aim_dy);
	var adx  = snap.dx; var ady = snap.dy;
	// Line of 1+lvl tiles
	var cells = grid_line_cells(grid_x, grid_y, adx, ady, 1 + lvl);
	for (var _i = 0; _i < array_length(cells); _i++) {
		player_grid_attack(cells[_i].gx, cells[_i].gy, round(damage * (1 + lvl)), crit_chance, crit_mult);
	}
	// AoE at end tile
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
	charge_timer    = 0;
	ability_dmg_cd  = ability_dmg_max;
	process_turn();
	move_anim_timer = MOVE_ANIM_DELAY;
	exit;
}
if (!keyboard_check(ord("E"))) charge_timer = 0;

// Guard against input during animation
if (move_anim_timer > 0) exit;

// Q — 2H sword ultimate
if (keyboard_check_pressed(ord("Q")) && ability_ult_cd <= 0) {
	two_hand_active      = true;
	two_hand_turns_left  = 10;
	ability_ult_cd       = ability_ult_max;
	process_turn();
	move_anim_timer = MOVE_ANIM_DELAY;
	exit;
}

// RMB — raise shield (blocks this turn's telegraph/enemy damage)
if (mouse_check_button(mb_right) && !two_hand_active) {
	shield_active = true;
}
// RMB in 2H mode — declare riposte
if (mouse_check_button_pressed(mb_right) && two_hand_active) {
	riposte_declared = true;
}

// SPACE — shuffle (move 2 tiles, 1-turn invincibility)
if (keyboard_check_pressed(vk_space) && ability_dash_cd <= 0) {
	var _ix = (keyboard_check(ord("D"))||keyboard_check(vk_right)) - (keyboard_check(ord("A"))||keyboard_check(vk_left));
	var _iy = (keyboard_check(ord("S"))||keyboard_check(vk_down))  - (keyboard_check(ord("W"))||keyboard_check(vk_up));
	if (_ix == 0 && _iy == 0) { _ix = round(aim_dx); _iy = round(aim_dy); }
	if (_ix != 0 || _iy != 0) {
		if (_ix != 0 && _iy != 0) _iy = 0;
		// Attempt to move 2 tiles
		var moved = false;
		if (try_move_player(_ix, _iy)) {
			moved = true;
			try_move_player(_ix, _iy); // second step
		}
		if (moved) {
			invincible_turns = 1;
			ability_dash_cd  = ability_dash_max;
			process_turn();
			move_anim_timer  = MOVE_ANIM_DELAY;
			exit;
		}
	}
}

// LMB — basic attack: 3-tile arc (5-tile arc in 2H mode)
if (mouse_check_button_pressed(mb_left)) {
	var snap = grid_snap_dir_8(aim_dx, aim_dy);
	var adx  = snap.dx; var ady = snap.dy;
	var ang  = point_direction(0, 0, adx, ady);
	if (!two_hand_active) {
		// Normal: 3-tile arc (center ±45°)
		var d0  = grid_snap_dir_8(lengthdir_x(1, ang),      lengthdir_y(1, ang));
		var d1  = grid_snap_dir_8(lengthdir_x(1, ang - 45), lengthdir_y(1, ang - 45));
		var d2  = grid_snap_dir_8(lengthdir_x(1, ang + 45), lengthdir_y(1, ang + 45));
		player_grid_attack(grid_x + d0.dx, grid_y + d0.dy, damage, crit_chance, crit_mult);
		player_grid_attack(grid_x + d1.dx, grid_y + d1.dy, damage, crit_chance, crit_mult);
		player_grid_attack(grid_x + d2.dx, grid_y + d2.dy, damage, crit_chance, crit_mult);
	} else {
		// 2H mode: 5-tile wide arc (center ±0 ±45 ±90)
		for (var _a = -90; _a <= 90; _a += 45) {
			var _d = grid_snap_dir_8(lengthdir_x(1, ang + _a), lengthdir_y(1, ang + _a));
			player_grid_attack(grid_x + _d.dx, grid_y + _d.dy, round(damage * 3), crit_chance, crit_mult);
		}
	}
	process_turn();
	move_anim_timer = MOVE_ANIM_DELAY;
	exit;
}

// WASD movement
var _ix = (keyboard_check_pressed(ord("D"))||keyboard_check_pressed(vk_right)) - (keyboard_check_pressed(ord("A"))||keyboard_check_pressed(vk_left));
var _iy = (keyboard_check_pressed(ord("S"))||keyboard_check_pressed(vk_down))  - (keyboard_check_pressed(ord("W"))||keyboard_check_pressed(vk_up));
if (_ix != 0 || _iy != 0) {
	if (_ix != 0 && _iy != 0) _iy = 0;
	if (try_move_player(_ix, _iy)) {
		process_turn();
		move_anim_timer = MOVE_ANIM_DELAY;
	}
	exit;
}
