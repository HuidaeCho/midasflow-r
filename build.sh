#!/bin/sh
# https://posit-dev.github.io/air/
air format . inst/CITATION
echo "devtools::document()" | Rscript -
pkg="midasflow_$(sed '/Version/!d; s/.* //' DESCRIPTION).tar.gz"
R CMD build .
R CMD check $pkg
R CMD INSTALL $pkg
