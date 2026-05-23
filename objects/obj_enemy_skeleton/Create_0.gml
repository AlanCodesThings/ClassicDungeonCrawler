event_inherited();
// Override base stats (re-apply floor scaling)
var f = global.floor_number;
hp     = round(20 * (1 + f * 0.15)); max_hp = hp;
damage = round(10 * (1 + f * 0.10));
move_speed = 2.2; armor = 0.0;
col_half_w = 11; col_half_h = 11;
attack_range = 28;
