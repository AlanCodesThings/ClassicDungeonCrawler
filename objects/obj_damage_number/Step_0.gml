timer--;
if (timer <= 0) { instance_destroy(); exit; }
// Rise fast, slow to a stop
drift_y = lerp(drift_y, 0, 0.07);
x += drift_x;
y += drift_y;
