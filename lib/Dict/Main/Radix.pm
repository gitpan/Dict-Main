# 
#     This file is part of dict.
#     Copyright (c) 2005 Andrea Benazzo <andy@slacky.it>
# 
#     This library is free software; you can redistribute it and/or
#     modify it under the terms of the GNU Library General Public
#     License as published by the Free Software Foundation; either
#     version 2 of the License, or (at your option) any later version.
# 
#     This library is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#     Library General Public License for more details.
# 
#     You should have received a copy of the GNU Library General Public License
#     along with this library; see the file COPYING.LIB.  If not, write to
#     the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
#     Boston, MA 02111-1307, USA.


package Dict::Main::Radix; #finds the radix of a word

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

return 1; #needed by "use.."
