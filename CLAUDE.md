I have a media console cabinet that has multiple pieces of networking and A/V equipment in it. I'm therefore working to improve the airflow in the cabinet. I'm going to enlarge the outlet hole, and add intake holes to the front of the cabinet. 

Right now I have a 120mm noctua industrial fan Noctua NF-F12 iPPC-2000 PWM, Heavy Duty Cooling Fan, 4-Pin, 2000 RPM (120mm, Black). I'm using to exhaust air out of the top of the cabinet, through a hole that is about 50mm in diameter. The fan is mounted inside the cabinet through an early beta version of the fan_adapter design. 

I want to improve the fan adapter that I have, which is a 3D printed part that connects the fan to the hole in the cabinet. I'm going to increase the size of the hole in cabinet from ~2 to to 4 inches round hole. So we need to update the design to accommodate this larger size. I also need to keep the fan as close to the wall as possible, so I need to make sure that the adapter is designed to fit snugly against the wall on one side. The other side of the adapter will be more sloped to accommodate the offset from the wall. It needs a hole in the side to accommodate two cables that need to pass through the fan outlet. That needs to be slightly over 20mm, and should be designed to minimize the lost air flow. It should also have a small countersink for the screws that will hold the adapter into the cabinet, which may need to be redesigned to accommodate the new size of the hole.


The adapter will need to be screwed up from inside the adapter into the ceiling/top of the cabinet. The hole is very near a wall (it turns out the edge of the hole is only about 9/32" away from a metal bracket attached to the wall in one dimension) so the fan has to be offset from the air hole. In the end we need the fan to be almost flush with the wall, and one side of the adapter has to be almost straight vertically up against the wall, then the other side is sloped to accomodate the offset.


* To attach the fan, we'll use M4 heat set nuts. Those are 6mm hole diameter (with a slight taper at the top), the nut will be 4mm deep?
* Wood screw holes need to build up a little countersink to rest against. #8 wood screws, Head Diameter 0.332"; Head Height 0.1"; shaft diameter 0.164"
* Actual fan inner diameter is about 116mm.
* Cable that needs to go through adapter sidewall is 20mm
* Distance from wall on the close side is generally like 12/32”
* However, there's a metal bracket where the clearance is just 9/32”. 


So please remember the physical requirements of the screws and nuts and how they have to attach. Consider the design which is mostly working, and make the necessary changes. 

You can run the OpenSCAD CLI to test the code.  `/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD DESIGN.scad -o DESIGN.stl` or render it to a PNG with `/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD DESIGN.scad --viewall --render -o DESIGN.png`


