include <../../lib/six-inch.scad>
include <../../external/hex-grid/hex-grid.scad>             //hexagon grid library


switch_dimensions = [101,101,25.4];
brackets=[[4.7,47.8,switch_dimensions,2,10,[false,true,true,true]]];
square_holes=[];
circular_holes=[];
units = 3*1; 
depth = SIX_INCH*1;
partNumber = 1;

module make_mm_part(part_id, units, depth, brackets=[],square_holes=[], circular_holes=[]){
    cabinet_dim = [CABINET_WIDTH, depth, u2mm(units)];
    //Base cabinet
    if(part_id == 0){
        difference(){
            cabinet(cabinet_dim, brackets,rear_panel_type="tabs");
            translate([5+WALL_THICKNESS,5,0])
                linear_extrude(WALL_THICKNESS)
                    hex_grid_shell(10,1,20,16);
            translate([WALL_THICKNESS,5,10])
                rotate([0,270,0])
                    linear_extrude(WALL_THICKNESS)
                        hex_grid_shell(10,1,20,5);
            
            translate([CABINET_WIDTH,5,10])
                rotate([0,270,0])
                    linear_extrude(WALL_THICKNESS)
                        hex_grid_shell(10,1,20,5);
       }
    }
    //Cabinet cutout 1
    if(part_id == 1){
        intersection(){
        union(){
        translate([5+WALL_THICKNESS,5,0])
            linear_extrude(WALL_THICKNESS)
                hex_grid_shell(10,1,21,16);
        translate([WALL_THICKNESS,5,10])
            rotate([0,270,0])
                linear_extrude(WALL_THICKNESS)
                    hex_grid_shell(10,1,20,5);
        translate([CABINET_WIDTH,5,10])
            rotate([0,270,0])
                linear_extrude(WALL_THICKNESS)
                    hex_grid_shell(10,1,20,5);
        }
        cabinet(cabinet_dim, brackets,rear_panel_type="tabs");
        }
    }   
    //Base lid
    if(part_id == 2){
        difference(){
            cabinet_lid(cabinet_dim,rear_panel_type="tabs");
            translate([5+WALL_THICKNESS,5,cabinet_dim.z-WALL_THICKNESS])
                linear_extrude(WALL_THICKNESS)
                    hex_grid_shell(10,1,20,16);
        }
    }
    //Lid cutout 1
    if(part_id == 3){
        intersection(){
            cabinet_lid(cabinet_dim,rear_panel_type="tabs");
            translate([5+WALL_THICKNESS,5,cabinet_dim.z-WALL_THICKNESS])
                linear_extrude(WALL_THICKNESS)
                    hex_grid_shell(10,1,20,16);
        }
    }
    //Base front panel 
    if(part_id == 4){
        difference(){
            rotate([270,0,0])cabinet_front_panel(cabinet_dim);
                translate([-EXTRUSION_PROFILE_WIDTH+2.5,2.5,0])linear_extrude(cabinet_dim.z)
                    hex_grid_shell(10,1,6,23);
                    
                    
         translate([(CABINET_WIDTH)/2-37,(U*units-20)/2,2]){
                minkowski(){
                    cube([75, 10, 1]);
                    sphere(1);
                }
            }
            translate([-4+CABINET_WIDTH/2,23,0])cube([OLED_window_w, OLED_window_h,1]);
            translate([CABINET_WIDTH/2,23,1])cube([OLED_screen_w, OLED_screen_h,2]);
            
        }
    }    
    //Front panel cutout 1 
    if(part_id == 5){
    intersection(){
        difference(){
            rotate([270,0,0])cabinet_front_panel(cabinet_dim);
         translate([(CABINET_WIDTH)/2-37,(U*units-20)/2,2]){
                minkowski(){
                    cube([75, 10, 1]);
                    sphere(1);
                }
            }
        }
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
                cabinet_rear_panel(cabinet_dim,square_holes, circular_holes,rear_panel_type="tabs");
        translate([2.5,2.5,0])linear_extrude(cabinet_dim.z)hex_grid_shell(10,1,6,17);
        }
    }    
    //Rear panel cutout 1
    if(part_id == 7){
                intersection(){
        translate([-WALL_THICKNESS-TOL,cabinet_dim.z-WALL_THICKNESS-TOL,-cabinet_dim.y+WALL_THICKNESS+TOL])
            rotate([90,0,0])
                cabinet_rear_panel(cabinet_dim,square_holes, circular_holes,rear_panel_type="tabs");
        translate([2.5,2.5,0])linear_extrude(cabinet_dim.z)hex_grid_shell(10,1,6,17);
        }
    }    
}
make_mm_part(partNumber,units,depth,brackets=brackets,square_holes=square_holes,circular_holes=circular_holes);
