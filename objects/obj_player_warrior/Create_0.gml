event_inherited();
hp = 150; max_hp = 150;
damage = 15;
armor  = 0.25; // Unique trait: reduced damage taken
crit_chance = 0.1; crit_mult = 2.0;
col_half_w = 13; col_half_h = 13;
// Ability cooldowns (frames, 60fps)
ability_dash_max = 180;  // 3s shuffle
ability_util_max = 360;  // parry — 6s cooldown
ability_dmg_max  = 240;  // 4s charge attack
ability_ult_max  = 1200; // 20s 2H sword
// Warrior-specific state
parry_active        = false;
parry_timer         = 0;
parry_timer_max     = 120; // 2s active window
parry_counter_timer = 0;   // drives counter-attack visual
charge_timer       = 0;
two_hand_active    = false;
two_hand_timer     = 0;
two_hand_timer_max = 600; // 10s
riposte_declared   = false;
// Sword swing trail
thrust_timer = 0;
swing_ang    = 0;
swing_half   = 60;
sword_trail  = [];
// Charge slam animation
charge_slam_timer = 0;
charge_slam_lvl   = 0;
charge_slam_dx    = 0;
charge_slam_dy    = 0;
