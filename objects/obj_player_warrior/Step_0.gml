event_inherited(); // visual lerp, timers, stairs
if (is_dead) exit;

// Charge slam animation timer
if (charge_slam_timer > 0) charge_slam_timer--;
if (parry_counter_timer > 0) parry_counter_timer--;

// Sword swing trail — record tip path during attack animation
if (thrust_timer > 0) {
	var _sw = two_hand_active ? 36 : 24;
	var _t  = 1 - (thrust_timer - 1) / 12.0;
	thrust_timer--;
	var _ca = swing_ang - swing_half + swing_half * 2 * _t;
	array_push(sword_trail, { tx: x + lengthdir_x(_sw, _ca), ty: y + lengthdir_y(_sw, _ca) });
	if (array_length(sword_trail) > 14) array_delete(sword_trail, 0, 1);
} else if (array_length(sword_trail) > 0) {
	array_delete(sword_trail, 0, 1); // dissolve trail one point per frame
}

// 2H mode — decrement timer each frame
if (two_hand_active) {
	two_hand_timer--;
	if (two_hand_timer <= 0) { two_hand_active = false; two_hand_timer = 0; }
}

// Parry — active window countdown; blocks all input while running
if (parry_active) {
    parry_timer--;
    if (parry_timer <= 0) { parry_active = false; parry_timer = 0; ability_util_cd = ability_util_max; }
    exit;
}
// Riposte (2H mode) — read button each frame
riposte_declared = mouse_check_button(mb_right) && two_hand_active;
// RMB — activate parry (not in 2H mode)
if (mouse_check_button_pressed(mb_right) && !two_hand_active && ability_util_cd <= 0) {
    parry_active = true;
    parry_timer  = parry_timer_max;
    exit;
}

// E — charge attack: 3 levels (lvl1≥20f 2×dmg 2-deep, lvl2≥50f 3.5×dmg 3-deep, lvl3≥90f 5.5×dmg 4-deep)
// Cone width expands: depth d has 2d-1 tiles wide centred on aim axis
if (keyboard_check(ord("E")) && ability_dmg_cd <= 0) {
	charge_timer = min(charge_timer + 1, 120);
	exit;
}
if (keyboard_check_released(ord("E")) && ability_dmg_cd <= 0 && charge_timer > 0) {
	var lvl = (charge_timer >= 90) ? 3 : ((charge_timer >= 50) ? 2 : ((charge_timer >= 20) ? 1 : 0));
	if (lvl > 0) {
		var snap      = grid_snap_dir_8(aim_dx, aim_dy);
		var adx       = snap.dx; var ady = snap.dy;
		var pdx       = -ady;    var pdy = adx;
		var max_depth = lvl + 1;
		var dmg_mult  = (lvl == 1) ? 2.0 : ((lvl == 2) ? 3.5 : 5.5);
		for (var _d = 1; _d <= max_depth; _d++) {
			for (var _p = -(_d - 1); _p <= (_d - 1); _p++) {
				player_grid_attack(grid_x + adx * _d + pdx * _p,
				                   grid_y + ady * _d + pdy * _p,
				                   round(damage * dmg_mult), crit_chance, crit_mult);
			}
		}
		charge_slam_timer = 20;
		charge_slam_lvl   = lvl;
		charge_slam_dx    = adx;
		charge_slam_dy    = ady;
		sword_trail  = [];
		thrust_timer = 12;
		swing_ang    = point_direction(0, 0, adx, ady);
		swing_half   = 60 + lvl * 15; // 75° / 90° / 105° per level
		ability_dmg_cd = ability_dmg_max;
		move_cd = 6;
	}
	charge_timer = 0;
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

// LMB / SPACE — basic attack (3-tile arc; 5-tile arc in 2H mode)
if ((mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_space)) && attack_cd <= 0) {
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
	sword_trail  = [];
	thrust_timer = 12;
	swing_ang    = point_direction(0, 0, aim_dx, aim_dy);
	swing_half   = two_hand_active ? 90 : 60;
	attack_cd = two_hand_active ? 25 : 18;
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
