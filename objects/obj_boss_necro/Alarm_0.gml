var ang = irandom(360);
instance_create_layer(x + lengthdir_x(90, ang), y + lengthdir_y(90, ang), "Instances", obj_enemy_skeleton);
alarm[0] = (phase == 1) ? 190 : 130;
