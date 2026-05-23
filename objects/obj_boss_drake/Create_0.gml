event_inherited();
hp = 2000; max_hp = 2000; damage = 30; move_speed = 1.8; armor = 0.2;
col_half_w = 50; col_half_h = 38;
charge_active = false; charge_dx = 0; charge_dy = 0; charge_speed = 0;
breath_timer = 0;
on_phase2 = function() { alarm[2] = 60; };
alarm[0] = 210; // charge loop
alarm[1] = 160; // breath loop
