UCSF Thesis LaTeX Style
=======================
UCSF is extremely particular about how theses are formatted.  If you don't want 
to go back and forth fixing stupid style details, just use this LaTeX document 
class.

Installation
------------
Install the ``ucsfthesis`` LaTeX document class:

    $ git clone https://github.com/kalekundert/ucsfthesis.git
    $ cd ucsfthesis
    $ make install

You can also uninstall the document class:

    $ make uninstall

The above repository contains blank forms and a demo LaTeX file, which you can 
use to test the installation:

    $ cd demo
    $ pdflatex demo.tex

Usage
-----
- Make a directory for your thesis:

      $ mkdir ~/my_thesis
      $ cd !$

- Make a "forms" directory:

      $ mkdir forms

- Sign and scan the publishing agreement, then move/link it into the forms 
  directory:

      $ mv ... forms/publishing_agreement.pdf

- Fill out the title page, then move/link in into the forms directory:

      $ mv ... forms/title_page.pdf

  Ultimately you'll have to get your comittee to sign the title page, too...  
  That's the hard part...

- Make a new LaTeX file:

      \documentclass[copyright]{ucsfthesis}

      \usepackage{blindtext}

      \begin{document}

      \frontmatter

      \ucsftableofcontents

      \mainmatter

      \blinddocument

      \end{document}

- Compile it!

      $ pdflatex my_thesis.tex

The document will contain instructions on how to fill out all the expected 
parameters.
