// ── Entity type macros ───────────────────────────────────────────────────────
#macro ENEMY_SKELETON  0
#macro ENEMY_ZOMBIE    1
#macro ENEMY_BAT       2
#macro ENEMY_GHOST     3
#macro ENEMY_ARCHER    4
#macro ENEMY_MAGE      5
#macro BOSS_GOLEM      10
#macro BOSS_WRAITH     11
#macro BOSS_DRAKE      12
#macro BOSS_NECRO      13
#macro BOSS_DEMON      14
#macro MOVE_ANIM_DELAY 8

// ── Core grid utilities ──────────────────────────────────────────────────────

function grid_is_walkable(gx, gy) {
	if (gx < 0 || gy < 0 || gx >= MAP_W || gy >= MAP_H) return false;
	return (ds_grid_get(global.map_grid, gx, gy) != TILE_WALL);
}

function grid_cell_has_enemy(gx, gy) {
	with (obj_enemy) { if (grid_x == gx && grid_y == gy) return id; }
	with (obj_boss)  { if (grid_x == gx && grid_y == gy) return id; }
	return noone;
}

function grid_cell_occupied(gx, gy) {
	return (grid_cell_has_enemy(gx, gy) != noone);
}

// Returns struct {dx, dy} snapped to nearest of 8 compass directions
function grid_snap_dir_8(fdx, fdy) {
	if (fdx == 0 && fdy == 0) return { dx: 1, dy: 0 };
	var ang  = point_direction(0, 0, fdx, fdy);
	var snap = round(ang / 45) * 45;
	return { dx: round(lengthdir_x(1, snap)), dy: round(lengthdir_y(1, snap)) };
}

// Returns array of {gx,gy} along a ray until a wall or map edge
function grid_line_cells(start_gx, start_gy, ddx, ddy, max_range) {
	var cells = [];
	var cgx = start_gx + ddx;
	var cgy = start_gy + ddy;
	for (var i = 0; i < max_range; i++) {
		if (!grid_is_walkable(cgx, cgy)) break;
		array_push(cells, { gx: cgx, gy: cgy });
		cgx += ddx;
		cgy += ddy;
	}
	return cells;
}

// Bresenham line-of-sight check (returns true if clear path)
function grid_has_los(x0, y0, x1, y1) {
	var dx  = abs(x1 - x0);
	var dy  = abs(y1 - y0);
	var sx  = (x0 < x1) ? 1 : -1;
	var sy  = (y0 < y1) ? 1 : -1;
	var err = dx - dy;
	var cx  = x0;
	var cy  = y0;
	var steps = dx + dy + 2;
	repeat (steps) {
		if (cx == x1 && cy == y1) return true;
		if (!grid_is_walkable(cx, cy)) return false;
		var e2 = 2 * err;
		if (e2 > -dy) { err -= dy; cx += sx; }
		if (e2 <  dx) { err += dx; cy += sy; }
	}
	return true;
}

// ── Telegraph helpers ────────────────────────────────────────────────────────

// Visual-only telegraph (col stored, dmg = 0)
function add_telegraph(gx, gy, col, turns_left) {
	array_push(global.telegraph_tiles, {
		gx: gx, gy: gy, col: col, turns_left: turns_left,
		dmg: 0, src_id: noone, cc: 0, cm: 1
	});
}

// Damaging telegraph
function add_telegraph_damage(gx, gy, col, turns_left, dmg, src_id, cc, cm) {
	array_push(global.telegraph_tiles, {
		gx: gx, gy: gy, col: col, turns_left: turns_left,
		dmg: dmg, src_id: src_id, cc: cc, cm: cm
	});
}

// ── Player actions ───────────────────────────────────────────────────────────

// Move player one tile; if tile occupied by enemy, bump-attack instead. Returns true if action happened.
function try_move_player(ddx, ddy) {
	if (!instance_exists(global.player_inst)) return false;
	var p   = global.player_inst;
	var tgx = p.grid_x + ddx;
	var tgy = p.grid_y + ddy;
	var eid = grid_cell_has_enemy(tgx, tgy);
	if (eid != noone) {
		bump_attack(eid);
		return true;
	}
	if (!grid_is_walkable(tgx, tgy)) return false;
	p.grid_x = tgx;
	p.grid_y = tgy;
	return true;
}

// Movement-only version for abilities — never attacks enemies in the path
function try_move_no_attack(ddx, ddy) {
	if (!instance_exists(global.player_inst)) return false;
	var p   = global.player_inst;
	var tgx = p.grid_x + ddx;
	var tgy = p.grid_y + ddy;
	if (!grid_is_walkable(tgx, tgy)) return false;
	if (grid_cell_has_enemy(tgx, tgy) != noone) return false;
	p.grid_x = tgx;
	p.grid_y = tgy;
	return true;
}

// Melee attack on an entity from player (auto-crits and ends vanish for Assassin)
function bump_attack(target_id) {
	if (!instance_exists(global.player_inst)) return;
	var p  = global.player_inst;
	var cc = p.crit_chance;
	var cm = p.crit_mult;
	if (variable_instance_exists(p, "invisible") && p.invisible) {
		cc = 1.0;
		p.invisible = false;
		p.vanish_turns = 0;
	}
	deal_damage(target_id, p.x, p.y, p.damage, cc, cm, 0);
}

// Deal damage to any enemy/boss occupying (gx, gy). Returns true if hit.
function player_grid_attack(gx, gy, dmg, cc, cm) {
	var hit = false;
	with (obj_enemy) {
		if (grid_x == gx && grid_y == gy) {
			if (!(variable_instance_exists(id, "phase_mode") && phase_mode)) {
				deal_damage(id, other.x, other.y, dmg, cc, cm, 0);
				hit = true;
			}
		}
	}
	with (obj_boss) {
		if (grid_x == gx && grid_y == gy) {
			deal_damage(id, other.x, other.y, dmg, cc, cm, 0);
			hit = true;
		}
	}
	return hit;
}

// Deal damage to player if they are on tile (gx, gy). Respects shield, smoke, invincibility, riposte.
function grid_attack_tile(gx, gy, dmg, src_id, cc, cm) {
	if (!instance_exists(global.player_inst)) return;
	var p = global.player_inst;
	if (p.grid_x != gx || p.grid_y != gy) return;
	if (p.invincible_turns > 0) return;
	// Shield block
	if (variable_instance_exists(p, "shield_active") && p.shield_active) return;
	// Smoke protection
	for (var _i = 0; _i < array_length(global.smoke_tiles); _i++) {
		if (global.smoke_tiles[_i].gx == gx && global.smoke_tiles[_i].gy == gy) return;
	}
	// Riposte (Warrior 2H mode)
	if (variable_instance_exists(p, "riposte_declared") && p.riposte_declared && instance_exists(src_id)) {
		p.riposte_declared = false;
		deal_damage(src_id, p.x, p.y, dmg * 5, cc, cm, 0);
		return;
	}
	var actual_dmg = max(1, round(dmg * (1 - p.armor)));
	p.hp -= actual_dmg;
	p.invincible_turns = 1;
	p.hit_flash = 10;
	var _dn = instance_create_layer(p.x + random_range(-6, 6), p.y - 14, "Instances", obj_damage_number);
	_dn.value            = actual_dmg;
	_dn.is_crit          = false;
	_dn.is_player_damage = true;
	if (p.hp <= 0) {
		p.hp = 0;
		p.is_dead = true;
		with (global.player_inst) { alarm[0] = 120; }
	}
}

// ── Turn processing ──────────────────────────────────────────────────────────

function process_turn() {
	global.turn_counter++;

	// Player-specific state ticks
	if (instance_exists(global.player_inst)) {
		var p = global.player_inst;
		// Decrement turn-based ability cooldowns
		if (p.ability_dash_cd  > 0) p.ability_dash_cd--;
		if (p.ability_util_cd  > 0) p.ability_util_cd--;
		if (p.ability_dmg_cd   > 0) p.ability_dmg_cd--;
		if (p.ability_ult_cd   > 0) p.ability_ult_cd--;
		if (p.invincible_turns > 0) p.invincible_turns--;
		// Vanish countdown
		if (variable_instance_exists(p, "vanish_turns") && p.vanish_turns > 0) {
			p.vanish_turns--;
			if (p.vanish_turns <= 0) p.invisible = false;
		}
		// Enchanted quiver
		if (variable_instance_exists(p, "ult_turns_left") && p.ult_turns_left > 0) {
			p.ult_turns_left--;
			if (p.ult_turns_left <= 0) p.ult_active = false;
		}
		// 2H mode
		if (variable_instance_exists(p, "two_hand_turns_left") && p.two_hand_turns_left > 0) {
			p.two_hand_turns_left--;
			if (p.two_hand_turns_left <= 0) p.two_hand_active = false;
		}
	}

	// Tick smoke tiles (remove expired)
	var _new_smoke = [];
	for (var _i = 0; _i < array_length(global.smoke_tiles); _i++) {
		var _s = global.smoke_tiles[_i];
		_s.turns_left--;
		if (_s.turns_left > 0) array_push(_new_smoke, _s);
	}
	global.smoke_tiles = _new_smoke;

	// Fire expired telegraphs; keep live ones
	var _new_tele = [];
	for (var _i = 0; _i < array_length(global.telegraph_tiles); _i++) {
		var _t = global.telegraph_tiles[_i];
		_t.turns_left--;
		if (_t.turns_left <= 0) {
			if (_t.dmg > 0) grid_attack_tile(_t.gx, _t.gy, _t.dmg, _t.src_id, _t.cc, _t.cm);
		} else {
			array_push(_new_tele, _t);
		}
	}
	global.telegraph_tiles = _new_tele;

	// Reset per-turn shield after telegraphs fire
	if (instance_exists(global.player_inst)) {
		if (variable_instance_exists(global.player_inst, "shield_active"))
			global.player_inst.shield_active = false;
	}

	// All enemies and bosses act
	with (obj_enemy) { if (instance_exists(id)) enemy_take_turn(id); }
	with (obj_boss)  { if (instance_exists(id)) boss_take_turn(id);  }
}

// ── Pathfinding ──────────────────────────────────────────────────────────────

// Greedy 4-directional step; returns {dx, dy} = {0,0} if stuck
function grid_pathfind_step(from_gx, from_gy, to_gx, to_gy, can_phase) {
	var best_dx   = 0;
	var best_dy   = 0;
	var best_dist = point_distance(from_gx, from_gy, to_gx, to_gy);
	var _dirs = [[1,0],[-1,0],[0,1],[0,-1]];
	for (var _i = 0; _i < 4; _i++) {
		var _mdx = _dirs[_i][0];
		var _mdy = _dirs[_i][1];
		var _ngx = from_gx + _mdx;
		var _ngy = from_gy + _mdy;
		if (!can_phase && !grid_is_walkable(_ngx, _ngy)) continue;
		if (can_phase && (_ngx < 0 || _ngy < 0 || _ngx >= MAP_W || _ngy >= MAP_H)) continue;
		if (grid_cell_occupied(_ngx, _ngy)) continue;
		var _d = point_distance(_ngx, _ngy, to_gx, to_gy);
		if (_d < best_dist) { best_dist = _d; best_dx = _mdx; best_dy = _mdy; }
	}
	return { dx: best_dx, dy: best_dy };
}

// ── Enemy AI dispatch ────────────────────────────────────────────────────────

function enemy_take_turn(eid) {
	if (!instance_exists(eid)) return;
	// Pin mechanic: pinned enemies skip their turn
	if (eid.turns_until_attack > 0) { eid.turns_until_attack--; return; }
	switch (eid.enemy_type) {
		case ENEMY_SKELETON: ai_skeleton_turn(eid); break;
		case ENEMY_ZOMBIE:   ai_zombie_turn(eid);   break;
		case ENEMY_BAT:      ai_bat_turn(eid);      break;
		case ENEMY_GHOST:    ai_ghost_turn(eid);    break;
		case ENEMY_ARCHER:   ai_archer_mob_turn(eid); break;
		case ENEMY_MAGE:     ai_mage_mob_turn(eid);   break;
	}
}

// Update aggro state and last-known player position (respects vanish + walls)
function _update_last_known(eid) {
	if (!instance_exists(global.player_inst)) return;
	var p = global.player_inst;
	var player_visible = !(variable_instance_exists(p, "invisible") && p.invisible);
	if (!player_visible) return;
	var dist    = abs(eid.grid_x - p.grid_x) + abs(eid.grid_y - p.grid_y);
	var has_los = grid_has_los(eid.grid_x, eid.grid_y, p.grid_x, p.grid_y);
	if (!eid.is_aggroed) {
		if (dist <= eid.aggro_radius && has_los) eid.is_aggroed = true;
	} else if (dist > eid.aggro_radius * 2) {
		eid.is_aggroed = false;
	}
	if (eid.is_aggroed && has_los) {
		eid.last_known_pgx = p.grid_x;
		eid.last_known_pgy = p.grid_y;
	}
}

function ai_skeleton_turn(eid) {
	if (!instance_exists(global.player_inst)) return;
	_update_last_known(eid);
	if (!eid.is_aggroed) return;
	var tgx = eid.last_known_pgx, tgy = eid.last_known_pgy;
	var dist = abs(eid.grid_x - tgx) + abs(eid.grid_y - tgy);
	if (dist <= 1) {
		grid_attack_tile(tgx, tgy, eid.damage, eid, 0, 1);
	} else {
		var step = grid_pathfind_step(eid.grid_x, eid.grid_y, tgx, tgy, false);
		eid.grid_x += step.dx;
		eid.grid_y += step.dy;
	}
}

function ai_zombie_turn(eid) {
	if (!instance_exists(global.player_inst)) return;
	_update_last_known(eid);
	if (!eid.is_aggroed) return;
	var tgx = eid.last_known_pgx, tgy = eid.last_known_pgy;
	var dist = abs(eid.grid_x - tgx) + abs(eid.grid_y - tgy);
	// Zombie attacks every 2 turns; at <50% HP moves every other turn too
	var can_attack = (eid.alt_turn == false);
	eid.alt_turn = !eid.alt_turn;
	if (eid.hp < eid.max_hp * 0.5 && !can_attack) return; // half speed at low hp
	if (dist <= 1 && can_attack) {
		grid_attack_tile(tgx, tgy, eid.damage, eid, 0, 1);
	} else if (dist > 1) {
		var step = grid_pathfind_step(eid.grid_x, eid.grid_y, tgx, tgy, false);
		eid.grid_x += step.dx;
		eid.grid_y += step.dy;
	}
}

function ai_bat_turn(eid) {
	if (!instance_exists(global.player_inst)) return;
	_update_last_known(eid);
	if (!eid.is_aggroed) return;
	var tgx = eid.last_known_pgx, tgy = eid.last_known_pgy;
	// Move 2 steps per turn, ignores walls
	repeat (2) {
		var dist = abs(eid.grid_x - tgx) + abs(eid.grid_y - tgy);
		if (dist <= 1) break;
		var step = grid_pathfind_step(eid.grid_x, eid.grid_y, tgx, tgy, true);
		if (step.dx == 0 && step.dy == 0) break;
		eid.grid_x += step.dx;
		eid.grid_y += step.dy;
	}
	var dist2 = abs(eid.grid_x - tgx) + abs(eid.grid_y - tgy);
	if (dist2 <= 1) grid_attack_tile(tgx, tgy, eid.damage, eid, 0, 1);
}

function ai_ghost_turn(eid) {
	if (!instance_exists(global.player_inst)) return;
	_update_last_known(eid);
	if (!eid.is_aggroed) return;
	// 25% chance to toggle phase each turn
	if (irandom(3) == 0) eid.phase_mode = !eid.phase_mode;
	var tgx = eid.last_known_pgx, tgy = eid.last_known_pgy;
	var dist = abs(eid.grid_x - tgx) + abs(eid.grid_y - tgy);
	var can_attack = (eid.alt_turn == false);
	eid.alt_turn = !eid.alt_turn;
	if (dist <= 1 && can_attack && !eid.phase_mode) {
		grid_attack_tile(tgx, tgy, eid.damage, eid, 0, 1);
	} else if (dist > 1) {
		var step = grid_pathfind_step(eid.grid_x, eid.grid_y, tgx, tgy, eid.phase_mode);
		if (step.dx == 0 && step.dy == 0) {
			// Try all 4 directions to escape walls when phasing
			if (eid.phase_mode) {
				var _dirs = [[1,0],[-1,0],[0,1],[0,-1]];
				var _di = irandom(3);
				eid.grid_x += _dirs[_di][0];
				eid.grid_y += _dirs[_di][1];
				eid.grid_x = clamp(eid.grid_x, 0, MAP_W - 1);
				eid.grid_y = clamp(eid.grid_y, 0, MAP_H - 1);
			}
		} else {
			eid.grid_x += step.dx;
			eid.grid_y += step.dy;
		}
	}
}

function ai_archer_mob_turn(eid) {
	if (!instance_exists(global.player_inst)) return;
	_update_last_known(eid);
	if (!eid.is_aggroed) return;
	var p  = global.player_inst;
	var px = p.grid_x, py = p.grid_y;
	var tkx = eid.last_known_pgx, tky = eid.last_known_pgy;
	var dist_real  = abs(eid.grid_x - px)  + abs(eid.grid_y - py);
	var dist_known = abs(eid.grid_x - tkx) + abs(eid.grid_y - tky);

	if (eid.attack_cd_turns > 0) { eid.attack_cd_turns--; }

	// Too close to real player — back away
	if (dist_real < 4) {
		var fdx = sign(eid.grid_x - px);
		var fdy = sign(eid.grid_y - py);
		if (fdx == 0 && fdy == 0) fdx = 1;
		var ngx = eid.grid_x + fdx;
		var ngy = eid.grid_y + fdy;
		if (grid_is_walkable(ngx, ngy) && !grid_cell_occupied(ngx, ngy)) {
			eid.grid_x = ngx;
			eid.grid_y = ngy;
		}
		return;
	}

	// In range and has LoS — telegraph shot at real position
	if (dist_real <= 8 && eid.attack_cd_turns <= 0 && grid_has_los(eid.grid_x, eid.grid_y, px, py)) {
		add_telegraph_damage(px, py, make_color_rgb(255, 140, 0), 1, eid.damage, eid, 0.1, 2.0);
		eid.attack_cd_turns = 2;
		return;
	}

	// Approach last-known position to get into range
	if (dist_known > 6) {
		var step = grid_pathfind_step(eid.grid_x, eid.grid_y, tkx, tky, false);
		eid.grid_x += step.dx;
		eid.grid_y += step.dy;
	}
}

function ai_mage_mob_turn(eid) {
	if (!instance_exists(global.player_inst)) return;
	_update_last_known(eid);
	if (!eid.is_aggroed) return;
	var p  = global.player_inst;
	var px = p.grid_x, py = p.grid_y;
	var dist = abs(eid.grid_x - px) + abs(eid.grid_y - py);

	if (eid.attack_cd_turns > 0) { eid.attack_cd_turns--; }

	// Too close — teleport away to a random floor tile at distance 6+
	if (dist < 3) {
		var attempts = 20;
		while (attempts-- > 0) {
			var rx = irandom(MAP_W - 1);
			var ry = irandom(MAP_H - 1);
			if (grid_is_walkable(rx, ry) && !grid_cell_occupied(rx, ry) &&
			    abs(rx - px) + abs(ry - py) >= 6) {
				eid.grid_x = rx;
				eid.grid_y = ry;
				break;
			}
		}
		return;
	}

	// In range — telegraph 3-tile fan toward player
	if (dist <= 7 && eid.attack_cd_turns <= 0 && grid_has_los(eid.grid_x, eid.grid_y, px, py)) {
		var snap = grid_snap_dir_8(px - eid.grid_x, py - eid.grid_y);
		// Perpendicular direction for fan
		var pdx = -snap.dy, pdy = snap.dx;
		var mage_col = make_color_rgb(180, 50, 255);
		add_telegraph_damage(px,        py,        mage_col, 1, eid.damage, eid, 0, 1);
		add_telegraph_damage(px + pdx,  py + pdy,  mage_col, 1, eid.damage, eid, 0, 1);
		add_telegraph_damage(px - pdx,  py - pdy,  mage_col, 1, eid.damage, eid, 0, 1);
		eid.attack_cd_turns = 2;
		return;
	}

	// Approach
	if (dist > 5) {
		var step = grid_pathfind_step(eid.grid_x, eid.grid_y, px, py, false);
		eid.grid_x += step.dx;
		eid.grid_y += step.dy;
	}
}

// ── Boss AI dispatch ─────────────────────────────────────────────────────────

function boss_take_turn(bid) {
	if (!instance_exists(bid)) return;
	if (!instance_exists(global.player_inst)) return;
	// Phase 2 transition
	if (bid.phase == 1 && bid.hp < bid.max_hp * 0.5) {
		bid.phase = 2;
		bid.on_phase2();
	}
	bid.boss_turn_counter++;
	// Move every move_interval turns
	if (bid.boss_turn_counter mod bid.move_interval == 0) {
		var p   = global.player_inst;
		var step = grid_pathfind_step(bid.grid_x, bid.grid_y, p.grid_x, p.grid_y, false);
		if (step.dx != 0 || step.dy != 0) {
			bid.grid_x += step.dx;
			bid.grid_y += step.dy;
		}
	}
	// Dispatch specific boss AI
	switch (bid.boss_type) {
		case BOSS_GOLEM:  boss_golem_turn(bid);  break;
		case BOSS_DEMON:  boss_demon_turn(bid);  break;
		case BOSS_WRAITH: boss_wraith_turn(bid); break;
		case BOSS_DRAKE:  boss_drake_turn(bid);  break;
		case BOSS_NECRO:  boss_necro_turn(bid);  break;
	}
}

function boss_golem_turn(bid) {
	var p  = global.player_inst;
	var px = p.grid_x, py = p.grid_y;
	var bx = bid.grid_x, by = bid.grid_y;
	var dist = abs(bx - px) + abs(by - py);

	// Melee when adjacent
	if (dist <= 2) grid_attack_tile(px, py, bid.damage, bid, 0, 1);

	// Rock volley every 3 turns — scatter tiles near player, 1-turn warning
	if (bid.boss_turn_counter mod 3 == 0) {
		var cnt = (bid.phase == 1) ? 4 : 6;
		for (var _i = 0; _i < cnt; _i++) {
			var rx = px + irandom_range(-3, 3);
			var ry = py + irandom_range(-3, 3);
			if (grid_is_walkable(rx, ry)) {
				add_telegraph_damage(rx, ry, make_color_rgb(255, 140, 0), 1,
				                     round(bid.damage * 0.8), bid, 0, 1);
			}
		}
	}

	// Stomp every 4 turns — 5-tile cross on player, 2-turn warning (orange → red)
	if (bid.boss_turn_counter mod 4 == 1) {
		var stomp_col = make_color_rgb(255, 140, 0);
		for (var _i = -2; _i <= 2; _i++) {
			add_telegraph_damage(px + _i, py,      stomp_col, 2, bid.damage * 2, bid, 0, 1);
			if (_i != 0) add_telegraph_damage(px, py + _i, stomp_col, 2, bid.damage * 2, bid, 0, 1);
		}
	}

	// Phase 2 — shockwave ring (expands outward 1 tile/turn for 3 turns)
	if (bid.phase == 2 && bid.boss_turn_counter mod 6 == 0) {
		for (var _r = 3; _r <= 5; _r++) {
			var _tl  = _r - 2; // r=3→tl=1, r=4→tl=2, r=5→tl=3
			var _col = (_tl == 1) ? c_red : make_color_rgb(255, 140, 0);
			for (var _dx = -_r; _dx <= _r; _dx++) {
				var _dy_abs = _r - abs(_dx);
				add_telegraph_damage(bx + _dx, by + _dy_abs, _col, _tl, round(bid.damage * 1.5), bid, 0, 1);
				if (_dy_abs != 0)
					add_telegraph_damage(bx + _dx, by - _dy_abs, _col, _tl, round(bid.damage * 1.5), bid, 0, 1);
			}
		}
	}
}

function boss_demon_turn(bid) {
	var p  = global.player_inst;
	var px = p.grid_x, py = p.grid_y;
	var bx = bid.grid_x, by = bid.grid_y;
	var dist = abs(bx - px) + abs(by - py);

	if (dist <= 2) grid_attack_tile(px, py, bid.damage, bid, 0, 1);

	// Spiral burst — 8 tiles at radius 4, rotate 45° each use
	var spiral_interval = (bid.phase == 2) ? 1 : 2;
	if (bid.boss_turn_counter mod spiral_interval == 0) {
		for (var _i = 0; _i < 8; _i++) {
			var _ang = bid.spiral_angle + _i * 45;
			var _sx  = bx + round(cos(degtorad(_ang)) * 4);
			var _sy  = by + round(-sin(degtorad(_ang)) * 4);
			if (grid_is_walkable(_sx, _sy)) {
				add_telegraph_damage(_sx, _sy, make_color_rgb(255, 80, 50), 1, bid.damage, bid, 0, 1);
			}
		}
		bid.spiral_angle = (bid.spiral_angle + 45) mod 360;
	}

	// Targeted volley every 3 turns
	if (bid.boss_turn_counter mod 3 == 1) {
		var cnt = (bid.phase == 2) ? 8 : 4;
		for (var _i = 0; _i < cnt; _i++) {
			var rx = px + irandom_range(-2, 2);
			var ry = py + irandom_range(-2, 2);
			if (grid_is_walkable(rx, ry)) {
				add_telegraph_damage(rx, ry, make_color_rgb(255, 100, 50), 2,
				                     round(bid.damage * 1.2), bid, 0, 1);
			}
		}
	}

	// Phase 2 nova at 33% HP (once only)
	if (!variable_instance_exists(bid, "nova_fired")) bid.nova_fired = false;
	if (!bid.nova_fired && bid.hp < bid.max_hp * 0.33) {
		bid.nova_fired = true;
		var nova_dmg = bid.damage * 2;
		for (var _r = 1; _r <= 3; _r++) {
			var _tl  = 4 - _r; // r=1→tl=3, r=2→tl=2, r=3→tl=1
			var _col;
			if (_tl == 1)      _col = c_red;
			else if (_tl == 2) _col = make_color_rgb(255, 140, 0);
			else               _col = make_color_rgb(255, 255, 0);
			for (var _dx = -_r; _dx <= _r; _dx++) {
				var _da = _r - abs(_dx);
				add_telegraph_damage(bx + _dx, by + _da, _col, _tl, nova_dmg, bid, 0, 1);
				if (_da != 0)
					add_telegraph_damage(bx + _dx, by - _da, _col, _tl, nova_dmg, bid, 0, 1);
			}
		}
	}
}

// Placeholder boss turns — they move and do basic attacks via boss_take_turn
function boss_wraith_turn(bid) {
	var p  = global.player_inst;
	var dist = abs(bid.grid_x - p.grid_x) + abs(bid.grid_y - p.grid_y);
	if (dist <= 2) grid_attack_tile(p.grid_x, p.grid_y, bid.damage, bid, 0, 1);
	if (bid.boss_turn_counter mod 3 == 0) {
		for (var _i = 0; _i < 5; _i++) {
			var rx = p.grid_x + irandom_range(-4, 4);
			var ry = p.grid_y + irandom_range(-4, 4);
			if (grid_is_walkable(rx, ry))
				add_telegraph_damage(rx, ry, make_color_rgb(100, 200, 255), 1, bid.damage, bid, 0, 1);
		}
	}
}

function boss_drake_turn(bid) {
	var p  = global.player_inst;
	var dist = abs(bid.grid_x - p.grid_x) + abs(bid.grid_y - p.grid_y);
	if (dist <= 2) grid_attack_tile(p.grid_x, p.grid_y, bid.damage, bid, 0, 1);
	if (bid.boss_turn_counter mod 4 == 0) {
		var snap = grid_snap_dir_8(p.grid_x - bid.grid_x, p.grid_y - bid.grid_y);
		var cells = grid_line_cells(bid.grid_x, bid.grid_y, snap.dx, snap.dy, 8);
		for (var _i = 0; _i < array_length(cells); _i++) {
			add_telegraph_damage(cells[_i].gx, cells[_i].gy, make_color_rgb(255, 100, 0), 1,
			                     round(bid.damage * 1.5), bid, 0, 1);
		}
	}
}

function boss_necro_turn(bid) {
	var p  = global.player_inst;
	var dist = abs(bid.grid_x - p.grid_x) + abs(bid.grid_y - p.grid_y);
	if (dist <= 2) grid_attack_tile(p.grid_x, p.grid_y, bid.damage, bid, 0, 1);
	if (bid.boss_turn_counter mod 3 == 0) {
		var bx = bid.grid_x, by = bid.grid_y;
		for (var _i = 0; _i < 8; _i++) {
			var _ang = _i * 45;
			var _sx = bx + round(cos(degtorad(_ang)) * 3);
			var _sy = by + round(-sin(degtorad(_ang)) * 3);
			if (grid_is_walkable(_sx, _sy))
				add_telegraph_damage(_sx, _sy, make_color_rgb(100, 255, 100), 2, bid.damage, bid, 0, 1);
		}
	}
}
