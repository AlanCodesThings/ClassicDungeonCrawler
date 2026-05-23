event_inherited();
if (is_dead) exit;

// SPACE — dodge (blocked during draw or charge)
if (keyboard_check_pressed(vk_space) && ability_dash_cd <= 0 && arrow_delay <= 0 && !charging) {
	var ix = (keyboard_check(ord("D"))||keyboard_check(vk_right)) - (keyboard_check(ord("A"))||keyboard_check(vk_left));
	var iy = (keyboard_check(ord("S"))||keyboard_check(vk_down))  - (keyboard_check(ord("W"))||keyboard_check(vk_up));
	if (ix == 0 && iy == 0) { ix = -round(aim_dx); iy = -round(aim_dy); }
	var vlen = sqrt(ix*ix + iy*iy); if (vlen > 0) { ix /= vlen; iy /= vlen; }
	dash_dx = ix; dash_dy = iy; dash_speed = 9; dash_timer = 10; invincible_timer = 10;
	pin_shot_ready = true; ability_dash_cd = ability_dash_max;
}

// LMB — draw and fire (stationary during draw, brief recovery after shot)
if (mouse_check_button_pressed(mb_left) && !charging && arrow_delay <= 0 && attack_lock <= 0) {
	arrow_delay = max(1, round(18 / attack_speed));
}
if (arrow_delay > 0) {
	attack_lock = max(attack_lock, 2); // hold movement lock while drawing
	arrow_delay--;
	if (arrow_delay == 0) {
		var a = instance_create_layer(x, y, "Instances", obj_arrow);
		a.owner_ref = id; a.dx = aim_dx; a.dy = aim_dy; a.spd = 10;
		a.dmg = damage; a.crit_chance = crit_chance; a.crit_mult = crit_mult;
		a.pin = pin_shot_ready; pin_shot_ready = false;
		a.max_dist = (ult_active ? 700 : 300);
		a.piercing = false; a.half_w = 6; a.half_h = 6;
		attack_lock = max(attack_lock, max(1, round(8 / attack_speed))); // recovery
	}
}

// E — power shot (stationary while charging, recovery on release)
if (keyboard_check_pressed(ord("E")) && ability_dmg_cd <= 0 && !charging && attack_lock <= 0 && arrow_delay <= 0) {
	charging = true; charge_timer = 0;
}
if (charging) {
	charge_timer = min(charge_timer + 1, 180);
	attack_lock = max(attack_lock, 2); // hold movement lock while charging
	if (!keyboard_check(ord("E"))) {
		var lvl = charge_timer div 30;
		var a = instance_create_layer(x, y, "Instances", obj_arrow);
		a.owner_ref = id; a.dx = aim_dx; a.dy = aim_dy;
		a.spd = 10 + lvl * 2; a.dmg = damage * (1 + lvl);
		a.crit_chance = crit_chance; a.crit_mult = crit_mult;
		a.pin = false; a.piercing = true;
		a.max_dist = (ult_active ? 700 : 200 + lvl * 80);
		a.half_w = 5 + lvl * 3; a.half_h = a.half_w;
		charging = false; charge_timer = 0; ability_dmg_cd = ability_dmg_max;
		attack_lock = max(attack_lock, max(1, round(10 / attack_speed))); // recovery
	}
}

// Q — enchanted quiver
if (keyboard_check_pressed(ord("Q")) && ability_ult_cd <= 0) {
	ult_active = true; ult_timer = 600; ability_ult_cd = ability_ult_max;
}
