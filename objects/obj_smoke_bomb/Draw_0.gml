var al = 0.5 * (timer / 240.0);
draw_set_alpha(al);
draw_set_color(make_color_rgb(100, 100, 100));
draw_circle(x, y, radius, false);
draw_set_alpha(1.0);
