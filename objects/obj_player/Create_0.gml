hp = 100; max_hp = 100;
damage = 20;
move_speed = 3.5;
armor = 0.0;
col_half_w = 12; col_half_h = 12;
crit_chance = 0.1; crit_mult = 2.0;
speed_mult = 1.0;
move_x = 0; move_y = 0;
aim_dx = 1; aim_dy = 0;
knockback_x = 0; knockback_y = 0;
dash_timer = 0; dash_dx = 0; dash_dy = 0; dash_speed = 0;
invincible_timer = 0; hit_flash = 0;
ability_dash_cd = 0;  ability_dash_max = 60;
ability_util_cd = 0;  ability_util_max = 120;
ability_dmg_cd  = 0;  ability_dmg_max  = 180;
ability_ult_cd  = 0;  ability_ult_max  = 600;
ult_active = false; ult_timer = 0;
is_dead = false;
attack_lock = 0;   // frames movement is locked for attack commitment
attack_speed = 1.0; // scale: higher = shorter windup/recovery
depth = -10;
global.player_inst = id;
camera_set_view_target(view_camera[0], id);
camera_set_view_size(view_camera[0], 800, 450);

take_damage = function(dmg, sx, sy) {
	if (invincible_timer > 0) return;
	var final_dmg = max(1, round(dmg * (1 - armor)));
	hp -= final_dmg;
	invincible_timer = 30;
	hit_flash = 10;
	var dx = x - sx, dy = y - sy;
	var d = sqrt(dx * dx + dy * dy);
	if (d > 0) { knockback_x = (dx / d) * 4; knockback_y = (dy / d) * 4; }
	if (hp <= 0) {
		hp = 0;
		is_dead = true;
		alarm[0] = 120;
	}
};
