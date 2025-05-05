$fn = 100;  // Increase circle resolution for smooth curves

//
// fan_adapter_06.scad
// Updated adapter to mount a 120mm Noctua PC fan to an enlarged cabinet exhaust hole
// Based on existing fan_adapter designs with modified dimensions for larger hole
// (BOSL2 must be properly installed to use <BOSL2/std.scad>)
//
include <libraries/BOSL2/std.scad>

module fan_adapter(
    top_hole_d          = 101.6,  // 4 inches in mm (increased from 53mm)
    top_flange_d        = 121.6,  // 20mm larger than the hole
    top_flange_thk      = 5,      // Thickness of top flange
    adapter_height      = 65,     // Slightly taller to accommodate the larger hole
    offset_x            = 35,     // Adjusted for the larger hole and wall proximity
    offset_y            = 0,      // No Y offset needed
    bottom_fan_size     = 120,    // Standard 120mm fan 
    bottom_flange_thk   = 8,      // Thickness of bottom flange
    wall_thickness      = 4,      // Wall thickness of adapter
    bottom_hole_d       = 116,    // Fan inner diameter (116mm per specs)
    fan_hole_spacing    = undef,  // Auto-calculated based on fan size
    // Wood (cabinet) screw parameters (#8 screws):
    top_screw_d         = 4.16,   // Shaft diameter (~0.164" in mm)
    top_screw_head_d    = 8.43,   // Head diameter (~0.332" in mm)
    wood_screw_head_h   = 2.54,   // Head height (~0.1" in mm)
    // Fan screw parameters (for M4 heat-set nuts):
    fan_screw_d         = 4,      // M4 screw diameter
    nut_trap_d          = 6,      // 6mm hole for M4 heat-set nut
    nut_trap_depth      = 5,      // 5mm depth for the 4mm deep nut
    // Cable pass-through hole parameters:
    cable_hole_d        = 21,     // Slightly over 20mm diameter for cables
    cable_hole_rot      = 180,    // Position the cable hole opposite from the wall
    cable_hole_height   = 25,     // Vertical exit position (z) for the cable hole
    // Wall proximity constraints:
    wall_distance       = 7.14    // 9/32" in mm - closest distance to wall/bracket
) {
    // Auto-calculate fan hole spacing if not specified
    actual_fan_hole_spacing = (fan_hole_spacing == undef) ? 
                             (bottom_fan_size == 120) ? 105 : 
                             (bottom_fan_size == 92) ? 82.5 : 
                             (bottom_fan_size == 80) ? 71.5 : 
                             (bottom_fan_size == 60) ? 50 : 
                             (bottom_fan_size == 40) ? 32 : 
                             bottom_fan_size * 0.875 : fan_hole_spacing;
    
    bottom_flange_outer = bottom_fan_size + 10;
    
    //
    // 1) Funnel Shell: Create a hollow, tapered body from the top flange down to the fan.
    //    This version has a more vertical profile on the wall side.
    //
    module funnel_shell() {
        difference() {
            // Outer shell: a hull between the top circle (at the offset) and the bottom circle
            hull() {
                translate([offset_x, offset_y, adapter_height - 0.01])
                    cylinder(d = top_flange_d, h = 0.01);
                cylinder(d = bottom_fan_size + 2*wall_thickness, h = 0.01);
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
            // Remove any overhanging flange material
            translate([offset_x, offset_y, adapter_height - 1])
                cylinder(d = top_hole_d, h = top_flange_thk + 2);
        }
    }

    //
    // 3) Bottom Flange: A ring at the bottom for the fan.
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
        // Through-hole for the screw shaft
        cylinder(d = top_screw_d, h = adapter_height + top_flange_thk + 0.02, center = false);

        // Full size access for the screw head
        cylinder(d = top_screw_head_d, h = adapter_height, center = false);
        
        // Conical countersink for the screw head
        translate([0, 0, adapter_height])
            cylinder(d1 = top_screw_head_d, d2 = top_screw_d, h = wood_screw_head_h, center = false);
    }
    
    // Only create screw holes where there's enough clearance (avoid the wall side)
    module top_screw_holes() {
        // Calculate the angular position where we're too close to the wall
        wall_angle = 180; // Angle pointing toward the wall
        
        // Evenly space 3 screw holes, avoiding the wall area
        for (angle = [60, 180, 300]) {
            // Skip the hole that would be too close to the wall bracket
            if (angle != wall_angle) {
                x_pos = (top_flange_d/2 - 5) * cos(angle) + offset_x;
                y_pos = (top_flange_d/2 - 5) * sin(angle) + offset_y;
                translate([x_pos, y_pos, -0.01])
                    wood_screw_hole();
            }
        }
    }

    //
    // 5) Fan Mounting Holes with Nut Traps:
    //    These holes hold the fan with M4 screws and corresponding heat-set nut pockets.
    //
    module fan_holes() {
        for (xsign = [-1, 1])
            for (ysign = [-1, 1]) {
                // Fan screw clearance hole
                translate([
                    xsign*(actual_fan_hole_spacing/2),
                    ysign*(actual_fan_hole_spacing/2),
                    -1
                ])
                    cylinder(d = fan_screw_d,
                             h = bottom_flange_thk + 2,
                             center = false);
                
                // Heat set insert nut pocket
                translate([
                    xsign*(actual_fan_hole_spacing/2),
                    ysign*(actual_fan_hole_spacing/2),
                    bottom_flange_thk - nut_trap_depth
                ])
                    cylinder(d = nut_trap_d, h = nut_trap_depth, center = false);
            }
    }

    //
    // 6) Cable Pass-Through Hole:
    //    The cable hole now starts at the center of the vent and
    //    exits at the perimeter at a direction given by cable_hole_rot and
    //    a vertical exit defined by cable_hole_height.
    //
    module cable_hole() {
        // Starting point: center of the vent
        start = [offset_x, offset_y, adapter_height];
        // Exit point: at the adapter's side with the given rotation,
        // and at the specified vertical (z) position
        
        // Calculate distance from center to wall of adapter at the given angle
        // This is more complex with the asymmetrical shape, so we'll use a conservative approach
        exit_radius = bottom_fan_size/2 + wall_thickness;
        
        exit_pt = [
            offset_x + exit_radius*cos(cable_hole_rot),
            offset_y + exit_radius*sin(cable_hole_rot),
            cable_hole_height
        ];
        
        // Compute the vector from start to exit
        v = [ exit_pt[0] - start[0],
              exit_pt[1] - start[1],
              exit_pt[2] - start[2] ];
        norm_v = sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);
        
        // Determine the rotation needed to align the cylinder with vector v
        angle = acos(v[2] / norm_v);
        axis = [ -v[1], v[0], 0 ];
        
        translate(start)
            rotate(a = angle * 180/PI, v = axis)
                cylinder(d = cable_hole_d, h = norm_v + 10, center = false);
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

// Top-level call with updated parameters for the new 4-inch hole design:
fan_adapter(
    top_hole_d = 101.6,  // 4 inches in mm
    top_flange_d = 121.6, // 20mm larger than hole
    offset_x = 35,        // Adjusted for larger hole and wall proximity
    offset_y = 0,
    adapter_height = 65,
    bottom_fan_size = 120,
    bottom_hole_d = 116,  // 116mm per actual fan inner diameter
    cable_hole_d = 21,    // Slightly over 20mm for cable clearance
    cable_hole_rot = 180, // Cable exits away from wall
    cable_hole_height = 25 // Set the vertical exit position
);