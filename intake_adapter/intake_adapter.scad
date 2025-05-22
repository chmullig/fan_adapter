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
fan_frame_width = fan_size;  // Noctua fans have a square frame

// Slot parameters
slot_width = 19.05;  // 3/4 inch
slot_length = fan_size + 20;  // Slightly longer than the fan diameter
slot_radius = slot_width / 2;  // Radius for the rounded ends

// Adapter parameters
adapter_angle = 70;  // Angle at which the fan is tilted (increased for much shorter height)
wall_thickness = 2.5;  // Minimum wall thickness
flange_thickness = 2.5;  // Reduced thickness of the flange for shorter height

// Asymmetric flange dimensions
flange_width_narrow = 2;  // Width of narrow side (near wall) - approximately 1/16"
flange_width_wide = 10;   // Width of the wider sides
flange_width_front = 8;   // Width of the front side (opposite to wall)

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
            
            // Add reinforcement ribs
            reinforcement_ribs();
        }
        
        // Subtract the inner air channel
        air_channel();
        
        // Subtract the mounting holes
        mounting_holes();
    }
}

// Flange that attaches to the cabinet with asymmetric width
module flange() {
    // Create the asymmetric flange shape
    linear_extrude(height = flange_thickness) {
        difference() {
            // Outer shape - custom asymmetric flange
            asymmetric_flange_shape();
            
            // Inner cutout - the actual slot
            stadium_shape(slot_length, slot_width);
        }
    }
}

// Create asymmetric flange outline shape
module asymmetric_flange_shape() {
    hull() {
        // Top side - narrow (wall side)
        translate([0, slot_width/2 + flange_width_narrow/2, 0])
            scale([slot_length + 2*flange_width_wide, flange_width_narrow, 1])
            circle(d=1);
            
        // Bottom side - wider
        translate([0, -slot_width/2 - flange_width_front/2, 0])
            scale([slot_length + 2*flange_width_wide, flange_width_front, 1])
            circle(d=1);
            
        // Left side
        translate([-slot_length/2 - flange_width_wide/2, 0, 0])
            scale([flange_width_wide, slot_width + flange_width_narrow + flange_width_front, 1])
            circle(d=1);
            
        // Right side
        translate([slot_length/2 + flange_width_wide/2, 0, 0])
            scale([flange_width_wide, slot_width + flange_width_narrow + flange_width_front, 1])
            circle(d=1);
    }
}

// Main body of the adapter that transitions from slot to fan
module adapter_body() {
    // Calculate the height of the adapter based on the angle and fan size
    // Using a reduced height to make the adapter much shorter
    adapter_height = fan_size * sin(adapter_angle) + fan_thickness * cos(adapter_angle) - 20;
    
    // Use hull to create a smooth transition from slot to fan
    hull() {
        // Bottom shape (at the flange)
        translate([0, 0, flange_thickness - 0.01])
            linear_extrude(height = 0.01)
            offset(r = wall_thickness) 
            stadium_shape(slot_length, slot_width);
        
        // Top shape (at the fan) - square with rounded corners for Noctua fan
        translate([0, 0, adapter_height])
            rotate([adapter_angle, 0, 0])
            linear_extrude(height = 0.01)
            rounded_square(fan_frame_width + 2 * wall_thickness, fan_frame_width + 2 * wall_thickness, 3);
    }
}

// The inner air channel
module air_channel() {
    // Calculate the height of the adapter based on the angle and fan size
    // Using a reduced height to make the adapter much shorter
    adapter_height = fan_size * sin(adapter_angle) + fan_thickness * cos(adapter_angle) - 20;
    
    // Use hull to create a smooth inner transition
    hull() {
        // Bottom shape (at the flange)
        translate([0, 0, flange_thickness - 0.01])
            linear_extrude(height = 0.01)
            stadium_shape(slot_length, slot_width);
        
        // Top shape (at the fan) - circular airflow path
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

// Add subtle reinforcement ribs that maintain an airtight seal
module reinforcement_ribs() {
    // Define rib parameters
    rib_height = 3;  // Height of rib (same as flange thickness)
    rib_width = 2;   // Width of rib base
    rib_length = 15; // Length of each rib
    
    // Location of mounting holes
    mount_positions = [
        [slot_length/2 + flange_width_wide/2, -slot_width/2 - flange_width_front/2, 0],  // Front-right
        [-slot_length/2 - flange_width_wide/2, -slot_width/2 - flange_width_front/2, 0], // Front-left
        [slot_length/2 + flange_width_wide/2, slot_width/2 + flange_width_narrow/2, 0],  // Back-right
        [-slot_length/2 - flange_width_wide/2, slot_width/2 + flange_width_narrow/2, 0]  // Back-left
    ];
    
    // Create reinforcement ribs for each mounting hole, except narrow side
    for (i = [0, 1]) {  // Only for the front (wider) side
        pos = mount_positions[i];
        
        // Angle of rib pointing toward center
        angle = atan2(pos[1], pos[0]) + 180;
        
        // Create a triangular rib that stays within the flange
        translate(pos) {
            rotate([0, 0, angle]) {
                translate([-rib_length/2, -rib_width/2, 0])
                linear_extrude(height = rib_height)
                polygon([
                    [0, 0],                  // Point at screw hole
                    [rib_length, 0],         // Extended along flange
                    [rib_length, rib_width], // Width of rib
                    [0, rib_width]           // Back to start
                ]);
            }
        }
    }
    
    // Side ribs (along the sides of the flange)
    side_rib_length = slot_width + flange_width_narrow/2 + flange_width_front/2;
    side_rib_width = 4;
    side_rib_offset = 5; // Offset from the edge of the slot
    
    // Left side rib
    translate([-slot_length/2 - side_rib_offset, 0, 0])
    rotate([0, 0, 90])
    linear_extrude(height = rib_height)
    polygon([
        [-side_rib_length/2, 0],
        [side_rib_length/2, 0],
        [side_rib_length/2, side_rib_width],
        [-side_rib_length/2, side_rib_width]
    ]);
    
    // Right side rib
    translate([slot_length/2 + side_rib_offset, 0, 0])
    rotate([0, 0, 90])
    linear_extrude(height = rib_height)
    polygon([
        [-side_rib_length/2, 0],
        [side_rib_length/2, 0],
        [side_rib_length/2, side_rib_width],
        [-side_rib_length/2, side_rib_width]
    ]);
}

// Mounting holes for both fan and cabinet
module mounting_holes() {
    // Cabinet mounting holes in the flange (asymmetric placement)
    cabinet_mount_positions = [
        [slot_length/2 + flange_width_wide/2, -slot_width/2 - flange_width_front/2, 0],  // Front-right
        [-slot_length/2 - flange_width_wide/2, -slot_width/2 - flange_width_front/2, 0], // Front-left
        [slot_length/2 + flange_width_wide/2, slot_width/2 + flange_width_narrow/2, 0],  // Back-right
        [-slot_length/2 - flange_width_wide/2, slot_width/2 + flange_width_narrow/2, 0]  // Back-left
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
    
    // Fan mounting holes for square fan frame
    // Using a reduced height to make the adapter much shorter
    adapter_height = fan_size * sin(adapter_angle) + fan_thickness * cos(adapter_angle) - 20;
    fan_mount_positions = [
        [fan_mount_spacing/2, fan_mount_spacing/2, 0],   // Top-right
        [fan_mount_spacing/2, -fan_mount_spacing/2, 0],  // Bottom-right
        [-fan_mount_spacing/2, fan_mount_spacing/2, 0],  // Top-left
        [-fan_mount_spacing/2, -fan_mount_spacing/2, 0]  // Bottom-left
    ];
    
    translate([0, 0, adapter_height])
        rotate([adapter_angle, 0, 0]) {
            // Add support platform for the fan (sits flush against the fan)
            difference() {
                translate([0, 0, -fan_thickness/2])
                    linear_extrude(height = 0.01)
                    difference() {
                        rounded_square(fan_frame_width, fan_frame_width, 3);
                        circle(d = fan_inner_diameter);
                    }
                
                // Remove support in areas where the heat-set nuts go
                for (pos = fan_mount_positions) {
                    translate(pos)
                        translate([0, 0, -fan_thickness/2 - 0.1])
                        cylinder(h = 1, d = fan_mount_nut_diameter + 1);
                }
            }
            
            // Create the actual mounting holes with heat-set nut pockets
            for (pos = fan_mount_positions) {
                translate(pos) {
                    // Screw hole through adapter
                    cylinder(h = fan_thickness + wall_thickness * 2, 
                             d = fan_mount_hole_diameter, 
                             center = true);
                    
                    // Heat-set nut pocket (bottom side)
                    translate([0, 0, -fan_thickness/2 - fan_mount_nut_depth/2])
                        cylinder(h = fan_mount_nut_depth, 
                                 d = fan_mount_nut_diameter);
                    
                    // Tapered entry for heat-set nut
                    translate([0, 0, -fan_thickness/2 + fan_mount_nut_depth/2])
                        cylinder(h = 1, 
                                 d1 = fan_mount_nut_diameter, 
                                 d2 = fan_mount_hole_diameter);
                }
            }
        }
}

// Helper module to create a rounded square shape for the fan frame
module rounded_square(width, height, radius) {
    hull() {
        translate([width/2 - radius, height/2 - radius, 0])
            circle(r = radius);
        translate([-width/2 + radius, height/2 - radius, 0])
            circle(r = radius);
        translate([width/2 - radius, -height/2 + radius, 0])
            circle(r = radius);
        translate([-width/2 + radius, -height/2 + radius, 0])
            circle(r = radius);
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