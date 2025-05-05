//
// fan_adapter.scad
// Customizable adapter to mount a PC fan to a cabinet exhaust hole
// Make sure you have BOSL2 properly installed, then open this file in OpenSCAD.
//

include <BOSL2/std.scad>

module fan_adapter(
    top_hole_d         = 50,    // Diameter of circular hole in cabinet
    top_flange_d       = 70,    // Outer diameter of top flange
    top_flange_thk     = 5,     // Thickness of top flange
    adapter_height     = 60,    // Height of the funnel (vertical distance)
    offset_x           = 20,    // How far to shift the top hole in X
    offset_y           = 20,    // How far to shift the top hole in Y
    bottom_fan_size    = 120,   // Fan size in mm (e.g., 120 for 120mm fan)
    bottom_flange_thk  = 5,     // Thickness of bottom flange
    wall_thickness     = 4,     // Wall thickness of the adapter
    bottom_hole_d      = 110,   // Diameter of circular hole at bottom (should be less than fan size)
    fan_hole_spacing   = undef, // Hole spacing for fan (default: auto-calculate)
    top_screw_d        = 4.16,  // Diameter of holes for cabinet screws
    top_screw_head_d   = 8.33,  // Diameter of head allowance for cabinet screws
    fan_screw_d        = 4,     // Diameter of holes for fan screws
    nut_trap_d         = 7.5,   // Diameter of nut traps for fan screws
    nut_trap_depth     = 3      // Depth of nut traps
) {
    // Calculate fan hole spacing if not specified
    actual_fan_hole_spacing = (fan_hole_spacing == undef) ? 
                             (bottom_fan_size == 120) ? 105 : 
                             (bottom_fan_size == 92) ? 82.5 : 
                             (bottom_fan_size == 80) ? 71.5 : 
                             (bottom_fan_size == 60) ? 50 : 
                             (bottom_fan_size == 40) ? 32 : 
                             bottom_fan_size * 0.875 : fan_hole_spacing;
    
    bottom_flange_outer = bottom_fan_size + 10;
    
    //
    // 1) Funnel: Create a hollow shell that transitions from top to bottom
    //
  
    module funnel_shell() {
        difference() {
            // Outer shell
            hull() {
                translate([offset_x, offset_y, adapter_height - 0.01])
                cylinder(d = top_flange_d, h = 0.01);
                
                cylinder(d = bottom_fan_size + 2*wall_thickness, h = 0.01);
            }

            // Inner hollow
            hull() {
                translate([offset_x, offset_y, adapter_height + 0.01])
                cylinder(d = top_hole_d, h = 0.01);
                
                translate([0, 0, -0.01])
                cylinder(d = bottom_hole_d, h = 0.01);
            }
        }
    }

    //
    // 2) Top flange: A ring at the top, properly offset to match the hole
    //
    module top_flange() {
        difference() {
            translate([offset_x, offset_y, adapter_height])
            linear_extrude(height = top_flange_thk)
            difference() {
                circle(d = top_flange_d);
                circle(d = top_hole_d);
            }
            
            // Cut the part of the flange that would float in air
            translate([offset_x, offset_y, adapter_height - 1])
            cylinder(d = top_hole_d, h = top_flange_thk + 2);
        }
    }

    //
    // 3) Bottom flange: A ring for the square fan cutout, extruded at Z=0
    //
    module bottom_flange() {
        difference() {
            linear_extrude(height = bottom_flange_thk)
            difference() {
                square([bottom_flange_outer, bottom_flange_outer], center=true);
                circle(d = bottom_hole_d);
            }
            
// CHRIS: NO
//            // Cut out the fan opening (square)
//            translate([0, 0, -0.01])
//            linear_extrude(height = bottom_flange_thk/2 + 0.02)
//            square([bottom_fan_size, bottom_fan_size], center=true);
        }
    }

    //
    // 4) Holes: (a) Four top mounting holes, (b) Four fan mounting holes with nut traps
    //
    module top_holes() {
        // Calculate positions for top mounting holes around the offset hole
        top_flange_hole_radius = top_flange_d/2 - 5;
        for (angle = [0, 90, 180, 270]) {
            // Skip holes that would be in the airflow path
            hole_x = top_flange_hole_radius*cos(angle) + offset_x;
            hole_y = top_flange_hole_radius*sin(angle) + offset_y;
            
            translate([
                hole_x,
                hole_y,
                -0.01
            ])
            union() {
                cylinder(d = top_screw_d,
                         h = adapter_height+top_flange_thk+0.02,
                         center = false);
                cylinder(d = top_screw_head_d,
                         h = adapter_height+0.02,
                         center = false);
            }
        }
    }

    module fan_holes() {
        for (xsign = [-1, 1])
            for (ysign = [-1, 1]) {
                // Fan mounting holes
                translate([
                    xsign*(actual_fan_hole_spacing/2),
                    ysign*(actual_fan_hole_spacing/2),
                    -1
                ])
                cylinder(d = fan_screw_d,
                         h = bottom_flange_thk + 2,
                         center = false);
                
                // Nut traps for fan screws
                translate([
                    xsign*(actual_fan_hole_spacing/2),
                    ysign*(actual_fan_hole_spacing/2),
                    bottom_flange_thk - nut_trap_depth
                ])
                cylinder(d = nut_trap_d, h = nut_trap_depth + 0.01, $fn=6);
            }
    }

    //
    // 5) Combine funnel + flanges, subtract holes
    //
    difference() {
        union() {
            funnel_shell();
            top_flange();
            bottom_flange();
        }
        union() {
            top_holes();
            fan_holes();
        }
    }
}

// Call it at the top level with desired parameters
fan_adapter(
    top_hole_d = 50,   
    offset_x = 25,
    offset_y = 0,
    adapter_height = 60,
    bottom_fan_size = 120,
    bottom_hole_d = 111
);
