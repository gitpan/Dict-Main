package Dict::Main;

use 5.008006;
use strict;
use warnings;
use utf8;

use Dict::Main::Radix;
use Dict::Main::Display;
use Switch;


our @ISA = qw();

our $VERSION = '1.00';


# Preloaded methods go here.
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
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Dict::Main - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Dict::Main;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Dict::Main, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.


=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Andrea Benazzo, E<lt>andy@slackware.lanE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Andrea Benazzo

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.


=cut
