event_inherited();
hp = 4000; max_hp = 4000;
damage = 40; armor = 0.2;
col_half_w = 55; col_half_h = 55;
boss_type     = BOSS_DEMON;
move_interval = 2;
spiral_angle  = 0;
nova_fired    = false;
on_phase2 = function() { damage = 55; move_interval = 1; };
