HoleR=5;
R=16.5;
HeadR=(R-HoleR)/2;
PipeR=HeadR+HoleR;
TotalLength=100;
ConnectLength=18;
RampLength=14;
TubeLength=TotalLength-14;
Thickness=3;
InnerR = R-Thickness;
Drop=8;
IOR=R-Drop-Thickness/2;
FN=15;

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


module Thinner() {
	rotate_extrude($fn=FN)
	translate([IOR,0,0])
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


module BottomPlant() {
	difference() {
		linear_extrude(height = 3)
		difference() {
			scale ([0.8,3])	circle(r=28);
			circle(r=6);
		}
		translate([0, -60, -1]) cylinder(r=4, 6);
		translate([0, 60, -1]) cylinder(r=4, 6);
	}
}

module Limiter(edge) {
	translate([InnerR-edge*sqrt(2)/2,0,RampLength+ConnectLength+edge]) rotate([90]) linear_extrude(height=1) polygon(points=[[0,0],[edge-3,-edge],[edge,-edge],[edge,edge]]);
}

module Limiters() {
	rotate(135) Limiter(8);
	rotate(315) Limiter(8);
}


module WaterStop() {
	difference() {
		assign(waterR=IOR-2.5, longer=4, smaller=0.8) {
			cylinder(r=waterR, ConnectLength+longer);
			translate([0,0,ConnectLength + longer])
			cylinder(r1=waterR, r2=(waterR+Drop)*smaller, RampLength*smaller);
			translate([0,0,ConnectLength + longer + RampLength*smaller])
			cylinder(r=(waterR+Drop)*smaller, 2);
		}

		translate([1, 1, 2])
		cube([IOR+3, IOR+3, ConnectLength+1]);
		rotate(90) translate([1, 1, 2])
		cube([IOR+3, IOR+3, ConnectLength+1]);
		rotate(180) translate([1, 1, 2])
		cube([IOR+3, IOR+3, ConnectLength+1]);
		rotate(270) translate([1, 1, 2])
		cube([IOR+3, IOR+3, ConnectLength+1]);

	}
}


render(convexity = 2) {
	translate([0,0,ConnectLength+RampLength]) {
		Head();
		TubeBody();
	}
	difference() {
		Thinner();
		translate([0,0,-2]) cylinder(r=20, 2);
	}
	rotate(-90) BottomPlant();
	cylinder(r=IOR-2, ConnectLength);
	Limiters();
	WaterStop();
	BottomPlant();
}


