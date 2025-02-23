//This is my customized build for the Raspberry Pi 4s I used in my cluster. 

include <../sixinch_lib.scad>
//Variable to explode the model. If not exploded, every part is generated in the place where it should fit. If true, it explodes it by another variable: explode_distance 
explode = false; 
explode_distance = 40; //20mm by default

//Taken from the mechancial drawings for the Raspberry Pi 4, located here: (https://datasheets.raspberrypi.com/rpi4/raspberry-pi-4-mechanical-drawing.pdf) 
board_dimensions = [85, 56];            //85 mm on X, 56mm on Y
board_screw_mounting_holes = [58, 49];  //
usb_port_1_dist_x = 9;                  //
usb_port_2_dist_x = 27;                 //
usb_port_1_x = 15;                      //
usb_port_2_x = 15;                      //

ethernet_port_dist_x = 45.75;           //
ethernet_port_x = 17;

build_cabinet = true; 
build_lid = false; 
build_rear_panel = false; 
build_front_panel = false; 

units = 3; 
depth = 110;

if(build_cabinet){
    rpi_x = 18;
    rpi_y = 24; 
    s_x1 = rpi_x; 
    s_y1 = rpi_y;
    s_x2 = rpi_x;
    s_y2 = rpi_y + 58;
    s_x3 = rpi_x + 49;
    s_y3 = rpi_y; 
    s_x4 = rpi_x + 49;
    s_y4 = rpi_y + 58;
    color(c=[1.0, 0.0, 0.0, 1]){
        standoffs = [
        [s_x1, s_y1, 6, 2.2, 3, true],
        [s_x2, s_y2, 6, 2.2, 3, true],
        [s_x3, s_y3, 6, 2.2, 3, true],
        [s_x4, s_y4, 6, 2.2, 3, true]];
        
        make_cabinet(depth, units,standoffs,[]);
    }
}
if(build_lid){
    color(c=[0.0, 1.0, 0.0, 1]){
      base_z = U*units-wall_thickness;
      translate([0,0,explode ? base_z + explode_distance : base_z])make_lid(depth);
    }
}
if(build_rear_panel){
    color(c=[0.0, 0.0, 1.0, 1]){
      base_y = depth;
      square_holes = [[19,7,16,14],[39,7,13.25,15.4],[57,7,13.25,15.4]];
      round_holes = [];
      translate([0,explode ? base_y + explode_distance : base_y,0])make_rear_panel(units,square_holes,round_holes);
    }
}
if(build_front_panel){
    OLED_window_w = 41; 
    OLED_window_h = 12;
    OLED_screen_w = 32.5; 
    OLED_screen_h = 12; 
    color(c=[0.5, 0, 0.5, 1]){
        base_y = -panel_thickness;
        square_holes = [];
        translate([-EXTRUSION_PROFILE_WIDTH,explode ? base_y - explode_distance : base_y,0]){
            difference(){
                make_front_panel(units,square_holes,[]);
                translate([(CABINET_WIDTH)/2 -17,0,(U*units-30)/2]){
                minkowski(){
                    cube([75, 1, 15]);
                    sphere(1);
                }
            }
            translate([19 + CABINET_WIDTH/2,1,23])cube([OLED_window_w, 2, OLED_window_h]);
            translate([23 + CABINET_WIDTH/2,0,23])cube([OLED_screen_w, 3, OLED_screen_h]);
            }
        }
    }
}