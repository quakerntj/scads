thin=3;
hook=8;

union() {

linear_extrude(height=thin*2)
polygon(points=[[0,thin*5-hook], [0,thin*5], [thin*3,thin*5],
			[thin*3,thin], [thin*4,thin], [thin*4,hook],
			[thin*5,hook], [thin*5,0], [thin*2,0],
			[thin*2,thin*4], [thin,thin*4], [thin,thin*5-hook]]);

translate([thin*4,thin,0])
rotate([0,-90])
linear_extrude(height=thin)
polygon(points=[[0,0], [thin,1],
			[thin*2,0]]);

}