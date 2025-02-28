include <../../lib/six-inch.scad>
include <../../external/hex-grid/hex-grid.scad>             //hexagon grid library
depth = 130; 
units = 2;
nano_pi_r5c_dim = [58,58,1];
nano_pi_screw_pos = [[52,36.5],[36.5,4]];

eth_adapter_dim=[26,68,16.3];
antenna_cutouts = [
			[25,u2mm(units)/2 -2,7],
			[CABINET_WIDTH-WALL_THICKNESS-25,u2mm(units)/2 - 2,7]
	          ];
rear_panel_square_cutouts = [
	
];
pos_off = [10,70,0];
screw_pos1 = [52,36.5,0] + pos_off;
screw_pos2 = [36.5,4,0] + pos_off;
//translate(pos_off+[0,0,6])cube(nano_pi_r5c_dim);
//standoffs = [[82.5-30.5,42.5-6,5,2,5],[67-30.5,10-6,5,2,5]];
standoffs = [[screw_pos1.x,screw_pos1.y,5,2,5],[screw_pos2.x,screw_pos2.y,5,2,5]];
rear_panel_type="tabs";
partNumber=7;
module make_part(part_id, units, depth){
    cabinet_dim = [CABINET_WIDTH, depth, u2mm(units)];
    brackets = [[CABINET_WIDTH-40,56.7+TOL,eth_adapter_dim,3,5,[false,true,false,true]]];
    if(part_id == 0){
        difference(){
            cabinet(cabinet_dim, brackets=brackets,standoffs=standoffs,rear_panel_type=rear_panel_type);
            translate([5+WALL_THICKNESS,5,0])
                linear_extrude(WALL_THICKNESS)
                    hex_grid_shell(10,1,16,16);
            translate([WALL_THICKNESS,5,8])
                rotate([0,270,0])
                    linear_extrude(WALL_THICKNESS)
                        hex_grid_shell(10,1,13,3);
            
            translate([CABINET_WIDTH,5,8])
                rotate([0,270,0])
                    linear_extrude(WALL_THICKNESS)
                        hex_grid_shell(10,1,13,3);
        }
    }
    if(part_id == 1){
        intersection(){
            union(){
                translate([5+WALL_THICKNESS,5,0])
                    linear_extrude(WALL_THICKNESS)
                        hex_grid_shell(10,1,16,16);
                translate([WALL_THICKNESS,5,8])
                    rotate([0,270,0])
                        linear_extrude(WALL_THICKNESS)
                            hex_grid_shell(10,1,13,3);
                
                translate([CABINET_WIDTH,5,8])
                    rotate([0,270,0])
                        linear_extrude(WALL_THICKNESS)
                            hex_grid_shell(10,1,13,3);
             }
                
        cabinet(cabinet_dim, brackets=brackets,standoffs=standoffs,rear_panel_type=rear_panel_type);
        }
    }
    if(part_id == 2){
        difference(){
            cabinet_lid(cabinet_dim,rear_panel_type=rear_panel_type);
            translate([5+WALL_THICKNESS,5,cabinet_dim.z-WALL_THICKNESS])
                linear_extrude(WALL_THICKNESS)
                    hex_grid_shell(10,1,16,16);
        }
    }
    if(part_id == 3){
        intersection(){
                cabinet_lid(cabinet_dim,rear_panel_type=rear_panel_type);
                translate([5+WALL_THICKNESS,5,cabinet_dim.z-WALL_THICKNESS])
                    linear_extrude(WALL_THICKNESS)
                        hex_grid_shell(10,1,16,16);
            }
    }      
    if(part_id == 4){
        difference(){
            rotate([270,0,0])cabinet_front_panel(cabinet_dim, circular_cutouts=antenna_cutouts);
            translate([-EXTRUSION_PROFILE_WIDTH+2.5,2.5,0])linear_extrude(cabinet_dim.z)
                    hex_grid_shell(10,1,3,23);
        }
    }
    if(part_id == 5){
        intersection(){
            rotate([270,0,0])cabinet_front_panel(cabinet_dim, circular_cutouts=antenna_cutouts);
            translate([-EXTRUSION_PROFILE_WIDTH+2.5,2.5,-10])
                    linear_extrude(cabinet_dim.z)
                        hex_grid_shell(10,1,3,23);
        }
    }
    if(part_id == 6){
        difference(){
            translate([-WALL_THICKNESS-TOL,cabinet_dim.z-WALL_THICKNESS-TOL,-cabinet_dim.y+WALL_THICKNESS+TOL])
                rotate([90,0,0])
                    cabinet_rear_panel(cabinet_dim, square_cutouts=rear_panel_square_cutouts,rear_panel_type=rear_panel_type);
                    translate([2.5,2.5,0])linear_extrude(cabinet_dim.z)hex_grid_shell(10,1,3,17);
            
        }
    }
    if(part_id == 7){
        intersection(){
            translate([-WALL_THICKNESS-TOL,cabinet_dim.z-WALL_THICKNESS-TOL,-cabinet_dim.y+WALL_THICKNESS+TOL])
                rotate([90,0,0])cabinet_rear_panel(cabinet_dim, square_cutouts=rear_panel_square_cutouts,rear_panel_type=rear_panel_type);
            translate([2.5,2.5,0])linear_extrude(cabinet_dim.z)hex_grid_shell(10,1,3,17);
        }
    }
    if(part_id == 8){
        cabinet(cabinet_dim,brackets=brackets,standoffs=standoffs);
        cabinet_lid(cabinet_dim);
        cabinet_front_panel(cabinet_dim, square_cutouts=front_square_cutouts);
        //cabinet_rear_panel(cabinet_dim,square_cutouts=rear_square_cutouts, circular_cutouts=rear_round_cutouts);
    }
}
make_part(partNumber, units, depth);
