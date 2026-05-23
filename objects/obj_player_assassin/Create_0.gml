event_inherited();
hp = 100; max_hp = 100;
damage = 20;
armor  = 0.0;
crit_chance = 0.2; crit_mult = 3.0; // Trait: 3× crits
col_half_w = 10; col_half_h = 10;
// Ability cooldowns (in turns)
ability_dash_max = 4;   // vanish: 4 turns of invisibility, CD 8 turns
ability_util_max = 6;   // smoke bomb
ability_dmg_max  = 4;   // flurry
ability_ult_max  = 12;  // shadowstep
// Assassin state
invisible    = false;
vanish_turns = 0;
smoke_active = false;
