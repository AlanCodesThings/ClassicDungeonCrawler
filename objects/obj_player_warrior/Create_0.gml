event_inherited();
hp = 150; max_hp = 150; damage = 15; move_speed = 3.0; armor = 0.25;
col_half_w = 13; col_half_h = 13;
shield_active = false;
charge_timer = 0;
two_hand_active = false; two_hand_timer = 0;
riposte_ready = false;
basic_atk_windup = 0;
locked_aim_dx = 1; locked_aim_dy = 0;
thrust_anim = 0.0;
ability_dash_max = 90;   // 1.5s shuffle
ability_util_max = 0;    // shield is hold-to-use, no cooldown
ability_dmg_max  = 240;  // 4s charge
ability_ult_max  = 1200; // 20s (lasts 10s)

// Override take_damage for shield + riposte mechanics
take_damage = function(dmg, sx, sy) {
	if (invincible_timer > 0) return;
	if (two_hand_active && riposte_ready) {
		riposte_ready = false;
		// Instant riposte
		with (obj_enemy) {
			if (point_distance(x, y, other.x, other.y) < 80) deal_damage(id, other.x, other.y, other.damage * 5, other.crit_chance, other.crit_mult, 8);
		}
		with (obj_boss) {
			if (point_distance(x, y, other.x, other.y) < 80) deal_damage(id, other.x, other.y, other.damage * 5, other.crit_chance, other.crit_mult, 4);
		}
		return;
	}
	if (shield_active) dmg = round(dmg * 0.15);
	var fin = max(1, round(dmg * (1 - armor)));
	hp -= fin; invincible_timer = 30; hit_flash = 10;
	var dx = x - sx, dy = y - sy, d = sqrt(dx*dx + dy*dy);
	if (d > 0) { knockback_x = (dx/d)*3; knockback_y = (dy/d)*3; }
	if (hp <= 0) { hp = 0; is_dead = true; alarm[0] = 120; }
};
