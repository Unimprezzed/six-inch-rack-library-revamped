//Constants. Do not change pls?
$fn=40;
SIX_INCH = 155;						                        // 6" to cm
EXTRUSION_PROFILE_WIDTH = 20;				                //Width of the 2020 extrusion
CABINET_WIDTH = SIX_INCH - 2 * EXTRUSION_PROFILE_WIDTH; 	//Cabinet Width
U = (44.5/19)* 6; 					                        //1U
 
TOL=0.1; 

//Wall and panel 
wall_thickness = 2;
panel_thickness = 3; 

//Screw parameters
screw_head_width = 7.4; 
screw_head_height = 2.2;
screw_thread_diameter = 3;                                  //M3 by default
screw_length = 7;

//Parameters for the cabinet
screw_trap_depth = 6; 
screw_trap_padding = 5; 
st_dist_from_ics = 10; //Distance of the screw traps on the top and bottom relative to the inside corners of the cabinet

//Profile transforms (Attachment points in the profile for other features) 
//For the cabinet
cb_bl_i = [wall_thickness, wall_thickness]; 			    // Bottom inside left corner of the cabinet
cb_br_i = [CABINET_WIDTH-wall_thickness, wall_thickness]; 	// Bottom inside right corner of the cabinet            
//For the lid
lid_bl = [wall_thickness + TOL, 0];
lid_br = [CABINET_WIDTH - 2 * (wall_thickness + TOL), 0];
//For the rear panel
rp_bl_i = [wall_thickness + TOL, wall_thickness + TOL];
rp_br_i = [CABINET_WIDTH - 2 * (wall_thickness + TOL), wall_thickness + TOL];
//For the front panel
fp_bl_i = [EXTRUSION_PROFILE_WIDTH + wall_thickness, wall_thickness];
fp_br_i = [CABINET_WIDTH - 2 * (wall_thickness + TOL), wall_thickness];

//Lid
lid_w = CABINET_WIDTH - 2 * (wall_thickness + TOL);
lid_h = wall_thickness;

outer_radius = screw_trap_padding + (screw_thread_diameter - TOL);
inner_radius = screw_thread_diameter/2 -TOL;

module vents(depth){
    for(i=[0:8:80]){
        translate([(CABINET_WIDTH - 80)/2 + i, -depth + 20,-50]){
            minkowski(){
                cube([0.01, depth-40, 200]);
                sphere(d=2);
            }
        }
    }
}

module screw(){
    union(){
        cylinder( d1=screw_thread_diameter, d2=screw_head_width, h=screw_head_height);
        translate([0,0,-screw_length+0.01]){cylinder(d=screw_thread_diameter, h=screw_length);}  
        translate([0,0,screw_head_height]){cylinder(d=screw_head_width, h=1);}
        }
}

module screw_trap_profile(){
    difference(){
        scale([0.7,1.0])circle(r = outer_radius);
        translate([0,inner_radius+2.3])circle(r=inner_radius);  
        translate([-outer_radius, -1.5*outer_radius])square([2*outer_radius, 1.5*outer_radius]);
    }
}

function dist(p1,p2) = sqrt(pow(p1.x - p2.x, 2)+pow(p1.y-p2.y,2)+pow(p1.z-p2.z,2));

module make_rear_panel(units, square_holes=[], round_holes=[]){
    panel_offset = [wall_thickness + TOL, 0, wall_thickness+TOL];
    rp_w = CABINET_WIDTH - 2 * (wall_thickness + TOL);
    rp_h = U * units - 2 *( TOL + wall_thickness);
    difference(){

        translate(panel_offset)
            rotate([90,0,0])
                linear_extrude(height=wall_thickness)
                    square([rp_w,rp_h]);

        translate([wall_thickness+st_dist_from_ics,-screw_head_height+TOL,wall_thickness+inner_radius+2.3])
            rotate([270,0,0])
                screw();
        translate([CABINET_WIDTH-wall_thickness-st_dist_from_ics,-screw_head_height+TOL,wall_thickness+inner_radius+2.3])
            rotate([270,0,0])
                screw();
        translate([wall_thickness+st_dist_from_ics,-screw_head_height+TOL,U*units - wall_thickness-inner_radius-2.3])
            rotate([270,0,0])
                screw();
        translate([CABINET_WIDTH-wall_thickness-st_dist_from_ics,-screw_head_height+TOL,U*units - wall_thickness-inner_radius-2.3])
            rotate([270,0,0])
                screw();
        //Square Holes go here
        if(len(square_holes) > 0){
            for(e=square_holes){
                x = e[0];
                z = e[1];
                w = e[2];
                h = e[3];
                translate([x,-panel_thickness,z])
                    cube([w,panel_thickness*2,h]);
            }
        }
        //Round Holes go here
        if(len(round_holes)>0){
            for(e=round_holes){
            echo(e);
                x = e[0];
                z = e[1];
                d = e[2];
                translate([x,panel_thickness/2,z])
                    rotate([90,0,0])
                        cylinder(panel_thickness*2, d=d);
            }
        }

    }     
}

module make_front_panel(units, square_holes=[],round_holes=[]){
    //Rack Mount hole locations
    x1 = (EXTRUSION_PROFILE_WIDTH/2)-0.5;
    x2 = SIX_INCH - (EXTRUSION_PROFILE_WIDTH/2)-0.5;
    z1 = U/2;
    z2 = U*units - U/2;
    //Positions for the holes for mounting to the rack 
    rx1z1 = [x1,panel_thickness,z1];
    rx1z2 = [x1,panel_thickness,z2];
    rx2z1 = [x2,panel_thickness,z1];
    rx2z2 = [x2,panel_thickness,z2];
    //Positions for the handles
    
    hx1z1 = [18,panel_thickness-screw_head_height, 4.5];
    hx1z2 = [18,panel_thickness-screw_head_height, U*units-4.5];
    hx2z1 = [SIX_INCH-18,panel_thickness-screw_head_height, 4.5];
    hx2z2 = [SIX_INCH-18,panel_thickness-screw_head_height, U*units-4.5];
    
    difference(){
        translate([1.25,1.25,1.25])
            minkowski(){
                cube([SIX_INCH-2.5,panel_thickness-2.5,U*units-2.5]);
                sphere(r=1.25);
            }
        //Holes for screws to secure the cabinet to the front rack
        translate(rx1z1)rotate([90,0,0])cylinder(r=2.3, h=2*panel_thickness);
        translate(rx1z2)rotate([90,0,0])cylinder(r=2.3, h=2*panel_thickness);
        translate(rx2z1)rotate([90,0,0])cylinder(r=2.3, h=2*panel_thickness);
        translate(rx2z2)rotate([90,0,0])cylinder(r=2.3, h=2*panel_thickness);
        //Holes for the screws to secure the handles
        translate(hx1z1)rotate([270,0,0])screw();
        translate(hx1z2)rotate([270,0,0])screw();
        translate(hx2z1)rotate([270,0,0])screw();
        translate(hx2z2)rotate([270,0,0])screw();
        //Holes to secure to the cabinet
        icbl = [EXTRUSION_PROFILE_WIDTH+wall_thickness,0,wall_thickness];
        icbr = [CABINET_WIDTH-wall_thickness,0,wall_thickness];
        ictl = [EXTRUSION_PROFILE_WIDTH+wall_thickness,0,U*units-wall_thickness-TOL];
        ictr = [CABINET_WIDTH-wall_thickness,0,U*units-wall_thickness-TOL];
        translate(icbl + [st_dist_from_ics,screw_head_height,inner_radius+2.3])
            rotate([90,0,0])
                screw();
        translate(icbr + [st_dist_from_ics,screw_head_height,inner_radius+2.3])
            rotate([90,0,0])
                screw();
        translate(ictl + [st_dist_from_ics,screw_head_height,-inner_radius-2.3])
            rotate([90,0,0])
                screw();
        translate(ictr + [st_dist_from_ics,screw_head_height,-inner_radius-2.3])
            rotate([90,0,0])
                screw();   
               
        if(len(round_holes) > 0){
            for(e=round_holes){
                x = e[0];
                y = e[1];
                d = e[2];
                translate(icbl + [x,panel_thickness/2,z])
                    rotate([90,0,0])
                        cylinder(h=panel_thickness*2, d=d);
            }
        }
         if(len(square_holes) > 0){
            for(e=square_holes){
                x = e[0];
                z = e[1];
                w = e[2];
                h = e[3];
                translate(icbl + [x,-panel_thickness/2,z])
                    cube([w,panel_thickness*2,h]);
            }
        }
    }  
}

module make_lid(depth){
	//Base lid profile extruded and then having the vents cutout
    inside_corner_fl = [wall_thickness,0,0];
    inside_corner_fr = [CABINET_WIDTH-wall_thickness,0,0];
    inside_corner_bl = [wall_thickness,depth,0];
    inside_corner_br = [CABINET_WIDTH-wall_thickness,depth,0];
    screw_pos = [
        inside_corner_fl + [inner_radius+2.3,screw_length+outer_radius/2,0],
        inside_corner_fr + [-inner_radius-2.3,screw_length+outer_radius/2,0],
        inside_corner_bl + [inner_radius+2.3,-wall_thickness-TOL-screw_length-outer_radius/2,0],
        inside_corner_br + [-inner_radius-2.3,-wall_thickness-TOL-screw_length-outer_radius/2,0]
    ];
    difference(){
    union(){
    translate(inside_corner_fl + [st_dist_from_ics,screw_trap_depth,0])
        
        rotate([90,180,0])
            linear_extrude(screw_trap_depth)
                screw_trap_profile();
    translate(inside_corner_fr + [-st_dist_from_ics,screw_trap_depth,0])
            rotate([90,180,0])
                linear_extrude(screw_trap_depth)
                    screw_trap_profile();
    translate(inside_corner_bl + [st_dist_from_ics,-wall_thickness-TOL,0])
        rotate([90,180,0])
            linear_extrude(screw_trap_depth)
                screw_trap_profile();
    translate(inside_corner_br + [-st_dist_from_ics,-wall_thickness-TOL,0])
            rotate([90,180,0])
                linear_extrude(screw_trap_depth)
                    screw_trap_profile();
    translate([wall_thickness + TOL, 0,0]){
	difference(){
		rotate([90,0,0])translate([0,0,-depth])linear_extrude(height=depth)square([lid_w,lid_h]);
		translate([0,depth,0])vents(depth);
	}
    }
    //Lid support
    
    }
    for(p=screw_pos){
        translate(p)screw();
    }
    }
    
}

module make_cabinet(depth, units, standoffs=[], brackets=[]){
    //
    cb_w = CABINET_WIDTH; 
    cb_h = U * units; 
    //Base Cabinet generation code
    difference(){
    union(){
        difference(){
            rotate([90,0,0])
                translate([0,0,-depth])
                    linear_extrude(height=depth)
                        difference(){
                            square([cb_w, cb_h]);
                            translate([wall_thickness, wall_thickness])
                                square([CABINET_WIDTH-2*(wall_thickness), cb_h]);
                        }
        //Vent cutouts
        translate([0,depth,0])vents(depth);}
        
        //More calculations...
        ridge_z = U*units - wall_thickness - TOL; 
        //Lower front left corner
        inside_corner_lfl = [wall_thickness,0,wall_thickness];
        //Lower front right corner
        inside_corner_lfr = [CABINET_WIDTH-wall_thickness,0,wall_thickness];
        //Lower back left corner
        inside_corner_lbl = [wall_thickness,depth,wall_thickness];
        //Lower back right corner
        inside_corner_lbr = [CABINET_WIDTH-wall_thickness,depth,wall_thickness]; 
        //Upper front left corner
        inside_corner_ufl = inside_corner_lfl + [0,0,ridge_z];
        //Upper front right corner
        inside_corner_ufr = inside_corner_lfr + [0,0,ridge_z];
        //Upper back left corner
        inside_corner_ubl = inside_corner_lbl + [0,0,ridge_z];
        //Upper back right corner
        inside_corner_ubr = inside_corner_lbr + [0,0,ridge_z];
        //Lower center left
        inside_corner_lcl = inside_corner_lfl + [0,depth/2,0];
        //Lower center right
        inside_corner_lcr = inside_corner_lfr + [0,depth/2,0];
        //Upper center left
        inside_corner_ucl = inside_corner_ufl + [0,depth/2,0];
        //Upper center right
        inside_corner_ucr = inside_corner_ufr + [0,depth/2,0];
        polygon_l = [[0,-U],[ 0,0],[3,0]];
        polygon_r = [[0,-U],[-3,0],[0,0]];
        offset_f = [0,screw_length,-wall_thickness];
        offset_b = [0,-wall_thickness-TOL,-wall_thickness];
        translate(inside_corner_ufl + offset_f)
            rotate([90,0,0])
                linear_extrude(height=screw_length)
                    polygon(polygon_l);
        translate(inside_corner_ufr + offset_f)
            rotate([90,0,0])
                linear_extrude(height=screw_length)
                    polygon(polygon_r);
        translate(inside_corner_ubl + offset_b)
            rotate([90,0,0])
                linear_extrude(height=screw_length)
                    polygon(polygon_l);
        translate(inside_corner_ubr + offset_b)
            rotate([90,0,0])
                linear_extrude(height=screw_length)
                    polygon(polygon_r);
        //Screw traps
        screw_trap_positions = [
            inside_corner_ufl + [0,screw_length+outer_radius/2,-screw_trap_depth-wall_thickness], 
            inside_corner_ufr + [0,screw_length+outer_radius/2,-screw_trap_depth-wall_thickness], 
            inside_corner_ubl + [0,-wall_thickness-TOL-screw_length-outer_radius/2,-screw_trap_depth-wall_thickness], 
            inside_corner_ubr + [0,-wall_thickness-TOL-screw_length-outer_radius/2,-screw_trap_depth-wall_thickness]
        ];
        screw_trap_rotations = [
            [0,0,270],[0,0,90],
            [0,0,270],[0,0,90],
            [0,0,270],[0,0,90]
        ];
        
        lip_length = depth - 2*outer_radius - 2*screw_length;
        
        translate(inside_corner_ucl + [0,-wall_thickness/2+lip_length/2,-wall_thickness])
            rotate([90,0,0])
                linear_extrude(height=lip_length)
                    polygon(polygon_l);
        translate(inside_corner_ucr + [0,-wall_thickness/2+lip_length/2,-wall_thickness])
            rotate([90,0,0])
                linear_extrude(height=lip_length)
                    polygon(polygon_r);
        
        trap_to_floor_h = U*units-wall_thickness-TOL-screw_trap_depth-wall_thickness;
        for(i=[0:3]){
            translate(screw_trap_positions[i])
                rotate(screw_trap_rotations[i]){
                    linear_extrude(height=screw_trap_depth)
                        screw_trap_profile();
                }
            translate(screw_trap_positions[i])
                rotate(screw_trap_rotations[i] + [0,180,0]){
                    linear_extrude(height=trap_to_floor_h, scale=0.5)
                        screw_trap_profile();
                }
        }
        //Front screw traps
        translate(inside_corner_lfl + [st_dist_from_ics,screw_trap_depth,0])
            rotate([90,0,0])
                linear_extrude(screw_trap_depth)
                    screw_trap_profile();
        translate(inside_corner_lfr + [-st_dist_from_ics,screw_trap_depth,0])
            rotate([90,0.0])
                linear_extrude(screw_trap_depth)
                    screw_trap_profile();
        //Back screw traps
        translate(inside_corner_lbl + [st_dist_from_ics,-wall_thickness-TOL,0])
            rotate([90,0,0])
                linear_extrude(screw_trap_depth)
                    screw_trap_profile();
        translate(inside_corner_lbr + [-st_dist_from_ics,-wall_thickness-TOL,0])
            rotate([90,0,0])
                linear_extrude(screw_trap_depth)
                    screw_trap_profile();
        //The little lip the back panel rests against
        translate(inside_corner_lbl + [0,-wall_thickness-TOL-2,0])
            difference(){
                cube([CABINET_WIDTH-2*wall_thickness,2,ridge_z-wall_thickness]);
                translate([1,-5,1])
                    cube([CABINET_WIDTH-2*wall_thickness-2,10,ridge_z-wall_thickness]);
            }
        //Brackets
	if(len(brackets) > 0){
	for(b=brackets){
		x = b[0];
		y = b[1];
		w = b[2];
		l = b[3];
		h = b[4];
		xl= b[5];
		yl= b[6];
		base_pos = inside_corner_lfl + [x,y,h/2];
		bracket_dim = [xl,yl,h];
		cutout_dim = [w,l,h];
		off_1 = base_pos + [w/2, l/2, 0];
		off_2 = base_pos + [w/2, -l/2, 0];
		off_3 = base_pos + [-w/2, -l/2, 0];
		off_4 = base_pos + [-w/2, l/2, 0];
		difference(){
			union(){
				translate(off_1)cube(bracket_dim, center=true);
				translate(off_2)cube(bracket_dim, center=true);
				translate(off_3)cube(bracket_dim, center=true);
				translate(off_4)cube(bracket_dim, center=true);
			}
			translate(base_pos)cube(cutout_dim,center=true);
		}		
	}
	}        
        //Standoffs
        if(len(standoffs) > 0){
        for(s=standoffs){
		x = s[0];
		y = s[1];
		od= s[2];
		id= s[3];
		h = s[4];
		base_pos = inside_corner_lfl + [x,y,0];
		translate(base_pos)
			union(){
				difference(){
					cylinder(d=od,h=h);
					cylinder(d=id,h=h+1);
				}
			translate([0,0,-wall_thickness])cylinder(d=od*2,h=wall_thickness);
			}	
	}
    }            
    }
    if(len(standoffs) > 0){
        inside_corner_lfl = [wall_thickness,0,wall_thickness];
        for(s=standoffs){
            if(s[5]){
            
            x = s[0];
            y = s[1];
            od = s[2];
            id = s[3];
            base_pos = inside_corner_lfl + [x,y,-wall_thickness];
            translate(base_pos){
                cylinder(h=screw_head_height, d1 = od, d2 = id);
                cylinder(h = screw_length+screw_head_height, d=id);
            }
        }  
    }
    }
    }
}
