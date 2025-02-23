include <../base/constants.scad>
include <../base/common.scad>

module front_panel(units, square_cutouts=[], round_cutouts=[], rounded_cutouts=[], brackets=[], standoffs=[]){
	panel_dim = [CABINET_WIDTH-2*(WALL_THICKNESS+TOL),WALL_THICKNESS,U*units];

}

module rear_panel(units, square_cutouts=[], round_cutouts=[], rounded_cutouts=[], brackets=[], standoffs=[]){
	panel_dim=[CABINET_WIDTH-2*(WALL_THICKNESS+TOL),WALL_THICKNESS,U*units];
}

module bottom_panel(depth, brackets=[], standoffs=[]){
	panel_dim=[CABINET_WIDTH-2*(WALL_THICKNESS+TOL), depth, WALL_THICKNESS];
}

module top_panel(depth, brackets=[], standoffs=[]){
	panel_dim=[CABINET_WIDTH-2*(WALL_THICKNESS+TOL), depth, WALL_THICKNESS];
}

module left_panel(units, depth, square_cutouts=[], round_cutouts=[], rounded_cutouts=[], brackets=[], standoffs=[], shelves=[]){
	panel_dim=[WALL_THICKNESS,depth,U*units];
}

module right_panel(units, depth, square_cutouts=[], round_cutouts=[], rounded_cutouts=[], brackets=[], standoffs=[], shelves=[]){
	panel_dim=[WALL_THICKNESS,depth,U*units];

}

module shelf(depth, brackets=[], standoffs=[]){
	shelf_dim=[CABINET_WIDTH-2*(WALL_THICKNESS+TOL), depth-2*(WALL_THICKNESS+TOL), WALL_THICKNESS];

}

