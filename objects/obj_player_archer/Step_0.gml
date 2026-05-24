event_inherited();
if (is_dead) exit;

if (move_anim_timer > 0) exit;

// E — charged shot: press E to build charge (1→2→3); E at 3 or LMB fires
if (charge_level > 0) {
	var _fire = false;
	if (keyboard_check_pressed(ord("E"))) {
		if (charge_level < 3) {
			charge_level++;
			process_turn();
			move_anim_timer = MOVE_ANIM_DELAY;
			exit;
		}
		_fire = true; // max charge, E releases it
	} else if (mouse_check_button_pressed(mb_left)) {
		_fire = true; // LMB releases at current level
	} else {
		exit; // stay in charge stance, no turn consumed
	}
	if (_fire) {
		var _cl     = charge_level;
		var snap    = grid_snap_dir_8(aim_dx, aim_dy);
		var _range  = _cl == 1 ? 8  : (_cl == 2 ? 14 : MAP_W);
		var _mult   = _cl == 1 ? 2.0 : (_cl == 2 ? 3.5 : 6.0);
		var _pierce = (_cl >= 2);
		var _was_pin = pin_shot_ready;
		var cells   = grid_line_cells(grid_x, grid_y, snap.dx, snap.dy, _range);
		var _ar_tx  = x; var _ar_ty = y;
		if (array_length(cells) > 0) {
			var _lc = cells[array_length(cells) - 1];
			_ar_tx = _lc.gx * TILE_SIZE + TILE_SIZE / 2;
			_ar_ty = _lc.gy * TILE_SIZE + TILE_SIZE / 2;
		}
		for (var _i = 0; _i < array_length(cells); _i++) {
			var hit_dmg  = round(damage * _mult);
			var _hit_eid = grid_cell_has_enemy(cells[_i].gx, cells[_i].gy);
			if (_hit_eid != noone) {
				if (!_pierce) { _ar_tx = _hit_eid.x; _ar_ty = _hit_eid.y; }
				deal_damage(_hit_eid, x, y, hit_dmg, crit_chance, crit_mult, 0);
				if (pin_shot_ready && variable_instance_exists(_hit_eid, "turns_until_attack"))
					_hit_eid.turns_until_attack = 3;
				pin_shot_ready = false;
				if (!_pierce) break;
			}
			if (_cl == 3) {
				player_grid_attack(cells[_i].gx + (-snap.dy), cells[_i].gy + snap.dx, hit_dmg, crit_chance, crit_mult);
				player_grid_attack(cells[_i].gx + snap.dy,   cells[_i].gy + (-snap.dx), hit_dmg, crit_chance, crit_mult);
			}
		}
		var _ar          = instance_create_layer(x, y, "Instances", obj_arrow);
		_ar.dx           = snap.dx;
		_ar.dy           = snap.dy;
		_ar.target_x     = _ar_tx;
		_ar.target_y     = _ar_ty;
		_ar.is_pin       = _was_pin;
		_ar.charge_level = _cl;
		_ar.speed_px     = 18 + _cl * 6;
		charge_level     = 0;
		ability_dmg_cd   = ability_dmg_max;
		process_turn();
		move_anim_timer  = MOVE_ANIM_DELAY;
		exit;
	}
}

// Begin charging (costs 1 turn, locks archer until fired)
if (keyboard_check_pressed(ord("E")) && ability_dmg_cd <= 0) {
	charge_level    = 1;
	process_turn();
	move_anim_timer = MOVE_ANIM_DELAY;
	exit;
}

// Q — enchanted quiver (all arrows pierce full room, 10 turns)
if (keyboard_check_pressed(ord("Q")) && ability_ult_cd <= 0) {
	ult_active      = true;
	ult_turns_left  = 10;
	ability_ult_cd  = ability_ult_max;
	process_turn();
	move_anim_timer = MOVE_ANIM_DELAY;
	exit;
}

// SPACE — dodge (move 2 tiles, next shot pins)
if (keyboard_check_pressed(vk_space) && ability_dash_cd <= 0) {
	var _ix = (keyboard_check(ord("D"))||keyboard_check(vk_right)) - (keyboard_check(ord("A"))||keyboard_check(vk_left));
	var _iy = (keyboard_check(ord("S"))||keyboard_check(vk_down))  - (keyboard_check(ord("W"))||keyboard_check(vk_up));
	if (_ix == 0 && _iy == 0) { _ix = -round(aim_dx); _iy = -round(aim_dy); }
	if (_ix != 0 && _iy != 0) _iy = 0;
	if (_ix != 0 || _iy != 0) {
		var moved = try_move_no_attack(_ix, _iy);
		if (moved) try_move_no_attack(_ix, _iy);
		if (moved) {
			pin_shot_ready  = true;
			ability_dash_cd = ability_dash_max;
			process_turn();
			move_anim_timer = MOVE_ANIM_DELAY;
			exit;
		}
	}
}

// LMB — instant ray shot
if (mouse_check_button_pressed(mb_left)) {
	var snap      = grid_snap_dir_8(aim_dx, aim_dy);
	var range     = ult_active ? MAP_W : 12;
	var cells     = grid_line_cells(grid_x, grid_y, snap.dx, snap.dy, range);
	var _was_pin  = pin_shot_ready;
	// Arrow travels to last walkable cell by default
	var _ar_tx = x, _ar_ty = y;
	if (array_length(cells) > 0) {
		var _lc = cells[array_length(cells) - 1];
		_ar_tx = _lc.gx * TILE_SIZE + TILE_SIZE / 2;
		_ar_ty = _lc.gy * TILE_SIZE + TILE_SIZE / 2;
	}
	for (var _i = 0; _i < array_length(cells); _i++) {
		var dist_bonus = 1.0 + _i * 0.1;
		var hit_dmg    = round(damage * min(dist_bonus, 2.0));
		var _hit_eid   = grid_cell_has_enemy(cells[_i].gx, cells[_i].gy);
		if (_hit_eid != noone) {
			if (!ult_active) { _ar_tx = _hit_eid.x; _ar_ty = _hit_eid.y; }
			deal_damage(_hit_eid, x, y, hit_dmg, crit_chance, crit_mult, 0);
			if (pin_shot_ready && variable_instance_exists(_hit_eid, "turns_until_attack")) {
				_hit_eid.turns_until_attack = 3;
			}
			pin_shot_ready = false;
			if (!ult_active) break;
		}
	}
	// Spawn visual arrow
	var _ar      = instance_create_layer(x, y, "Instances", obj_arrow);
	_ar.dx       = snap.dx;
	_ar.dy       = snap.dy;
	_ar.target_x = _ar_tx;
	_ar.target_y = _ar_ty;
	_ar.is_pin   = _was_pin;
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
