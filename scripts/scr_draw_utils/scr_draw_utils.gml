function draw_health_bar(xx, yy, ww, hh, current, maximum, col_bg, col_fg) {
	draw_set_color(col_bg);
	draw_rectangle(xx, yy, xx + ww, yy + hh, false);
	if (maximum > 0) {
		var pct = clamp(current / maximum, 0, 1);
		draw_set_color(col_fg);
		draw_rectangle(xx, yy, xx + round(ww * pct), yy + hh, false);
	}
	draw_set_color(c_black);
	draw_rectangle(xx, yy, xx + ww, yy + hh, true);
	draw_set_color(c_white);
}

function draw_cooldown_pip(xx, yy, sz, current_cd, max_cd, col_ready, col_cooling, label) {
	var pct = (max_cd > 0) ? clamp(1 - (current_cd / max_cd), 0, 1) : 1;
	draw_set_color((current_cd <= 0) ? col_ready : col_cooling);
	draw_rectangle(xx, yy, xx + sz, yy + sz, false);
	if (current_cd > 0) {
		draw_set_color(make_color_rgb(20, 20, 20));
		draw_rectangle(xx, yy + round(sz * pct), xx + sz, yy + sz, false);
	}
	draw_set_color(c_black);
	draw_rectangle(xx, yy, xx + sz, yy + sz, true);
	var prev_ha = draw_get_halign();
	var prev_va = draw_get_valign();
	draw_set_color(c_white);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_text(xx + sz / 2, yy + sz / 2, label);
	draw_set_halign(prev_ha);
	draw_set_valign(prev_va);
}
