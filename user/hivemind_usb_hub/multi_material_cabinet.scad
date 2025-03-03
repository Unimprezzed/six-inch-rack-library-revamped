include <../../lib/six-inch.scad>
include <../../external/hex-grid/hex-grid.scad>             //hexagon grid library
depth = 90; 
units = 3;
usb_hub_dim = [94,68.6,22.86];

rear_panel_circular_cutouts=[

];
rear_panel_square_cutouts = [
	
];
front_panel_square_cutouts=[

];
front_panel_circular_cutouts=[

];


rear_panel_type="tabs";
partNumber=3;
module make_part(part_id, units, depth){
    cabinet_dim = [CABINET_WIDTH, depth, u2mm(units)];
    brackets = [[8.5,16.2,usb_hub_dim,3,5,[false,true,false,true]]];
    if(part_id == 0){
        difference(){
            cabinet(cabinet_dim, brackets=brackets,rear_panel_type=rear_panel_type);
            translate([5+WALL_THICKNESS,5,0])
                linear_extrude(WALL_THICKNESS)
                    hex_grid_shell(10,1,11,16);
            translate([WALL_THICKNESS,5,8])
                rotate([0,270,0])
                    linear_extrude(WALL_THICKNESS)
                        hex_grid_shell(10,1,11,3);
            
            translate([CABINET_WIDTH,5,8])
                rotate([0,270,0])
                    linear_extrude(WALL_THICKNESS)
                        hex_grid_shell(10,1,11,3);
        }
    }
    if(part_id == 1){
        intersection(){
            union(){
                translate([5+WALL_THICKNESS,5,0])
                    linear_extrude(WALL_THICKNESS)
                        hex_grid_shell(10,1,11,16);
                translate([WALL_THICKNESS,5,8])
                    rotate([0,270,0])
                        linear_extrude(WALL_THICKNESS)
                            hex_grid_shell(10,1,11,3);
                
                translate([CABINET_WIDTH,5,8])
                    rotate([0,270,0])
                        linear_extrude(WALL_THICKNESS)
                            hex_grid_shell(10,1,11,3);
             }
                
        cabinet(cabinet_dim, brackets=brackets,rear_panel_type=rear_panel_type);
        }
    }
    if(part_id == 2){
        difference(){
            cabinet_lid(cabinet_dim,rear_panel_type=rear_panel_type);
            translate([5+WALL_THICKNESS,5,cabinet_dim.z-WALL_THICKNESS])
                linear_extrude(WALL_THICKNESS)
                    hex_grid_shell(10,1,11,16);
        }
    }
    if(part_id == 3){
        intersection(){
                cabinet_lid(cabinet_dim,rear_panel_type=rear_panel_type);
                translate([5+WALL_THICKNESS,5,cabinet_dim.z-WALL_THICKNESS])
                    linear_extrude(WALL_THICKNESS)
                        hex_grid_shell(10,1,11,16);
            }
    }      
    if(part_id == 4){
        difference(){
            rotate([270,0,0])cabinet_front_panel(cabinet_dim,square_cutouts=front_panel_square_cutouts,circular_cutouts=front_panel_circular_cutouts);
            translate([-EXTRUSION_PROFILE_WIDTH+2.5,2.5,0])linear_extrude(cabinet_dim.z)
                    hex_grid_shell(10,1,6,23);
        }
    }
    if(part_id == 5){
        intersection(){
            rotate([270,0,0])cabinet_front_panel(cabinet_dim,square_cutouts=front_panel_square_cutouts,circular_cutouts=front_panel_circular_cutouts);
            translate([-EXTRUSION_PROFILE_WIDTH+2.5,2.5,-10])
                    linear_extrude(cabinet_dim.z)
                        hex_grid_shell(10,1,6,23);
        }
    }
    if(part_id == 6){
        difference(){
            translate([-WALL_THICKNESS-TOL,cabinet_dim.z-WALL_THICKNESS-TOL,-cabinet_dim.y+WALL_THICKNESS+TOL])
                rotate([90,0,0])
                    cabinet_rear_panel(cabinet_dim, square_cutouts=rear_panel_square_cutouts,circular_cutouts=rear_panel_circular_cutouts,rear_panel_type=rear_panel_type);
                    translate([2.5,2.5,0])linear_extrude(cabinet_dim.z)hex_grid_shell(10,1,5,17);
            
        }
    }
    if(part_id == 7){
        intersection(){
            translate([-WALL_THICKNESS-TOL,cabinet_dim.z-WALL_THICKNESS-TOL,-cabinet_dim.y+WALL_THICKNESS+TOL])
                rotate([90,0,0])cabinet_rear_panel(cabinet_dim, square_cutouts=rear_panel_square_cutouts,circular_cutouts=rear_panel_circular_cutouts,rear_panel_type=rear_panel_type);
            translate([2.5,2.5,0])linear_extrude(cabinet_dim.z)hex_grid_shell(10,1,5,17);
        }
    }
    if(part_id == 8){
        cabinet(cabinet_dim,brackets=brackets);
        cabinet_lid(cabinet_dim);
        cabinet_front_panel(cabinet_dim);
        cabinet_rear_panel(cabinet_dim,square_cutouts=rear_panel_square_cutouts);
    }
}
make_part(partNumber, units, depth);
