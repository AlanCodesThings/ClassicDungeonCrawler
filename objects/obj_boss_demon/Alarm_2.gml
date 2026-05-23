// Phase 2: spawn minion skeletons
for (var i = 0; i < 3; i++)
    instance_create_layer(x + irandom_range(-130, 130), y + irandom_range(-130, 130), "Instances", obj_enemy_skeleton);
alarm[2] = 260;
