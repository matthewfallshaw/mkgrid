#!/usr/bin/env bash

# Usage: ./this_script.sh width height main_grid_size sub_grid_factor background_color line_color
# Example: ./this_script.sh 1920 1080 100 2 "rgb(0,77,129)" "white"

# Get script parameters
width=${1:-2560}
height=${2:-1600}
main_grid_size=${3:-100}
sub_grid_factor=${4:-2} # Sub-grid factor relative to main grid (0.5, 1, 2, etc.)
background_color=${5:-"rgb(0,77,129)"}
line_color=${6:-"white"}
alpha=${7:-0.5} # Alpha value for sub grid lines
strokewidth=${8:-1}
sub_grid_size=$(( main_grid_size / sub_grid_factor ))

current_step=0
total_main_lines=$(( (width / main_grid_size + (height / main_grid_size)) * 2 - 4 ))
total_sub_lines=$(( (width / sub_grid_size + (height / sub_grid_size)) * 2 * (sub_grid_factor - 1) / sub_grid_factor - 4 ))
total_steps=$(( total_main_lines + total_sub_lines ))

# Check for ImageMagick's 'convert' command
if ! command -v convert &>/dev/null; then
    echo "convert command not found. Please ensure ImageMagick is installed or run 'nix-shell' if you are using a Nix environment."
    exit 1
fi

# Function to draw the grid, skipping lines that overlap with the main grid
function draw_grid() {
    local -i size=$1
    local color=$2
    local -i increment=$size
    local -i skip_factor=$3
    local -i strokewidth=$4

    local commands=()

    # Draw vertical lines
    for ((i = increment; i < width; i += increment)); do
        (( skip_factor > 0 && i % (increment * skip_factor) == 0 )) && continue
        commands+=("-draw")
        commands+=("line $i,0 $i,$height")
    done

    # Draw horizontal lines
    for ((i = increment; i < height; i += increment)); do
        (( skip_factor > 0 && i % (increment * skip_factor) == 0 )) && continue
        commands+=("-draw")
        commands+=("line 0,$i $width,$i")
    done

    draw_lines "${commands[@]}"
}

function draw_lines() {
    convert background.png -fill none -stroke "$color" -strokewidth "$strokewidth" "$@"
    update_progress $#
}

function convert_rgb_to_rgba() {
    local rgb_color=$1
    local alpha_value=$2
    # Replace 'rgb' with 'rgba' and append the alpha value before the closing parenthesis
    local rgba_color
    rgba_color=$(echo "$rgb_color" | sed -e 's/rgb/rgba/' -e "s/)/,${alpha_value})/")
    echo "$rgba_color"
}

# Function to draw a progress bar
function draw_progress_bar() {
    local -i step=$1
    local -i total=$2
    local -i percentage=$((step * 100 / total))
    local -i bar_length=50
    local -i filled_length=$((percentage * bar_length / 100))
    local bar
    bar=$(printf "%-${bar_length}s" "=")
    echo -ne "\r[${bar:0:$filled_length}$(printf ' %.0s' $(seq $filled_length $bar_length))] $percentage% completed"
}

# Function to update progress and draw the progress bar
function update_progress() {
    ((current_step++))
    draw_progress_bar $current_step $total_steps
}

# Create a background image
convert -size "${width}x${height}" xc:"$background_color" background.png

# Draw the main grid
draw_grid $main_grid_size "$line_color" 0 $strokewidth

# Draw the 50px grid with 50% opacity
# Convert line color to RGBA with 0.5 alpha for sub grid
rgba_line_color=$(convert_rgb_to_rgba "$line_color" $alpha)

draw_grid $sub_grid_size "$rgba_line_color" $sub_grid_factor

echo # Move to a new line after progress bar completion

echo "Image generated as background.png"
echo "$line_color || $alpha || $rgba_line_color || "