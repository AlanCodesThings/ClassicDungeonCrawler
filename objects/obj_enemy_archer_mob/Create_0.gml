event_inherited();
enemy_type = ENEMY_ARCHER;
var f = global.floor_number;
hp     = round(25 * (1 + f * 0.15)); max_hp = hp;
damage = round(9  * (1 + f * 0.10));
col_half_w = 11; col_half_h = 11;
attack_cd_turns = 0;
