{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/packages/
  packages = with pkgs; [ git tectonic git-secret ];

  # https://devenv.sh/languages/
  languages.texlive.enable = true;

  # https://devenv.sh/tasks/
  # Usage: devenv tasks run build
  tasks = {
    "build:tex" = {
      exec = "emacs --batch -Q --load $DEVENV_ROOT/export-cv.el";
      description = "Build from org-mode to tex";
    };
    "build:pdf" = {
      exec = "tectonic -X build";
      after = [ "build:tex" ];
      description = "Build from tex to pdf";
    };
  };

  # https://devenv.sh/scripts/
  scripts = {
    # Usage: o2t *.org
    # Usage: o2t
    "o2t" = {
      exec = "emacs --batch -Q --load $DEVENV_ROOT/export-cv.el $1";
      description = "Quick: Build from org-mode to tex";
    };
    # Usage: t2p *.tex 
    "t2p" = {
      exec = ''
        set -e
        input="$1"
        base=$(basename "$input" .tex)
        output_dir="$DEVENV_ROOT/build/$base"
        mkdir -p "$output_dir"
        tectonic "$input" -o "$output_dir"
      '';
      description = "Quick: Build from tex to pdf";
    };
  };
}
