event_inherited();
hp = 1000; max_hp = 1000; damage = 25; move_speed = 0.9; armor = 0.3;
col_half_w = 44; col_half_h = 44;
stomp_telegraph = 0;
on_phase2 = function() { move_speed = 1.6; damage = 36; alarm[2] = 1; };
alarm[0] = 120; // stomp loop
alarm[1] = 180; // rock throw loop
