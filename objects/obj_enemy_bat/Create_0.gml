event_inherited();
enemy_type   = ENEMY_BAT;
ai_timer_max = 15;
var f = global.floor_number;
hp     = round(15 * (1 + f * 0.15)); max_hp = hp;
damage = round(7  * (1 + f * 0.10));
col_half_w = 9; col_half_h = 9;
