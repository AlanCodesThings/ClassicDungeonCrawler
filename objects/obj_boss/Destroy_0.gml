global.boss_killed = true;
// Drop a guaranteed large health pickup
if (!global.cleaning_up) {
    var pk = instance_create_layer(x, y, "Instances", obj_pickup);
    pk.pickup_type = 0; pk.value = 80;
}
