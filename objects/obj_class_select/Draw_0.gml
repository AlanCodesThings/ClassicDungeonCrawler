draw_set_color(make_color_rgb(10, 8, 18));
draw_rectangle(0, 0, room_width, room_height, false);

// Stars
var prev_seed = random_get_seed();
random_set_seed(12345);
draw_set_color(make_color_rgb(200, 200, 220));
repeat(120) {
	draw_point(random(room_width), random(room_height));
}
random_set_seed(prev_seed);

if (global.won) {
	draw_set_color(c_yellow);
	draw_set_halign(fa_center); draw_set_valign(fa_middle);
	draw_set_font(-1);
	draw_text(room_width / 2, room_height / 2 - 60, "VICTORY!");
	draw_set_color(c_white);
	draw_text(room_width / 2, room_height / 2, "You conquered all 50 floors!");
	draw_set_color(c_ltgray);
	draw_text(room_width / 2, room_height / 2 + 60, "Press ENTER to play again");
	draw_set_halign(fa_left); draw_set_valign(fa_top);
	exit;
}

draw_set_color(c_white);
draw_set_halign(fa_center); draw_set_valign(fa_top);
draw_text(room_width / 2, 50, "CLASSIC DUNGEON CRAWLER");
draw_set_color(make_color_rgb(180, 180, 200));
draw_text(room_width / 2, 110, "Choose your class");

var bw = 280, bh = 340, gap = 40;
var total_w = bw * 3 + gap * 2;
var startx = (room_width - total_w) / 2;

for (var i = 0; i < 3; i++) {
	var bx = startx + i * (bw + gap);
	var by = 160;
	var is_sel = (i == selected);
	draw_set_color(is_sel ? make_color_rgb(40, 55, 120) : make_color_rgb(20, 20, 40));
	draw_rectangle(bx, by, bx + bw, by + bh, false);
	draw_set_color(is_sel ? c_yellow : make_color_rgb(80, 80, 120));
	draw_rectangle(bx, by, bx + bw, by + bh, true);

	// Class icon
	draw_set_color(is_sel ? c_white : make_color_rgb(160, 160, 190));
	draw_set_halign(fa_center);
	draw_text(bx + bw / 2, by + 18, classes[i]);

	switch (i) {
		case 0: // Warrior
			draw_set_color(make_color_rgb(80, 120, 220));
			draw_rectangle(bx + bw/2 - 14, by + 58, bx + bw/2 + 14, by + 108, false);
			draw_set_color(make_color_rgb(180, 180, 200));
			draw_line_width(bx + bw/2 + 10, by + 58, bx + bw/2 + 10, by + 108, 8);
			draw_set_color(make_color_rgb(100, 100, 200));
			draw_rectangle(bx + bw/2 - 22, by + 65, bx + bw/2 - 14, by + 95, false);
			break;
		case 1: // Assassin
			draw_set_color(make_color_rgb(120, 20, 120));
			draw_rectangle(bx + bw/2 - 16, by + 60, bx + bw/2 - 4, by + 110, false);
			draw_rectangle(bx + bw/2 + 4, by + 60, bx + bw/2 + 16, by + 110, false);
			draw_set_color(make_color_rgb(200, 180, 220));
			draw_line_width(bx + bw/2 - 10, by + 58, bx + bw/2 - 10, by + 30, 2);
			draw_line_width(bx + bw/2 + 10, by + 58, bx + bw/2 + 10, by + 30, 2);
			break;
		case 2: // Archer
			draw_set_color(make_color_rgb(40, 160, 40));
			draw_rectangle(bx + bw/2 - 12, by + 60, bx + bw/2 + 12, by + 110, false);
			draw_set_color(make_color_rgb(180, 130, 60));
			draw_line_width(bx + bw/2 - 20, by + 60, bx + bw/2 + 0, by + 45, 3);
			draw_line_width(bx + bw/2 + 0, by + 45, bx + bw/2 + 20, by + 60, 3);
			draw_set_color(make_color_rgb(200, 200, 180));
			draw_line_width(bx + bw/2 - 20, by + 60, bx + bw/2 + 20, by + 60, 2);
			break;
	}

	var lines = desc_lines[i];
	draw_set_color(make_color_rgb(160, 160, 190));
	for (var li = 0; li < array_length(lines); li++) {
		if (li == 0) draw_set_color(is_sel ? c_white : make_color_rgb(200, 200, 220));
		else if (li == 2) draw_set_color(make_color_rgb(100, 200, 100));
		else draw_set_color(make_color_rgb(160, 160, 190));
		draw_text(bx + bw / 2, by + 128 + li * 38, lines[li]);
	}
}

draw_set_color(c_yellow);
draw_set_halign(fa_center);
draw_text(room_width / 2, 530, "< A / D or hover to select   |   CLICK ANYWHERE or ENTER to play >");

// Boss shortcut button
var bbx = room_width / 2 - 130;
var bby = 572;
var bbw = 260; var bbh = 40;
var boss_hover = (mouse_x >= bbx && mouse_x <= bbx + bbw && mouse_y >= bby && mouse_y <= bby + bbh);
draw_set_color(boss_hover ? make_color_rgb(150, 30, 20) : make_color_rgb(70, 14, 10));
draw_rectangle(bbx, bby, bbx + bbw, bby + bbh, false);
draw_set_color(boss_hover ? make_color_rgb(255, 90, 70) : make_color_rgb(160, 50, 40));
draw_rectangle(bbx, bby, bbx + bbw, bby + bbh, true);
draw_set_color(boss_hover ? c_white : make_color_rgb(210, 160, 150));
draw_set_halign(fa_center); draw_set_valign(fa_middle);
draw_text(bbx + bbw / 2, bby + bbh / 2, "Skip to Boss (Floor 10)");
draw_set_halign(fa_left); draw_set_valign(fa_top);

