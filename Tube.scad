HoleR=5;
R=16.5;
HeadR=(R-HoleR)/2;
PipeR=HeadR+HoleR;
TubeLength=90;
Thickness=3;
InnerR = R-Thickness;
FN=80;

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
		}
}

module Pipe() {
	oneSidePipe();
	mirror([1,-1,0]) oneSidePipe();
}

module HeadSupport() {
	rotate_extrude() translate([R-1,0,0]) rotate(90) polygon(points=[[0,0],[(HeadR+4)*1.33,0],[(HeadR+4)*1.33, (HeadR+4)]]);

}

module Head() {
	union() {
		translate([0,0,TubeLength])
		difference()
		{
			union()	{
					rotate_extrude($fn=FN) translate([PipeR, 0, 0]) circle(r = HeadR);
					translate([0,0,-(HeadR+3)*1.33-4.2]) HeadSupport();
			}
			translate([0,0,-R]) cube([R,R,2*R]);
		}
		
		Pipe();
	}
}


module TubeBody() {
	difference() {
		cylinder(r=R, TubeLength, $fn=FN);
		cylinder(r=InnerR, TubeLength, $fn=FN);
		cube([R+1, R+1, TubeLength+1]);
	}
}

ConnectLength=15;
RampLength=14;
Drop=8;

module Thinner() {
	rotate_extrude($fn=FN)
	translate([R-Drop-Thickness/2,0,0])
	rotate(90)
	minkowski() {
		circle(Thickness/2, $fn=FN);
		polygon(points=[[0,0], [0,-0.01],
			[ConnectLength, -0.01],
			[ConnectLength+RampLength, -Drop-0.01],
			[ConnectLength+RampLength,-Drop],
			[ConnectLength, 0]]);
	}
}

render(convexity = 2) {
	translate([0,0,ConnectLength+RampLength]) {
		Head();
		TubeBody();
	}
	Thinner();
}