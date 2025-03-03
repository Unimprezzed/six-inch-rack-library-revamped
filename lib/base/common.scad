include <constants.scad>

//Converts units to millimeters
function u2mm(u) = U*u;

//Converts millimeters to units
function mm2u(mm) = mm/U;

//Measures distance on two dimensions
function dist2D(p1,p2) = sqrt(pow(p1.x-p2.x,2) + pow(p1.y-p2.y,2));

//Measures distance on three dimensions
function dist3D(p1,p2) = sqrt(pow(p1.x - p2.x, 2)+pow(p1.y-p2.y,2)+pow(p1.z-p2.z,2));

//Module that creates vents for cabinet and enclosure panels of a specified depth
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

//Used to create vents for rack panels
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

//Module that creates a placeholder object representing a counter-sunk M3 machine screw. Used to make a form-fitting slot for related fastener hardware. 
module m3_cs_screw(){
	union(){
        cylinder( d1=M3_SCREW_THREAD, d2=M3_CS_SCREW_HEAD_WIDTH, h=M3_CS_SCREW_HEAD_HEIGHT);
        translate([0,0,-M3_SCREW_LENGTH+0.01]){cylinder(d=M3_SCREW_THREAD, h=M3_SCREW_LENGTH);}  
        translate([0,0,M3_CS_SCREW_HEAD_HEIGHT]){cylinder(d=M3_CS_SCREW_HEAD_WIDTH, h=1);}
        }
}

//Module that creates a placeholder object representing an M5 machine screw. 
module m5_screw(){
	union(){
		translate([0,0,39])cylinder(d=5,h=40);
		translate([0,0,-4])cylinder(d1=10,d2=6,h=3.5);
		translate([0,0,-34])cylinder(d=10,h=30);
	}
}

//I couldn't think of a better name for this. This module partially encloses a square area with walls at the corners and, optionally, tabs that hook over the top of the enclosed area to clip the object in place. 
//This is useful for things that are already inside their own cases or are otherwise difficult to remove from their cases, like network switches, USB hubs, ethernet-USB adapters, and the like. 
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

//Standoffs that are used for securing PCBs and other thin objects to flat internal surfaces
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

//For instances where we need to have a screw thread through the bottom of a standoff (like if it's having to secure a Pi and a spacer between it and a HAT)
module standoff_thru_screw(od,id){
    cylinder(h=WALL_THICKNESS, d1=od, d2=id);
}  

//This is the tab used to secure the rear panel to the rests on the cabinet. It can also be used for snap-in parts. 
module tab(){
    tab_poly_points = [
        [0,WALL_THICKNESS],
        [0,0],
        [WALL_THICKNESS+TOL,0],
        [WALL_THICKNESS+TOL+2,-2],
        [WALL_THICKNESS+TOL+4,0],
        [WALL_THICKNESS+TOL+4,WALL_THICKNESS],
    ];
    translate([0,WALL_THICKNESS/2,0])rotate([90,0,0])linear_extrude(WALL_THICKNESS)polygon(tab_poly_points);
}

//Used in the "grid" option for rack_panel
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

//Handle design common to the major modules in this ecosystem.  
module handle(units){
    h1 = u2mm(units);
    outer_r = 4.5;
    inner_r = outer_r/2;
    h2 = h1-4*inner_r;
    translate([0,0,0]){
        difference(){
            handle_sub(outer_r,h1,10);
            translate([outer_r, 0,-2])handle_sub(inner_r,h2,12);
            translate([inner_r,0,5])rotate([90,0,0])cylinder(h=M3_SCREW_LENGTH,d=M3_SCREW_THREAD-TOL,$fn=20);
            translate([h1-inner_r,0,5])rotate([90,0,0])cylinder(h=M3_SCREW_LENGTH,d=M3_SCREW_THREAD-TOL,$fn=20);
        }
    }
}

//A sub-module of the above that creates the basic shape of the handle
module handle_sub(outer_r,l,h){
    hull(){
            translate([outer_r,-outer_r,0])cylinder(r=outer_r,h=h);
            translate([l-outer_r,-outer_r,0])cylinder(r=outer_r,h=h);
            translate([0,-outer_r,0])cube([l,outer_r,h]);
    }
}

//Module taken from the original library that creates a piece that has similiar dimensions to a 2020 aluminum extrusion.
//Last variables 
module extrusion(length_mm, screw_trap_center=false, screw_traps_x=false, screw_traps_y=false){
	difference(){
		translate([0,2,2])
			minkowski(){
				cube(length_mm,16,16);
				sphere(d=4);
			}
		translate([-5,10,1.99])
			rotate([0,90,0])
				linear_extrude(length_mm+10)
					polygon(points=[[0,-2.5],[2,-4],[2,4],[0,2.5]]);
		translate([-5,10,18.01])
			rotate([0,-90,180])
				linear_extrude(length_mm+10)
					polygon(points=[[0,-2.5],[2,-4],[2,4],[0,2.5]]);
        
		 translate([-5,18.01,10])
			rotate([90,0,90])
				linear_extrude(length_mm+10)
					polygon(points=[[0,-2.5],[2,-4],[2,4],[0,2.5]]);
            
		translate([-5,1.99,10])
			rotate([-90,0,-90])
				linear_extrude(len+10)
					polygon(points=[[0,-2.5],[2,-4],[2,4],[0,2.5]]);
		
		if(screw_trap_center)
			translate([-5,10,10])
				rotate([0,90,0])
					cylinder(d=4.6,h=length_mm+10);
		if(screw_traps_y)
			for(i=[0:30])
				translate([U/2+i*U,10,-5])
					cylinder(d=3.8,h=30);
		if(screw_traps_x)
			for(i=[0:30])
				translate([U/2+i*U,25,10])
					rotate([90,0,0])
						cylinder(d=3.8,h=30);
		//Length cutoff
		translate([-2,0,0])cube([4,60,60],center=true);
		translate([length_mm+2,0,0])cube([4,60,60],center=true);
	}
}

module extrusion_bend(){
	translate([SIX_INCH/2,-10,15])
		rotate([0,67.5,0])
			cube([80,80,30]);
	translate([0,80,0])
		rotate([0,67.5,180])
			cube([80,80,30]);
	translate([-20,0,-100])
		cube([40,80,100]);
}

module rack_panel(dim=[0,0,0]){
	//Positions for the holes to mount the cabinet to the rack
	 mounting_screw_pos = [
		[-HALF_EXTRUSION_PROFILE_WIDTH, -PANEL_THICKNESS,U/2],
		[-HALF_EXTRUSION_PROFILE_WIDTH, -PANEL_THICKNESS, dim.z-U/2],
		[SIX_INCH-(EXTRUSION_PROFILE_WIDTH*1.5),-PANEL_THICKNESS,U/2],
		[SIX_INCH-(EXTRUSION_PROFILE_WIDTH*1.5),-PANEL_THICKNESS,dim.z-U/2],
        [-HALF_EXTRUSION_PROFILE_WIDTH,-PANEL_THICKNESS,dim.z/2],
        [SIX_INCH-(EXTRUSION_PROFILE_WIDTH*1.5),-PANEL_THICKNESS,dim.z/2]
	];
	difference(){
		translate([-EXTRUSION_PROFILE_WIDTH+1.25,-PANEL_THICKNESS+1.25,1.25])
			minkowski(){
				cube([SIX_INCH-2.5,PANEL_THICKNESS-2.5,dim.z-2.5]);
				sphere(r=1.25);
			}
		for(i=[0:mm2u(dim.z) >=5 ? 5: 3]){
			translate(mounting_screw_pos[i])
				rotate([270,0,0])
					cylinder(r=2.3,h=dim.y);
		}
        
	}
}
