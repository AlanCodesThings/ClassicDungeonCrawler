// Phase 2: persistent death rings spread around arena
for (var i = 0; i < 3; i++) {
    array_push(death_zones, { x: x + irandom_range(-160, 160), y: y + irandom_range(-160, 160), r: 70, timer: 660 });
}
alarm[2] = 320;
