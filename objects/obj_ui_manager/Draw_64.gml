if (!instance_exists(global.player_inst)) exit;
var p   = global.player_inst;
var cls = global.player_class;

// ── HP Bar (top-left) ──────────────────────────────────────────────
var hpx = 10; var hpy = 10; var hpw = 220; var hph = 18;
var hp_pct = clamp(p.hp / p.max_hp, 0, 1);
draw_set_color(make_color_rgb(40, 8, 8));
draw_rectangle(hpx, hpy, hpx + hpw, hpy + hph, false);
var hp_fill_col;
if (hp_pct > 0.5)       hp_fill_col = make_color_rgb(210, 55, 55);
else if (hp_pct > 0.25) hp_fill_col = make_color_rgb(215, 130, 25);
else                    hp_fill_col = make_color_rgb(250, 55, 25);
draw_set_color(hp_fill_col);
draw_rectangle(hpx, hpy, hpx + round(hpw * hp_pct), hpy + hph, false);
draw_set_color(make_color_rgb(18, 4, 4));
var seg_w = hpw / 5;
for (var si = 1; si < 5; si++) {
    draw_line_width(hpx + si * seg_w, hpy, hpx + si * seg_w, hpy + hph, 1);
}
draw_set_color(make_color_rgb(180, 60, 60));
draw_rectangle(hpx, hpy, hpx + hpw, hpy + hph, true);
draw_set_color(c_white);
draw_set_halign(fa_left); draw_set_valign(fa_top);
draw_text(hpx, hpy + hph + 3, string(p.hp) + " / " + string(p.max_hp));
draw_set_color(make_color_rgb(160, 160, 210));
draw_text(hpx, hpy + hph + 18, cls);

// ── Floor / status (top-centre) ─────────────────────────────────────
draw_set_halign(fa_center);
draw_set_color(c_yellow);
draw_text(683, 8, "Floor " + string(global.floor_number) + (global.boss_floor ? "  [BOSS]" : ""));
var ult_on = false;
if (variable_instance_exists(p, "two_hand_active") && p.two_hand_active) ult_on = true;
if (variable_instance_exists(p, "invisible")        && p.invisible)       ult_on = true;
if (p.ult_active) ult_on = true;
if (ult_on) {
    draw_set_alpha(0.6 + sin(current_time * 0.08) * 0.4);
    draw_set_color(c_yellow);
    draw_text(683, 28, "ULTIMATE ACTIVE");
    draw_set_alpha(1.0);
}
if (global.boss_floor && global.boss_killed) {
    draw_set_color(make_color_rgb(100, 255, 100));
    draw_text(683, 48, "Boss defeated — find the stairs!");
}
draw_set_halign(fa_left);

// ── Hotbar — 5 slots: LMB / SPACE / RMB / E / Q ──────────────────
var slot_sz  = 64;
var slot_gap = 10;
var n_slots  = 5;
var bar_w    = slot_sz * n_slots + slot_gap * (n_slots - 1);
var bar_x    = floor((display_get_gui_width()  - bar_w) * 0.5);
var bar_y    = display_get_gui_height() - slot_sz - 22;
var bar_pad  = 10;

// Panel shadow + background
draw_set_color(make_color_rgb(0, 0, 0));
draw_set_alpha(0.5);
draw_rectangle(bar_x - bar_pad + 2, bar_y - bar_pad - 18 + 2,
               bar_x + bar_w + bar_pad + 2, bar_y + slot_sz + bar_pad + 2, false);
draw_set_alpha(0.92);
draw_set_color(make_color_rgb(10, 8, 20));
draw_rectangle(bar_x - bar_pad, bar_y - bar_pad - 18,
               bar_x + bar_w + bar_pad, bar_y + slot_sz + bar_pad, false);
draw_set_alpha(1.0);
draw_set_color(make_color_rgb(50, 44, 80));
draw_rectangle(bar_x - bar_pad, bar_y - bar_pad - 18,
               bar_x + bar_w + bar_pad, bar_y + slot_sz + bar_pad, true);

// Slot CDs / maxes  (index 0 = LMB basic, no CD)
var slot_cds  = [0, p.ability_dash_cd, p.ability_util_cd, p.ability_dmg_cd,  p.ability_ult_cd];
var slot_maxs = [0, p.ability_dash_max, p.ability_util_max, p.ability_dmg_max, p.ability_ult_max];
var slot_cols = [
    make_color_rgb(195, 190, 220),  // LMB — silver
    make_color_rgb(80,  210, 235),  // SPACE — cyan
    make_color_rgb(80,  220, 120),  // RMB — lime
    make_color_rgb(225, 150, 50),   // E — orange
    make_color_rgb(185, 100, 255)]; // Q — purple
var slot_keys = ["LMB", "SPACE", "RMB", "E", "Q"];

var slot_labs = [];
if (cls == "Warrior") {
    slot_labs = ["THRUST", "SHUFFLE", "SHIELD", "CHARGE", "2H MODE"];
} else if (cls == "Assassin") {
    slot_labs = ["STAB", "VANISH", "SMOKE", "FLURRY", "STEP"];
} else {
    slot_labs = ["FIRE", "DODGE", "—", "POWER", "QUIVER"];
}

// Active state (slot lights up when ability is in-use)
var slot_active = [false, false, false, false, false];
if (variable_instance_exists(p, "attack_lock")    && p.attack_lock > 0)    slot_active[0] = true;
if (variable_instance_exists(p, "dash_timer")     && p.dash_timer > 0)     slot_active[1] = true;
if (variable_instance_exists(p, "invisible")      && p.invisible)           slot_active[1] = true;
if (variable_instance_exists(p, "shield_active")  && p.shield_active)       slot_active[2] = true;
if (variable_instance_exists(p, "charge_timer")   && p.charge_timer > 0)   slot_active[3] = true;
if (variable_instance_exists(p, "flurry_active")  && p.flurry_active)       slot_active[3] = true;
if (variable_instance_exists(p, "charging")       && p.charging)            slot_active[3] = true;
if (variable_instance_exists(p, "two_hand_active") && p.two_hand_active)    slot_active[4] = true;
if (p.ult_active)                                                            slot_active[4] = true;

for (var i = 0; i < n_slots; i++) {
    var sx  = bar_x + i * (slot_sz + slot_gap);
    var sy  = bar_y;
    var cd  = slot_cds[i];
    var mcd = slot_maxs[i];
    var col = slot_cols[i];
    var has_cd = (mcd > 0);
    var ready  = (!has_cd || cd <= 0);

    // Ready-flash tracking
    if (has_cd) {
        if (cd > 0) {
            cd_was_active[i] = true;
        } else if (cd_was_active[i]) {
            cd_was_active[i] = false;
            cd_flash_timer[i] = 30;
        }
        if (cd_flash_timer[i] > 0) cd_flash_timer[i]--;
    }

    // Slot background
    draw_set_color(ready ? make_color_rgb(18, 15, 32) : make_color_rgb(11, 9, 20));
    draw_rectangle(sx, sy, sx + slot_sz, sy + slot_sz, false);

    // Icon color — dim to ~30% when on CD
    var icon_col;
    if (ready) {
        icon_col = col;
    } else {
        icon_col = make_color_rgb(
            round(colour_get_red(col)   * 0.28),
            round(colour_get_green(col) * 0.28),
            round(colour_get_blue(col)  * 0.28));
    }
    draw_set_color(icon_col);

    var ic  = sx + slot_sz / 2;    // icon centre x
    var icy = sy + slot_sz / 2 - 2; // icon centre y

    // ── Per-class icons ───────────────────────────────────────────
    if (cls == "Warrior") {
        switch (i) {
            case 0: // Thrust — sword
                draw_line_width(ic - 11, icy + 11, ic + 11, icy - 11, 4);
                draw_line_width(ic - 7, icy - 3, ic + 7, icy + 3, 2);
                draw_circle(ic + 12, icy - 12, 2, false);
                break;
            case 1: // Shuffle — right arrow
                draw_triangle(ic + 13, icy, ic + 1, icy - 10, ic + 1, icy + 10, false);
                draw_rectangle(ic - 10, icy - 4, ic + 1, icy + 4, false);
                break;
            case 2: // Shield — D-shape
                draw_circle(ic, icy - 1, 12, false);
                draw_set_color(make_color_rgb(11, 9, 20));
                draw_rectangle(ic - 14, icy + 9, ic + 14, icy + 18, false);
                draw_set_color(icon_col);
                draw_circle(ic, icy - 1, 12, true);
                draw_line_width(ic, icy - 13, ic, icy + 9, 2);
                break;
            case 3: // Charge — arc rings + bolt
                draw_ellipse(ic - 14, icy - 8, ic + 14, icy + 8, true);
                draw_ellipse(ic - 9,  icy - 5, ic + 9,  icy + 5, true);
                // Lightning bolt
                draw_line_width(ic - 3, icy - 8, ic + 3,  icy - 1, 2);
                draw_line_width(ic + 3, icy - 1, ic - 2,  icy + 3, 2);
                draw_line_width(ic - 2, icy + 3, ic + 4, icy + 10, 2);
                break;
            case 4: // 2H sword — wider blade
                draw_line_width(ic - 13, icy + 13, ic + 13, icy - 13, 5);
                draw_line_width(ic - 9,  icy - 4,  ic + 9,  icy + 4,  2);
                draw_circle(ic + 14, icy - 14, 3, false);
                draw_circle(ic - 13, icy + 13, 3, false);
                break;
        }
    } else if (cls == "Assassin") {
        switch (i) {
            case 0: // Dual stab — X daggers
                draw_line_width(ic - 11, icy - 11, ic + 11, icy + 11, 3);
                draw_line_width(ic + 11, icy - 11, ic - 11, icy + 11, 3);
                draw_circle(ic - 12, icy - 12, 2, false);
                draw_circle(ic + 12, icy - 12, 2, false);
                break;
            case 1: // Vanish — slashed eye
                draw_ellipse(ic - 13, icy - 5, ic + 13, icy + 5, true);
                draw_circle(ic, icy, 4, false);
                draw_line_width(ic - 11, icy + 8, ic + 11, icy - 8, 2);
                break;
            case 2: // Smoke bomb — cloud
                draw_circle(ic,     icy + 3,  8, false);
                draw_circle(ic - 8, icy + 5,  6, false);
                draw_circle(ic + 8, icy + 5,  6, false);
                draw_circle(ic - 3, icy - 4,  7, false);
                draw_circle(ic + 4, icy - 3,  6, false);
                break;
            case 3: // Flurry — starburst of lines
                for (var li = 0; li < 6; li++) {
                    var la = li * 60;
                    draw_line_width(ic + lengthdir_x(5, la),  icy + lengthdir_y(5, la),
                                    ic + lengthdir_x(14, la), icy + lengthdir_y(14, la), 2);
                }
                break;
            case 4: // Shadowstep — portal ring + figure
                draw_circle(ic, icy, 12, true);
                draw_circle(ic, icy, 7,  false);
                draw_circle(ic, icy - 6, 3, false);
                break;
        }
    } else { // Archer
        switch (i) {
            case 0: // Fire — arrow in flight
                draw_triangle(ic + 15, icy, ic + 5, icy - 7, ic + 5, icy + 7, false);
                draw_line_width(ic - 10, icy, ic + 5, icy, 2);
                draw_line_width(ic - 10, icy, ic - 6, icy - 5, 1);
                draw_line_width(ic - 10, icy, ic - 6, icy + 5, 1);
                break;
            case 1: // Dodge — arrow + pin circle
                draw_triangle(ic + 12, icy, ic - 2, icy - 9, ic - 2, icy + 9, false);
                draw_rectangle(ic - 11, icy - 3, ic - 2, icy + 3, false);
                draw_set_color(make_color_rgb(80, 200, 255));
                draw_circle(ic + 12, icy - 11, 4, true);
                draw_set_color(icon_col);
                break;
            case 2: // No ability
                draw_set_color(make_color_rgb(55, 50, 75));
                draw_line_width(ic - 11, icy, ic + 11, icy, 3);
                break;
            case 3: // Power shot — drawn bow
                draw_line_width(ic - 1, icy - 14, ic + 5, icy, 2);
                draw_line_width(ic + 5, icy, ic - 1, icy + 14, 2);
                draw_line(ic - 1, icy - 14, ic - 10, icy);
                draw_line(ic - 1, icy + 14, ic - 10, icy);
                draw_line_width(ic - 10, icy, ic + 5, icy, 2);
                break;
            case 4: // Quiver — bundle of arrows
                draw_rectangle(ic - 5, icy - 11, ic + 5, icy + 8, false);
                draw_ellipse(ic - 5, icy + 5, ic + 5, icy + 9, false);
                for (var qi = 0; qi < 3; qi++) {
                    draw_line_width(ic - 3 + qi * 3, icy - 11, ic - 3 + qi * 3, icy - 17, 1);
                }
                break;
        }
    }

    // Cooldown overlay — fills from top, shrinks as CD counts down
    if (!ready && has_cd) {
        var cd_h = round((cd / mcd) * (slot_sz - 2));
        draw_set_color(c_black);
        draw_set_alpha(0.74);
        draw_rectangle(sx + 1, sy + 1, sx + slot_sz - 1, sy + 1 + cd_h, false);
        draw_set_alpha(1.0);
        // Seconds remaining (only when > 1 second left)
        if (cd > 60) {
            draw_set_color(c_white);
            draw_set_halign(fa_center); draw_set_valign(fa_middle);
            draw_text(sx + slot_sz / 2, sy + slot_sz / 2, string(ceil(cd / 60)) + "s");
        }
    }

    // Border — ready/active/flash state
    draw_set_alpha(1.0);
    var border_col;
    if (has_cd && cd_flash_timer[i] > 0) {
        var fp = cd_flash_timer[i] / 30.0;
        border_col = make_color_rgb(
            round(colour_get_red(col)   + (255 - colour_get_red(col))   * fp),
            round(colour_get_green(col) + (255 - colour_get_green(col)) * fp),
            round(colour_get_blue(col)  + (255 - colour_get_blue(col))  * fp));
        draw_set_alpha(0.55 + fp * 0.45);
    } else if (slot_active[i]) {
        border_col = c_white;
        draw_set_alpha(0.65 + sin(current_time * 0.09) * 0.35);
    } else if (ready) {
        border_col = col;
        draw_set_alpha(1.0);
    } else {
        border_col = make_color_rgb(
            round(colour_get_red(col)   * 0.32),
            round(colour_get_green(col) * 0.32),
            round(colour_get_blue(col)  * 0.32));
        draw_set_alpha(1.0);
    }
    draw_set_color(border_col);
    draw_rectangle(sx, sy, sx + slot_sz, sy + slot_sz, true);
    draw_set_alpha(1.0);

    // Key label — bottom of slot
    draw_set_color(make_color_rgb(120, 115, 155));
    draw_set_halign(fa_center); draw_set_valign(fa_bottom);
    draw_text(sx + slot_sz / 2, sy + slot_sz - 2, slot_keys[i]);

    // Ability name — above slot
    draw_set_color(ready ? make_color_rgb(185, 180, 215) : make_color_rgb(75, 70, 100));
    draw_set_valign(fa_bottom);
    draw_text(sx + slot_sz / 2, sy - 2, slot_labs[i]);
}

draw_set_halign(fa_left); draw_set_valign(fa_top);
