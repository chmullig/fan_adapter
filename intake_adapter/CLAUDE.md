# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
This is an OpenSCAD project for designing 3D-printable fan adapters for a media console cabinet to improve airflow. The project focuses on creating parametric designs for intake fan adapters that can be mounted inside a cabinet.

## Development Environment

### Required Software
- OpenSCAD - The primary design tool
- BOSL2 library for OpenSCAD
- GNU Make (for build automation)

### Common Commands

#### Rendering and Exporting Designs
- Generate STL file: `/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD DESIGN.scad -o DESIGN.stl`
- Render PNG preview: `/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD DESIGN.scad --viewall --render -o DESIGN.png`

#### Using the Makefile
The project includes a Makefile to simplify common operations. When new OpenSCAD files are created, they should be added to the Makefile.

## Design Guidelines

### Key Parameters
- Fan sizes: 60mm and 80mm (configurable)
- Wall thickness: 2.5mm minimum for structural integrity
- Fan mounting: M4 heat-set nuts (6mm hole diameter, 5mm depth)
- Cabinet mounting: #8 wood screws (4.16mm shaft, 8.33mm head diameter)

### Design Process
1. Start with basic shapes and gradually refine
2. Render multiple views to verify designs before finalizing
3. Check for manufacturing feasibility (3D printing constraints)
4. Ensure smooth internal transitions for optimal airflow
5. Verify all dimensions and clearances

### Quality Requirements
- Validate designs by rendering multiple views
- Check for geometric errors or inconsistencies
- Verify hardware mounting clearances
- Ensure the design meets airflow requirements

## Project-Specific Design Constraints
- The adapter connects fans to intake/outlet slots in a media cabinet
- Critical to maintain proper airflow while accommodating physical constraints
- Designs must allow for cable routing through the adapter
- Fan placement must work around existing cabinet structures

## Version Control
- Document each design iteration with comments and version numbers
- Include renders from multiple angles to verify design correctness
- Use descriptive commit messages that explain design changes and rationale