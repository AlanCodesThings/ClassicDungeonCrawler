hp = 100; max_hp = 100;
damage = 20;
armor  = 0.0;
crit_chance = 0.1; crit_mult = 2.0;
col_half_w = 12; col_half_h = 12;
// Grid position (tile coordinates)
grid_x = floor(x / TILE_SIZE);
grid_y = floor(y / TILE_SIZE);
// Snap visual position to tile center
x = grid_x * TILE_SIZE + TILE_SIZE / 2;
y = grid_y * TILE_SIZE + TILE_SIZE / 2;
// Animation gate — blocks input while lerping to new tile
move_anim_timer = 0;
// Turn-based invincibility (blocks hits within the same process_turn call)
invincible_turns = 0;
// Aim direction (normalised, updated toward mouse each frame)
aim_dx = 1; aim_dy = 0;
// Turn-based cooldowns (values = turns remaining)
ability_dash_cd  = 0; ability_dash_max  = 3;
ability_util_cd  = 0; ability_util_max  = 0;
ability_dmg_cd   = 0; ability_dmg_max   = 4;
ability_ult_cd   = 0; ability_ult_max   = 20;
ult_active = false;
ult_turns_left = 0;
hit_flash = 0;
is_dead = false;
depth   = -10;
global.player_inst = id;
camera_set_view_target(view_camera[0], id);
camera_set_view_size(view_camera[0], 800, 450);

take_damage = function(dmg, sx, sy) {
	// Legacy function — kept for alarm[0] death trigger compatibility
	if (invincible_turns > 0) return;
	var final_dmg = max(1, round(dmg * (1 - armor)));
	hp -= final_dmg;
	invincible_turns = 1;
	hit_flash = 10;
	var _dn = instance_create_layer(x + random_range(-6, 6), y - 14, "Instances", obj_damage_number);
	_dn.value = final_dmg; _dn.is_crit = false;
	if (hp <= 0) { hp = 0; is_dead = true; alarm[0] = 120; }
};
