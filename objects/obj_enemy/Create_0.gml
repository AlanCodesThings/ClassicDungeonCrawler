hp = 30; max_hp = 30;
damage = 8; move_speed = 1.5; armor = 0.0;
col_half_w = 12; col_half_h = 12;
knockback_x = 0; knockback_y = 0;
invincible_timer = 0; hit_flash = 0;
attack_cd = 0; attack_cd_max = 90;
aggro_range = 320; attack_range = 32;
pin_timer = 0;
is_dead = false;
depth = 0;
// Scale with floor depth
var f = global.floor_number;
hp    = round(hp    * (1 + f * 0.15)); max_hp = hp;
damage = round(damage * (1 + f * 0.10));
