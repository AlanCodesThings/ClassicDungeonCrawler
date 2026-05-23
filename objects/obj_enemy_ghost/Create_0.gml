event_inherited();
enemy_type   = ENEMY_GHOST;
ai_timer_max = 30;
var f = global.floor_number;
hp     = round(35 * (1 + f * 0.15)); max_hp = hp;
damage = round(12 * (1 + f * 0.10));
armor  = 0.1;
col_half_w = 12; col_half_h = 12;
phase_mode = false;
