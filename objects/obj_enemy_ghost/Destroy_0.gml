if (!global.cleaning_up && irandom(4) == 0) {
    var pk = instance_create_layer(x, y, "Instances", obj_pickup);
    pk.pickup_type = irandom(2);
    pk.value = (pk.pickup_type == 0) ? 25 : 4;
}
