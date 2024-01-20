import argparse
import webcolors
from PIL import Image, ImageDraw
from typing import Tuple, Optional

# Parse command-line arguments using argparse
def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Generate a grid image.")
    parser.add_argument("width", type=int, nargs="?", default=3600, help="Width of the image")
    parser.add_argument("height", type=int, nargs="?", default=3600, help="Height of the image")
    parser.add_argument("main_grid_size", type=int, nargs="?", default=300, help="Size of the main grid")
    parser.add_argument("sub_grid_factor", type=int, nargs="?", default=3, help="Factor for sub-grid size")
    parser.add_argument("background_color", type=str, nargs="?", default="white", help="Background color")
    parser.add_argument("background_alpha", type=float, nargs="?", default=1.0, help="Transparency for background")
    parser.add_argument("line_color", type=str, nargs="?", default="black", help="Line color")
    parser.add_argument("line_alpha", type=float, nargs="?", default=0.6, help="Transparency for sub-grid lines")
    parser.add_argument("strokewidth", type=int, nargs="?", default=4, help="Width for main grid lines")
    return parser.parse_args()

# Validate and convert color
def validate_and_convert_color(color: str, alpha: Optional[float] = None) -> Tuple[int, int, int, int]:
    try:
        # Handle RGB string
        if color.startswith("rgb(") and color.endswith(")"):
            rgb_values = [int(value.strip()) for value in color[4:-1].split(',')]
            if len(rgb_values) != 3:
                raise ValueError("RGB color must have exactly three components")
            rgb_tuple = tuple(rgb_values)
        else:
            # Convert named color to RGB
            rgb = webcolors.name_to_rgb(color)
            rgb_tuple = (rgb.red, rgb.green, rgb.blue)

        # Handle alpha component
        alpha_value = int(255 * alpha) if alpha is not None else 255
        return (rgb_tuple[0], rgb_tuple[1], rgb_tuple[2], alpha_value)

    except ValueError as e:
        valid_color_names = list(webcolors.CSS3_NAMES_TO_HEX)
        raise ValueError(f"Invalid color name '{color}'. Valid color names are: {', '.join(valid_color_names)}") from e

# Convert RGB tuple to a color string for PIL
def rgb_to_color_string(rgb: Tuple[int, int, int]) -> str:
    return f"rgb({rgb[0]},{rgb[1]},{rgb[2]})"

# Draw the grid
def draw_grid(image: Image.Image, size: int, color: Tuple[int, int, int, int], stroke: int):
    draw = ImageDraw.Draw(image)
    for i in range(size, image.width, size):
        draw.line((i, 0, i, image.height), fill=color, width=stroke)
    for i in range(size, image.height, size):
        draw.line((0, i, image.width, i), fill=color, width=stroke)

# Main function
def main():
    args = parse_args()

    # Validate and convert background color (opaque) and line color (with alpha for subgrid)
    background_rgba = validate_and_convert_color(args.background_color, args.background_alpha)
    subgrid_rgba = validate_and_convert_color(args.line_color, args.line_alpha)
    main_grid_rgba = validate_and_convert_color(args.line_color)  # Opaque for main grid

    # Create the background image
    background: Image.Image = Image.new("RGBA", (args.width, args.height), background_rgba)

    # Draw the sub-grid directly onto the background
    draw_grid(background, args.main_grid_size // args.sub_grid_factor, subgrid_rgba, 3)

    # Draw the main grid on the background (opaque)
    draw_grid(background, args.main_grid_size, main_grid_rgba, args.strokewidth)

    background.save("background.png")
    print("Image generated as background.png")

if __name__ == "__main__":
    main()