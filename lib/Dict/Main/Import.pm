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


package Dict::Main::Import; #import other dictionaries

use strict;
use Dict::Main::Radix;
use Dict::Main::Encode;
use utf8;



sub import{

	my $file;
	my $transl;
	my $word;
	my $count_files=$#_;
	my $count_new_words=0;
	my $count_old_words=0;
	my $count_new_dicts=0;

shift @_; #trashes "import"


foreach $file (@_){
	open FINPUT, "<".$file or die "Cannot open $file: $!\n";
	binmode(FINPUT,":utf8");

	while(my $line=<FINPUT>){
		chomp($line);
		if($line=~/^([\w-]+) = ([\w-]+)/){
			$transl=$1;
			$line=$2;
			$word=$2.$';

			my $radix=radix::radix($line);
			my $input=encode::encode($radix);
			$input="%".$input;
			chomp($input="./dicts/".$input);

			if (-e $input){
				open DICT, "+<".$input or die "Error in opening $input: $!\n";
				binmode(DICT,":utf8");
				#look for the translation
				my $found=0;
				while($found==0 and my $read_line=<DICT>){
					chomp($read_line);
					if($read_line=~/^$word\t$transl/){
						$found=1;
						$count_old_words++;
					}
				}
				if(!$found){
					print DICT "$word\t$transl\n";
					$count_new_words++;
				}
			}
			else{
				#create the new radix file
				open DICT, ">".$input or die "Error in creating $input: $!\n";
				binmode(DICT,":utf8");
	
				print DICT "\t$radix\n\n";
				print DICT "$word\t$transl\n";
				$count_new_dicts++;
				$count_new_words++;
			}
			close DICT;
		}
	}
	close FINPUT;
	print "Imported file: $file\n";
}

@dicts=glob "./dicts/*";

print "Importation completed:
\tfiles processed: $count_files
\tnew words added: $count_new_words
\twords already present: $count_old_words
\tnew radixes created: $count_new_dicts
\tradixes now available: ".($#dicts+1)."\n";

}

return 1;
