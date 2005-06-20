package Dict::Main::Radix;

use strict;
use utf8;
use Switch;


sub radix{

	my $radix;
	my $word=$_[0];
	
	#let's strip down every prefix and suffix I'm aware of
	if($word=~/^([وفب]*ال|[بيلمتوسن]*ت|[بلوكف]*م|[ال]*ل|[ولسف]*ي|[وفلب]*ا|)(.*?)(ات|وا|تا|ون|وه|ان|تي|ته|تم|كم|ه[نم]*|ها|ية|تك|نا|ي[نه]*|[ةهيا]|)$/)
	{
 		$word=$2;
       }

       #let's strip down all other unnecessary letters
       my $length=length($word);

       switch($length){
			case 3	{
				$radix=$word;
			}
			case 4	{
				$radix=&four($word);
			}
			case 5	{
				$radix=&five($word);
			}
			case 6	{
				$radix=&six($word);
			}
			else	{
				#warn "\t$length is not a valid length!\n";
				$radix="NotFound";
			}

       }
return $radix;
}

sub four{
	my $word=$_[0];
	
	if($word=~/(.)(.)(ا|ي|و)(.)/){
		$word=$1.$2.$4;
	}
	elsif ($word=~/(.)(ا|و|ط|ي)(.)(.)/){
		$word=$1.$3.$4;
	}
	else{
		$word="NotFound";
	}
}

sub five{
	my $word=$_[0];
	
	if($word=~/(.)(.)(ا)(ا)(.)/){
		$word=$1.$2.$5;
	}
	elsif ($word=~/(.)(ت|ي)(.)(ا)(.)/){
		$word=$1.$3.$5;
	}
	elsif ($word=~/(.)(و)(ا)(.)(.)/){
		$word=$1.$4.$5;
	}
	elsif ($word=~/(.)(ا)(.)(ي|و)(.)/){
		$word=$1.$3.$5;
	}
	elsif ($word=~/(.)(.)(.)(ا|ي|و)(.)/){
		$word=$1.$2.$3.$5;
		$word=&four($word);
	}
	elsif ($word=~/(.)(.)(ا|ي)(.)(.)/){
		$word=$1.$2.$4.$5;
		$word=&four($word);
	}
	else{
		$word="NotFound";
	}
}

sub six{
	my $word=$_[0];
	
	if($word=~/(.)(و)(ا)(.)(ي)(.)/){
		$word=$1.$4.$6;
	}
	elsif ($word=~/(.)(.)(ا)(.)(ي)(.)/){
		$word=$1.$2.$4.$6;
		$word=&four($word);
	}
	else{
		$word="NotFound";
	}
}

1;
__END__

=head1 NAME

Dict::Main::Radix - Perl extension for finding the radix of a given Arabic word

=head1 SYNOPSIS

  use Dict::Main::Radix;


=head1 DESCRIPTION

This module will take care of finding the radix of an Arabic word, through chopping the extremities of the word and by taking away unnecessary letters in the middle of the word.


=head1 AUTHOR

Andrea Benazzo, E<lt>andy@slacky.itE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Andrea Benazzo

This library is covered by the GPL License; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.


=cut
