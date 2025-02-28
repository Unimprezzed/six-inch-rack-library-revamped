include <constants.scad>

function u2mm(u) = U*u;

function mm2u(mm) = mm/U;

function dist3D(p1,p2) = sqrt(pow(p1.x - p2.x, 2)+pow(p1.y-p2.y,2)+pow(p1.z-p2.z,2));

module cabinet_vents(depth) {
	for(i=[0:8:80]){
        translate([(CABINET_WIDTH - 80)/2 + i, 20 ,-50]){
            minkowski(){
                cube([0.01, depth-40, 200]);
                sphere(d=2);
            }
        }
    }
}

module rack_vents(depth){
    for(i=[0:8:120]){
        translate([(CABINET_WIDTH - 80)/2 + i, 20 ,-50]){
            minkowski(){
                cube([0.01, depth-40, 200]);
                sphere(d=2);
            }
        }
    }
}

module m3_cs_screw(){
	union(){
        cylinder( d1=M3_SCREW_THREAD, d2=M3_CS_SCREW_HEAD_WIDTH, h=M3_CS_SCREW_HEAD_HEIGHT);
        translate([0,0,-M3_SCREW_LENGTH+0.01]){cylinder(d=M3_SCREW_THREAD, h=M3_SCREW_LENGTH);}  
        translate([0,0,M3_CS_SCREW_HEAD_HEIGHT]){cylinder(d=M3_CS_SCREW_HEAD_WIDTH, h=1);}
        }
}
module bracket(dim, thickness, length,tabs=[false, false, false, false]){
    //color([0.2,0.2,0.2,0.5])cube(dim);
    //Corners first
    translate([-thickness-TOL,-thickness-TOL])cube([length,thickness,dim.z]);
    translate([-thickness-TOL,-thickness-TOL])cube([thickness,length,dim.z]);
    translate([dim.x-length+thickness+TOL,-thickness-TOL])cube([length,thickness,dim.z]);
    translate([dim.x+TOL,-thickness-TOL])cube([thickness,length,dim.z]);
    translate([-thickness-TOL,dim.y+TOL])cube([length,thickness,dim.z]);
    translate([-thickness-TOL,dim.y-length+thickness+TOL])cube([thickness,length,dim.z]);
    translate([dim.x-length+thickness+TOL,dim.y+TOL])cube([length,thickness,dim.z]);
    translate([dim.x+TOL,dim.y-length+thickness+TOL])cube([thickness,length,dim.z]);
    
    tab_profile = [
        [-3,-WALL_THICKNESS],
        [thickness,-WALL_THICKNESS],
        [thickness,dim.z],
        [thickness+2,dim.z+2],
        [thickness, dim.z+4],
        [0,dim.z+4]
    ];
    if(tabs[0]==true){
        translate([(dim.x + length)/2-thickness,dim.y+thickness+TOL,0])
            rotate([90,0,270])
                linear_extrude(length)
                    polygon(tab_profile);
    }
    if(tabs[1]==true){
        translate([dim.x + thickness+TOL,(dim.y-length)/2,0])
            rotate([90,0,180])
                linear_extrude(length)
                    polygon(tab_profile);
    }
    if(tabs[2]==true){
        translate([(dim.x-length)/2,-thickness-TOL,0])
            rotate([90,0,90])
                linear_extrude(length)
                    polygon(tab_profile);
    }
    if(tabs[3]==true){
        translate([-thickness-TOL,(dim.y+length)/2,0])
            rotate([90,0,0])
                linear_extrude(length)
                    polygon(tab_profile);
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

module grid(){
    width=SIX_INCH-1;
    
    intersection(){
        union(){
            sz=8;
            grid = 15;
            for(i=[-grid*8:12:grid*8]){        
                translate([sz/2+i+70,sz/2+78,PANEL_THICKNESS/2]){
                    rotate([0,0,45]){
                    cube([2,width*1.5,PANEL_THICKNESS],center=true);        
                    }
                }
                translate([sz/2+i+70,sz/2+82,PANEL_THICKNESS/2]){
                    rotate([0,0,-45]){
                        cube([2,width*1.5,PANEL_THICKNESS],center=true);        
                    }
                }
            }
        }
        translate([15,15,-1]){cube([125,125,10]);}
    }
}

//Handle design common to enclosures, cabinets, drawers, whatever. 
module handle(units){
    h1 = u2mm(units);
    outer_r = 4.5;
    inner_r = outer_r/2;
    h2 = h1-4*inner_r;
    translate([0,0,0]){
        difference(){
            handle_sub(outer_r,h1,10);
            translate([outer_r, 0,-2])handle_sub(inner_r,h2,12);
            translate([inner_r,0,5])rotate([90,0,0])cylinder(h=M3_SCREW_LENGTH,d=M3_SCREW_THREAD-TOL);
            translate([h1-inner_r,0,5])rotate([90,0,0])cylinder(h=M3_SCREW_LENGTH,d=M3_SCREW_THREAD-TOL);
        }
    }
}
module handle_sub(outer_r,l,h){
    hull(){
            translate([outer_r,-outer_r,0])cylinder(r=outer_r,h=h);
            translate([l-outer_r,-outer_r,0])cylinder(r=outer_r,h=h);
            translate([0,-outer_r,0])cube([l,outer_r,h]);
    }
}