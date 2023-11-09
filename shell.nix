{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.imagemagick
  ];

  # Set any environment variables if needed
  # environment = {
  #   EXAMPLE_VAR = "value";
  # };
}
