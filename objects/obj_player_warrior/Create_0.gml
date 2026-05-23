event_inherited();
hp = 150; max_hp = 150;
damage = 15;
armor  = 0.25;
crit_chance = 0.1; crit_mult = 2.0;
col_half_w = 13; col_half_h = 13;
// Ability cooldowns (in turns)
ability_dash_max = 3;   // shuffle
ability_util_max = 0;   // shield — hold-to-use, no CD
ability_dmg_max  = 4;   // charge attack
ability_ult_max  = 20;  // 2H sword
// Warrior-specific state
shield_active    = false;
charge_timer     = 0;    // frames E held (real-time)
two_hand_active  = false;
two_hand_turns_left = 0;
riposte_declared = false;

take_damage = function(dmg, sx, sy) {
	if (invincible_turns > 0) return;
	if (two_hand_active && riposte_declared) {
		riposte_declared = false;
		with (obj_enemy) {
			if (point_distance(x, y, other.x, other.y) < 80)
				deal_damage(id, other.x, other.y, other.damage * 5, other.crit_chance, other.crit_mult, 0);
		}
		with (obj_boss) {
			if (point_distance(x, y, other.x, other.y) < 100)
				deal_damage(id, other.x, other.y, other.damage * 5, other.crit_chance, other.crit_mult, 0);
		}
		return;
	}
	if (shield_active) dmg = round(dmg * 0.15);
	var fin = max(1, round(dmg * (1 - armor)));
	hp -= fin; invincible_turns = 1; hit_flash = 10;
	var _dn = instance_create_layer(x + random_range(-6,6), y - 14, "Instances", obj_damage_number);
	_dn.value = fin; _dn.is_crit = false;
	if (hp <= 0) { hp = 0; is_dead = true; alarm[0] = 120; }
};
