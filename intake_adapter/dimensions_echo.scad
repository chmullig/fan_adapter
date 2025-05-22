include <intake_adapter.scad>

echo("==== DIMENSIONS ANALYSIS ====");
echo(str("Fan size: ", fan_size, "mm"));
echo(str("Slot dimensions: ", slot_length, "mm x ", slot_width, "mm"));
echo(str("Flange width: ", flange_width, "mm"));
echo(str("Flange thickness: ", flange_thickness, "mm"));
echo(str("Flange outer dimensions: ", slot_length+2*flange_width, "mm x ", slot_width+2*flange_width, "mm"));
echo(str("Mounting holes distance from slot edge: ", flange_width/2, "mm"));
echo(str("Distance between mounting holes in X: ", slot_length+flange_width, "mm"));
echo(str("Distance between mounting holes in Y: ", slot_width+flange_width, "mm"));
echo(str("Cabinet mount hole diameter: ", cabinet_mount_hole_diameter, "mm"));
echo(str("Cabinet mount head diameter: ", cabinet_mount_head_diameter, "mm"));

// Don't render anything
cube(0);