#!/usr/local/bin/perl

#------------------------------------------------------------------------------
# Dictionary.pm
# Dictionary package that creates a hash object of words.
# Author: Miriam Raphael
# Date: April 18, 2025
#------------------------------------------------------------------------------
package Dictionary;

use strict;
use warnings;
use Exporter 'import';

our @EXPORT = qw(getDictionary);

my %dict;

#------------------------------------------------------------------------------
# getDictionary:
# Input: Flatfile dictionary in the following tab or space delimited format:
# number,word,grammer|pronunciation, definition
# Output: Reference to a simple hash with the words as keys
#------------------------------------------------------------------------------
sub getDictionary {
	my($filename) = @_;

	open(F,$filename) || die("Could not open $filename for reading\n\n");

	while(<F>) {
		my($num,$word, $grammar,@def) = split(/\s/,$_);
		$dict{$word} = "($grammar) ".join(' ',@def);
	}
return \%dict;
}

1;
