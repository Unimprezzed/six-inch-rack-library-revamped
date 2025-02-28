include <../../lib/six-inch.scad>
include <../../external/hex-grid/hex-grid.scad>             //hexagon grid library


//Taken from the mechancial drawings for the Raspberry Pi 4, located here: (https://datasheets.raspberrypi.com/rpi4/raspberry-pi-4-mechanical-drawing.pdf) 
board_dimensions = [85, 56];            //85 mm on X, 56mm on Y
board_screw_mounting_holes = [58, 49];  //
usb_port_1_dist_x = 9*1;                  //
usb_port_2_dist_x = 27*1;                 //
usb_port_1_x = 15*1;                      //
usb_port_2_x = 15*1;                      //

ethernet_port_dist_x = 45.75*1;           //
ethernet_port_x = 17*1;
units = 3*1; 
depth = 110*1;
rpi_x = 27.5*1;
rpi_y = 24*1; 
s_x1 = rpi_x; 
s_y1 = rpi_y;
s_x2 = rpi_x;
s_y2 = rpi_y + 58;
s_x3 = rpi_x + 49;
s_y3 = rpi_y; 
s_x4 = rpi_x + 49;
s_y4 = rpi_y + 58;
OLED_window_w = 41*1; 
OLED_window_h = 12*1;
OLED_screen_w = 32.5*1; 
OLED_screen_h = 12*1; 
partNumber = 0;
standoffs = [
    [s_x1, s_y1, 6, 2.2, 3, true],
    [s_x2, s_y2, 6, 2.2, 3, true],
    [s_x3, s_y3, 6, 2.2, 3, true],
    [s_x4, s_y4, 6, 2.2, 3, true]
];

module make_mm_part(part_id, units, depth, brackets=[],standoffs=[],square_holes=[], circular_holes=[]){
    cabinet_dim = [CABINET_WIDTH, depth, u2mm(units)];
    //Base cabinet
    if(part_id == 0){
        difference(){
            cabinet(cabinet_dim, brackets,standoffs);
            translate([5+WALL_THICKNESS,5,0])
                linear_extrude(WALL_THICKNESS)
                    hex_grid_shell(10,1,13,16);
            translate([WALL_THICKNESS,5,10])
                rotate([0,270,0])
                    linear_extrude(WALL_THICKNESS)
                        hex_grid_shell(10,1,13,5);
            
            translate([CABINET_WIDTH,5,10])
                rotate([0,270,0])
                    linear_extrude(WALL_THICKNESS)
                        hex_grid_shell(10,1,13,5);
       }
    }
    //Cabinet cutout 1
    if(part_id == 1){
        intersection(){
        union(){
        translate([5+WALL_THICKNESS,5,0])
            linear_extrude(WALL_THICKNESS)
                hex_grid_shell(10,1,13,16);
        translate([WALL_THICKNESS,5,10])
            rotate([0,270,0])
                linear_extrude(WALL_THICKNESS)
                    hex_grid_shell(10,1,13,5);
        translate([CABINET_WIDTH,5,10])
            rotate([0,270,0])
                linear_extrude(WALL_THICKNESS)
                    hex_grid_shell(10,1,13,5);
        }
        cabinet(cabinet_dim, brackets,standoffs);
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
            rotate([270,0,0])front_panel(cabinet_dim,square_holes, circular_holes);
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
            rotate([270,0,0])front_panel(cabinet_dim,square_holes, circular_holes);
                
                    
                    
         translate([(CABINET_WIDTH)/2-37,(U*units-20)/2,2]){
                minkowski(){
                    cube([75, 10, 1]);
                    sphere(1);
                }
            }
            translate([-4+CABINET_WIDTH/2,23,0])cube([OLED_window_w, OLED_window_h,1]);
            translate([CABINET_WIDTH/2,23,1])cube([OLED_screen_w, OLED_screen_h,2]);
            
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
                rear_panel(cabinet_dim,square_holes, circular_holes);
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
square_holes = [[rpi_x+1,7,16,14],[rpi_x+21,7,13.25,15.4],[rpi_x+39,7,13.25,15.4]];
make_mm_part(partNumber,3,110,standoffs=standoffs,square_holes=square_holes);
