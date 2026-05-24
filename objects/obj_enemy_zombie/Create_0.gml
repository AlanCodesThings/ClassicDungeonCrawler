event_inherited();
enemy_type = ENEMY_ZOMBIE;
var f = global.floor_number;
hp     = round(80 * (1 + f * 0.15)); max_hp = hp;
damage = round(15 * (1 + f * 0.10));
armor  = 0.2;
col_half_w = 14; col_half_h = 14;
aggro_radius = 6;
