# OpenSCAD Intake Fan Adapter Project

This project contains OpenSCAD designs for 3D printable fan adapters for a media console cabinet to improve airflow.

## Using the Makefile

The Makefile provides an easy way to generate STL files for 3D printing and PNG renders for visualization.

## Requirements

- OpenSCAD
- BOSL2 library
- GNU Make

## Design Process

You can run the OpenSCAD CLI to test the code.  `/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD DESIGN.scad -o DESIGN.stl` or render it to a PNG with `/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD DESIGN.scad --viewall --render -o DESIGN.png`

You *must* render, visualize, and analyze multiple views of the design to verify that it is correct. Rendering the design from multiple angles will help you identify any potential issues with the design before printing, such as incorrect dimensions, misalignments, impossible to 3D print shapes, poor airflow, and other problems. This is especially important for complex designs with multiple components or features.
