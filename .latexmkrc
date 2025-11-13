# Use XeLaTeX
$xelatex = 'xelatex -interaction=nonstopmode -shell-escape %O %S';

# Default to PDF mode
$pdf_mode = 1;

# Output directory
$out_dir = 'build';

# Clean-up settings (remove intermediates on clean)
$clean_ext = "aux bbl blg log toc out lof lot fls fdb_latexmk synctex.gz";

# Enable automatic reruns if necessary
$recorder = 1;

