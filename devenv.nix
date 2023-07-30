{ pkgs, ... }:

{
  dotenv.enable = true;

  # https://devenv.sh/packages/
  packages = [ 
    pkgs.hugo
    pkgs.imagemagick
    pkgs.envchain
  ];
}
