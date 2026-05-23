hp = 30; max_hp = 30;
damage = 8; armor = 0.0;
col_half_w = 12; col_half_h = 12;
invincible_timer = 0; hit_flash = 0;
// Grid position
grid_x = floor(x / TILE_SIZE);
grid_y = floor(y / TILE_SIZE);
// Snap visual position to tile center
x = grid_x * TILE_SIZE + TILE_SIZE / 2;
y = grid_y * TILE_SIZE + TILE_SIZE / 2;
// AI state
enemy_type         = -1;
last_known_pgx     = 0;
last_known_pgy     = 0;
turns_until_attack = 0;
attack_cd_turns    = 0;
alt_turn           = false;
is_dead            = false;
depth              = 0;
// Scale with floor depth
var f = global.floor_number;
hp     = round(hp     * (1 + f * 0.15)); max_hp = hp;
damage = round(damage * (1 + f * 0.10));
// Initialise last known to player position if available
if (instance_exists(global.player_inst)) {
	last_known_pgx = global.player_inst.grid_x;
	last_known_pgy = global.player_inst.grid_y;
}
