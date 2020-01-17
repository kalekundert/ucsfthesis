\ProvidesClass{ucsfthesis}[2018/03/29 UCSF Thesis]
\LoadClass[letterpaper,11pt,oneside,openany]{book}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Related to the UCSF style (I think)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Programming tools geared primarily towards LaTeX class and package authors.
\RequirePackage{etoolbox}
\RequirePackage{xifthen}

% Add a class option to have a copyright page.
\newtoggle{ucsfcopyright}
\DeclareOption{copyright}{\toggletrue{ucsfcopyright}}
\ProcessOptions\relax

% Add commands to specify everything that needs to be in the front matter.
\newcommand{\ucsf@title}{%
Use \textbackslash{}title\{...\} to specify the title of your thesis.
}
\newcommand{\ucsf@author}{%
Use \textbackslash{}author\{...\} to specify your name.
}
\newcommand{\ucsf@abstract}{%
Use \textbackslash{}abstract\{...\} to specify an abstract of 350 words or 
fewer.
}
\newcommand{\ucsf@epigraph@text}{%
Use \textbackslash{}epi\{...\}\{source\} to specify an epigraph, or  \textbackslash{}epi\{\}\{\} to skip this page.
}
\newcommand{\ucsf@epigraph@source}{%
The ucsfthesis authors
}
\newcommand{\ucsf@thanks}{%
Use \textbackslash{}thanks\{...\} to specify a dedication or acknowledgement.  If you didn't get any help from anyone at any time in your PhD, use \textbackslash{}thanks\{\} to skip this page.
}
\renewcommand{\title}[1]{
    \renewcommand{\ucsf@title}{#1}
}
\renewcommand{\author}[1]{
    \renewcommand{\ucsf@author}{#1}
}
\newcommand{\abstract}[1]{
    \renewcommand{\ucsf@abstract}{#1}
}
\newcommand{\epi}[2]{
    \renewcommand{\ucsf@epigraph@text}{#1}
    \renewcommand{\ucsf@epigraph@source}{#2}
}
\renewcommand{\thanks}[1]{
    \renewcommand{\ucsf@thanks}{#1}
}

% Modify the \frontmatter command to create the various title and dedication pages required by UCSF, using the information provided in the commands defined above.
% 
% How to prepare the signature page:
% - Download the title page form: http://graduate.ucsf.edu/forms/
% - Fill in the title and author fields, then print it.
% - Get your committee to sign it, then scan it back as a PDF.
% - Save the scanned PDF to the following location: forms/title_page.pdf

\RequirePackage{pdfpages}
\RequirePackage{epigraph}

\appto\frontmatter{%
\onecolumn

% Signature page
\includepdf{forms/title_page}%

% Copyright notice (optional)
\newpage
\iftoggle{ucsfcopyright}{%
    \begin{center}%
    Copyright \number\year \\
    \ucsf@author
    \end{center}%
}{%
    \null
}%

% Set the page number to 2, to account for the signature page.
\setcounter{page}{2}

% Epigraph page
\ifthenelse{\isempty{\ucsf@epigraph@text}}{}{%
    \newpage
    \newgeometry{}
    \epigraph{\ucsf@epigraph@text}{\ucsf@epigraph@source}
    \restoregeometry
}

% Dedication page
\ifthenelse{\isempty{\ucsf@thanks}}{}{%
    \newpage
    \newgeometry{}
    \section*{Acknowledgements}
    \ucsf@thanks
    \restoregeometry
}

% Title page
\newpage
\null
\vskip 2em%
\begin{center}%
{\LARGE \ucsf@title \par}%
\vskip 1.5em%
{\large \ucsf@author \par}%
\end{center}%
\vskip 1.5em
\ucsf@abstract
%\twocolumn
}

% Allow floats to move to the top of empty pages.  This is postponed until the beginning of the document, because otherwise it messes up sideways tables with adjust boxes.
%\AtBeginDocument{%
%  \setlength{\@fptop}{0pt}%
%  \setlength{\@fpbot}{0pt plus 1fil}%
%}

% Include the (signed and scanned) publishing agreement at the end.
% - Download the publishing agreement: http://graduate.ucsf.edu/forms/
% - Print it out, the sign it and scan it as a PDF.
% - Save it in the same directory as your *.tex file.
\AtEndDocument{%
%\onecolumn
\includepdf[pagecommand={\thispagestyle{plain}}]{forms/publishing_agreement}%
%\twocolumn
}

% Set 1" margins.
\RequirePackage[margin=1in]{geometry}

% Make the document double-spaced.
\RequirePackage{setspace}
\doublespacing

% Customize the captions in floating environments like figure and table.
% KBK: Don't hyperlink figure captions?  Why not?
\RequirePackage{caption}
\captionsetup[figure]{hypcap=false}

% Make floats a little more user-friendly.
\RequirePackage{float}

% Setup the header and footer that will appear on each page.
% KBK: Are we actually using fancyhdr?
\RequirePackage{fancyhdr}
\pagestyle{plain}

% Add support for typesetting code.
% listings and minted are not compatible with each other.  Ideally, we'd add 
% a package option allowing the user to specify which package they'd rather
% use for listings, and then setup the proper hooks accordingly.
\RequirePackage{listings}

% Reset the listing counter for each chapter.
\RequirePackage{chngcntr}  % Defines \counterwithin
%\AtBeginDocument{\counterwithin{listing}{chapter}}
\renewcommand\lstlistlistingname{List of Data Files}

% Properly format the bibliography.
\usepackage[
backend=biber,
sorting=none,
autocite=superscript,
sortcites,
backref,
refsection=chapter
]{biblatex}

% Add "Bibliography" to the table of contents.
\RequirePackage[nottoc]{tocbibind}

% Use the footnote symbol for footnotes.
\renewcommand{\thefootnote}{\fnsymbol{footnote}}

% Add chapter titles and numbers to the lists of figures and tables.
\def\ucsf@chaptertitle{}
\def\ucsf@chapternumber{}
\newtoggle{ucsf@firstFigure}
\newtoggle{ucsf@firstTable}
\newtoggle{ucsf@firstListing}

% When 
\apptocmd{\@chapter}{%
\gdef\ucsf@chaptertitle{#1}%
\gdef\ucsf@chapternumber{\thechapter}%
\global\toggletrue{ucsf@firstFigure}%
\global\toggletrue{ucsf@firstTable}%
\global\toggletrue{ucsf@firstListing}%
}{}{\ClassError{ucsfthesis}{Can't patch \\chapter}{}}

% the figure environment does the job: the first time it is used after a \chapter command, it writes the information of the chapter to the LoF

\newcommand\ucsf@chapterline@iftoggle[2]{%
  \iftoggle{#1}{%
    \addtocontents{#2}{\protect\contentsline{chapter}%
      {\protect\numberline {\ucsf@chapternumber} {\ucsf@chaptertitle}}{}{} }%
    \global\togglefalse{#1}%
  }{}%
}

\AtBeginDocument{%
  \AtBeginEnvironment{figure}{%
    \ucsf@chapterline@iftoggle{ucsf@firstFigure}{lof}%
  }%
  \AtBeginEnvironment{wrapfigure}{%
    \ucsf@chapterline@iftoggle{ucsf@firstFigure}{lof}%
  }%
  \AtBeginEnvironment{tabular}{%
    \ucsf@chapterline@iftoggle{ucsf@firstTable}{lot}%
  }%
}
\pretocmd{\lstinputlisting}{%
  \ucsf@chapterline@iftoggle{ucsf@firstListing}{lol}%
}{}{\ClassError{ucsfthesis}{Can't patch \\lstinputlisting}{}}

% Make clickable cross-references.
% KBK: This has to be done after the \@chapter command is monkey-patched above, otherwise shit breaks for weird reasons.
\RequirePackage[hyperfigures,breaklinks,hidelinks]{hyperref}

% Code to remove things from table of contents.
% https://tex.stackexchange.com/questions/272070/
\newcommand*{\BeginNoToc}{%
	\addtocontents{toc}{%
		\edef\protect\SavedTocDepth{\protect\the\protect\value{tocdepth}}%
	}%
	\addtocontents{toc}{%
		\protect\setcounter{tocdepth}{-10}%
	}%
}
\newcommand*{\EndNoToc}{%
	\addtocontents{toc}{%
		\protect\setcounter{tocdepth}{\protect\SavedTocDepth}%
	}%
}

% Define a command to make the TOC.
\newcommand\ucsftableofcontents{
\tableofcontents%
\BeginNoToc%
\listoftables%
\listoffigures%
\lstlistoflistings%
\EndNoToc%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Unrelated to the UCSF style (I think)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

