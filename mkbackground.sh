#!/bin/bash

# Define dimensions
width=2560
height=1600

# Define colors
background_color="rgb(0,77,129)"
line_color="white"

# Create a background image
convert -size ${width}x${height} xc:$background_color background.png

# Draw the 100px grid
for ((i = 100; i < $width; i+=100)); do
   convert background.png -fill none -stroke $line_color -draw "line $i,0 $i,$height" background.png
done

for ((i = 100; i < $height; i+=100)); do
   convert background.png -fill none -stroke $line_color -draw "line 0,$i $width,$i" background.png
done

# Draw the 50px grid with 50% opacity
for ((i = 50; i < $width; i+=50)); do
   convert background.png -fill none -stroke "rgba(255, 255, 255, 0.5)" -draw "line $i,0 $i,$height" background.png
done

for ((i = 50; i < $height; i+=50)); do
   convert background.png -fill none -stroke "rgba(255, 255, 255, 0.5)" -draw "line 0,$i $width,$i" background.png
done
