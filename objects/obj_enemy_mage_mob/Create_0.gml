event_inherited();
enemy_type   = ENEMY_MAGE;
ai_timer_max = 40;
var f = global.floor_number;
hp     = round(30 * (1 + f * 0.15)); max_hp = hp;
damage = round(14 * (1 + f * 0.10));
col_half_w = 11; col_half_h = 11;
attack_cd_turns = 0;
