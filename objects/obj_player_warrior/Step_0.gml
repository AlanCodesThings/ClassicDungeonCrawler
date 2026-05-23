event_inherited();
if (is_dead) exit;

// Shield — only when not mid-windup
shield_active = (mouse_check_button(mb_right) && !two_hand_active && basic_atk_windup <= 0);

// 2H timer
if (two_hand_active) {
	two_hand_timer--;
	if (two_hand_timer <= 0) two_hand_active = false;
	riposte_ready = mouse_check_button(mb_right);
}

// SPACE — shuffle dash (blocked during attack commitment)
if (keyboard_check_pressed(vk_space) && ability_dash_cd <= 0 && attack_lock <= 0) {
	var ix = (keyboard_check(ord("D"))||keyboard_check(vk_right)) - (keyboard_check(ord("A"))||keyboard_check(vk_left));
	var iy = (keyboard_check(ord("S"))||keyboard_check(vk_down))  - (keyboard_check(ord("W"))||keyboard_check(vk_up));
	if (ix == 0 && iy == 0) { ix = round(aim_dx); iy = round(aim_dy); }
	var vlen = sqrt(ix*ix + iy*iy); if (vlen > 0) { ix /= vlen; iy /= vlen; }
	dash_dx = ix; dash_dy = iy; dash_speed = 7; dash_timer = 8; invincible_timer = 8;
	ability_dash_cd = ability_dash_max;
}

// Windup tick — fire at end of windup, then recovery holds the lock
if (basic_atk_windup > 0) {
	basic_atk_windup--;
	if (basic_atk_windup == 0) {
		if (!two_hand_active) {
			var hit = instance_create_layer(x + locked_aim_dx*36, y + locked_aim_dy*36, "Instances", obj_hitbox);
			hit.owner_ref = id; hit.dmg = damage; hit.hw = 22; hit.hh = 22;
			hit.life = 8; hit.max_life = 8; hit.is_player = true;
			hit.aim_dx = locked_aim_dx; hit.aim_dy = locked_aim_dy;
		} else {
			var cx = x + locked_aim_dx * 50, cy = y + locked_aim_dy * 50;
			with (obj_enemy) { if (point_distance(x,y,cx,cy) < 85) deal_damage(id, cx, cy, other.damage*3, other.crit_chance, other.crit_mult, 8); }
			with (obj_boss)  { if (point_distance(x,y,cx,cy) < 85) deal_damage(id, cx, cy, other.damage*3, other.crit_chance, other.crit_mult, 4); }
		}
	}
}

// Thrust animation lerp
if (basic_atk_windup > 0) {
	thrust_anim = lerp(thrust_anim, 1.0, 0.3);
} else if (attack_lock > 0) {
	thrust_anim = lerp(thrust_anim, 0.0, 0.18);
} else {
	thrust_anim = lerp(thrust_anim, 0.0, 0.28);
}

// LMB — begin windup (blocked during recovery or existing windup)
if (mouse_check_button_pressed(mb_left) && basic_atk_windup <= 0 && attack_lock <= 0) {
	locked_aim_dx = aim_dx; locked_aim_dy = aim_dy;
	var windup   = max(1, round(10 / attack_speed));
	var recovery = max(1, round(10 / attack_speed));
	if (two_hand_active) {
		windup   = max(1, round(14 / attack_speed));
		recovery = max(1, round(12 / attack_speed));
	}
	basic_atk_windup = windup;
	attack_lock = windup + recovery;
}

// E — charge attack: stationary while held, brief recovery on release
if (keyboard_check(ord("E")) && ability_dmg_cd <= 0 && attack_lock <= 0) {
	charge_timer = min(charge_timer + 1, 180);
	attack_lock = max(attack_lock, 2); // keep movement locked each frame while charging
}
if (keyboard_check_released(ord("E")) && ability_dmg_cd <= 0 && charge_timer > 0) {
	var lvl = charge_timer div 30;
	var cx = x + aim_dx * 40, cy = y + aim_dy * 40;
	var rad = 40 + lvl * 15;
	with (obj_enemy) { if (point_distance(x,y,cx,cy) < rad) deal_damage(id, cx, cy, other.damage*(1+lvl), other.crit_chance, other.crit_mult, 6); }
	with (obj_boss)  { if (point_distance(x,y,cx,cy) < rad) deal_damage(id, cx, cy, other.damage*(1+lvl), other.crit_chance, other.crit_mult, 3); }
	ability_dmg_cd = ability_dmg_max;
	charge_timer = 0;
	attack_lock = max(attack_lock, max(1, round(14 / attack_speed)));
}
if (!keyboard_check(ord("E"))) charge_timer = 0;

// Q — 2H sword ultimate
if (keyboard_check_pressed(ord("Q")) && ability_ult_cd <= 0) {
	two_hand_active = true; two_hand_timer = 600; ability_ult_cd = ability_ult_max;
}
