event_inherited();
hp = 4000; max_hp = 4000; damage = 40; move_speed = 2.0; armor = 0.2;
col_half_w = 55; col_half_h = 55;
phase3 = false;
spiral_angle = 0;
on_phase2 = function() { move_speed = 2.8; damage = 55; alarm[2] = 1; };
on_phase3 = function() { move_speed = 3.5; damage = 70; alarm[3] = 1; };
alarm[0] = 85;  // spiral burst
alarm[1] = 140; // targeted volley
