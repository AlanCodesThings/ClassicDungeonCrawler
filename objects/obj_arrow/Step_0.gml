life--;
if (life <= 0) { instance_destroy(); exit; }
x += dx * spd; y += dy * spd;
dist_traveled += spd;
// Distance bonus damage (archer trait: more damage at range)
var dist_bonus = 1.0 + (dist_traveled / 200.0) * 0.5;
dist_bonus = min(dist_bonus, 2.0);
// Wall collision
if (!can_move_to(x, y, half_w, half_h)) { instance_destroy(); exit; }
// Range limit
if (dist_traveled > max_dist) { instance_destroy(); exit; }
// Enemy hit
var did_hit = false;
with (obj_enemy) {
    if (rect_overlap(x, y, col_half_w, col_half_h, other.x, other.y, other.half_w, other.half_h)) {
        deal_damage(id, other.x, other.y, round(other.dmg * dist_bonus), other.crit_chance, other.crit_mult, 5);
        if (other.pin) {
            pin_timer = 110;
            knockback_x = 0; knockback_y = 0;
        }
        if (!other.piercing) did_hit = true;
    }
}
with (obj_boss) {
    if (rect_overlap(x, y, col_half_w, col_half_h, other.x, other.y, other.half_w, other.half_h)) {
        deal_damage(id, other.x, other.y, round(other.dmg * dist_bonus), other.crit_chance, other.crit_mult, 2);
        if (!other.piercing) did_hit = true;
    }
}
if (did_hit && !piercing) { instance_destroy(); exit; }
