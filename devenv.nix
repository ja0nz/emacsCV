{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/packages/
  packages = with pkgs; [ git tectonic git-secret ];

  # https://devenv.sh/languages/
  languages.texlive = {
    enable = true;
    base = pkgs.texliveFull;
  };

  # https://devenv.sh/tasks/
  # Usage: devenv tasks run build
  tasks = {
    "build:tex" = {
      exec = "emacs --batch -Q --load $DEVENV_ROOT/export-cv.el";
      description = "Build from org-mode to tex";
    };
    "build:pdf" = {
      exec = "bash $DEVENV_ROOT/build-tectonic.sh";
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
      exec = ./build-tectonic.sh;
      description = "Tectonic: Build from tex to pdf";
    };
    # Usage: tt2p *.tex
    "tt2p" = {
      exec = ./build-latexmk.sh;
      description = "Latexmk: Build from tex to pdf";
    };
    "showlatest" = {
      exec = ''
        shopt -s nullglob
        # Find all PDFs recursively and pick the newest one
        newest_pdf=$(find build -type f -iname '*.pdf' -printf '%T@ %p\n' | sort -nr | head -n1 | cut -d' ' -f2-)
        if [[ -n "$newest_pdf" ]]; then
            echo "Opening newest PDF: $newest_pdf"
            xdg-open "$newest_pdf"
        else
            echo "No PDF found in build/"
        fi
      '';
      description = "Show latest pdf in build/";
    };
  };
}
