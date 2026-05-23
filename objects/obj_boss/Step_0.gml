if (hit_flash > 0) hit_flash--;
if (invincible_timer > 0) invincible_timer--;
if (attack_cd > 0) attack_cd--;
knockback_x *= 0.88; knockback_y *= 0.88;
if (abs(knockback_x) < 0.1) knockback_x = 0;
if (abs(knockback_y) < 0.1) knockback_y = 0;
if (phase == 1 && hp < max_hp * 0.5) {
    phase = 2;
    on_phase2();
}
