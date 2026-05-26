var shaft_len = is_power ? 22 : 16;
var tail_x = x - dir_x * shaft_len;
var tail_y = y - dir_y * shaft_len;

// Shaft
draw_set_color(is_ult ? make_color_rgb(80, 230, 255) : make_color_rgb(200, 180, 120));
draw_line_width(tail_x, tail_y, x, y, is_power ? 3 : 2);

// Arrowhead (small triangle in travel direction)
var perp_x = -dir_y;
var perp_y =  dir_x;
var tip_x  = x + dir_x * 6;
var tip_y  = y + dir_y * 6;
var base_w = is_power ? 5 : 3;
draw_set_color(is_ult ? make_color_rgb(50, 200, 240) : make_color_rgb(220, 200, 100));
draw_triangle(tip_x, tip_y,
              x + perp_x * base_w, y + perp_y * base_w,
              x - perp_x * base_w, y - perp_y * base_w, false);

// Fletching
var fletch_len = 7;
draw_set_color(make_color_rgb(160, 80, 40));
draw_line(tail_x, tail_y, tail_x - dir_x * fletch_len + perp_x * 4, tail_y - dir_y * fletch_len + perp_y * 4);
draw_line(tail_x, tail_y, tail_x - dir_x * fletch_len - perp_x * 4, tail_y - dir_y * fletch_len - perp_y * 4);

// Power shot glow
if (is_power) {
    draw_set_alpha(0.35);
    draw_set_color(make_color_rgb(255, 220, 80));
    draw_circle(x, y, 10, false);
    draw_set_alpha(1.0);
}

// Ult glow
if (is_ult) {
    draw_set_alpha(0.4);
    draw_set_color(make_color_rgb(80, 230, 255));
    draw_circle(x, y, 8, false);
    draw_set_alpha(1.0);
}
