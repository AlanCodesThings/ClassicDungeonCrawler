map_surface = -1;
depth = 90;
torch_list = ds_list_create();

render_map_surface = function() {
	ds_list_clear(torch_list);
	if (surface_exists(map_surface)) surface_free(map_surface);
	map_surface = surface_create(MAP_W * TILE_SIZE, MAP_H * TILE_SIZE);
	surface_set_target(map_surface);
	draw_clear(make_color_rgb(8, 6, 12));
	var ts = TILE_SIZE;

	// ── Pass 1: Floor tiles ──────────────────────────────────────────────
	for (var ty = 0; ty < MAP_H; ty++) {
		for (var tx = 0; tx < MAP_W; tx++) {
			if (ds_grid_get(global.map_grid, tx, ty) != TILE_FLOOR) continue;
			var px = tx * ts;
			var py = ty * ts;

			// Count non-floor neighbours for edge darkening
			var wall_cnt = 0;
			for (var nx = -1; nx <= 1; nx++) {
				for (var ny = -1; ny <= 1; ny++) {
					if (nx == 0 && ny == 0) continue;
					var cx2 = clamp(tx + nx, 0, MAP_W - 1);
					var cy2 = clamp(ty + ny, 0, MAP_H - 1);
					if (ds_grid_get(global.map_grid, cx2, cy2) != TILE_FLOOR) wall_cnt++;
				}
			}
			var openness = 1.0 - (wall_cnt / 8.0) * 0.30;
			var checker  = (((tx + ty) mod 2) == 0) ? 0.0 : 1.0;
			var noise    = ((tx * 2731 + ty * 6841) mod 64) / 64.0;

			var r = round((54 + checker * 8 + noise * 6) * openness);
			var g = round((49 + checker * 7 + noise * 5) * openness);
			var b = round((41 + checker * 6 + noise * 4) * openness);

			draw_set_color(make_color_rgb(r, g, b));
			draw_rectangle(px, py, px + ts - 1, py + ts - 1, false);

			// Grout border
			draw_set_color(make_color_rgb(24, 20, 16));
			draw_rectangle(px, py, px + ts - 1, py + ts - 1, true);

			// Inner bevel: top/left brighter, bottom/right darker
			draw_set_color(make_color_rgb(min(255, r + 12), min(255, g + 10), min(255, b + 8)));
			draw_line(px + 1, py + 1, px + ts - 3, py + 1);
			draw_line(px + 1, py + 1, px + 1, py + ts - 3);
			draw_set_color(make_color_rgb(max(0, r - 10), max(0, g - 8), max(0, b - 6)));
			draw_line(px + ts - 2, py + 2, px + ts - 2, py + ts - 2);
			draw_line(px + 2, py + ts - 2, px + ts - 2, py + ts - 2);

			// Occasional floor stain (~6% of tiles)
			if (((tx * 5237 + ty * 9311) mod 17) == 0) {
				draw_set_color(make_color_rgb(max(0, r - 14), max(0, g - 11), max(0, b - 9)));
				var ex = px + 8 + ((tx * 3) mod 14);
				var ey = py + 8 + ((ty * 5) mod 14);
				draw_ellipse(ex, ey, ex + 6, ey + 4, false);
			}
		}
	}

	// ── Pass 2: Wall tiles ───────────────────────────────────────────────
	for (var ty = 0; ty < MAP_H; ty++) {
		for (var tx = 0; tx < MAP_W; tx++) {
			if (ds_grid_get(global.map_grid, tx, ty) == TILE_FLOOR) continue;
			var px = tx * ts;
			var py = ty * ts;

			// Walls not adjacent to floor are solid void
			var near_fl = false;
			for (var nx = -1; nx <= 1; nx++) {
				for (var ny = -1; ny <= 1; ny++) {
					if (nx == 0 && ny == 0) continue;
					var cx2 = clamp(tx + nx, 0, MAP_W - 1);
					var cy2 = clamp(ty + ny, 0, MAP_H - 1);
					if (ds_grid_get(global.map_grid, cx2, cy2) == TILE_FLOOR) { near_fl = true; break; }
				}
				if (near_fl) break;
			}

			if (!near_fl) {
				draw_set_color(make_color_rgb(8, 6, 12));
				draw_rectangle(px, py, px + ts, py + ts, false);
				continue;
			}

			// Stone colour with subtle per-tile variation
			var noise = ((tx * 4523 + ty * 8191) mod 64) / 64.0;
			var br = round(36 + noise * 8);
			var bg = round(31 + noise * 6);
			var bb = round(50 + noise * 10);
			draw_set_color(make_color_rgb(br, bg, bb));
			draw_rectangle(px, py, px + ts, py + ts, false);

			// Brick mortar lines
			var half = ts / 2;
			draw_set_color(make_color_rgb(20, 17, 28));
			draw_line_width(px, py + half, px + ts, py + half, 2);
			var vx_u = (ty mod 2 == 0) ? half : 0;
			var vx_l = (ty mod 2 == 0) ? 0    : half;
			draw_line_width(px + vx_u, py,        px + vx_u, py + half, 2);
			draw_line_width(px + vx_l, py + half, px + vx_l, py + ts,   2);

			// Top-left highlight (ambient light)
			draw_set_color(make_color_rgb(min(255, br + 22), min(255, bg + 18), min(255, bb + 28)));
			draw_line_width(px + 1, py + 1, px + ts - 2, py + 1,     2);
			draw_line_width(px + 1, py + 2, px + 1,      py + ts - 2, 2);
			// Bottom-right shadow
			draw_set_color(make_color_rgb(max(0, br - 16), max(0, bg - 13), max(0, bb - 20)));
			draw_line_width(px + 2, py + ts - 2, px + ts,      py + ts - 2, 2);
			draw_line_width(px + ts - 2, py + 2, px + ts - 2, py + ts,      2);
		}
	}

	// ── Pass 3: Wall face + floor shadow (walls open to south) ──────────
	for (var ty = 0; ty < MAP_H - 1; ty++) {
		for (var tx = 0; tx < MAP_W; tx++) {
			var tile_c = ds_grid_get(global.map_grid, tx, ty);
			var tile_s = ds_grid_get(global.map_grid, tx, ty + 1);
			if (tile_c == TILE_FLOOR || tile_s != TILE_FLOOR) continue;
			var px = tx * ts;
			var py = ty * ts;

			// Lit front face of wall (8 px band at tile bottom)
			draw_set_color(make_color_rgb(84, 76, 106));
			draw_rectangle(px + 1, py + ts - 9, px + ts - 1, py + ts - 1, false);
			// Bright top edge of face
			draw_set_color(make_color_rgb(115, 104, 142));
			draw_line_width(px + 1, py + ts - 9, px + ts - 1, py + ts - 9, 2);
			// Dark base of face
			draw_set_color(make_color_rgb(44, 39, 58));
			draw_line_width(px + 1, py + ts - 2, px + ts - 1, py + ts - 2, 2);

			// Cast shadow on the floor tile directly below
			var spx = tx * ts;
			var spy = (ty + 1) * ts;
			draw_set_color(make_color_rgb(14, 11, 9));
			draw_rectangle(spx, spy, spx + ts - 1, spy + 7, false);
			draw_set_color(make_color_rgb(26, 22, 18));
			draw_rectangle(spx, spy + 7, spx + ts - 1, spy + 12, false);
		}
	}

	// ── Pass 4: Torches on south-facing walls ────────────────────────────
	for (var ty = 1; ty < MAP_H - 1; ty++) {
		for (var tx = 1; tx < MAP_W - 1; tx++) {
			var tile_c = ds_grid_get(global.map_grid, tx, ty);
			var tile_s = ds_grid_get(global.map_grid, tx, ty + 1);
			if (tile_c == TILE_FLOOR || tile_s != TILE_FLOOR) continue;
			if ((tx * 3 + ty * 7) mod 11 != 0) continue;

			var cx = tx * ts + ts / 2;
			var cy = ty * ts + ts - 12;
			ds_list_add(torch_list, cx);
			ds_list_add(torch_list, cy);

			// Bracket
			draw_set_color(make_color_rgb(80, 58, 22));
			draw_rectangle(cx - 2, cy + 4, cx + 2, cy + 10, false);
			draw_set_color(make_color_rgb(55, 40, 14));
			draw_rectangle(cx - 4, cy + 8, cx + 4, cy + 10, false);

			// Static flame (animated glow overlay drawn per-frame in Draw event)
			draw_set_color(make_color_rgb(55, 32, 5));
			draw_circle(cx, cy + 2, 7, false);
			draw_set_color(make_color_rgb(200, 110, 15));
			draw_circle(cx, cy + 1, 5, false);
			draw_set_color(make_color_rgb(255, 195, 45));
			draw_circle(cx, cy, 3, false);
			draw_set_color(make_color_rgb(255, 250, 200));
			draw_circle(cx, cy - 1, 1, false);
		}
	}

	surface_reset_target();
};

generate_dungeon(global.floor_number);

// Create or reposition player
var pobj = obj_player_warrior;
if (global.player_class == "Assassin") pobj = obj_player_assassin;
else if (global.player_class == "Archer") pobj = obj_player_archer;

if (!instance_exists(global.player_inst)) {
	global.player_inst = instance_create_layer(global.player_spawn_x, global.player_spawn_y, "Instances", pobj);
} else {
	global.player_inst.x = global.player_spawn_x;
	global.player_inst.y = global.player_spawn_y;
}

// Create UI manager
if (instance_number(obj_ui_manager) == 0) {
	instance_create_layer(0, 0, "Instances", obj_ui_manager);
}

render_map_surface();
