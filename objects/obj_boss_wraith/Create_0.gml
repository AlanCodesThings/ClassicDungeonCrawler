event_inherited();
hp = 1500; max_hp = 1500; damage = 22; move_speed = 2.2; armor = 0.15;
col_half_w = 36; col_half_h = 36;
invis_timer = 0; teleport_cd = 0;
on_phase2 = function() { alarm[2] = 1; };
alarm[0] = 110; // shadow dash loop
alarm[1] = 170; // shadow hands loop
