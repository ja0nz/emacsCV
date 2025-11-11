{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/packages/
  packages = with pkgs; [ git tectonic ];

  # https://devenv.sh/languages/
  languages.texlive.enable = true;
}
