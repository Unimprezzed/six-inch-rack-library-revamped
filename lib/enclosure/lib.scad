include <../base/constants.scad>
include <../base/common.scad>

module enclosure_Np(dim,square_cutouts=[], circular_cutouts=[], brackets=[], standoffs=[]){
    panel_dim=[dim.x-2*WALL_THICKNESS,WALL_THICKNESS,dim.z-2*WALL_THICKNESS];
    translate([WALL_THICKNESS,dim.y-WALL_THICKNESS,0]){
        color("red",0.5){
            difference(){
                union(){
                    difference(){
                        cube(panel_dim);
                        if(len(square_cutouts) > 0){
                            for(c=square_cutouts_){
                                x=c[0];
                                z=c[1];
                                w=c[2];
                                h=c[3];
                                translate([x,0,z])cube([w,300,h]);
                            }
                        }
                        if(len(circular_cutouts) > 0){
                            for(c=circular_cutouts){
                                x=c[0];
                                z=c[1];
                                d=c[2];
                                translate([x,0,z])rotate([90,0,0])cylinder(d=d,h=300);
                            }
                        }
                    }
                    if(len(brackets) > 0){
                        for(b=brackets){
                            x=b[0];
                            z=b[1];
                            dim=b[2];
                            thickness=b[3];
                            length=b[4];
                            tabs=b[5];
                            translate([x,0,z])
                                rotate([90,0,0])
                                    bracket(dim, thickness,length, tabs);
                        }
                    }
                    if(len(standoffs) > 0){
                        for(s=standoffs){
                            x=s[0];
                            z=s[1];
                            od=s[2];
                            id=s[3];
                            h=s[4];
                            translate([x,0,z])
                                rotate([90,0,0])
                                    standoff(od,id,h);
                        }
                    }
                }
               if(len(standoffs) > 0){
                    for(s=standoffs){
                        if(s[5]){
                            x=s[0];
                            z=s[1];
                            od=s[2];
                            id=s[3];
                            translate([x,0,z])
                                rotate([90,0,0])
                                    standoff_thru_screw(od,id);
                        }
                    }
               }
            }
        }
    }
}
module enclosure_Sp(dim,square_cutouts=[], circular_cutouts=[], brackets=[], standoffs=[]){
    panel_dim=[dim.x+2*EXTRUSION_PROFILE_WIDTH,PANEL_THICKNESS,dim.z];
    translate([-0,0,-WALL_THICKNESS]){
        color("blue",0.5){            
            difference(){
                union(){
                    difference(){
                        rack_panel(panel_dim);
                        if(len(square_cutouts) > 0){
                            for(c=square_cutouts_){
                                x=c[0];
                                z=c[1];
                                w=c[2];
                                h=c[3];
                                translate([x,0,z])rotate([270,270,0])cube([w,300,h]);
                            }
                        }
                        if(len(circular_cutouts) > 0){
                            for(c=circular_cutouts){
                                x=c[0];
                                z=c[1];
                                d=c[2];
                                translate([x,0,z])rotate([270,270,0])cylinder(d=d,h=300);
                            }
                        }
                    }
                    if(len(brackets) > 0){
                        for(b=brackets){
                            x=b[0];
                            z=b[1];
                            dim=b[2];
                            thickness=b[3];
                            length=b[4];
                            tabs=b[5];
                            translate([x,0,z])
                                rotate([270,270,0])
                                    bracket(dim, thickness,length, tabs);
                        }
                    }
                    if(len(standoffs) > 0){
                        for(s=standoffs){
                            x=s[0];
                            z=s[1];
                            od=s[2];
                            id=s[3];
                            h=s[4];
                            translate([x,0,z])
                                rotate([270,270,0])
                                    standoff(od,id,h);
                        }
                    }
                }
               if(len(standoffs) > 0){
                    for(s=standoffs){
                        if(s[5]){
                            x=s[0];
                            z=s[1];
                            od=s[2];
                            id=s[3];
                            translate([x,0,z])
                                rotate([270,270,0])
                                    standoff_thru_screw(od,id);
                        }
                    }
               }
            }
        }
    }
}
module enclosure_Ep(dim, square_cutouts=[], circular_cutouts=[], brackets=[], standoffs=[]){
    panel_dim=[WALL_THICKNESS,dim.y,dim.z-2*WALL_THICKNESS];
    translate([dim.x-WALL_THICKNESS,0,0]){    
        color("green",0.5){
            cube(panel_dim);
        }
    }
}
module enclosure_Wp(dim, square_cutouts=[], circular_cutouts=[], brackets=[], standoffs=[]){
    panel_dim=[WALL_THICKNESS,dim.y,dim.z-2*WALL_THICKNESS];
    translate([0,0,0]){
        color("yellow",0.5){
           cube(panel_dim);
        }
    }
}
module enclosure_Up(dim, brackets=[], standoffs=[]){
    panel_dim=[dim.x,dim.y,WALL_THICKNESS];
    translate([0,0,dim.z-2*WALL_THICKNESS]){
        color("orange",0.5){
            difference(){
                cube(panel_dim);
                cabinet_vents(dim.y);
            }
        }
    }
}
module enclosure_Dp(dim, brackets=[], standoffs=[]){
    panel_dim=[dim.x,dim.y,WALL_THICKNESS];
    translate([0,0,-WALL_THICKNESS]){
        color("purple",0.5){
            difference(){
                cube(panel_dim);
                cabinet_vents(dim.y);
            }
        }
    }
}


$fn=20;
dim = [CABINET_WIDTH,110,u2mm(5)];
explode_up = [0,0,1];
explode_down = [0,0,-1];
explode_backward = [0,1,0];
explode_forward = [0,-1,0];
explode_left = [-1,0,0];
explode_right = [1,0,0];
explode_distance=10;

//rotate([270,270,0])bracket([10,10,10],2,5);
//rotate([90,0,0])bracket([10,10,10],2,5);
translate(explode_backward*explode_distance)enclosure_Np(dim);
translate(explode_forward*explode_distance)enclosure_Sp(dim);
translate(explode_right*explode_distance)enclosure_Ep(dim);
translate(explode_left*explode_distance)enclosure_Wp(dim);
translate(explode_up*explode_distance)enclosure_Up(dim);
translate(explode_down*explode_distance)enclosure_Dp(dim);
