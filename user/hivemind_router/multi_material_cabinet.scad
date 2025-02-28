include <../../lib/six-inch.scad>

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
//Format: [x,y,points=[],paths=[]]
rear_panel_polygon_cutouts = [
	
];
pos_off = [10,70,0];
screw_pos1 = [52,36.5,0] + pos_off;
screw_pos2 = [36.5,4,0] + pos_off;
//translate(pos_off+[0,0,6])cube(nano_pi_r5c_dim);
//standoffs = [[82.5-30.5,42.5-6,5,2,5],[67-30.5,10-6,5,2,5]];
standoffs = [[screw_pos1.x,screw_pos1.y,5,2,5],[screw_pos2.x,screw_pos2.y,5,2,5]];

partNumber=0;
module make_part(part_id, units, depth){
    cabinet_dim = [CABINET_WIDTH, depth, u2mm(units)];
    brackets = [[CABINET_WIDTH-40,56.7+TOL,eth_adapter_dim,3,5,[false,true,false,true]]];
    if(part_id == 0){cabinet(cabinet_dim, brackets=brackets,standoffs=standoffs,toggle_rear_bottom_screwtraps=false);}
    if(part_id == 1){lid(cabinet_dim);}   
    if(part_id == 2){front_panel(cabinet_dim, circular_cutouts=antenna_cutouts);}
    //if(part_id == 3){rear_panel(cabinet_dim,square_cutouts=rear_square_cutouts, circular_cutouts=rear_round_cutouts);}
    if(part_id == 4){
        cabinet(cabinet_dim,brackets=brackets,standoffs=standoffs);
        lid(cabinet_dim);
        front_panel(cabinet_dim, square_cutouts=front_square_cutouts);
        //rear_panel(cabinet_dim,square_cutouts=rear_square_cutouts, circular_cutouts=rear_round_cutouts);
    }
}
make_part(partNumber, units, depth);
