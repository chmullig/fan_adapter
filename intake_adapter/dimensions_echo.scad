include <intake_adapter.scad>

echo("==== DIMENSIONS ANALYSIS ====");
echo(str("Fan size: ", fan_size, "mm"));
echo(str("Slot dimensions: ", slot_length, "mm x ", slot_width, "mm"));
echo(str("Flange thickness: ", flange_thickness, "mm"));
echo(str("Flange width (narrow side): ", flange_width_narrow, "mm"));
echo(str("Flange width (wide sides): ", flange_width_wide, "mm"));
echo(str("Flange width (front side): ", flange_width_front, "mm"));
echo(str("Mounting holes on narrow side distance from slot edge: ", flange_width_narrow/2, "mm"));
echo(str("Mounting holes on wide sides distance from slot edge: ", flange_width_wide/2, "mm"));
echo(str("Mounting holes on front side distance from slot edge: ", flange_width_front/2, "mm"));
echo(str("Cabinet mount hole diameter: ", cabinet_mount_hole_diameter, "mm"));
echo(str("Cabinet mount head diameter: ", cabinet_mount_head_diameter, "mm"));
echo(str("Current adapter height: ", fan_size * sin(adapter_angle) + fan_thickness * cos(adapter_angle) - 20, "mm"));
echo(str("Current adapter angle: ", adapter_angle, " degrees"));

// Don't render anything
cube(0);