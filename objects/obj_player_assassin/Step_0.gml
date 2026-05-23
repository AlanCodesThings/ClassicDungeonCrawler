event_inherited();
if (is_dead) exit;

// Invisibility tick
if (invis_timer > 0) {
	invis_timer--;
	if (invis_timer <= 0) { invisible = false; invis_first_attack = false; speed_mult = 1.0; }
}

// SPACE — vanish (blocked during attack commitment)
if (keyboard_check_pressed(vk_space) && ability_dash_cd <= 0 && attack_lock <= 0) {
	invisible = true; invis_timer = 240; invis_first_attack = true;
	speed_mult = 1.7; invincible_timer = 240; ability_dash_cd = ability_dash_max;
}

// Windup tick — fire at end of windup
if (basic_atk_windup > 0) {
	basic_atk_windup--;
	if (basic_atk_windup == 0) {
		if (invisible) {
			invisible = false; invis_timer = 0; speed_mult = 1.0; invincible_timer = 0;
			var hx = x + locked_aim_dx * 30, hy = y + locked_aim_dy * 30;
			with (obj_enemy) {
				if (rect_overlap(x,y,col_half_w,col_half_h,hx,hy,22,22))
					deal_damage(id, hx, hy, other.damage, 1.0, other.crit_mult, 6);
			}
			with (obj_boss) {
				if (rect_overlap(x,y,col_half_w,col_half_h,hx,hy,22,22))
					deal_damage(id, hx, hy, other.damage, 1.0, other.crit_mult, 3);
			}
			invis_first_attack = false;
		} else {
			var h1 = instance_create_layer(x+locked_aim_dx*28+locked_aim_dy*8, y+locked_aim_dy*28-locked_aim_dx*8, "Instances", obj_hitbox);
			h1.owner_ref=id; h1.dmg=damage; h1.hw=14; h1.hh=14;
			h1.life=3; h1.max_life=3; h1.is_player=true;
			h1.aim_dx=locked_aim_dx; h1.aim_dy=locked_aim_dy;
			var h2 = instance_create_layer(x+locked_aim_dx*28-locked_aim_dy*8, y+locked_aim_dy*28+locked_aim_dx*8, "Instances", obj_hitbox);
			h2.owner_ref=id; h2.dmg=damage; h2.hw=14; h2.hh=14;
			h2.life=3; h2.max_life=3; h2.is_player=true;
			h2.aim_dx=locked_aim_dx; h2.aim_dy=locked_aim_dy;
		}
	}
}

// LMB — begin windup (faster and critting from invis)
if (mouse_check_button_pressed(mb_left) && basic_atk_windup <= 0 && attack_lock <= 0 && !flurry_active) {
	locked_aim_dx = aim_dx; locked_aim_dy = aim_dy;
	var windup   = 0;
	var recovery = 0;
	if (invisible) {
		windup   = max(1, round(4 / attack_speed));
		recovery = max(1, round(6 / attack_speed));
	} else {
		windup   = max(1, round(6 / attack_speed));
		recovery = max(1, round(8 / attack_speed));
	}
	basic_atk_windup = windup;
	attack_lock = windup + recovery;
}

// RMB — smoke bomb
if (mouse_check_button_pressed(mb_right) && ability_util_cd <= 0) {
	smoke_inst = instance_create_layer(x, y, "Instances", obj_smoke_bomb);
	smoke_inst.owner_ref = id;
	ability_util_cd = ability_util_max;
}

// E — flurry (movement locked for full sequence + recovery)
if (keyboard_check_pressed(ord("E")) && ability_dmg_cd <= 0 && !flurry_active && attack_lock <= 0) {
	flurry_active = true; flurry_hits = 0; flurry_step = 0;
	ability_dmg_cd = ability_dmg_max;
	attack_lock = max(1, round(42 / attack_speed)); // 36 frames sequence + 6 recovery
}
if (flurry_active) {
	flurry_step++;
	if (flurry_step mod 6 == 0 && flurry_hits < 6) {
		var fc = 0.1 + flurry_hits * 0.15;
		var h = instance_create_layer(x + aim_dx*28, y + aim_dy*28, "Instances", obj_hitbox);
		h.owner_ref = id; h.dmg = damage; h.hw = 17; h.hh = 17;
		h.life = 2; h.max_life = 2; h.is_player = true;
		h.aim_dx = aim_dx; h.aim_dy = aim_dy;
		h.crit_override = fc; h.crit_mult_override = crit_mult;
		flurry_hits++;
	}
	if (flurry_hits >= 6) { flurry_active = false; flurry_step = 0; }
}

// Q — shadowstep with recovery after (so you can't immediately vanish)
if (keyboard_check_pressed(ord("Q")) && ability_ult_cd <= 0 && attack_lock <= 0) {
	var target = noone; var best = 99999;
	with (obj_enemy) { var d=point_distance(x,y,mouse_x,mouse_y); if(d<best){best=d;target=id;} }
	with (obj_boss)  { var d=point_distance(x,y,mouse_x,mouse_y); if(d<best){best=d;target=id;} }
	if (instance_exists(target)) {
		var ang = point_direction(target.x, target.y, x, y);
		x = target.x + lengthdir_x(50, ang);
		y = target.y + lengthdir_y(50, ang);
		repeat (20) {
			if (!instance_exists(target)) break;
			target.invincible_timer = 0;
			deal_damage(target, x, y, damage, crit_chance, crit_mult, 1);
		}
		ability_ult_cd = ability_ult_max;
		attack_lock = max(1, round(14 / attack_speed));
	}
}
