include <../../lib/six-inch.scad>

//Taken from the mechancial drawings for the Raspberry Pi 4, located here: (https://datasheets.raspberrypi.com/rpi4/raspberry-pi-4-mechanical-drawing.pdf) 
board_dimensions = [85, 56];            //85 mm on X, 56mm on Y
board_screw_mounting_holes = [58, 49];  //
usb_port_1_dist_x = 9;                  //
usb_port_2_dist_x = 27;                 //
usb_port_1_x = 15;                      //
usb_port_2_x = 15;                      //

ethernet_port_dist_x = 45.75;           //
ethernet_port_x = 17;
units = 2; 
depth = 110;
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
partNumber = 0;
standoffs = [
    [s_x1, s_y1, 6, 2.2, 3, true],
    [s_x2, s_y2, 6, 2.2, 3, true],
    [s_x3, s_y3, 6, 2.2, 3, true],
    [s_x4, s_y4, 6, 2.2, 3, true]
];
rear_cutouts = [[19,7,16,14],[39,7,13.25,15.4],[57,7,13.25,15.4]];

module make_part(part_id, units, depth, brackets=[],standoffs=[],square_holes=[], circular_holes=[]){
    cabinet_dim = [CABINET_WIDTH, depth, u2mm(units)];
    if(part_id == 0){cabinet(cabinet_dim, brackets,standoffs);}
    if(part_id == 1){lid(cabinet_dim);}   
    if(part_id == 2){front_panel(cabinet_dim);}
    if(part_id == 3){rear_panel(cabinet_dim,rear_cutouts);}
    if(part_id == 4){
        cabinet(cabinet_dim, brackets,standoffs);
        lid(cabinet_dim);
        front_panel(cabinet_dim);
        rear_panel(cabinet_dim,rear_cutouts);
    }
}

make_part(partNumber, units, depth, standoffs=standoffs, square_holes=rear_cutouts);