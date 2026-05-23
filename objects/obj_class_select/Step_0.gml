if (global.won) {
	if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || mouse_check_button_pressed(mb_left)) {
		global.won = false;
		global.floor_number = 0;
		global.player_inst = noone;
	}
	exit;
}

if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"))) selected = (selected - 1 + 3) mod 3;
if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) selected = (selected + 1) mod 3;

// Mouse hover
var bw = 280; var bh = 340; var gap = 40;
var startx = (room_width - (bw * 3 + gap * 2)) / 2;
for (var i = 0; i < 3; i++) {
	var bx = startx + i * (bw + gap);
	if (mouse_x >= bx && mouse_x <= bx + bw && mouse_y >= 160 && mouse_y <= 160 + bh) {
		selected = i;
	}
}

// Boss shortcut button — must be checked before the catch-all click handler
var bbx = room_width / 2 - 130;
var bby = 572;
var bbw = 260; var bbh = 40;
if (mouse_check_button_pressed(mb_left) &&
    mouse_x >= bbx && mouse_x <= bbx + bbw &&
    mouse_y >= bby && mouse_y <= bby + bbh) {
	global.player_class = classes[selected];
	global.floor_number = 10;
	global.player_inst = noone;
	global.boss_floor = false;
	global.boss_killed = false;
	global.won = false;
	room_goto(rm_game);
	exit;
}

if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || mouse_check_button_pressed(mb_left)) {
	global.player_class = classes[selected];
	global.floor_number = 0;
	global.player_inst = noone;
	global.boss_floor = false;
	global.boss_killed = false;
	global.won = false;
	room_goto(rm_game);
}
