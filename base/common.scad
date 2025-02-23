include <constants.scad>
$fn=40;
function u2mm(u) = U*u;
module vents(depth) {
	for(i=[0:8:80]){
        translate([(CABINET_WIDTH - 80)/2 + i, 20 ,-50]){
            minkowski(){
                cube([0.01, depth-40, 200]);
                sphere(d=2);
            }
        }
    }
}
function dist3D(p1,p2) = sqrt(pow(p1.x - p2.x, 2)+pow(p1.y-p2.y,2)+pow(p1.z-p2.z,2));
module m3_cs_screw(){
	union(){
        cylinder( d1=M3_SCREW_THREAD, d2=M3_CS_SCREW_HEAD_WIDTH, h=M3_CS_SCREW_HEAD_HEIGHT);
        translate([0,0,-M3_SCREW_LENGTH+0.01]){cylinder(d=M3_SCREW_THREAD, h=M3_SCREW_LENGTH);}  
        translate([0,0,M3_CS_SCREW_HEAD_HEIGHT]){cylinder(d=M3_CS_SCREW_HEAD_WIDTH, h=1);}
        }
}

module bracket(w,l,xl,yl,h){
  corner_dim = [xl,yl,h-TOL];
  cutout_dim = [w,l,h];
  corners = [
    [0,0,0],
    [0,l-yl/2,0],
    [w-xl/2,0,0],
    [w-xl/2,l-yl/2,0]
  ];
  difference(){
    union(){
        for(c=corners){
            translate(c)cube(corner_dim);
        }
    }
    translate([corner_dim.x/4, corner_dim.y/4, 0])cube(cutout_dim);
  }
}

module standoff(od,id,h){
    union(){
        translate([0,0,WALL_THICKNESS]){
            difference(){
                cylinder(h=h,d1=2*od,d2=od);
                cylinder(h=h+TOL,d=id);
            }
        }
        cylinder(h=WALL_THICKNESS, d=od*2);
    }
}
module standoff_thru_screw(od,id){
    cylinder(h=WALL_THICKNESS, d1=od, d2=id);
}  
