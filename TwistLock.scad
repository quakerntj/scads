translate([0,0,1]) linear_extrude(height = 15, twist = 90, slices = 200, scale=1.3, $fn=60) {
  difference() {
      square(10-0.1, center = true);
      square(7, center = true);
  }
}

linear_extrude(height = 1, scale=0.79)
square(13, center = true);

translate([30,0,0]) linear_extrude(height = 15, twist = 90, slices = 200, $fn=60) {
  difference() {
      square(12 * 1.3, center = true);
      square(10 * 1.3, center = true);
  }
}


