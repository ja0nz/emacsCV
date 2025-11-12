{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/packages/
  packages = with pkgs; [ git tectonic git-secret ];

  # https://devenv.sh/languages/
  languages.texlive.enable = true;

  # https://devenv.sh/scripts/
  # 
  scripts = {
    # Usage: org2tex cv/*.org
    # Usage: org2tex
    "org2tex" = {
      exec = "emacs --batch -Q --load $DEVENV_ROOT/export-cv.el $1";
      description = "Build from org-mode to tex";
    };
  };
}
