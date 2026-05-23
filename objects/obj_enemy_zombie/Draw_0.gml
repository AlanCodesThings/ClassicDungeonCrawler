var flash = (hit_flash > 5);
var grn   = flash ? c_white : make_color_rgb(65, 115, 50);
var dgrn  = flash ? c_white : make_color_rgb(45, 85, 35);
var bob   = sin(current_time * 0.008 + x * 0.01 + y * 0.01) * 1; // slow lumbering bob

// -- Shambling legs (wide, slow) --
draw_set_color(dgrn);
draw_rectangle(x - 11, y + 8,  x - 3, y + 16 + bob,  false);
draw_rectangle(x + 3,  y + 8,  x + 11, y + 16 - bob, false);

// -- Wide hunched torso --
draw_set_color(grn);
draw_rectangle(x - 14, y - 5 + 3, x + 14, y + 10, false); // main torso (shifted down = hunched)
// Belly bulge
draw_set_color(make_color_rgb(75, 130, 58));
draw_ellipse(x - 10, y, x + 10, y + 10, false);

// -- Reaching arms --
if (!flash) {
    var arm_bob = sin(current_time * 0.008 + x * 0.01 + y * 0.01 + 1) * 4;
    draw_set_color(grn);
    // Left arm reaching forward-left
    draw_rectangle(x - 20, y - 2 + arm_bob, x - 14, y + 6, false);
    draw_rectangle(x - 26, y - 4 + arm_bob, x - 20, y + 2, false); // forearm
    // Right arm reaching forward-right
    draw_rectangle(x + 14, y - 2 - arm_bob, x + 20, y + 6, false);
    draw_rectangle(x + 20, y - 4 - arm_bob, x + 26, y + 2, false);
    // Claws
    draw_set_color(make_color_rgb(35, 65, 28));
    draw_line(x - 26, y - 4 + arm_bob, x - 30, y - 7 + arm_bob);
    draw_line(x - 26, y - 2 + arm_bob, x - 30, y - 1 + arm_bob);
    draw_line(x + 26, y - 4 - arm_bob, x + 30, y - 7 - arm_bob);
    draw_line(x + 26, y - 2 - arm_bob, x + 30, y - 1 - arm_bob);
}

// -- Big head --
draw_set_color(grn);
draw_circle(x, y - 14, 11, false);
if (!flash) {
    // Lopsided features
    draw_set_color(make_color_rgb(20, 14, 10));
    draw_circle(x - 4, y - 16, 3, false); // left eye (sunken)
    draw_set_color(make_color_rgb(220, 50, 20));
    draw_circle(x + 3, y - 14, 2, false); // right eye (bloodshot)
    draw_set_color(make_color_rgb(30, 20, 15));
    draw_line_width(x - 5, y - 9, x + 6, y - 8, 2); // mouth gash
}

// -- Pin indicator --
if (pin_timer > 0) {
    draw_set_color(make_color_rgb(80, 200, 255));
    draw_set_alpha(0.55);
    draw_rectangle(x - 16, y - 27, x + 16, y + 18, true);
    draw_set_alpha(1.0);
}
draw_health_bar(x - 14, y - 32, 28, 5, hp, max_hp, make_color_rgb(60,0,0), c_lime);
