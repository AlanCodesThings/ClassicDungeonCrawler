life--;
if (life <= 0) instance_destroy();
// Hitbox is visual-only in grid mode; damage is dealt by player_grid_attack in class Step files
