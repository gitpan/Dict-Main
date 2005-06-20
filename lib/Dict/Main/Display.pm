package Dict::Main::Display;

use strict;
use Dict::Main::Radix;
use Dict::Main::Encode;
use utf8;


sub translate{ #translate the word by opening the file related to its radix

	my $word=$_[0];
	my $translation="NotFound";

	my $input=encode::encode(radix::radix($word));
	$input="%".$input;
	$input="./dicts/".$input;
	if (-e $input){
		open DICT, "<".$input or die "Error in opening $input: $!";
		binmode(DICT,":utf8");
		#look for the translation
		my $found=0;
		while($found==0 and my $line=<DICT>){
			chomp($line);
			if($line=~/^$word/){
				$translation=$';
				$found=1;
			}
		}
		if(!$found){
			print "No translation found\n";
		}
	}
	else{
		warn "Cannot find the file $input: $!\n";
	}

$translation;
}


sub display_html{ # exports the dictionary in html form

	if(!-e "html"){
		mkdir "html", 0755 or die "Can't create the html directory: $!\n";
	}
	open INDEX, ">./html/index.html" or die "Cannot create ./html/index.html: $!\n";
	binmode(INDEX,":utf8");
	print INDEX &html_header("Dictionary");
	print INDEX
"<div id=\"body\"><body>
<h1>Available radixes</h1>\n";

	my @alphabet=("Ø§","Ø¨","Øª","Ø«","Ø®","Ø­","Ø¬","Ø¯","Ø°","Ø±","Ø²","Ø³","Ø´","Øµ","Ø¶","Ø·","Ø¸","Ø¹","Øº","Ù","Ù","Ù","Ù","Ù","Ù","Ù","Ù","Ù","NotFound");
	foreach my $letter (@alphabet){
	print INDEX "<h2>$letter</h2>\n<ol>\n";
	$letter=encode::encode($letter);
	my @dicts=glob("./dicts/%$letter*");
	
print "Letter: $letter\n";
print "dictionaries: @dicts\n";

	foreach my $file (@dicts){
		my $filename=substr($file,8);
		open FOUTPUT, ">./html/$filename.html" or die "Cannot create ./html/$filename.html: $!\n";
		binmode(FOUTPUT,":utf8");

		open FINPUT, "<".$file or die "Cannot open $file: $!\n";
		binmode(FINPUT,":utf8");
		
		#get the radix name
		chomp(my $line=<FINPUT>);
		$line=~s/^\t//;

		print INDEX "<li><h3><a href=\"./$filename.html\">$line</a></h3></li>\n";
		print FOUTPUT &html_header($line);
		print FOUTPUT
"<body>
<div id=\"body\">
<a href=\"./index.html\">Radix index</a>
<center><h1>$line</h1></center>
<ol>\n";
		#eats the newline
		$line=<FINPUT>;
		#gets the translations
		while($line=<FINPUT>){
			chomp($line);
			$line=~/(.*)\t/;
			print FOUTPUT "<li><h4>$1 $'</h4></li>";
		}
	print FOUTPUT "</div></ol></body></html>";
	close FOUTPUT;
	}
	
	print INDEX "</ol>\n"
}
	print INDEX "</div></body>\n</html>";

	print "\tHTML pages are located in ./html/\n";
}


sub html_header{

	my $header=
"<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">
<html>
<head>
	<title>$_[0]</title>
	<meta http-equiv=\"content-type\" content=\"text/html;charset=utf-8\">
	<style type=\"text/css\">
#body :link, #body :visited {text-decoration: none;}
#body :link:hover, #body :visited:hover {color: #5795ff;}
	</style>

</head>\n";

	return $header;
}


sub display_latex{ # creates the LaTeX source file for the whole dictionary

	if(!-e "latex"){
		mkdir "latex", 0755 or die "Can't create the LaTeX directory: $!\n";
	}
	open FOUTPUT, ">./latex/index.tex" or die "Cannot create ./latex/index.tex: $!\n";
	binmode(FOUTPUT,":utf8");
	print FOUTPUT
'\documentclass[a4paper,twoside,openright,titlepage]{report}
\usepackage{arabtex,atrans,nashbf}
\usepackage[italian]{babel}
\usepackage[left=3.5cm, right=3cm, top=4cm, bottom=4cm]{geometry}
\usepackage{makeidx}
\usepackage{float}
\usepackage{inputenc}
\usepackage{utf8}
\setlength{\headsep}{2cm}
\stepcounter{chapter}
\frenchspacing
\setarab
\setnash
\makeindex


\title{\textbf{Arabic-Italian Dictionary}}

\begin{document}
\let \MakeUppercase \relax
\setcode{utf8}\transfalse\arabtrue
\maketitle
';
	my @dicts=glob "./dicts/*";
	foreach my $file (@dicts){
		open FINPUT, "<".$file or die "Cannot open $file: $!\n";
		binmode(FINPUT,":utf8");

		#get the radix name
		chomp(my $line=<FINPUT>);
		$line=~s/^\t//;
		print FOUTPUT "\\section{\\RL{$line} = $}\n";

		#eats the newline
		$line=<FINPUT>;
		#gets the translations
		while($line=<FINPUT>){
			chomp($line);
			if($line=~/^(.*)\t/){
				print FOUTPUT "\\RL{$1} $'\\\\\n";
			}
		}
	}

	print FOUTPUT "\\end{document}";
	close FOUTPUT;

	print "\tLaTeX source file is in ./latex/\n";
}



1;
__END__

=head1 NAME

Dict::Main::Display - Perl extension for translating Arabic words into Italian

=head1 SYNOPSIS

  use Dict::Main::Display;


=head1 DESCRIPTION

This module will take care of various duties:
->display the translation of the given word (according to the local DB)
->export the local DB in HTML/LaTeX form


=head1 AUTHOR

Andrea Benazzo, E<lt>andy@slacky.itE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Andrea Benazzo

This library is covered by the GPL License; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.


=cut
