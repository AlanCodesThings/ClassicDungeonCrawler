event_inherited();
hp = 2500; max_hp = 2500; damage = 28; move_speed = 1.3; armor = 0.1;
col_half_w = 30; col_half_h = 38;
death_zones = [];
on_phase2 = function() { alarm[2] = 60; };
alarm[0] = 130; // summon skeleton loop
alarm[1] = 210; // plague bomb loop
