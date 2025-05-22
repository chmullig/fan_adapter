# OpenSCAD Fan and Intake Adapter Makefile
# This file contains commands to generate various STL models and render images

OPENSCAD=/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
RESOLUTION=200
COMMON_RENDER_ARGS=--viewall --render --colorscheme "Sunset"

# Main design files
DESIGN_FILES=intake_adapter.scad intake_adapter_v2.scad
DESIGN_BASE=$(basename $(DESIGN_FILES))

# Default target builds everything
all: stl renders

# Build STL files for 3D printing
stl: intake_adapter_60mm.stl intake_adapter_80mm.stl intake_adapter_v2_60mm.stl intake_adapter_v2_80mm.stl

# Build PNG renders for visualization
renders: intake_adapter_80mm.png intake_adapter_60mm.png \
         intake_adapter_80mm_side.png intake_adapter_60mm_side.png \
         intake_adapter_80mm_bottom.png intake_adapter_60mm_bottom.png \
         intake_adapter_v2_80mm.png intake_adapter_v2_60mm.png \
         intake_adapter_v2_80mm_side.png intake_adapter_v2_60mm_side.png \
         intake_adapter_v2_80mm_bottom.png intake_adapter_v2_60mm_bottom.png

# 80mm fan adapter STL
intake_adapter_80mm.stl: intake_adapter.scad
	$(OPENSCAD) -o $@ -D "fan_size=80" $<

# 60mm fan adapter STL
intake_adapter_60mm.stl: intake_adapter.scad
	$(OPENSCAD) -o $@ -D "fan_size=60" $<

# V2 80mm fan adapter STL
intake_adapter_v2_80mm.stl: intake_adapter_v2.scad
	$(OPENSCAD) -o $@ -D "fan_size=80" $<

# V2 60mm fan adapter STL
intake_adapter_v2_60mm.stl: intake_adapter_v2.scad
	$(OPENSCAD) -o $@ -D "fan_size=60" $<

# Standard renders (top view)
intake_adapter_80mm.png: intake_adapter.scad
	$(OPENSCAD) -o $@ $(COMMON_RENDER_ARGS) --camera=0,0,0,55,0,25,140 --imgsize=1920,1080 -D "fan_size=80" -D "\$$fn=$(RESOLUTION)" $<

intake_adapter_60mm.png: intake_adapter.scad
	$(OPENSCAD) -o $@ $(COMMON_RENDER_ARGS) --camera=0,0,0,55,0,25,120 --imgsize=1920,1080 -D "fan_size=60" -D "\$$fn=$(RESOLUTION)" $<

intake_adapter_v2_80mm.png: intake_adapter_v2.scad
	$(OPENSCAD) -o $@ $(COMMON_RENDER_ARGS) --camera=0,0,0,55,0,25,140 --imgsize=1920,1080 -D "fan_size=80" -D "\$$fn=$(RESOLUTION)" $<

intake_adapter_v2_60mm.png: intake_adapter_v2.scad
	$(OPENSCAD) -o $@ $(COMMON_RENDER_ARGS) --camera=0,0,0,55,0,25,120 --imgsize=1920,1080 -D "fan_size=60" -D "\$$fn=$(RESOLUTION)" $<

# Side view renders
intake_adapter_80mm_side.png: intake_adapter.scad
	$(OPENSCAD) -o $@ $(COMMON_RENDER_ARGS) --camera=0,100,0,90,0,0,140 --imgsize=1920,1080 -D "fan_size=80" -D "\$$fn=$(RESOLUTION)" $<

intake_adapter_60mm_side.png: intake_adapter.scad
	$(OPENSCAD) -o $@ $(COMMON_RENDER_ARGS) --camera=0,100,0,90,0,0,120 --imgsize=1920,1080 -D "fan_size=60" -D "\$$fn=$(RESOLUTION)" $<

intake_adapter_v2_80mm_side.png: intake_adapter_v2.scad
	$(OPENSCAD) -o $@ $(COMMON_RENDER_ARGS) --camera=0,100,0,90,0,0,140 --imgsize=1920,1080 -D "fan_size=80" -D "\$$fn=$(RESOLUTION)" $<

intake_adapter_v2_60mm_side.png: intake_adapter_v2.scad
	$(OPENSCAD) -o $@ $(COMMON_RENDER_ARGS) --camera=0,100,0,90,0,0,120 --imgsize=1920,1080 -D "fan_size=60" -D "\$$fn=$(RESOLUTION)" $<

# Bottom view renders
intake_adapter_80mm_bottom.png: intake_adapter.scad
	$(OPENSCAD) -o $@ $(COMMON_RENDER_ARGS) --camera=0,0,-100,0,0,0,140 --imgsize=1920,1080 -D "fan_size=80" -D "\$$fn=$(RESOLUTION)" $<

intake_adapter_60mm_bottom.png: intake_adapter.scad
	$(OPENSCAD) -o $@ $(COMMON_RENDER_ARGS) --camera=0,0,-100,0,0,0,120 --imgsize=1920,1080 -D "fan_size=60" -D "\$$fn=$(RESOLUTION)" $<

intake_adapter_v2_80mm_bottom.png: intake_adapter_v2.scad
	$(OPENSCAD) -o $@ $(COMMON_RENDER_ARGS) --camera=0,0,-100,0,0,0,140 --imgsize=1920,1080 -D "fan_size=80" -D "\$$fn=$(RESOLUTION)" $<

intake_adapter_v2_60mm_bottom.png: intake_adapter_v2.scad
	$(OPENSCAD) -o $@ $(COMMON_RENDER_ARGS) --camera=0,0,-100,0,0,0,120 --imgsize=1920,1080 -D "fan_size=60" -D "\$$fn=$(RESOLUTION)" $<

# Cutaway view for checking internal structure
cutaway: intake_adapter_80mm_cutaway.png intake_adapter_60mm_cutaway.png intake_adapter_v2_80mm_cutaway.png intake_adapter_v2_60mm_cutaway.png

intake_adapter_80mm_cutaway.png: intake_adapter.scad
	$(OPENSCAD) -o $@ $(COMMON_RENDER_ARGS) --camera=50,50,50,55,0,25,140 --imgsize=1920,1080 -D "fan_size=80" -D "\$$fn=$(RESOLUTION)" -D "cutaway=true" $<

intake_adapter_60mm_cutaway.png: intake_adapter.scad
	$(OPENSCAD) -o $@ $(COMMON_RENDER_ARGS) --camera=50,50,50,55,0,25,120 --imgsize=1920,1080 -D "fan_size=60" -D "\$$fn=$(RESOLUTION)" -D "cutaway=true" $<
	
intake_adapter_v2_80mm_cutaway.png: intake_adapter_v2.scad
	$(OPENSCAD) -o $@ $(COMMON_RENDER_ARGS) --camera=50,50,50,55,0,25,140 --imgsize=1920,1080 -D "fan_size=80" -D "\$$fn=$(RESOLUTION)" -D "cutaway=true" $<

intake_adapter_v2_60mm_cutaway.png: intake_adapter_v2.scad
	$(OPENSCAD) -o $@ $(COMMON_RENDER_ARGS) --camera=50,50,50,55,0,25,120 --imgsize=1920,1080 -D "fan_size=60" -D "\$$fn=$(RESOLUTION)" -D "cutaway=true" $<

# Clean up generated files
clean:
	rm -f *.stl *.png

.PHONY: all stl renders cutaway clean