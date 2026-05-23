draw_set_color(make_color_rgb(200, 160, 0));
draw_rectangle(x - 18, y - 18, x + 18, y + 18, false);
draw_set_color(c_black);
for (var i = 0; i < 4; i++) draw_line(x - 13, y - 11 + i * 8, x + 13, y - 11 + i * 8);
draw_set_color(c_yellow);
draw_rectangle(x - 18, y - 18, x + 18, y + 18, true);
// Lock icon if boss still alive on boss floor
if (global.boss_floor && !global.boss_killed) {
    draw_set_color(c_red);
    draw_circle(x, y - 24, 8, false);
}
