include <../base/constants.scad>
include <../base/common.scad>
use <../../external/hex-grid/hex-grid.scad>
use <../../external/bolts/BOLTS.scad>

//Nutless trap
module nutless_trap(length){
    difference(){
        union(){
            translate([-2.4,0,4]){
                cube([4.8,length,1.5]);
            }    
            translate([-2.4,length,0]){
                rotate([90,0,0]){
                    linear_extrude(length){
                        polygon(points=[[0,0],[4.8,0],[7,4],[-2.2,4]]);
                    }
                }
            }
        }                        
        for(i=[1:mm2u(length)]){
            translate([0,U*i-U/2,-1]){
                cylinder(d=M4_SCREW_THREAD,h=10);
            }                       
        }
    }
}
/*
 For the top and bottom of the rack
 I've also had success attaching these to the sides of a rack to add more stability for a taller rack or keep curious hands away from important cables. 
 Type parameter determines what pattern is used for the cutouts (if any): 
 0: Closed, no feet
 1: Closed, square frustrum feet
 2: Closed, hexagonal frustrum feet
 3: Open, no feet
 4: Open, square frustrum feet
 5: Open, hexagonal frustrum feet
 6: Grid, no feet
 7: Grid, square frustrum feet
 8: Grid, hexagonal frustrum feet
 9: Hex grid, no feet
 10: Hex grid, square frustrum feet
 11: Hex grid, hexagonal frustrum feet
 12: Vents, no feet
 13: Vents, square frustrum feet
 14: Vents, hexagonal frustrum feet
*/
module rack_panel(type){

    union(){
        //Subtractive elements first
        difference(){
            translate([1.25,1.25,1.25])
                minkowski(){
                    w = PANEL_WIDTH - 2.5;
                    cube([w,w,PANEL_THICKNESS-2.5]);
                    sphere(r=1.25);
                }
            //The screw holes 
            translate([10,10,-0.1]){cylinder(d=5,h=10); cylinder(d1=10,d2=6,h=3.5);}
            translate([PANEL_WIDTH-10,10,-0.1]){ cylinder(d=5,h=10); cylinder(d1=10,d2=6,h=3.5);}
            translate([10,PANEL_WIDTH-10,-0.1]){ cylinder(d=5,h=10); cylinder(d1=10,d2=6,h=3.5);}
            translate([PANEL_WIDTH-10,PANEL_WIDTH-10,-0.1]){ cylinder(d=5,h=10); cylinder(d1=10,d2=6,h=3.5);}  
            if(type>=3 && type<=11){
                translate([20,20,-1])cube([PANEL_WIDTH-40,PANEL_WIDTH-40,PANEL_THICKNESS+2]);
                
            }
            if(type>=12 && type<=14){
                rack_vents(PANEL_WIDTH);
            } 
        }
        //Additive elements next
        //Start with the vent style (if grid or hex has been selected)
        if(type>=6 && type <=8){
            grid();
        }
        if(type>=9 && type<=11){
            translate([24,24,0])linear_extrude(PANEL_THICKNESS)hex_grid_shell(10,2,17,20);
        }
        if(type % 3 ==1){
            foot_profile = [[-2.5,-2.5],[2.5,-2.5],[2.5,2.5],[-2.5,2.5]];
            foot_positions = [[20,10,-PANEL_THICKNESS],
                              [PANEL_WIDTH/2,10,-PANEL_THICKNESS],
                              [PANEL_WIDTH-20,10,-PANEL_THICKNESS],
                              [10,20,-PANEL_THICKNESS],
                              [10,PANEL_WIDTH/2,-PANEL_THICKNESS],
                              [10,PANEL_WIDTH-20,-PANEL_THICKNESS],
                              [20,PANEL_WIDTH-10,-PANEL_THICKNESS],
                              [PANEL_WIDTH/2,PANEL_WIDTH-10,-PANEL_THICKNESS],
                              [PANEL_WIDTH-20,PANEL_WIDTH-10,-PANEL_THICKNESS],
                              [PANEL_WIDTH-10,20,-PANEL_THICKNESS],
                              [PANEL_WIDTH-10,PANEL_WIDTH/2,-PANEL_THICKNESS],
                              [PANEL_WIDTH-10,PANEL_WIDTH-20,-PANEL_THICKNESS],
                              ];
            for(f=foot_positions)translate(f)linear_extrude(PANEL_THICKNESS, scale=1.5)polygon(foot_profile);
        }
        if(type % 3 == 2){
            foot_profile = circle(5,$fn=6);
            foot_positions = [[20,10,-PANEL_THICKNESS],
                              [PANEL_WIDTH/2,10,-PANEL_THICKNESS],
                              [PANEL_WIDTH-20,10,-PANEL_THICKNESS],
                              [10,20,-PANEL_THICKNESS],
                              [10,PANEL_WIDTH/2,-PANEL_THICKNESS],
                              [10,PANEL_WIDTH-20,-PANEL_THICKNESS],
                              [20,PANEL_WIDTH-10,-PANEL_THICKNESS],
                              [PANEL_WIDTH/2,PANEL_WIDTH-10,-PANEL_THICKNESS],
                              [PANEL_WIDTH-20,PANEL_WIDTH-10,-PANEL_THICKNESS],
                              [PANEL_WIDTH-10,20,-PANEL_THICKNESS],
                              [PANEL_WIDTH-10,PANEL_WIDTH/2,-PANEL_THICKNESS],
                              [PANEL_WIDTH-10,PANEL_WIDTH-20,-PANEL_THICKNESS],
                              ];
            for(f=foot_positions)translate(f)linear_extrude(PANEL_THICKNESS, scale=0.5)polygon(foot_profile);
        }
    }
}



module side_panel(){
    
}


//This is for mounting things like power supplies to the sides and back of a 
module side_bracket(part_dim, units){
    

}
rack_panel(type=9);
//rack_panel(type=10);

