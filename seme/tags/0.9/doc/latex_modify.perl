#!/usr/bin/perl
#
# This utility script modifies LaTeX source files (*.tex) generated by doxygen
# for generating more optimized Reference and Developers Manuals for Dakota.
# It automates the modifications documented in header-ref.tex and header-dev.tex
# (which become latex-ref/refman.tex and latex-dev/refman.tex).
#
# The script contains logic to prevent multiple applications of the desired
# modifications.  This allows it to be used when the Developers/Reference files
# are in a mixed state (some modified, some unmodified).

################################
# Reference Manual: refman.tex #
################################
$texfile = "latex-ref/refman.tex";
$newtexfile = $texfile . "_";
open (INPUT,  "<$texfile")    || die "cannot open original file $texfile\n$!";
open (OUTPUT, ">$newtexfile") || die "cannot open new file $newtexfile\n$!";
print "Processing $texfile\n";

# read input file until EOF
while (<INPUT>) { # read each line of file
# These no longer match, so comment out
#  if (/^\\(chapter{Dakota Directory Hierarchy}|input{dirs}|chapter{Dakota Hierarchical Index}|input\{hierarchy}|chapter{Dakota File Index}|input\{files}|chapter{Dakota Page Index}|input\{pages}|chapter{Dakota Directory Documentation}|input{dir_000000}|chapter{Dakota Page Documentation}|printindex)/) {
  if (/^\\(chapter{File Index}|input\{files}|printindex)/) {
    print OUTPUT "%$_";
  }
  elsif (/^\\include\{(\w*Commands|Bibliography)}/) {
    s/\\include\{/\\input\{/;
    print OUTPUT;
  }
  else {
    print OUTPUT;
  }
}

# close both files
close (INPUT);
close (OUTPUT);

# Replace original file with new file
rename $newtexfile, $texfile;

#################################################
# Reference Manual: Commands/Bibliography files #
#################################################
@texfiles = (<latex-ref/*Commands.tex>, "latex-ref/Bibliography.tex");

# for each LaTeX Commands file in latex-ref, perform modifications
foreach $texfile (@texfiles) {

  open (INPUT, "$texfile") || die "cannot open original file $texfile\n$!";
  $_ = <INPUT>;
  if ( /\\chapter/ ) {
    print "$texfile already processed\n";
    close (INPUT);
  }
  else {
    print "Processing $texfile\n";
    seek INPUT, 0, 0; # rewind to beginning
    $newtexfile = $texfile . "_";
    open (OUTPUT, ">$newtexfile") || die "cannot open new file $newtexfile\n$!";

    # read input file until EOF
    while (<INPUT>) { # read each line of file

      # Promote sectioning macros up one level:
      # \section       -> \chapter
      # \subsection    -> \section
      # \subsubsection -> \subsection

      # With Doxygen-1.6.1 (maybe 1.5.1) and newer, no longer need
      #s/\\section/\\chapter/go;
      #s/\\subsection/\\section/go;
      #s/\\subsubsection/\\subsection/go;

      # Change table declarations
      s/table\}\[h\]/table}[htp!]/g;

      print OUTPUT;
    }

    # close both files
    close (INPUT);
    close (OUTPUT);

    # Replace original file with new file
    rename $newtexfile, $texfile;
  }
}

#################################
# Developers Manual: refman.tex #
#################################
$texfile = "latex-dev/refman.tex";
$newtexfile = $texfile . "_";
open (INPUT,  "<$texfile")    || die "cannot open original file $texfile\n$!";
open (OUTPUT, ">$newtexfile") || die "cannot open new file $newtexfile\n$!";
print "Processing $texfile\n";

# read input file until EOF
while (<INPUT>) { # read each line of file
  if (/^\\(chapter{Todo List}|label{todo}|hypertarget{todo}{}|include{todo})/) {
    print OUTPUT "%$_";
  }
  elsif (/^\\include\{(DakLibrary|FnEvals|IteratorFlow|StyleConventions|SpecChange|VarContainersViews)}/) {
    s/\\include\{/\\input\{/;
    print OUTPUT;
  }
  else {
    print OUTPUT;
  }
}

# close both files
close (INPUT);
close (OUTPUT);

# Replace original file with new file
rename $newtexfile, $texfile;

######################################
# Developers Manual: extra dox files #
######################################
@texfiles = ("latex-dev/DakLibrary.tex",  "latex-dev/FnEvals.tex",
             "latex-dev/IteratorFlow.tex", "latex-dev/SpecChange.tex",
             "latex-dev/StyleConventions.tex", 
	     "latex-dev/VarContainersViews.tex");

# for each LaTeX special topics file in latex-dev, perform modifications
foreach $texfile (@texfiles) {

  open (INPUT, "$texfile") || die "cannot open original file $texfile\n$!";
  $_ = <INPUT>;
  if ( /\\chapter/ ) {
    print "$texfile already processed\n";
    close (INPUT);
  }
  else {
    print "Processing $texfile\n";
    seek INPUT, 0, 0; # rewind to beginning
    $newtexfile = $texfile . "_";
    open (OUTPUT, ">$newtexfile") || die "cannot open new file $newtexfile\n$!";

    # read input file until EOF
    while (<INPUT>) { # read each line of file

      # Promote sectioning macros up one level:
      # \section       -> \chapter
      # \subsection    -> \section
      # \subsubsection -> \subsection

      # With Doxygen-1.6.1 (maybe 1.5.1) and newer, no longer need
      #s/\\section/\\chapter/go;
      #s/\\subsection/\\section/go;
      #s/\\subsubsection/\\subsection/go;

      print OUTPUT;
    }

    # close both files
    close (INPUT);
    close (OUTPUT);

    # Replace original file with new file
    rename $newtexfile, $texfile;
  }
}

print "LaTeX modification Script Complete.\n";