include <../base/constants.scad>
include <../base/common.scad>


//calculates the inside corners of the cabinet
function calculate_inside_corners(w, d, h)=[
	[ WALL_THICKNESS, 0, WALL_THICKNESS],	//  0: Front lower left
	[w-WALL_THICKNESS, 0, WALL_THICKNESS],	//  1: Front lower right
	[ WALL_THICKNESS, d/2, WALL_THICKNESS],	//  2: Middle lower left
	[w-WALL_THICKNESS, d/2, WALL_THICKNESS],//  3: Middle lower right
	[ WALL_THICKNESS, d, WALL_THICKNESS],	//  4: Back lower left
	[w-WALL_THICKNESS, d, WALL_THICKNESS],	//  5: Back lower right
	[ WALL_THICKNESS, 0,  h/2],		//  6: Front middle left
	[w-WALL_THICKNESS, 0, h/2],		//  7: Front middle right
	[ WALL_THICKNESS, d/2, h/2],		//  8: Middle middle left
	[w-WALL_THICKNESS, d/2, h/2],		//  9: Middle middle right
	[ WALL_THICKNESS, d, h/2],		// 10: Back middle left
	[w-WALL_THICKNESS, d, h/2],		// 11: Back middle right
	[ WALL_THICKNESS, 0, h],		// 12: Front upper left
	[w-WALL_THICKNESS, 0, h],		// 13: Front upper right
	[ WALL_THICKNESS, d/2, h],		// 14: Middle upper left
	[w-WALL_THICKNESS, d/2, h],		// 15: Middle upper right
	[ WALL_THICKNESS, d, h],		// 16: Back upper left
	[w-WALL_THICKNESS, d, h]		// 17: Back upper right
];
//Creates a support strut centered at 0,0 
function rib_base(side)= (side=="L") ? [[0,-4],[3,0],[0,4]] : [[-3,0],[0,4],[0,-4]];
function lid_rest(side)= (side=="L") ? [[0,-3],[ 0,0],[3,0]] : [[0,-3],[-3,0],[0,0]];

module cabinet(cabinet_dim=[0,0,0],brackets=[],standoffs=[]){
    $fn=60;
	ic = calculate_inside_corners(cabinet_dim.x, cabinet_dim.y, cabinet_dim.z);
	screw_trap_pos = [
		//Front Screw traps
		ic[0] + [SCREW_TRAP_DISTANCE,0,0],													//0
		ic[1] + [-SCREW_TRAP_DISTANCE,0,0],													//1
		ic[6],																				//2
		ic[7],																				//3
		//Rear Screw Traps
		ic[4] + [SCREW_TRAP_DISTANCE,-TOL-2*WALL_THICKNESS,0],								//4
		ic[5] + [-SCREW_TRAP_DISTANCE,-TOL-2*WALL_THICKNESS,0],								//5
		ic[10] + [0,-TOL-2*WALL_THICKNESS,0],												//6
		ic[11] + [0,-TOL-2*WALL_THICKNESS,0],												//7
		//Top Screw Traps
		ic[12] + [0,SCREW_TRAP_OUTER_DIAMETER/2,-TOL-WALL_THICKNESS],						//8
		ic[13] + [0,SCREW_TRAP_OUTER_DIAMETER/2,-TOL-WALL_THICKNESS],						//9
		ic[16] + [0,-SCREW_TRAP_OUTER_DIAMETER/2-TOL-WALL_THICKNESS,-TOL-WALL_THICKNESS],	//10
		ic[17] + [0,-SCREW_TRAP_OUTER_DIAMETER/2-TOL-WALL_THICKNESS,-TOL-WALL_THICKNESS],	//11
		ic[14] + [0,0,-TOL-WALL_THICKNESS],													//12
		ic[15] + [0,0,-TOL-WALL_THICKNESS]													//13
	];
	//Outside of the cube means it's considered out of bounds for the cabinet. 
	intersection(){
        difference(){
		union(){
			difference(){
				union(){
					difference(){
						//Base shape for the cabinet
						cube(cabinet_dim);
						//The cutout that establishes the inside of the cabinet
						translate(ic[0]+[0,-0.01,0])cube([cabinet_dim.x-2*WALL_THICKNESS, cabinet_dim.y-2*WALL_THICKNESS-TOL,cabinet_dim.z]);
						//The cutout that creates a little lip for the rear panel rest
						translate(ic[0]+[WALL_THICKNESS,0,WALL_THICKNESS])cube([cabinet_dim.x-4*WALL_THICKNESS,cabinet_dim.y,cabinet_dim.z]);
						//The vents on the bottom of the cabinet
                        translate(ic[4]+[0,-WALL_THICKNESS-TOL,0])cube([cabinet_dim.x-2*WALL_THICKNESS,10,cabinet_dim.z]);                 
                        translate(ic[12]+[0,0,-WALL_THICKNESS])cube([cabinet_dim.x-2*WALL_THICKNESS,cabinet_dim.y, WALL_THICKNESS+TOL]);
						vents(cabinet_dim.y);
					};
					difference(){
						union(){
							//Front screw traps
							for(i=[0:1]){
								translate(screw_trap_pos[i])
                                    scale([0.7,1,1])
                                        sphere(d=SCREW_TRAP_OUTER_DIAMETER);
							}
                            if(cabinet_dim.z > 90){
                                for(i=[2:3]){
                                    translate(screw_trap_pos[i])
                                        scale([1,1,0.7])
                                            sphere(d=SCREW_TRAP_OUTER_DIAMETER);
                                }
                            }
							//Rear screw traps
							for(i=[4:5]){
								translate(screw_trap_pos[i])
                                    scale([0.7,1,1])
                                        sphere(d=SCREW_TRAP_OUTER_DIAMETER);
							}
                            if(cabinet_dim.z > 90){
                                for(i=[6:7]){
                                    translate(screw_trap_pos[i])
                                        scale([1,1,0.7])
                                            sphere(d=SCREW_TRAP_OUTER_DIAMETER);
                                }
                            }
					
							//Top screw traps
							for(i=[8:11]){
								translate(screw_trap_pos[i])
                                    scale([1,0.7,1])
                                        sphere(d=SCREW_TRAP_OUTER_DIAMETER);
							}
                            translate([screw_trap_pos[8].x, screw_trap_pos[8].y,WALL_THICKNESS])
                                linear_extrude(cabinet_dim.z-WALL_THICKNESS-TOL)
										polygon(rib_base("L"));
                            translate([screw_trap_pos[9].x, screw_trap_pos[9].y,WALL_THICKNESS])
                                linear_extrude(cabinet_dim.z-WALL_THICKNESS-TOL)
										polygon(rib_base("R"));
                            translate([screw_trap_pos[10].x, screw_trap_pos[10].y,WALL_THICKNESS])
                                linear_extrude(cabinet_dim.z-WALL_THICKNESS-TOL)
										polygon(rib_base("L"));
                            translate([screw_trap_pos[11].x, screw_trap_pos[11].y,WALL_THICKNESS])
                                linear_extrude(cabinet_dim.z-WALL_THICKNESS-TOL)
										polygon(rib_base("R"));
                            if(cabinet_dim.y > 90){
                                for(i=[12:13]){
                                    translate(screw_trap_pos[i])
                                        scale([1,0.7,1])
                                            sphere(d=SCREW_TRAP_OUTER_DIAMETER);
                                }
                                translate([screw_trap_pos[12].x, screw_trap_pos[12].y,WALL_THICKNESS])linear_extrude(cabinet_dim.z-WALL_THICKNESS-TOL)
										polygon(rib_base("L"));
                                translate([screw_trap_pos[13].x, screw_trap_pos[13].y,WALL_THICKNESS])linear_extrude(cabinet_dim.z-WALL_THICKNESS-TOL)
										polygon(rib_base("R"));
                            }
                            //Lid Rest
                            translate(ic[16] + [0,0,-WALL_THICKNESS-TOL])rotate([90,0,0])linear_extrude(cabinet_dim.y)polygon(lid_rest("L"));
							translate(ic[17] + [0,0,-WALL_THICKNESS-TOL])rotate([90,0,0])linear_extrude(cabinet_dim.y)polygon(lid_rest("R"));
							translate(ic[4])rotate([90,270,0])linear_extrude(cabinet_dim.y)polygon(lid_rest("L"));
							translate(ic[5])rotate([90,90,0])linear_extrude(cabinet_dim.y)polygon(lid_rest("R"));
						}
						//Cutouts for the screw traps
						translate([0,-SCREW_TRAP_OUTER_DIAMETER,0])
							cube([cabinet_dim.x,SCREW_TRAP_OUTER_DIAMETER/2,cabinet_dim.z]);
						translate([WALL_THICKNESS,0,cabinet_dim.z-WALL_THICKNESS-TOL])
							cube([cabinet_dim.x-2*(WALL_THICKNESS), cabinet_dim.y, 2*WALL_THICKNESS]); 
						translate([WALL_THICKNESS, cabinet_dim.y-WALL_THICKNESS-TOL,WALL_THICKNESS])
							cube([cabinet_dim.x-2*WALL_THICKNESS, 2*WALL_THICKNESS, cabinet_dim.z]);
						//Cut out the holes for the screws
						translate([WALL_THICKNESS+SCREW_TRAP_DISTANCE,0,WALL_THICKNESS+SCREW_TRAP_OUTER_DIAMETER*0.2])
							rotate([270,0,0])
								cylinder(d=M3_SCREW_THREAD-TOL, h=cabinet_dim.y);
						translate([cabinet_dim.x - WALL_THICKNESS-SCREW_TRAP_DISTANCE, 0, WALL_THICKNESS + SCREW_TRAP_OUTER_DIAMETER*0.2])
                           rotate([270,0,0])
                                cylinder(d=M3_SCREW_THREAD-TOL, h=cabinet_dim.y);
						translate(screw_trap_pos[8] + [SCREW_TRAP_OUTER_DIAMETER*0.2,0,0])
							rotate([180,0,0])
								cylinder(d=M3_SCREW_THREAD-TOL, h=M3_SCREW_LENGTH+0.5);
                        translate(screw_trap_pos[9] + [-SCREW_TRAP_OUTER_DIAMETER*0.2,0,0])
							rotate([180,0,0])
								cylinder(d=M3_SCREW_THREAD-TOL, h=M3_SCREW_LENGTH+0.5);
						translate(screw_trap_pos[10] + [SCREW_TRAP_OUTER_DIAMETER*0.2,0,0])
							rotate([180,0,0])
								cylinder(d=M3_SCREW_THREAD-TOL, h=M3_SCREW_LENGTH+0.5);
						translate(screw_trap_pos[11] + [-SCREW_TRAP_OUTER_DIAMETER*0.2,0,0])
							rotate([180,0,0])
								cylinder(d=M3_SCREW_THREAD-TOL, h=M3_SCREW_LENGTH+0.5);
						if(cabinet_dim.z > 90){
                            translate([WALL_THICKNESS+SCREW_TRAP_OUTER_DIAMETER*0.2,0,cabinet_dim.z/2])
                                rotate([270,0,0])
                                    cylinder(d=M3_SCREW_THREAD-TOL, h=cabinet_dim.y);
                            translate([cabinet_dim.x-WALL_THICKNESS-SCREW_TRAP_OUTER_DIAMETER*0.2,0,cabinet_dim.z/2])
                                rotate([270,0,0])
                                    cylinder(d=M3_SCREW_THREAD-TOL, h=cabinet_dim.y);
                        }
						if(cabinet_dim.y > 90){
							translate(screw_trap_pos[12] + [SCREW_TRAP_OUTER_DIAMETER*0.2,0,0])
							rotate([180,0,0])
								cylinder(d=M3_SCREW_THREAD-TOL, h=M3_SCREW_LENGTH+0.5);
						translate(screw_trap_pos[13] + [-SCREW_TRAP_OUTER_DIAMETER*0.2,0,0])
							rotate([180,0,0])
								cylinder(d=M3_SCREW_THREAD-TOL, h=M3_SCREW_LENGTH+0.5);
						}   
					}
				}	

			}
            //Now that the basic shape of the cabinet has been defined, we can define the standoffs and brackets. 
            if(len(brackets) > 0){
                for(b=brackets){
                    x = b[0];
                    y = b[1];
                    w = b[2];
                    l = b[3];
                    h = b[4];
                    xl= b[5];
                    yl= b[6];
                    translate(ic[0] + [x,y,0])bracket(w,l,xl,yl,h);
                }
            }
            if(len(standoffs) > 0){
                for(s=standoffs){
                    x=s[0];
                    y=s[1];
                    od=s[2];
                    id=s[3];
                    h=s[4];
                    translate(ic[0] + [x,y,-WALL_THICKNESS])standoff(od,id,h);
                }
            }
		}
        //These are the countersunk holes for standoffs
        if(len(standoffs) > 0){
            for(s=standoffs){
                x=s[0];
                y=s[1];
                od=s[2];
                id=s[3];
                enabled=s[5];
                if(enabled){
                    translate(ic[0] + [x,y,-WALL_THICKNESS])standoff_thru_screw(od,id);
                }
            }
        }        
        translate([screw_trap_pos[8].x-WALL_THICKNESS, screw_trap_pos[8].y,0])
            linear_extrude(cabinet_dim.z-WALL_THICKNESS-TOL)
                scale([0.5,0.5,1])
                    polygon(rib_base("L"));
        translate([screw_trap_pos[9].x+WALL_THICKNESS, screw_trap_pos[9].y,0])
            linear_extrude(cabinet_dim.z-WALL_THICKNESS-TOL)
                scale([0.5,0.5,1])
                    polygon(rib_base("R"));
        translate([screw_trap_pos[10].x-WALL_THICKNESS, screw_trap_pos[10].y,0])
            linear_extrude(cabinet_dim.z-WALL_THICKNESS-TOL)
                scale([0.5,0.5,1])
                    polygon(rib_base("L"));
        translate([screw_trap_pos[11].x+WALL_THICKNESS, screw_trap_pos[11].y,0])
            linear_extrude(cabinet_dim.z-WALL_THICKNESS-TOL)
                scale([0.5,0.5,1])
                    polygon(rib_base("R"));
        if(cabinet_dim.y > 90){
            translate([screw_trap_pos[12].x-WALL_THICKNESS, screw_trap_pos[12].y,0])
                linear_extrude(cabinet_dim.z-WALL_THICKNESS-TOL)
                    scale([0.5,0.5,1])
                        polygon(rib_base("L"));
            translate([screw_trap_pos[13].x+WALL_THICKNESS, screw_trap_pos[13].y,0])
                linear_extrude(cabinet_dim.z-WALL_THICKNESS-TOL)
                    scale([0.5,0.5,1])
                        polygon(rib_base("R"));
        }
        
        
        
        }
		//This cube ensures that no component inside the cabinet sticks out beyond the design specs. 
		cube(cabinet_dim);
	}		
}

module lid(cabinet_dim=[0,0,0]){
    $fn=60;
    lid_dim = [cabinet_dim.x-2*(WALL_THICKNESS+TOL), cabinet_dim.y, WALL_THICKNESS];
	ic = calculate_inside_corners(cabinet_dim.x, cabinet_dim.y, cabinet_dim.z);
    screw_trap_pos = [
		//Front Screw traps
		ic[12] + [SCREW_TRAP_DISTANCE,0,-TOL-WALL_THICKNESS],													//0
		ic[13] + [-SCREW_TRAP_DISTANCE,0,-TOL-WALL_THICKNESS],													//1
		//Rear Screw Traps
		ic[16] + [SCREW_TRAP_DISTANCE,-TOL-2*WALL_THICKNESS,-TOL-WALL_THICKNESS],								//2
		ic[17] + [-SCREW_TRAP_DISTANCE,-TOL-2*WALL_THICKNESS,-TOL-WALL_THICKNESS],								//3
		//Top Screw Traps
		ic[12] + [0,SCREW_TRAP_OUTER_DIAMETER/2,-TOL-WALL_THICKNESS],						//4
		ic[13] + [0,SCREW_TRAP_OUTER_DIAMETER/2,-TOL-WALL_THICKNESS],						//5
		ic[16] + [0,-SCREW_TRAP_OUTER_DIAMETER/2-TOL-WALL_THICKNESS,-TOL-WALL_THICKNESS],	//6
		ic[17] + [0,-SCREW_TRAP_OUTER_DIAMETER/2-TOL-WALL_THICKNESS,-TOL-WALL_THICKNESS],	//7
		ic[14] + [0,0,-TOL-WALL_THICKNESS],													//8
		ic[15] + [0,0,-TOL-WALL_THICKNESS]													//9
	];
    intersection(){
        difference(){
            union(){
                translate(ic[12]+[TOL,0,-WALL_THICKNESS])cube([cabinet_dim.x-2*(WALL_THICKNESS+TOL), cabinet_dim.y, WALL_THICKNESS]);
                for(i=[0:3]){
                    translate(screw_trap_pos[i])
                        scale([0.7,1,1])
                            sphere(d=SCREW_TRAP_OUTER_DIAMETER);
                }
                dist = dist3D(screw_trap_pos[2],screw_trap_pos[3]);
                translate(screw_trap_pos[2] + [0,0,-WALL_THICKNESS])cube([dist,WALL_THICKNESS,WALL_THICKNESS]);
            }
            vents(cabinet_dim.y);
            translate(ic[4]+[0,-WALL_THICKNESS-TOL,-2*WALL_THICKNESS])cube([cabinet_dim.x-2*WALL_THICKNESS,10,cabinet_dim.z]);
            translate(screw_trap_pos[0] + [0,0,-SCREW_TRAP_OUTER_DIAMETER*0.2])rotate([270,0,0])cylinder(d=M3_SCREW_THREAD-TOL, h=cabinet_dim.y);
            translate(screw_trap_pos[1] + [0,0,-SCREW_TRAP_OUTER_DIAMETER*0.2])rotate([270,0,0])cylinder(d=M3_SCREW_THREAD-TOL, h=cabinet_dim.y);
            for(i=[4:2:9]){
                translate(screw_trap_pos[i] + [SCREW_TRAP_OUTER_DIAMETER*0.2,0,0])
                    m3_cs_screw();
            }
            for(i=[5:2:9]){
                translate(screw_trap_pos[i] + [-SCREW_TRAP_OUTER_DIAMETER*0.2,0,0])
                    m3_cs_screw();
            }
        }
        cube(cabinet_dim);
    }
}

module front_panel(cabinet_dim=[0,0,0],square_cutouts=[], circular_cutouts=[]){
    $fn=60; 
	ic = calculate_inside_corners(cabinet_dim.x, cabinet_dim.y, cabinet_dim.z);
    //Positions for the holes to mount the cabinet to the rack
    mounting_screw_pos = [
        [-HALF_EXTRUSION_PROFILE_WIDTH, -PANEL_THICKNESS,U/2],
        [-HALF_EXTRUSION_PROFILE_WIDTH, -PANEL_THICKNESS, cabinet_dim.z-U/2],
        [SIX_INCH-(EXTRUSION_PROFILE_WIDTH*1.5),-PANEL_THICKNESS,U/2],
        [SIX_INCH-(EXTRUSION_PROFILE_WIDTH*1.5),-PANEL_THICKNESS,
        cabinet_dim.z-U/2]
    ];
    handle_screw_pos =[
        [-2,-M3_CS_SCREW_HEAD_HEIGHT,4.5],
        [-2,-M3_CS_SCREW_HEAD_HEIGHT,cabinet_dim.z-4.5],
        [cabinet_dim.x+2,-M3_CS_SCREW_HEAD_HEIGHT,4.5],
        [cabinet_dim.x+2,-M3_CS_SCREW_HEAD_HEIGHT,cabinet_dim.z-4.5]
    ];
    cabinet_screws_pos = [
        ic[0] + [SCREW_TRAP_DISTANCE,-WALL_THICKNESS,SCREW_TRAP_OUTER_DIAMETER*0.2],
        ic[1] + [-SCREW_TRAP_DISTANCE,-WALL_THICKNESS,SCREW_TRAP_OUTER_DIAMETER*0.2],
        ic[0] + [SCREW_TRAP_DISTANCE,-WALL_THICKNESS,cabinet_dim.z-2*WALL_THICKNESS-SCREW_TRAP_OUTER_DIAMETER*0.2],
        ic[1] + [-SCREW_TRAP_DISTANCE,-WALL_THICKNESS,cabinet_dim.z-2*WALL_THICKNESS-SCREW_TRAP_OUTER_DIAMETER*0.2],
        ic[6] + [SCREW_TRAP_OUTER_DIAMETER*0.2,-WALL_THICKNESS,0],
        ic[7] + [-SCREW_TRAP_OUTER_DIAMETER*0.2,-WALL_THICKNESS,0]
    ];
    
    difference(){
        translate([-EXTRUSION_PROFILE_WIDTH+1.25,-PANEL_THICKNESS+1.25,1.25]){
            minkowski(){
                cube([SIX_INCH-2.5,PANEL_THICKNESS-2.5,cabinet_dim.z-2.5]);
                sphere(r=1.25);
            }
        }
        //
        for(s=mounting_screw_pos){
            translate(s)
                rotate([270,0,0])
                    cylinder(r=2.3,h=cabinet_dim.y);
        }
        for(s=handle_screw_pos){
            translate(s)
                rotate([270,0,0])
                    m3_cs_screw();
        }
        for(i=[0:3]){
            translate(cabinet_screws_pos[i])
                rotate([90,0,0])
                    m3_cs_screw();
        }
        if(cabinet_dim.z > 90){
            for(i=[4:5]){
                translate(cabinet_screws_pos[i])
                    rotate([90,0,0])
                        m3_cs_screw();
            }
        }
        //Square cutouts 
        if(len(square_cutouts)>0){
            for(c=square_cutouts){
                x = c[0];
                z = c[1];
                w = c[2];
                h = c[3];
                translate(ic[0] + [x,-PANEL_THICKNESS,z])
                    rotate([90,0,0])
                        cube([w, cabinet_dim.y, h]);
            }
        }
        //Circular cutouts
        if(len(circular_cutouts)>0){
            for(c=circular_cutouts){
                x=c[0];
                z=c[1];
                d=c[2];
                translate(ic[0] + [x,-PANEL_THICKNESS,z])
                    rotate([90,0,0])
                        cylinder(d=d,h=cabinet_dim.y);
            }
        } 
    }
    
}

module rear_panel(cabinet_dim=[0,0,0],square_cutouts=[], circular_cutouts=[]){
    $fn=60;
    rear_panel_dim = [cabinet_dim.x-2*(WALL_THICKNESS+TOL), WALL_THICKNESS,cabinet_dim.z-2*(WALL_THICKNESS+TOL) ];
	ic = calculate_inside_corners(cabinet_dim.x, cabinet_dim.y, cabinet_dim.z);
    screw_pos = [
        ic[4] + [SCREW_TRAP_DISTANCE,-1,SCREW_TRAP_OUTER_DIAMETER*0.2],
        ic[5] + [-SCREW_TRAP_DISTANCE,-1,SCREW_TRAP_OUTER_DIAMETER*0.2],
        ic[4] + [SCREW_TRAP_DISTANCE,-1,cabinet_dim.z-2*WALL_THICKNESS-SCREW_TRAP_OUTER_DIAMETER*0.2],
        ic[5] + [-SCREW_TRAP_DISTANCE,-1,cabinet_dim.z-2*WALL_THICKNESS-SCREW_TRAP_OUTER_DIAMETER*0.2],
        ic[10]+ [SCREW_TRAP_OUTER_DIAMETER*0.2,-1,0],
        ic[11]+ [-SCREW_TRAP_OUTER_DIAMETER*0.2,-1,0],
    ];
    
    difference(){
        translate([WALL_THICKNESS+TOL, cabinet_dim.y-WALL_THICKNESS-TOL, WALL_THICKNESS+TOL])
            cube(rear_panel_dim);
        for(i=[0:3]){
            translate(screw_pos[i])
                rotate([270,0,0])
                    m3_cs_screw();
        }
        if(cabinet_dim.z > 90){
            translate(screw_pos[4])
                rotate([270,0,0])
                    m3_cs_screw();
            translate(screw_pos[5])
                rotate([270,0,0])
                    m3_cs_screw();
        }
        //Square cutouts 
        if(len(square_cutouts)>0){
            for(c=square_cutouts){
                x = c[0];
                z = c[1];
                w = c[2];
                h = c[3];
                translate(ic[0] + [x,0,z])
                    rotate([0,0,0])
                        cube([w, cabinet_dim.y, h]);
            }
        }
        
        //Circular cutouts
        if(len(circular_cutouts)>0){
            for(c=circular_cutouts){
                x=c[0];
                z=c[1];
                d=c[2];
                translate(ic[0] + [x,0,z])
                    rotate([90,0,0])
                        cylinder(d=d,h=cabinet_dim.y);
            }
        } 
    }

}

module make_part(part_id, units, depth, brackets=[],standoffs=[],square_holes=[], circular_holes=[]){
	cabinet_dim = [CABINET_WIDTH,depth,u2mm(units)];
	//Part 0: Cabinet
	if(part_id==0){
		cabinet(cabinet_dim, brackets,standoffs);
	}
	//Part 1: Lid
	if(part_id==1){
		lid(cabinet_dim);
	}
	//Part 2: Front Panel
	if(part_id==2){
		front_panel(cabinet_dim,square_holes, circular_holes);
	}
	//Part 3: Rear Panel
	if(part_id==3){
		rear_panel(cabinet_dim,square_holes, circular_holes);
	}
	if(part_id != 0 && part_id != 1 && part_id != 2 && part_id != 3){
		echo("Unrecognized part id! Please select 0=Cabinet, 1=Lid, 2=Front Panel, 3=Rear Panel");
	}
}