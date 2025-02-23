/*
    This is an example of how to use this library. 
    Specifically, it is my customized version of the enclosure for my cluster's router / gateway: a NanoPi R5C. It has a cutout on the front panel for a small USB flash drive to be used for storage. 
    
    Feel free to customize this file as you like. Just don't expect me to help fix what you broke. :-)
*/
include <../sixinch_lib.scad>
//Variable to explode the model. If not exploded, every part is generated in the place where it should fit. If true, it explodes it by another variable: explode_distance 
explode = false; 
explode_distance = 40; //20mm by default

build_cabinet = false; 
build_lid = false; 
build_rear_panel = false; 
build_front_panel = false; 

depth = 90; 
units = 2;
if(build_cabinet){
    color(c=[1.0, 0.0, 0.0, 1]){
        standoffs = [
            [82.5, 42.5,5,2, 5],
            [67,10, 5,2,5]
        ];
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
      square_holes = [
      //I want to make this quick and dirty, so for now, just one big square cutout. 
      [29, 6, 60, U*units-6]
      ];
      round_holes = [
      //Antenna mounts
      [18,U*units/2,7],
      [CABINET_WIDTH-18, U*units/2,7]
      ];
      translate([0,explode ? base_y + explode_distance : base_y,0])make_rear_panel(units,square_holes,round_holes);
    }
}
if(build_front_panel){
    color(c=[0.5, 0, 0.5, 1]){
        base_y = -panel_thickness;
        square_holes = [[66, 6, 17, 12]];
        translate([-EXTRUSION_PROFILE_WIDTH,explode ? base_y - explode_distance : base_y,0])make_front_panel(units,square_holes,[]);
    }
}