event_inherited();
enemy_type   = ENEMY_ZOMBIE;
ai_timer_max = 45;
aggro_radius = 6;
var f = global.floor_number;
hp     = round(25 * (1 + f * 0.15)); max_hp = hp;
damage = round(15 * (1 + f * 0.10));
armor  = 0.2;
col_half_w = 14; col_half_h = 14;
