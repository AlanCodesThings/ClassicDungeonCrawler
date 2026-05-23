#macro TILE_WALL 0
#macro TILE_FLOOR 1
#macro TILE_STAIRS 2
#macro MAP_W 72
#macro MAP_H 54
#macro TILE_SIZE 32

function generate_dungeon(floor_num) {
	global.room_list = [];
	global.boss_floor = false;
	global.boss_killed = false;
	if (ds_exists(global.map_grid, ds_type_grid)) ds_grid_destroy(global.map_grid);
	global.map_grid = ds_grid_create(MAP_W, MAP_H);
	ds_grid_set_region(global.map_grid, 0, 0, MAP_W-1, MAP_H-1, TILE_WALL);
	if (floor_num > 0 && floor_num mod 10 == 0) {
		gen_boss_floor(floor_num);
	} else {
		var root = new BSPNode(1, 1, MAP_W-2, MAP_H-2);
		bsp_split(root, 0);
		bsp_create_rooms(root);
		bsp_connect_rooms(root);
		place_stairs_and_spawn(floor_num);
		spawn_enemies(floor_num);
	}
}

// Renamed fields: nx/ny/nw/nh avoid x/y/w/h built-ins; leaf avoids room built-in; ch_l/ch_r avoid depth
function BSPNode(lx, ly, lw, lh) constructor {
	nx = lx; ny = ly; nw = lw; nh = lh;
	ch_l = -1; ch_r = -1; leaf = -1;
}

function bsp_split(node, lvl) {
	if (lvl >= 5) return;
	var split_horiz;
	if (node.nh > node.nw * 1.25) split_horiz = true;
	else if (node.nw > node.nh * 1.25) split_horiz = false;
	else split_horiz = (irandom(1) == 0);
	if (split_horiz) {
		if (node.nh < 10) return;
		var sp = node.ny + 4 + irandom(node.nh - 8);
		node.ch_l = new BSPNode(node.nx, node.ny, node.nw, sp - node.ny);
		node.ch_r = new BSPNode(node.nx, sp, node.nw, node.nh - (sp - node.ny));
	} else {
		if (node.nw < 12) return;
		var sp = node.nx + 5 + irandom(node.nw - 10);
		node.ch_l = new BSPNode(node.nx, node.ny, sp - node.nx, node.nh);
		node.ch_r = new BSPNode(sp, node.ny, node.nw - (sp - node.nx), node.nh);
	}
	bsp_split(node.ch_l, lvl + 1);
	bsp_split(node.ch_r, lvl + 1);
}

function bsp_create_rooms(node) {
	if (node.ch_l == -1) {
		var pw = min(max(5, node.nw - 4 - irandom(2)), 12); // cap: rooms max 12 tiles wide
		var ph = min(max(4, node.nh - 4 - irandom(2)), 9);  // cap: rooms max 9 tiles tall
		var px = node.nx + 1 + irandom(max(1, node.nw - pw - 2));
		var py = node.ny + 1 + irandom(max(1, node.nh - ph - 2));
		pw = min(pw, node.nw - 2);
		ph = min(ph, node.nh - 2);
		node.leaf = { rx: px, ry: py, rw: pw, rh: ph };
		ds_grid_set_region(global.map_grid, px, py, px + pw - 1, py + ph - 1, TILE_FLOOR);
		array_push(global.room_list, node.leaf);
		return;
	}
	bsp_create_rooms(node.ch_l);
	bsp_create_rooms(node.ch_r);
}

function bsp_get_room(node) {
	if (node.leaf != -1) return node.leaf;
	var l = (node.ch_l != -1) ? bsp_get_room(node.ch_l) : -1;
	var r = (node.ch_r != -1) ? bsp_get_room(node.ch_r) : -1;
	if (l == -1) return r;
	if (r == -1) return l;
	return (irandom(1) == 0) ? l : r;
}

function bsp_connect_rooms(node) {
	if (node.ch_l == -1) return;
	bsp_connect_rooms(node.ch_l);
	bsp_connect_rooms(node.ch_r);
	var ra = bsp_get_room(node.ch_l);
	var rb = bsp_get_room(node.ch_r);
	if (ra == -1 || rb == -1) return;
	var ax = ra.rx + ra.rw div 2;
	var ay = ra.ry + ra.rh div 2;
	var bx = rb.rx + rb.rw div 2;
	var by = rb.ry + rb.rh div 2;
	if (irandom(1) == 0) { carve_h(ay, ax, bx); carve_v(bx, ay, by); }
	else                 { carve_v(ax, ay, by); carve_h(by, ax, bx); }
}

function carve_h(row, x1, x2) {
	var s = min(x1, x2), e = max(x1, x2);
	for (var i = s; i <= e; i++) ds_grid_set(global.map_grid, i, row, TILE_FLOOR);
}

function carve_v(col, y1, y2) {
	var s = min(y1, y2), e = max(y1, y2);
	for (var j = s; j <= e; j++) ds_grid_set(global.map_grid, col, j, TILE_FLOOR);
}

function place_stairs_and_spawn(floor_num) {
	var cnt = array_length(global.room_list);
	if (cnt < 1) return;
	var sr = global.room_list[0];
	global.player_spawn_x = (sr.rx + sr.rw div 2) * TILE_SIZE + TILE_SIZE div 2;
	global.player_spawn_y = (sr.ry + sr.rh div 2) * TILE_SIZE + TILE_SIZE div 2;
	if (cnt < 2) return;
	var lr = global.room_list[cnt - 1];
	var sx = (lr.rx + lr.rw div 2) * TILE_SIZE + TILE_SIZE div 2;
	var sy = (lr.ry + lr.rh div 2) * TILE_SIZE + TILE_SIZE div 2;
	instance_create_layer(sx, sy, "Instances", obj_stairs);
}

function spawn_enemies(floor_num) {
	var cnt = array_length(global.room_list);
	for (var i = 1; i < cnt; i++) {
		var rm = global.room_list[i];
		var per = clamp(6 + floor_num div 2, 6, 22);
		repeat(per) {
			var ex = (rm.rx + 1 + irandom(rm.rw - 3)) * TILE_SIZE + TILE_SIZE div 2;
			var ey = (rm.ry + 1 + irandom(rm.rh - 3)) * TILE_SIZE + TILE_SIZE div 2;
			instance_create_layer(ex, ey, "Instances", pick_enemy(floor_num));
		}
	}
}

function pick_enemy(f) {
	if (f <= 5)  return choose(obj_enemy_skeleton, obj_enemy_zombie);
	if (f <= 10) return choose(obj_enemy_skeleton, obj_enemy_zombie, obj_enemy_bat);
	if (f <= 20) return choose(obj_enemy_skeleton, obj_enemy_bat, obj_enemy_archer_mob);
	if (f <= 30) return choose(obj_enemy_zombie, obj_enemy_bat, obj_enemy_archer_mob, obj_enemy_ghost);
	if (f <= 40) return choose(obj_enemy_bat, obj_enemy_ghost, obj_enemy_archer_mob, obj_enemy_mage_mob);
	return choose(obj_enemy_ghost, obj_enemy_archer_mob, obj_enemy_mage_mob);
}

function gen_boss_floor(floor_num) {
	var ax = 4, ay = 4, aw = 63, ah = 46; // fits within 72x54 map
	ds_grid_set_region(global.map_grid, ax, ay, ax + aw - 1, ay + ah - 1, TILE_FLOOR);
	var my = ay + ah div 2;
	for (var i = 1; i < ax; i++) {
		ds_grid_set(global.map_grid, i, my - 1, TILE_FLOOR);
		ds_grid_set(global.map_grid, i, my,     TILE_FLOOR);
		ds_grid_set(global.map_grid, i, my + 1, TILE_FLOOR);
	}
	global.player_spawn_x = 2 * TILE_SIZE + TILE_SIZE div 2;
	global.player_spawn_y = my * TILE_SIZE + TILE_SIZE div 2;
	var boss_obj;
	switch (floor_num) {
		case 10: boss_obj = obj_boss_golem;  break;
		case 20: boss_obj = obj_boss_wraith; break;
		case 30: boss_obj = obj_boss_drake;  break;
		case 40: boss_obj = obj_boss_necro;  break;
		case 50: boss_obj = obj_boss_demon;  break;
		default: boss_obj = obj_boss_golem;  break;
	}
	instance_create_layer((ax + aw div 2) * TILE_SIZE + TILE_SIZE div 2, (ay + ah div 2) * TILE_SIZE + TILE_SIZE div 2, "Instances", boss_obj);
	instance_create_layer((ax + aw - 2)   * TILE_SIZE + TILE_SIZE div 2, my * TILE_SIZE + TILE_SIZE div 2, "Instances", obj_stairs);
	global.boss_floor = true;
	global.room_list = [{ rx: ax, ry: ay, rw: aw, rh: ah }];
}

function can_move_to(wx, wy, hw, hh) {
	var tx1 = floor((wx - hw) / TILE_SIZE);
	var ty1 = floor((wy - hh) / TILE_SIZE);
	var tx2 = floor((wx + hw - 1) / TILE_SIZE);
	var ty2 = floor((wy + hh - 1) / TILE_SIZE);
	for (var ty = ty1; ty <= ty2; ty++) {
		for (var tx = tx1; tx <= tx2; tx++) {
			if (tx < 0 || ty < 0 || tx >= MAP_W || ty >= MAP_H) return false;
			if (ds_grid_get(global.map_grid, tx, ty) == TILE_WALL) return false;
		}
	}
	return true;
}

function rect_overlap(ax, ay, ahw, ahh, bx, by, bhw, bhh) {
	return (ax - ahw < bx + bhw && ax + ahw > bx - bhw &&
	        ay - ahh < by + bhh && ay + ahh > by - bhh);
}
