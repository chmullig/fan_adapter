// Intake Adapter for Media Console Cabinet
// This adapter connects smaller fans (configurable between 60mm and 80mm)
// to intake slots cut into the bottom of a media console cabinet.

// Import BOSL2 library if available
// include <BOSL2/std.scad>

// ===== PARAMETERS =====

// Rendering options
cutaway = false;  // Set to true for cutaway view

// Fan parameters
fan_size = 80;  // Options: 60 or 80 (mm)
fan_thickness = 25;  // Standard PC fan thickness

// Derived fan parameters
fan_inner_diameter = (fan_size == 80) ? 76 : 56;  // Approximate inner diameter
fan_mount_spacing = (fan_size == 80) ? 71.5 : 50;  // Distance between mounting holes

// Slot parameters
slot_width = 19.05;  // 3/4 inch
slot_length = fan_size + 20;  // Slightly longer than the fan diameter
slot_radius = slot_width / 2;  // Radius for the rounded ends

// Adapter parameters
adapter_angle = 45;  // Angle at which the fan is tilted
wall_thickness = 2.5;  // Minimum wall thickness
flange_width = 10;  // Width of the mounting flange
flange_thickness = 3;  // Thickness of the flange

// Mounting hardware parameters
fan_mount_hole_diameter = 4.5;  // M4 screws
fan_mount_nut_diameter = 6;  // M4 heat-set nuts
fan_mount_nut_depth = 5;  // Depth for heat-set nuts
cabinet_mount_hole_diameter = 4.16;  // #8 wood screws
cabinet_mount_head_diameter = 8.33;  // #8 wood screw head

// Resolution
$fn = 50;  // Set to 100 for final version

// ===== MODULES =====

// Main module for the intake adapter
module intake_adapter() {
    difference() {
        union() {
            // Base flange that attaches to the cabinet
            flange();
            
            // Main adapter body
            adapter_body();
        }
        
        // Subtract the inner air channel
        air_channel();
        
        // Subtract the mounting holes
        mounting_holes();
    }
}

// Flange that attaches to the cabinet
module flange() {
    linear_extrude(height = flange_thickness) {
        difference() {
            // Outer shape - stadium/pill shape plus some padding
            offset(r = flange_width) {
                stadium_shape(slot_length, slot_width);
            }
            
            // Inner cutout - the actual slot
            stadium_shape(slot_length, slot_width);
        }
    }
}

// Main body of the adapter that transitions from slot to fan
module adapter_body() {
    // Calculate the height of the adapter based on the angle and fan size
    adapter_height = fan_size * sin(adapter_angle) + fan_thickness * cos(adapter_angle);
    
    // Use hull to create a smooth transition from slot to fan
    hull() {
        // Bottom shape (at the flange)
        translate([0, 0, flange_thickness - 0.01])
            linear_extrude(height = 0.01)
            offset(r = wall_thickness) 
            stadium_shape(slot_length, slot_width);
        
        // Top shape (at the fan)
        translate([0, 0, adapter_height])
            rotate([adapter_angle, 0, 0])
            linear_extrude(height = 0.01)
            circle(d = fan_size + 2 * wall_thickness);
    }
}

// The inner air channel
module air_channel() {
    // Calculate the height of the adapter based on the angle and fan size
    adapter_height = fan_size * sin(adapter_angle) + fan_thickness * cos(adapter_angle);
    
    // Use hull to create a smooth inner transition
    hull() {
        // Bottom shape (at the flange)
        translate([0, 0, flange_thickness - 0.01])
            linear_extrude(height = 0.01)
            stadium_shape(slot_length, slot_width);
        
        // Top shape (at the fan)
        translate([0, 0, adapter_height])
            rotate([adapter_angle, 0, 0])
            linear_extrude(height = 0.01)
            circle(d = fan_inner_diameter);
    }
    
    // Extended fan hole
    translate([0, 0, adapter_height])
        rotate([adapter_angle, 0, 0])
        linear_extrude(height = fan_thickness + 1, center = false)
        circle(d = fan_inner_diameter);
}

// Mounting holes for both fan and cabinet
module mounting_holes() {
    // Cabinet mounting holes in the flange
    cabinet_mount_positions = [
        [slot_length/2 + flange_width/2, slot_width/2 + flange_width/2, 0],
        [slot_length/2 + flange_width/2, -slot_width/2 - flange_width/2, 0],
        [-slot_length/2 - flange_width/2, slot_width/2 + flange_width/2, 0],
        [-slot_length/2 - flange_width/2, -slot_width/2 - flange_width/2, 0]
    ];
    
    for (pos = cabinet_mount_positions) {
        translate(pos) {
            // Screw hole
            cylinder(h = flange_thickness * 3, d = cabinet_mount_hole_diameter, center = true);
            
            // Countersink for screw head
            translate([0, 0, flange_thickness - cabinet_mount_head_diameter/4])
                cylinder(h = cabinet_mount_head_diameter/2, 
                         d1 = cabinet_mount_hole_diameter, 
                         d2 = cabinet_mount_head_diameter);
        }
    }
    
    // Fan mounting holes
    adapter_height = fan_size * sin(adapter_angle) + fan_thickness * cos(adapter_angle);
    fan_mount_positions = [
        [fan_mount_spacing/2, fan_mount_spacing/2, 0],
        [fan_mount_spacing/2, -fan_mount_spacing/2, 0],
        [-fan_mount_spacing/2, fan_mount_spacing/2, 0],
        [-fan_mount_spacing/2, -fan_mount_spacing/2, 0]
    ];
    
    for (pos = fan_mount_positions) {
        translate([0, 0, adapter_height])
            rotate([adapter_angle, 0, 0])
            translate(pos) {
                // Screw hole
                cylinder(h = fan_thickness + wall_thickness * 2, 
                         d = fan_mount_hole_diameter, 
                         center = true);
                
                // Heat-set nut hole (bottom side)
                translate([0, 0, -fan_thickness/2 - fan_mount_nut_depth/2])
                    cylinder(h = fan_mount_nut_depth, 
                             d = fan_mount_nut_diameter);
            }
    }
}

// Helper module to create a stadium/pill shape
module stadium_shape(length, width) {
    hull() {
        translate([length/2 - width/2, 0, 0])
            circle(d = width);
        translate([-length/2 + width/2, 0, 0])
            circle(d = width);
    }
}

// ===== RENDER =====
if (cutaway) {
    // Render a cutaway view for checking internal structure
    difference() {
        intake_adapter();
        translate([-200, 0, -10])
            cube([400, 400, 400]);
    }
} else {
    // Render the complete model
    intake_adapter();
}