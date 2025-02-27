include <../../base/constants.scad>    //Constants
include <../../base/common.scad>       //Common parts
include <../../cabinet/lib.scad>       //Cabinet library
include <../../external/hex-grid/hex-grid.scad>             //hexagon grid library
 
partNumber = 0;
cabinet_depth = 140;
units = 3;
space_between_drives = 2;
cabinet_dim = [CABINET_WIDTH, cabinet_depth, u2mm(units)];
drive_dim = [70,100,7];
base_drive_pos = [(CABINET_WIDTH/2) - drive_dim.x/2, 10, WALL_THICKNESS+space_between_drives];


bracket_dim = [3,110,37];
drive_pos =[
    for(i=[0:3]) base_drive_pos + i*[0,0,drive_dim.z + space_between_drives]
];
mounting_hole_pos=[
            drive_pos[0] + [-5,14,3],       //0
            drive_pos[0] + [-5,90.6,3],     //1
            drive_pos[1] + [-5,14,3],       //2
            drive_pos[1] + [-5,90.6,3],     //3
            drive_pos[2] + [-5,14,3],       //4
            drive_pos[2] + [-5,90.6,3],     //5
            drive_pos[3] + [-5,14,3],       //6
            drive_pos[3] + [-5,90.6,3],     //7
        ];
module drive_bay(){
    /*
    //For debug purposes
    color([0.5,0.5,0.5,0.5]){
        for(p=drive_pos){
            translate(p)cube(drive_dim);
        }
    }*/
    difference(){
        union(){
            //First bracket
            translate([(CABINET_WIDTH-drive_dim.x-6)/2 , 8, WALL_THICKNESS]){
                difference(){
                    cube(bracket_dim);
                    hull(){
                        translate([-0.01,0,5])rotate([90,0,90])cylinder(d=10,h=5);
                        translate([-0.01,0,40])rotate([90,0,90])cylinder(d=10,h=5);
                    }
                    hull(){
                        translate([-0.01,110,5])rotate([90,0,90])cylinder(d=10,h=5);
                        translate([-0.01,110,40])rotate([90,0,90])cylinder(d=10,h=5);
                    }
                }
            }
            //Second bracket
            translate([(CABINET_WIDTH + drive_dim.x)/2 , 8, WALL_THICKNESS]){
                difference(){
                    cube(bracket_dim);
                    hull(){
                        translate([-0.01,0,5])rotate([90,0,90])cylinder(d=10,h=5);
                        translate([-0.01,0,u2mm(3)])rotate([90,0,90])cylinder(d=10,h=5);
                    }
                    hull(){
                        translate([-0.01,110,5])rotate([90,0,90])cylinder(d=10,h=5);
                        translate([-0.01,110,u2mm(3)])rotate([90,0,90])cylinder(d=10,h=5);
                    }
                }
            }
        }
        
        for(p=mounting_hole_pos){
        	translate(p)rotate([0,90,0])cylinder(d=M3_SCREW_THREAD+TOL,h=100);
    	}
    }
}
module modded_cabinet(cabinet_dim){
    difference(){
        union(){
            difference(){
                cabinet(cabinet_dim);
                hull(){
                    translate([-5,24,mounting_hole_pos[0].z])rotate([0,90,0])cylinder(r=5,h=200);
                    translate([-5,24,mounting_hole_pos[6].z])rotate([0,90,0])cylinder(r=5,h=200);
                }
                
                hull(){
                    translate([-5,100.6,mounting_hole_pos[1].z])rotate([0,90,0])cylinder(r=5,h=200);
                    translate([-5,100.6,mounting_hole_pos[7].z])rotate([0,90,0])cylinder(r=5,h=200);
                }
            }
            drive_bay();
        }
    }
}
module make_mm_part(part_id, units, depth, brackets=[],standoffs=[],square_holes=[], circular_holes=[]){
    cabinet_dim = [CABINET_WIDTH, depth, u2mm(units)];
    //Base cabinet
    if(part_id == 0){
        difference(){
            modded_cabinet(cabinet_dim);
            translate([5+WALL_THICKNESS,5,0])
                linear_extrude(WALL_THICKNESS)
                    hex_grid_shell(10,1,17,16);
            translate([WALL_THICKNESS,5,10])
                rotate([0,270,0])
                    linear_extrude(WALL_THICKNESS)
                        hex_grid_shell(10,1,17,5);
            
            translate([CABINET_WIDTH,5,10])
                rotate([0,270,0])
                    linear_extrude(WALL_THICKNESS)
                        hex_grid_shell(10,1,17,5);
       
       }
    }
    //Cabinet cutout 1
    if(part_id == 1){
        intersection(){
        union(){
            translate([5+WALL_THICKNESS,5,0])
                    linear_extrude(WALL_THICKNESS)
                        hex_grid_shell(10,1,17,16);
                translate([WALL_THICKNESS,5,10])
                    rotate([0,270,0])
                        linear_extrude(WALL_THICKNESS)
                            hex_grid_shell(10,1,17,5);
                
                translate([CABINET_WIDTH,5,10])
                    rotate([0,270,0])
                        linear_extrude(WALL_THICKNESS)
                            hex_grid_shell(10,1,17,5);
            }
        modded_cabinet(cabinet_dim);
        }
    }   
    //Base lid
    if(part_id == 2){
        difference(){
            lid(cabinet_dim);
            translate([5+WALL_THICKNESS,5,cabinet_dim.z-WALL_THICKNESS])
                linear_extrude(WALL_THICKNESS)
                    hex_grid_shell(10,1,13,16);
        }
    }
    //Lid cutout 1
    if(part_id == 3){
        intersection(){
            lid(cabinet_dim);
            translate([5+WALL_THICKNESS,5,cabinet_dim.z-WALL_THICKNESS])
                linear_extrude(WALL_THICKNESS)
                    hex_grid_shell(10,1,13,16);
        }
    }
    //Base front panel 
    if(part_id == 4){
        difference(){
            rotate([270,0,0])front_panel(cabinet_dim);
                translate([-EXTRUSION_PROFILE_WIDTH+2.5,2.5,0])linear_extrude(cabinet_dim.z)
                    hex_grid_shell(10,1,6,23);
        }
    }    
    //Front panel cutout 1 
    if(part_id == 5){
    intersection(){
	rotate([270,0,0])front_panel(cabinet_dim);
        translate([-EXTRUSION_PROFILE_WIDTH+2.5,2.5,-10])
		linear_extrude(cabinet_dim.z)
			hex_grid_shell(10,1,6,23);
        }
    }    
    //Base rear panel
    if(part_id == 6){
        difference(){
        translate([-WALL_THICKNESS-TOL,cabinet_dim.z-WALL_THICKNESS-TOL,-cabinet_dim.y+WALL_THICKNESS+TOL])
            rotate([90,0,0])
                rear_panel(cabinet_dim,square_holes,circular_holes);
        translate([2.5,2.5,0])linear_extrude(cabinet_dim.z)hex_grid_shell(10,1,6,17);
        }
    }    
    //Rear panel cutout 1
    if(part_id == 7){
                intersection(){
        translate([-WALL_THICKNESS-TOL,cabinet_dim.z-WALL_THICKNESS-TOL,-cabinet_dim.y+WALL_THICKNESS+TOL])
            rotate([90,0,0])
                rear_panel(cabinet_dim,square_holes, circular_holes);
        translate([2.5,2.5,0])linear_extrude(cabinet_dim.z)hex_grid_shell(10,1,6,17);
        }
    }    
}
square_holes = [];
circular_holes=[];
make_mm_part(partNumber,units,cabinet_depth,square_holes=square_holes,circular_holes);
