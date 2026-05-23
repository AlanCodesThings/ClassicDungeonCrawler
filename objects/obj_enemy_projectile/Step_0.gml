if (life_timer > 0) {
    life_timer--;
    if (life_timer <= 0) {
        if (instance_exists(global.player_inst) && point_distance(x, y, global.player_inst.x, global.player_inst.y) < hw * 2)
            global.player_inst.take_damage(dmg, x, y);
        instance_destroy(); exit;
    }
}
if (spd > 0) {
    x += dx * spd; y += dy * spd;
    if (!can_move_to(x, y, hw, hh)) { instance_destroy(); exit; }
}
if (instance_exists(global.player_inst)) {
    var px = global.player_inst.x, py = global.player_inst.y;
    if (rect_overlap(px, py, global.player_inst.col_half_w, global.player_inst.col_half_h, x, y, hw, hh)) {
        // Smoke bomb protection
        var prot = false;
        with (obj_smoke_bomb) { if (point_distance(x, y, other.x, other.y) < radius) prot = true; }
        if (!prot) global.player_inst.take_damage(dmg, x, y);
        if (spd > 0) { instance_destroy(); exit; }
    }
    // Warrior shield block
    if (variable_instance_exists(global.player_inst, "shield_active") && global.player_inst.shield_active) {
        if (rect_overlap(px, py, 32, 32, x, y, hw, hh)) { instance_destroy(); exit; }
    }
}
