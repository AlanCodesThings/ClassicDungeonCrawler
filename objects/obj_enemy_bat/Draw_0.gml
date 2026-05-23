var flash = (hit_flash > 5);
var wing_flap = sin(current_time * 0.25 + x * 0.01 + y * 0.01) * 8;
var body_bob  = sin(current_time * 0.22 + x * 0.01 + y * 0.01) * 3;

// -- Wings (animated flapping) --
draw_set_color(flash ? c_white : make_color_rgb(55, 25, 75));
// Left wing
draw_triangle(x, y + body_bob,
              x - col_half_w * 2.6, y - 6 + wing_flap + body_bob,
              x - col_half_w,       y - 2 + body_bob, false);
// Right wing
draw_triangle(x, y + body_bob,
              x + col_half_w * 2.6, y - 6 + wing_flap + body_bob,
              x + col_half_w,       y - 2 + body_bob, false);

// Wing membrane highlight
if (!flash) {
    draw_set_color(make_color_rgb(75, 40, 95));
    draw_triangle(x - 2, y + body_bob,
                  x - col_half_w * 2.0, y - 4 + wing_flap + body_bob,
                  x - col_half_w * 0.5, y + body_bob, false);
    draw_triangle(x + 2, y + body_bob,
                  x + col_half_w * 2.0, y - 4 + wing_flap + body_bob,
                  x + col_half_w * 0.5, y + body_bob, false);
}

// -- Body --
draw_set_color(flash ? c_white : make_color_rgb(40, 18, 58));
draw_circle(x, y + body_bob, col_half_w - 1, false);

// -- Ears --
if (!flash) {
    draw_set_color(make_color_rgb(60, 25, 80));
    draw_triangle(x - 4, y - col_half_w + body_bob,
                  x - 8, y - col_half_w - 7 + body_bob,
                  x - 1, y - col_half_w - 4 + body_bob, false);
    draw_triangle(x + 4, y - col_half_w + body_bob,
                  x + 8, y - col_half_w - 7 + body_bob,
                  x + 1, y - col_half_w - 4 + body_bob, false);
    // Inner ear
    draw_set_color(make_color_rgb(150, 60, 100));
    draw_triangle(x - 4, y - col_half_w + body_bob,
                  x - 6, y - col_half_w - 5 + body_bob,
                  x - 2, y - col_half_w - 3 + body_bob, false);
    draw_triangle(x + 4, y - col_half_w + body_bob,
                  x + 6, y - col_half_w - 5 + body_bob,
                  x + 2, y - col_half_w - 3 + body_bob, false);
    // Eyes
    draw_set_color(make_color_rgb(255, 40, 40));
    draw_circle(x - 3, y - 2 + body_bob, 2, false);
    draw_circle(x + 3, y - 2 + body_bob, 2, false);
    draw_set_color(make_color_rgb(20, 10, 10));
    draw_circle(x - 3, y - 2 + body_bob, 1, false);
    draw_circle(x + 3, y - 2 + body_bob, 1, false);
    // Fangs
    draw_set_color(make_color_rgb(240, 235, 220));
    draw_triangle(x - 2, y + 2 + body_bob, x - 3, y + 6 + body_bob, x - 1, y + 2 + body_bob, false);
    draw_triangle(x + 2, y + 2 + body_bob, x + 3, y + 6 + body_bob, x + 1, y + 2 + body_bob, false);
}

// -- Pin indicator --
if (pin_timer > 0) {
    draw_set_color(make_color_rgb(80, 200, 255));
    draw_set_alpha(0.55);
    draw_circle(x, y + body_bob, col_half_w + 4, true);
    draw_set_alpha(1.0);
}
draw_health_bar(x - col_half_w, y - col_half_w - 14, col_half_w * 2, 4, hp, max_hp, make_color_rgb(60,0,0), c_lime);
