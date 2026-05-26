event_inherited();
hp = 100; max_hp = 100;
damage = 20;
armor  = 0.0;
crit_chance = 0.2; crit_mult = 3.0; // Trait: 3× crits
col_half_w = 10; col_half_h = 10;
// Ability cooldowns (frames, 60fps)
ability_dash_max = 240;  // 4s vanish CD (doubled = 8s after use)
ability_util_max = 360;  // 6s smoke bomb
ability_dmg_max  = 240;  // 4s flurry
ability_ult_max  = 720;  // 12s shadowstep
// Assassin state
invisible      = false;
vanish_timer   = 0;
vanish_timer_max = 240;  // 4s duration
smoke_active   = false;
// Dagger stab animation
thrust_timer = 0;
swing_ang_a  = 0;
swing_ang_b  = 0;
swing_adx    = 0;
swing_ady    = 0;
// Flurry channel state
flurry_active    = false;
flurry_timer     = 0;
flurry_hits_done = 0;
flurry_target    = noone;
flurry_adx       = 0;
flurry_ady       = 0;
