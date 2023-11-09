# Image Grid Generator

This script generates a 2560x1600 image with a specified background color, overlaid with a white 100px grid and an additional 50% opacity 50px grid.

## Prerequisites

To run this script, you'll need to have Nix installed on your system as it relies on a Nix environment to ensure all dependencies are available.

If you do not have Nix installed, please follow the installation instructions on the [Nix website](https://nixos.org/download.html).

## Setting Up the Environment

The project includes a `shell.nix` file that declares ImageMagick as a dependency.

To set up the environment, run:

```bash
nix-shell
```

This command will download and install ImageMagick within the Nix environment.

## Running the Script

After entering the Nix environment, you can run the script as follows:

```bash
./mkbackground.sh
```

The script will generate an image named `background.png` in the current directory.

## Script Customization

You can modify the script parameters for the background color, line color, and grid opacity by editing the respective variables within the `mkbackground.sh` file.

## License

This project is provided under the MIT License. See the LICENSE file for the full text.

## Author

Created by Matthew Fallshaw (with GPT-4)
