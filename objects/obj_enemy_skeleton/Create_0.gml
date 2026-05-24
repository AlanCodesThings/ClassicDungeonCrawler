event_inherited();
enemy_type = ENEMY_SKELETON;
var f = global.floor_number;
hp     = round(20 * (1 + f * 0.15)); max_hp = hp;
damage = round(10 * (1 + f * 0.10));
col_half_w = 11; col_half_h = 11;
aggro_radius = 8;
