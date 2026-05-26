event_inherited();
hp = 110; max_hp = 110;
damage = 22;
armor  = 0.0;
crit_chance = 0.15; crit_mult = 2.0;
col_half_w = 11; col_half_h = 11;
// Ability cooldowns (frames, 60fps)
ability_dash_max = 180;
ability_util_max = 240;  // 4s dodge + pin
ability_dmg_max  = 300;  // 5s power shot
ability_ult_max  = 1080; // 18s enchanted quiver
// Archer state
charge_timer   = 0;
charging       = false;
arrow_delay    = 0;
arrow_aim_dx   = 0;
arrow_aim_dy   = 0;
pin_shot_ready = false;
dodge_timer    = 0;
dodge_from_x   = 0;
dodge_from_y   = 0;
ult_timer      = 0;
ult_timer_max  = 600;    // 10s duration
