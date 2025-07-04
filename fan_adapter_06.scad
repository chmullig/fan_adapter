$fn = 100;  // Increase circle resolution for smooth curves

//
// fan_adapter.scad
// Customizable adapter to mount a PC fan to a cabinet exhaust hole.
// (BOSL2 must be properly installed to use <BOSL2/std.scad>)
//
include <BOSL2/std.scad>

module fan_adapter(
    top_hole_d          = 101.6, // Diameter of cabinet exhaust hole (4 inches = 101.6mm)
    top_flange_d        = 131.6, // 30mm larger than hole for sufficient mounting area
    top_flange_thk      = 5,     
    adapter_height      = 45,    // Slightly taller to accommodate larger diameter
    offset_x            = 0,    // Increased offset to accommodate larger hole
    offset_y            = 0,     
    bottom_fan_size     = 120,   
    bottom_flange_thk   = 8,     
    wall_thickness      = 4,     
    bottom_hole_d       = 116,   // Fan inner diameter (~116mm)
    fan_hole_spacing    = undef, 
    // Wood (cabinet) screw parameters (#8 screws):
    top_screw_d         = 4.16,  // Shaft diameter (in mm)
    top_screw_head_d    = 8.33,  // Head diameter (~0.332" in mm)
    wood_screw_head_h   = 2.54,  // Head height (~0.1" in mm)
    // Fan screw parameters (for M4 screws):
    fan_screw_d         = 4,     
    nut_trap_d          = 6,     // 6mm hole for M4 heat–set nut
    nut_trap_depth      = 6,     // Deeper (6mm) to allow 4mm nut embedment
    // Cable pass–through hole parameters:
    cable_hole_d        = 20,    // 20mm diameter for cables
    cable_hole_rot      = 0,     // Rotation angle (degrees) for cable hole (0 = right, 90 = up, etc.)
    cable_hole_height   = 60     // Vertical exit position (z) for the cable hole
) {
    // Auto–calculate fan hole spacing if not specified
    actual_fan_hole_spacing = (fan_hole_spacing == undef) ? 
                             (bottom_fan_size == 120) ? 105 : 
                             (bottom_fan_size == 92) ? 82.5 : 
                             (bottom_fan_size == 80) ? 71.5 : 
                             (bottom_fan_size == 60) ? 50 : 
                             (bottom_fan_size == 40) ? 32 : 
                             bottom_fan_size * 0.875 : fan_hole_spacing;
    
    bottom_flange_outer = bottom_fan_size + 10;
    
    //
    // 1) Funnel Shell: Create a hollow, tapered body with a vertical wall side
    //
    module funnel_shell() {
        difference() {
            union() {
                // Main body hull - will be intersected with a cuboid for wall side
                hull() {
                    translate([offset_x, offset_y, adapter_height - 0.01])
                        cylinder(d = top_flange_d, h = 0.01);
                    cylinder(d = bottom_fan_size + 2*wall_thickness, h = 0.01);
                }
                
                // Create vertical wall side using intersection
                intersection() {
                    // The same hull as above
                    hull() {
                        translate([offset_x, offset_y, adapter_height - 0.01])
                            cylinder(d = top_flange_d, h = 0.01);
                        cylinder(d = bottom_fan_size + 2*wall_thickness, h = 0.01);
                    }
                    
                    // Large cuboid to create vertical wall side (negative X direction)
                    translate([-200, -100, -0.1])
                        cube([200, 200, adapter_height + 0.2]);
                }
            }
            
            // Inner hollow: subtract the airflow path
            hull() {
                translate([offset_x, offset_y, adapter_height + 0.01])
                    cylinder(d = top_hole_d, h = 0.01);
                translate([0, 0, -0.01])
                    cylinder(d = bottom_hole_d, h = 0.01);
            }
        }
    }

    //
    // 2) Top Flange: A ring at the top matching the cabinet hole.
    //
    module top_flange() {
        difference() {
            translate([offset_x, offset_y, adapter_height])
                linear_extrude(height = top_flange_thk)
                    difference() {
                        circle(d = top_flange_d);
                        circle(d = top_hole_d);
                    }
            // Remove any overhanging flange material.
            translate([offset_x, offset_y, adapter_height - 1])
                cylinder(d = top_hole_d, h = top_flange_thk + 2);
        }
    }

    //
    // 3) Bottom Flange: A ring at the bottom.
    //
    module bottom_flange() {
        difference() {
            linear_extrude(height = bottom_flange_thk)
                difference() {
                    square([bottom_flange_outer, bottom_flange_outer], center=true);
                    circle(d = bottom_hole_d);
                }
        }
    }

    //
    // 4) Wood Screw Holes with Countersink:
    //    These holes provide a countersunk recess for the #8 wood screws.
    //
    module wood_screw_hole() {
        // Through–hole for the screw shaft:
        cylinder(d = top_screw_d, h = adapter_height + top_flange_thk + 0.02, center = false);

        // Full size access for the screw head:
        cylinder(d = top_screw_head_d, h = adapter_height, center = false);
        
        // Conical countersink for the screw head:
        translate([0, 0, adapter_height])
            cylinder(d1 = top_screw_head_d, d2 = top_screw_d, h = wood_screw_head_h, center = false);
    }
    
    // Create mounting holes positioned for better accessibility
    module top_screw_holes() {
        // Wall is at negative X (180°), avoid positions close to wall
        wall_side = 0;
        avoid_angles = [wall_side-30, wall_side, wall_side+30]; // Avoid angles 150°-210°
        
        // Place screw holes at these angles (well distributed, avoiding wall)
        screw_angles = [0, 60, 120, 180, 240, 300];
        
        // Position holes closer to the opening for better access
        screw_radius = top_hole_d/2 + 8;
        
        for (angle = screw_angles) {
            // Skip holes that would be too close to the wall
            if (!search([angle], avoid_angles)[0]) {
                x_pos = screw_radius * cos(angle) + offset_x;
                y_pos = screw_radius * sin(angle) + offset_y;
                translate([x_pos, y_pos, -0.01])
                    wood_screw_hole();
            }
        }
    }

    //
    // 5) Fan Mounting Holes with Nut Traps:
    //    These holes hold the fan with M4 screws and corresponding heat–set nut pockets.
    //
    module fan_holes() {
        for (xsign = [-1, 1])
            for (ysign = [-1, 1]) {
                // Fan screw clearance hole:
                translate([
                    xsign*(actual_fan_hole_spacing/2),
                    ysign*(actual_fan_hole_spacing/2),
                    -1
                ])
                    cylinder(d = fan_screw_d,
                             h = bottom_flange_thk + 2,
                             center = false);
                
                // Heat set insert nut:
                translate([
                    xsign*(actual_fan_hole_spacing/2),
                    ysign*(actual_fan_hole_spacing/2),
                    bottom_flange_thk - nut_trap_depth
                ])
                    cylinder(d = nut_trap_d, h = nut_trap_depth, center = false);
            }
    }

    //
    // 6) Cable Pass–Through Hole:
    //    The cable hole now starts at the center of the 53mm vent and
    //    exits at the perimeter at a direction given by cable_hole_rot and
    //    a vertical exit defined by cable_hole_height.
    //
    module cable_hole() {
        // Starting point: center of the vent.
        start = [offset_x, offset_y, adapter_height];
        // Exit point: at the vent’s edge (using half of top_hole_d) with the given rotation,
        // and at the specified vertical (z) position.
        exit_pt = [
            offset_x + (top_hole_d/2)*cos(cable_hole_rot * PI/180),
            offset_y + (top_hole_d/2)*sin(cable_hole_rot * PI/180),
            cable_hole_height
        ];
        // Compute the vector from start to exit.
        v = [ exit_pt[0] - start[0],
              exit_pt[1] - start[1],
              exit_pt[2] - start[2] ];
        norm_v = sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);
        // Determine the rotation needed to align the cylinder’s z-axis with vector v.
        angle = acos(v[2] / norm_v)*180/PI;
        axis = [ -v[1], v[0], 0 ];
        
        translate(start)
            rotate(a = angle, v = axis)
                cylinder(d = cable_hole_d, h = norm_v + 1, center = false);
    }

    //
    // 7) Final Assembly:
    //    Combine the funnel shell and both flanges, then subtract all the holes.
    //
    difference() {
        union() {
            funnel_shell();
            top_flange();
            bottom_flange();
        }
        union() {
            top_screw_holes();
            fan_holes();
            cable_hole();
        }
    }
}

// Top–level call with updated parameters:
fan_adapter(
    top_hole_d = 101.6,       // 4 inches
    top_flange_d = 131.6,     // 30mm larger than hole for mounting
    offset_x = 10,            // Offset to accommodate wall
    offset_y = 0,
    adapter_height = 45,      // Slightly taller for the larger hole
    bottom_fan_size = 120,    // 120mm fan
    bottom_hole_d = 116,      // 116mm inner diameter
    cable_hole_d = 21,        // Slightly larger for cable clearance
    cable_hole_rot = 90,       // Cable exits opposite to wall
    cable_hole_height = 10    // Lower vertical position for better cable routing
);
