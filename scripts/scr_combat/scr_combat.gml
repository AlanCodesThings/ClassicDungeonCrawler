/// deal_damage(target_id, src_x, src_y, base_dmg, crit_chance, crit_mult, kb_force)
/// Deals damage to target_id from position (src_x, src_y).
/// Returns damage dealt, or 0 if blocked by invincibility.
function deal_damage(target_id, src_x, src_y, base_dmg, crit_chance, crit_mult, kb_force) {
	if (!instance_exists(target_id)) return 0;
	if (target_id.invincible_timer > 0) return 0;
	var dmg = base_dmg;
	if (random(1) < crit_chance) dmg = round(dmg * crit_mult);
	dmg = max(1, round(dmg * (1 - target_id.armor)));
	target_id.hp -= dmg;
	target_id.invincible_timer = 6;
	target_id.hit_flash = 10;
	var _dn = instance_create_layer(target_id.x + random_range(-6, 6), target_id.y - 14, "Instances", obj_damage_number);
	_dn.value   = dmg;
	_dn.is_crit = (dmg > base_dmg);
	if (kb_force > 0) {
		var dx = target_id.x - src_x;
		var dy = target_id.y - src_y;
		var d = sqrt(dx * dx + dy * dy);
		if (d > 0) {
			target_id.knockback_x += (dx / d) * kb_force;
			target_id.knockback_y += (dy / d) * kb_force;
		}
	}
	if (target_id.hp <= 0) {
		instance_destroy(target_id);
	}
	return dmg;
}
