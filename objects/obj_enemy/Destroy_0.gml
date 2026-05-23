// Drop loot on death (not during floor cleanup)
if (!global.cleaning_up && irandom(4) == 0) {
	var p = instance_create_layer(x, y, "Instances", obj_pickup);
	p.pickup_type = irandom(2);
	p.value = 20 + global.floor_number * 2;
}
