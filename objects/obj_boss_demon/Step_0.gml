event_inherited();
// Demon has a 3rd phase; check it here
if (!variable_instance_exists(id, "phase3")) phase3 = false;
if (!phase3 && hp < max_hp * 0.33) {
	phase3 = true;
	phase  = 2; // triggers on_phase2 in boss_take_turn if not yet done
}
