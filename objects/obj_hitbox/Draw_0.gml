var pct = life / max_life;

if (aim_dx != 0 || aim_dy != 0) {
    // Directional swing: streak along aim direction, fades and shrinks
    var streak_len = (hw * 1.4 + 8) * pct; // shrinks as it fades
    var perp_x = -aim_dy;
    var perp_y =  aim_dx;

    // Soft outer glow (wide, low alpha)
    draw_set_alpha(pct * 0.45);
    draw_set_color(make_color_rgb(200, 220, 255));
    draw_line_width(
        x - aim_dx * streak_len * 0.6, y - aim_dy * streak_len * 0.6,
        x + aim_dx * streak_len,       y + aim_dy * streak_len,
        10 * pct + 3);

    // Bright core streak
    draw_set_alpha(pct * 0.9);
    draw_set_color(c_white);
    draw_line_width(
        x - aim_dx * streak_len * 0.5, y - aim_dy * streak_len * 0.5,
        x + aim_dx * streak_len,       y + aim_dy * streak_len,
        4 * pct + 1);

    // Impact burst at the tip (only first half of life)
    if (pct > 0.5) {
        var bpct = (pct - 0.5) * 2.0;
        draw_set_alpha(bpct * 0.8);
        draw_set_color(make_color_rgb(255, 255, 200));
        var br = 7 * (1.0 - bpct) + 2;
        draw_circle(x + aim_dx * streak_len, y + aim_dy * streak_len, br, false);
        // Small cross-spark at tip
        draw_set_alpha(bpct * 0.6);
        draw_line_width(x + aim_dx * streak_len - perp_x * 5, y + aim_dy * streak_len - perp_y * 5,
                        x + aim_dx * streak_len + perp_x * 5, y + aim_dy * streak_len + perp_y * 5, 2);
    }
    draw_set_alpha(1.0);
} else {
    // No direction set — plain flash circle (e.g. AoE or enemy hitboxes)
    draw_set_alpha(pct * 0.5);
    draw_set_color(c_white);
    draw_circle(x, y, (hw + hh) * 0.5 * (0.5 + pct * 0.5), true);
    draw_set_alpha(1.0);
}
