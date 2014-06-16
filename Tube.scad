HoleR=5;
R=16.5;
HeadR=(R-HoleR)/2;
PipeR=HeadR+HoleR;
TubeLength=90;
Thickness=3;
InnerR = R-Thickness;
FN=60;

module BottomPipe() {
	linear_extrude(0.1) difference() {
		intersection() {
			square([R,R]);
			circle(R);
			polygon([[0,0], [R,0],
				[cos(30)*(R+2),sin(30)*(R+2)]]);
		}
		circle(InnerR);
	}
}

module oneSidePipe() {
		assign(Rm = R-0.5)
		hull() {
			translate([PipeR, 0, TubeLength]) sphere(HeadR, center=true, $fn=FN);
BottomPipe();
//			translate([Rm*cos(30), Rm*sin(30), 0]) rotate(30) cube(1, center=true);
		}
}

module Pipe() {
	oneSidePipe();
	mirror([1,-1,0]) oneSidePipe();
}

module Head() {
	union() {
		translate([0,0,TubeLength])
		difference()
		{
			rotate_extrude($fn=FN) translate([PipeR, 0, 0]) circle(r = HeadR);
			translate([0,0,-R/2]) cube(R);
		}
		
		Pipe();
	}
}

module TubeBodyNegative() {
	assign(ConicalHeight=(TubeLength-InnerR)*tan(60))
	union() {
		translate([0,0,ConicalHeight]) cylinder(r1=InnerR, r2=0, InnerR/cos(60));
		cylinder(r=InnerR, ConicalHeight + 0.1, $fn=FN);
	}
}

module TubeBody() {
	difference() {
		cylinder(r=R, TubeLength);
		TubeBodyNegative();
		cube([R+1, R+1, TubeLength+1]);
		
	}
}


render(convexity = 2) {
	Head();
	TubeBody();
}