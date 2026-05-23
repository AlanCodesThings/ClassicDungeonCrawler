life--;
if (life <= 0) { instance_destroy(); exit; }
if (!instance_exists(owner_ref)) { instance_destroy(); exit; }
var cr = (crit_override >= 0)    ? crit_override    : owner_ref.crit_chance;
var cm = (crit_mult_override > 0) ? crit_mult_override : owner_ref.crit_mult;
if (is_player) {
    with (obj_enemy) {
        if (rect_overlap(x, y, col_half_w, col_half_h, other.x, other.y, other.hw, other.hh))
            deal_damage(id, other.x, other.y, other.dmg, cr, cm, 5);
    }
    with (obj_boss) {
        if (rect_overlap(x, y, col_half_w, col_half_h, other.x, other.y, other.hw, other.hh))
            deal_damage(id, other.x, other.y, other.dmg, cr, cm, 3);
    }
}
