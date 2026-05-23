/// deal_damage(target_id, src_x, src_y, base_dmg, crit_chance, crit_mult, kb_force)
/// Deals damage to an enemy or boss from a player attack.
/// Returns damage dealt, or 0 if target already hit this turn.
function deal_damage(target_id, src_x, src_y, base_dmg, crit_chance, crit_mult, kb_force) {
	if (!instance_exists(target_id)) return 0;
	if (target_id.invincible_timer > 0) return 0;
	var is_crit = (random(1) < crit_chance);
	var dmg = is_crit ? round(base_dmg * crit_mult) : base_dmg;
	dmg = max(1, round(dmg * (1 - target_id.armor)));
	target_id.hp -= dmg;
	target_id.invincible_timer = 30;
	target_id.hit_flash = 10;
	var _dn = instance_create_layer(target_id.x + random_range(-6, 6), target_id.y - 14,
	                                "Instances", obj_damage_number);
	_dn.value   = dmg;
	_dn.is_crit = is_crit;
	if (target_id.hp <= 0) {
		instance_destroy(target_id);
	}
	return dmg;
}
