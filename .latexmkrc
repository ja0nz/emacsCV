# Use XeLaTeX
$xelatex = 'xelatex -interaction=nonstopmode -shell-escape %O %S';

# Default to PDF mode
$pdf_mode = 1;

# Output directory
$out_dir = 'build';

# TEXINPUTS: include src directory for classes/packages
$ENV{'TEXINPUTS'} = "src:" . ($ENV{'TEXINPUTS'} // '');
# TEXINPUTS: this awesome-cv.cls take precedence
$ENV{'TEXINPUTS'} = "lib/Awesome-CV:" . ($ENV{'TEXINPUTS'} // '');

# Clean-up settings (remove intermediates on clean)
$clean_ext = "aux bbl blg log toc out lof lot fls fdb_latexmk synctex.gz";

# Enable automatic reruns if necessary
$recorder = 1;

