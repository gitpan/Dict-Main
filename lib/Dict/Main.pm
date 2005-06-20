package Dict::Main;

use 5.008006;
use strict;
use warnings;
use utf8;

use Dict::Main::Radix;
use Dict::Main::Display;
use Switch;


our @ISA = qw();

our $VERSION = '1.2';


sub get_radix{

	open FINPUT, "<".$_[0] or die "Cannot open $_[0]: $!\n";
	binmode(FINPUT,":utf8");
	open FOUTPUT, ">".$_[1] or die "Cannot create $_[1]: $!\n";
	binmode(FOUTPUT,":utf8");
	while(my $word=<FINPUT>){
		chomp $word;
		my $radix=Dict::Main::Radix::radix($word);
		print FOUTPUT "$word has radix: $radix\n";
	}
	close FINPUT;
	close FOUTPUT;

	print "\tThe word has been processed\n";
}

sub get_translation{

	open FINPUT, "<".$_[0] or die "Cannot open $_[0]: $!\n";
	binmode(FINPUT,":utf8");
	open FOUTPUT, ">".$_[1] or die "Cannot create $_[1]: $!\n";
	binmode(FOUTPUT,":utf8");
	while(my $word=<FINPUT>){
		chomp $word;
		my $translation=Dict::Main::Display::translate($word);
		print FOUTPUT "$word means: $translation\n";
	}
	close FINPUT;
	close FOUTPUT;

	print "\tThe word has been processed\n";
}

sub display_html{
	Dict::Main::Display::display_html();
}

sub display_latex{
	Dict::Main::Display::display_latex();
}

sub import{
	Dict::Main::Import::import();
}

1;
__END__

=head1 NAME

Dict::Main - Perl extension for translating Arabic words into Italian

=head1 SYNOPSIS

  use Dict::Main;


=head1 DESCRIPTION

This module will take care of various duties:
->find the radix of an Arabic word
->encoding an Arabic word into ArabTeX
->display the translation of the given word (according to the local DB)
->export the local DB in HTML/LaTeX form
->import a new DB


=head1 SEE ALSO

I've used ArabTeX "encoding" for local DB files, so that the shell won't argue with the filenames. You may find more info about that at ftp://ftp.informatik.uni-stuttgart.de/pub/arabtex/arabtex.htm



=head1 AUTHOR

Andrea Benazzo, E<lt>andy@slacky.itE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Andrea Benazzo

This library is covered by the GPL License; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.


=cut
