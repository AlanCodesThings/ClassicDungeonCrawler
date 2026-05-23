event_inherited();
hp = 2500; max_hp = 2500;
damage = 28; armor = 0.1;
col_half_w = 30; col_half_h = 38;
boss_type     = BOSS_NECRO;
move_interval = 3;
on_phase2 = function() { damage = 38; move_interval = 2; };
