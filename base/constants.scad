SIX_INCH = 155;	
PANEL_WIDTH = SIX_INCH + 1;					            // 6" to cm
EXTRUSION_PROFILE_WIDTH = 20;				           	//Width of the 2020 extrusion (mm)
HALF_EXTRUSION_PROFILE_WIDTH=EXTRUSION_PROFILE_WIDTH/2;
CABINET_WIDTH = SIX_INCH - 2 * EXTRUSION_PROFILE_WIDTH; //Cabinet Width (mm)
U = (44.5/19)* 6; 					               		//1U
TOL=0.1; 												//Tolerance for generated parts (mm)

//Wall and panel 
WALL_THICKNESS = 2;										//Thickness of the walls (mm)
PANEL_THICKNESS = 3; 									//Thickness of panels (mm)

//Screw parameters
M3_CS_SCREW_HEAD_WIDTH = 6;								//Width of a counter-sunk M3 screw (mm)
M3_CS_SCREW_HEAD_HEIGHT = 1.1; 							//Height of a counter-sunk M3 screw (mm)
M3_SCREW_THREAD = 3.0;									//The diameter of an M3 screw (mm)
M3_SCREW_LENGTH = 7.0;									//The maximum length of an M3 screw used in this project
M4_SCREW_HEAD_WIDTH = 7; 								//
M4_SCREW_HEAD_HEIGHT = 3.5; 							//
M4_SCREW_THREAD = 4.0;									//
M5_SCREW_THREAD = 5.0;
SCREW_TRAP_DISTANCE = 14; 								//Single-axis distance of a screw trap from the nearest corner (mm)
SCREW_TRAP_OUTER_DIAMETER = 16;								//Diameter of a screw trap (mm)
