include <../base/constants.scad>
include <../base/common.scad>

module enclosure_front_panel(units, square_cutouts=[], circular_cutouts=[], brackets=[], standoffs=[]){
	panel_dim = [CABINET_WIDTH-2*(WALL_THICKNESS+TOL),WALL_THICKNESS,u2mm(units)];    
}

module enclosure_rear_panel(units, square_cutouts=[], circular_cutouts=[], brackets=[], standoffs=[]){
	panel_dim=[CABINET_WIDTH-2*(WALL_THICKNESS+TOL),WALL_THICKNESS,u2mm(units)];
}

module enclosure_bottom_panel(depth, brackets=[], standoffs=[]){
    inside_corner=[WALL_THICKNESS,WALL_THICKNESS,WALL_THICKNESS];
	panel_dim=[CABINET_WIDTH, depth, WALL_THICKNESS];
    screw_trap_size = 8;
    screw_trap_pos = [
        [WALL_THICKNESS,screw_trap_size+TOL,WALL_THICKNESS],
        [screw_trap_size+TOL,WALL_THICKNESS,WALL_THICKNESS],
        [panel_dim.x-screw_trap_size-WALL_THICKNESS,screw_trap_size+TOL,WALL_THICKNESS],
        [panel_dim.x-2*screw_trap_size-TOL,WALL_THICKNESS,WALL_THICKNESS],
        [WALL_THICKNESS,panel_dim.y-2*screw_trap_size,WALL_THICKNESS],
        [screw_trap_size,panel_dim.y-WALL_THICKNESS-screw_trap_size,WALL_THICKNESS],
        [panel_dim.x-screw_trap_size-WALL_THICKNESS,panel_dim.y-2*screw_trap_size,WALL_THICKNESS],
        [panel_dim.x-screw_trap_size*2,panel_dim.y-screw_trap_size-WALL_THICKNESS,WALL_THICKNESS]
    ];
    screw_pos = [
        screw_trap_pos[0] + screw_trap_size*[0,0.5,0.5],
        screw_trap_pos[1] + screw_trap_size*[0.5,0,0.5],
        screw_trap_pos[2] + screw_trap_size*[1,0.5,0.5],
        screw_trap_pos[3] + screw_trap_size*[0.5,0,0.5],
        screw_trap_pos[4] + screw_trap_size*[0,0.5,0.5],
        screw_trap_pos[5] + screw_trap_size*[0.5,1,0.5],
        screw_trap_pos[6] + screw_trap_size*[1,0.5,0.5],
        screw_trap_pos[7] + screw_trap_size*[0.5,1,0.5]
    ];
    screw_rot = [
        90*[0,1,0],
        90*[3,0,0],
        90*[0,3,0],
        90*[3,0,0],
        90*[0,1,0],
        90*[1,0,0],
        90*[0,3,0],
        90*[1,0,0]
    ];
    
    difference(){
        union(){
            cube(panel_dim);
            for(i=screw_trap_pos){
                translate(i)cube(screw_trap_size);
            }
            if(len(brackets) > 0){
                for(b=brackets){
                    x = b[0];
                    y = b[1];
                    w = b[2];
                    l = b[3];
                    h = b[4];
                    xl= b[5];
                    yl= b[6];
                    translate(inside_corner + [x,y,0])
                        bracket(w,l,xl,yl,h);
                }
            }
            if(len(standoffs) >0){
                for(s=standoffs){
                    x=s[0];
                    y=s[1];
                    od=s[2];
                    id=s[3];
                    h=s[4];
                    translate(inside_corner + [x,y,0])
                        standoff(od,id,h);
                }
            }
        }
        cabinet_vents(panel_dim.y);
        translate([screw_trap_size/2,screw_trap_size/2,M3_CS_SCREW_HEAD_HEIGHT])
            rotate([180,0,0])
                m3_cs_screw();
        translate([panel_dim.x-screw_trap_size/2,screw_trap_size/2,M3_CS_SCREW_HEAD_HEIGHT])
            rotate([180,0,0])
                m3_cs_screw();
        translate([panel_dim.x-screw_trap_size/2,panel_dim.y-screw_trap_size/2,M3_CS_SCREW_HEAD_HEIGHT])
            rotate([180,0,0])
                m3_cs_screw();
        translate([screw_trap_size/2,panel_dim.y-screw_trap_size/2,M3_CS_SCREW_HEAD_HEIGHT])
            rotate([180,0,0])
                m3_cs_screw();
        translate([panel_dim.x/2,screw_trap_size/2,M3_CS_SCREW_HEAD_HEIGHT])
            rotate([180,0,0])
                m3_cs_screw();
        translate([panel_dim.x-screw_trap_size/2,panel_dim.y/2,M3_CS_SCREW_HEAD_HEIGHT])
            rotate([180,0,0])
                m3_cs_screw();
        translate([panel_dim.x/2,panel_dim.y-screw_trap_size/2,M3_CS_SCREW_HEAD_HEIGHT])
            rotate([180,0,0])
                m3_cs_screw();
        translate([screw_trap_size/2,panel_dim.y/2,M3_CS_SCREW_HEAD_HEIGHT])
            rotate([180,0,0])
                m3_cs_screw();
        for(i=[0:7]){
            translate(screw_pos[i])
                rotate(screw_rot[i])
                    cylinder(d=M3_SCREW_THREAD-TOL,h=M3_SCREW_LENGTH);
        }
        if(len(standoffs) > 0){
            for(s=standoffs){
                x=s[0];
                y=s[1];
                od=s[2];
                id=s[3];
                enabled=s[5];
                if(enabled){
                    translate(inside_corner + [x,y,-WALL_THICKNESS])standoff_thru_screw(od,id);
                }
            }
        }
    }
}

module enclosure_top_panel(depth, brackets=[], standoffs=[]){
	panel_dim=[CABINET_WIDTH-2*(WALL_THICKNESS+TOL), depth, WALL_THICKNESS];
}

module enclosure_left_panel(units, depth, square_cutouts=[], circular_cutouts=[], brackets=[], standoffs=[], shelves=[]){
	panel_dim=[WALL_THICKNESS,depth,u2mm(units)];
}

module enclosure_right_panel(units, depth, square_cutouts=[], circular_cutouts=[], brackets=[], standoffs=[], shelves=[]){
	panel_dim=[WALL_THICKNESS,depth,u2mm(units)];

}

module enclosure_shelf(depth, brackets=[], standoffs=[]){
	shelf_dim=[CABINET_WIDTH-2*(WALL_THICKNESS+TOL), depth-2*(WALL_THICKNESS+TOL), WALL_THICKNESS];

}

bottom_panel(110);
