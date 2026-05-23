// Tick smoke tiles (frame-based, 240 frames = 4s)
var _new_smoke = [];
for (var _i = 0; _i < array_length(global.smoke_tiles); _i++) {
	var _s = global.smoke_tiles[_i];
	_s.turns_left--;
	if (_s.turns_left > 0) array_push(_new_smoke, _s);
}
global.smoke_tiles = _new_smoke;

// Tick telegraph tiles and fire when expired
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
