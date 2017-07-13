# LCLUC_presentation
Presentation materials for LCLUC training

Lectures are available as PDF or as org-mode source (see http://orgmode.org/
for more details of how to compile this to a PDF)

Individual markdown files for lectures 1 and 2 are made available.  These can be compiled to PDF with [Pandoc](https://pandoc.org/) using the command

```pandoc -t beamer --filter column_filter.py LCLUC_training_L1.md -o lec1.pdf ```

```pandoc -t beamer --filter column_filter.py LCLUC_training_L2.md -o lec2.pdf ```

The [R](https://www.r-project.org/) scripts in the practical materials are made available by and are
copyright of Dr Alexander Archibald, University of Cambridge.  Please contact
him before redistributing.

The [Jupyter](https://anaconda.org/anaconda/jupyter) notebooks are made available and are copyright of Dr Paul
Griffiths, please contact me before distributing using the contact details available through this site.
