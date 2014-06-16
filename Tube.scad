HoleR=5;
R=16.5;
HeadR=(R-HoleR)/2;
PipeR=HeadR+HoleR;
TubeLength=90;
Thickness=3;
InnerR = R-Thickness;

module Head() {
	union() {
		translate([0,0,TubeLength])
		difference()
		{
			rotate_extrude($fn=50) translate([PipeR, 0, 0]) circle(r = HeadR);
			translate([0,0,-R/2]) cube(R);
		}
		
		hull() {
			translate([PipeR, 0, TubeLength]) sphere(HeadR, center=true, $fn=50);
			translate([PipeR, 0, 0]) sphere(HeadR, center=true, $fn=50);
		}
		
		hull() {
				translate([0, PipeR, TubeLength]) sphere(HeadR, center=true, $fn=50);
				translate([0, PipeR, 0]) sphere(HeadR, center=true, $fn=50);
		}
	}
}

module oneSidePipe(FN=50) {
		hull() {
			translate([PipeR, 0, TubeLength]) sphere(HeadR, center=true, $fn=FN);
			translate([PipeR*cos(30), PipeR*sin(30), 0]) rotate(30) cube(1, center=true);
		}
}

module Pipe(FN=50) {
	oneSidePipe(FN);
	mirror([1,-1,0]) oneSidePipe(FN);
}

Pipe(10);

module TubeBody() {
	assign(ConicalHeight=TubeLength-InnerR*tan(60))
	union() {
		translate([0,0,ConicalHeight]) cylinder(r1=InnerR, r2=0, InnerR/cos(60) + HeadR);
		cylinder(r=InnerR, ConicalHeight, $fn=50);
	}
}

//render(convexity = 2) difference() {
//	Head();
//  TubeBody();
//}