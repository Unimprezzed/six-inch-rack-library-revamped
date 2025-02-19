Introduction: 
	This OpenSCAD design is meant to be compatible with KronBjorn's Customizable 6" Rack Enclosure. 
	Since I wanted to make a somewhat serious-looking Raspberry Pi cluster that was expandable, I liked this library enough to download it and use it. 
  
  That's when I ran into some issues that made me decide to write this library. 

 	 1. I felt the original library relied too much on undocumented "magic numbers" that would break the entire design if you changed them. 

	2. KronBjorn swapped the Y and Z axes. This is something that irked me, since I'm used to the Z axis being "up" and "down" and Y axis being "forward" and "back" (from the perspective of the viewport). It also made printing the cabinet in the position it was generated difficult in materials like ABS, since the layers would delaminate, even inside an enclosure. 
	
 	3. The library was lacking a few things I would have found useful, like having small internal tabs for holding items already in an enclosure (like network switches and USB hubs) in place. 
	
 	4. While the author gave you plenty of room to place and move screws around, I found that it was unnecessary for most things, as having more screws securing the cabinet together did not signficantly improve the strength of these connections. 
	
 	5. This is more of a "stupid user" moment on my end, but I could never figure out how to place add cutouts on the front and rear panels. 
	
 	6. It renders a little slower than I'd like, even in the nightly builds of OpenSCAD with multicore rendering. 

  Now, for my changes. "+" means I added something or made something I consider an improvement. "-" means I simplified or removed a feature I didn't find particularly useful 
		+ The smallest change was the extension of the vents (named "chimneys" in the original library) so that they scale in size to the depth of the cabinet.
		+ I redesigned the cabinet code in a way that it can be printed as generated without needing to add supports. I did this with thicker screw traps for the lid that reach down to the floor of the cabinet and extending the lip the lid rests on downward, which reduces the number of overhangs and strengthens the walls. These extensions have a small footprint, so the internal volume of the cabinet is not significantly affected.
		+ I made the rules for placing things like standoffs or internal brackets internally consistent. All additions are placed relative to the front left inside corner of the cabinet. 
			+ This includes: 
				+ Standoffs
				+ Internal brackets
				+ Square and round cutouts on the front and rear panels
			+ Standoffs now have a small round base to bridge the gap across the newly extended vents. 
		- I simplified the screw placement logic for the lid, front, and rear panels. 
			-There are now only four screws holding the lid and the front and rear panels onto the cabinet. I might add the ability to automatically place more 
			-In line with the new placement code, screws for the front and rear panels are placed are placed with respect to the front left inside corner of the cabinet, except it is mirrored to where it's on the right side of the cabinet as well.

	
