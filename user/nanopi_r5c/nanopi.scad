include <../../base/constants.scad>    //Constants
include <../../base/common.scad>       //Common parts
include <../../cabinet/lib.scad>       //Cabinet library

depth = 90; 
units = 2;
rear_square_cutouts = [[29, 6, 60, u2mm(units)-6]];
rear_round_cutouts = [[18,u2mm(units)/2,7],[CABINET_WIDTH-18, u2mm(units)/2,7]];
front_square_cutouts = [[66, 6, 17, 12]];
standoffs = [[82.5, 42.5,5,2, 5],[67,10, 5,2,5]];
partNumber=0;
module make_part(part_id, units, depth){
    cabinet_dim = [CABINET_WIDTH, depth, u2mm(units)];
    if(part_id == 0){cabinet(cabinet_dim, standoffs=standoffs);}
    if(part_id == 1){lid(cabinet_dim);}   
    if(part_id == 2){front_panel(cabinet_dim, square_cutouts=front_square_cutouts);}
    if(part_id == 3){rear_panel(cabinet_dim,square_cutouts=rear_square_cutouts, circular_cutouts=rear_round_cutouts);}
    if(part_id == 4){
        cabinet(cabinet_dim, standoffs=standoffs);
        lid(cabinet_dim);
        front_panel(cabinet_dim, square_cutouts=front_square_cutouts);
        rear_panel(cabinet_dim,square_cutouts=rear_square_cutouts, circular_cutouts=rear_round_cutouts);
    }
}
make_part(partNumber, units, depth);