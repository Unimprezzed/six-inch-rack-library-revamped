This OpenSCAD design is meant to be (mostly) compatible with KronBjorn's Customizable 6" Rack Enclosure (https://github.com/KronBjorn/SixInchRack)

I found it on Thingiverse a while ago, and I liked it enough to use it for a Raspberry Pi Cluster I wanted to build. When I tried working with it, however, is when the problems started to mount. The original libary was written for an older version of OpenSCAD, which is perfectly fine. What *wasn't* as easy to work around were some other "eccentricites" of the library. 

* The original library relies heavily on poorly-documented "magic numbers" that aren't immediately obvious what they do.
* The original library swaps the Y and Z axes. This was a little disorienting, since I'm used to the Z axis being "up" and "down," with the Y axis being "forward" and "back". It also results in a print orientation that was challenging to print, since trying to print the design in ABS resulted the layers delaminating.
* The original library was missing a few features that I would have found useful, like the abilty to create "brackets" that hold enclosed objects in place.
* The original library gave a lot more control over where screws can go than it probably should have.
* I had a hard time figuring out where to place square and round holes on the front and rear panels. 

I'm not about to demand that the original author come back from the life he's living and support a library he wrote for a small project he wrote in 2016 to meet my particular tastes, and I didn't want to make a PR for a change that radically redefines how the library works and will probably be ignored anyway. To that end, I wrote a modified version of the library to meet my needs, and after wrapping up the project to where I'm happy, I decided to share my work with the rest of the world. Feel free to use and modify it to your own ends. You can even write a multi-paragraph README.md in your fork that tells me how much of an idiot I am. My feelings won't be hurt. (づ￣ 3￣)づ

Here's the features of this library: 
* The axes now follow the right-hand rule.
* The base cabinets have been redesigned so that they can be printed without supports. This was accomplished with screw traps that reach down to the floor of the cabinet and extending the lip rest downward. 
* The placement for square cutouts, round cutouts, internal brackets, and standoffs is relative to the inside left forward corner of the cabinet.
* Vents have been extended to scale with the length of the cabinet for improved airflow. Standoffs have additional code that allows them to bridge the gap across these vents.
* I've included an option that allows you to thread a counter-sunk screw on the bottom of the cabinet through the standoff. This is something I found particularly useful when I needed to secrue a spacer in place for a HAT. 
* Screw placement logic has been greatly simplified. Four screws hold the lid on the cabinet, four screws hold on the front panel, and four screws hold the rear panel in place. This is the rule, no matter how much you increase the height and depth of the cabinet. 
* Screws for the front and rear panels are placed with respect of the left-most corner of the cabinet and mirrored to the other side of the cabinet, ensuring that no matter what you do, the holes for the panels will always line up with the cabinet.

Parts included in this repo: 
* Cabinets: Built for small, self-contained electronics. Consists of the cabinet itself, a front and rear panel, and a lid. Front and rear panels can have square and round cutouts, cabinet can support brackets and standoffs. 
* Enclosures: Multi-part containers that are built to house larger, more complex electronics. Consists of front, rear, top, bottom, left, and right panels. All panels support square and round cutouts, and standoffs and brackets. Supports internal divisions called "levels." 
* Drawers: A single or multi-level container that is built to support drawers that slide on rails. Can be used to hold screws and stuff. Not sure *why* you would want to make this, but the option is there. 
* Rack: The rack is what this entire "ecosystem" is built around. Can be used to generate 3D-printed profiles with nutless traps built-in, or nutless traps that slide into aluminum 2020 extrusions.

Extras: 
* I wanted to add some extra flair for the cabinets for my Pi4 cluster, so I made a OpenSCAD design that makes cutouts for the cabinets that makes them multi-material. 

Dependencies:
I've included copies of other OpenSCAD libraries or designs that I used.  
* BOLTS													[Used in /rack/lib.scad]
* hex-grid: (https://github.com/charlespascoe/hex-grid) [Used in /extras/multi_material_cabinet.scad]

