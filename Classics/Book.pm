#!/usr/local/bin/perl

# -------------------------------------------------------------------------------------
# Book.pm:
# Book package that retrieves a book either locally or from a url in text format and
# defines, highlights and footnotes any words from the dictionary list in Latex format
# Author: Miriam Raphael
# Date: April 18, 2025
# -------------------------------------------------------------------------------------

package Book;

use LWP::Simple;
use JSON;
use Data::Dumper;
use Try::Tiny;
use File::Slurp;
use Classics::Dictionary qw(getDictionary);
use utf8;
use strict;
use warnings;
#use PDF::Create;

BEGIN {
    no strict 'refs';
}

# --------------------------------------------------------------------------
# Book class constructor:
# title - Book title
# url - URL where book can be pulled using LWP
# dictfile - the dictionary flatfile to be used. Default is structured.txt
# textfile - optional local textfile of the book (if not using url)
# --------------------------------------------------------------------------
sub new {
	my ($class,$args) = @_;
	my $self = {
		_title => $args->{'title'},
		_url => $args->{'url'},
		_author => $args->{'author'},
		_dictfile => $args->{'dictfile'} || 'structured.txt',
		_textfile => $args->{'textfile'},
	};
	print "\n\nCreating new book with title: $args->{'title'}\n\n";
	return bless $self, $class;
}

sub getTitle {
	my $self = shift;
	return $self->{'_title'};
}

sub getURL {
	my $self = shift;
	return $self->{'_url'};
}

sub getAuthor {
	my $self = shift;
	return $self->{'_author'};
}
#-------------------------------------------------------------------
# pullBookText:
# Pulls the book text either via 'get' or by opening a file locally
#--------------------------------------------------------------------
sub pullBookText {
	my ($self) = shift;

	my $data = '';
	my $localfile = $self->{'_textfile'};
	print "\nLocalfile is:$localfile\n\n";


	if (!defined($self->{'_textfile'})) {
		print "Pulling the book from the url\n\n";
		eval {
			$data = get($self->{'_url'});	
			return $data;
		} or do {
			die("Could not retrieve the book text file at $self->{'_url'}\n\n");
		}
	} else {
		open(L,$localfile) || die("Could not open $localfile for reading\n\n");
		$data = read_file($localfile);	
		close(L);
		return $data;
	}
}

#----------------------------------------------------------
# getNewFileName:
# Returns the filename for the new .tex file
#----------------------------------------------------------
sub getNewFileName {
	my $self = shift;

	my $newname = $self->{'_title'};
	$newname =~ s/\s|-//g;
	$newname .= '.tex';
	return $newname;
}

#----------------------------------------------------------
# createLatexBook:
# Input: Name of the new file where the contents will be written.
# Calls the functions to assemble the Latex book file. Accepts
# an optional filename as a parameter. If $newfile is empty, it
# will create the new filename based on the title.
#----------------------------------------------------------
sub createLatexBook {
	my ($self,$newfile) = @_;

	if ($newfile eq '') {	
		$newfile = $self->getNewFilename();
	}

	my $latex = $self->getLatexFormat();
	my $final = $self->printBook($latex);

	open(N,">$newfile") || die("Could not open $newfile for writing\n\n");
	print N $final;
	close(N);

	print "\n$newfile successfully created.\n\n";
}

#------------------------------------------------------------------
# getLatexFormat:
# Creates the dynamic dictionary the user wants to use, parses the
# file and returns the content of the book in Latex format with the 
# dictionary words boled, foornoted and indexed.
#-------------------------------------------------------------------
sub getLatexFormat {
	my $self = shift;

	my $dictref = Dictionary::getDictionary($self->{'_dictfile'});
	my %dict = %{$dictref};			# Dynamic Hash dictionary
	my $text = $self->pullBookText();
	my @keys = keys %dict;
	my $count =1;

	# Identify the chapters, if any, and isolate them with section tags
	if (utf8::is_utf8($text)) {
	#	$text = utf8::decode($text);
	}
	$text =~ s/\x93/"/g;
	$text =~ s/\x94/"/g;
	$text =~ s/(.*)START OF THE PROJECT GUTENBERG(.*)$//g;
	$text =~ s/Chapter (\d{1,2})/\\section\*\{Chapter $1\}/ig;

	# Loop through each of the words and footnote them 
	for(my $k=0; $k < @keys; $k++ ) {
		my $w = $keys[$k];
#		print "Current key: $w\n";
		$text =~ s/\b($w)\b/\\textbf\{$1\}\\index\{$1\}\\stepcounter\{footnote\}\\footnotetext\{\\textbg\{$w\}  \- $dict{$w}\}\\index\{$w\}/gi;
	}
return $text;

}

#------------------------------------------------------------------
# printBook:
# Input: The contents of the book in Latex format.
# Returns: 
# Assembles and returns the book in Latex format.
#------------------------------------------------------------------
sub printBook {
	my ($self,$bookdata) = @_;

my $latex = <<BOOK;
\\documentclass{book}
\\usepackage{makeidx}
\\makeindex
\\pagestyle{plain} \\linespread{1}
\\begin{document}
\frontmatter

\\title{$self->{'_title'}}
\\author{$self->{'_author'}}

\\mainmatter
$bookdata

\backmatter
\\newpage\\textbf{APPENDIX}

\\printindex
\\end{document}
BOOK

return $latex;
}

__END__

=head1 Classics::Book

Book object package for the Classics library. This package allows a user to create a book via a local text file or pulling (via a url) from the gutenberg project. The program will allow a user to parse the text for (difficult) words to be highlighted and footnoted in Latex format along with an index.

=head2 Accessors and methods

=head3 title

The title of the book


=head3 url

The optional url value where the book/text is accessible online.

=head3 dictfile 

Optional dictionary file which allows the user to specify the dictionary they would like to use. If left blank, the program will use the local 'structured.txt' file. If there is no local text file or dictfile, the program will die.

=head3 textfile  

If not using the url from the Gutenberg project, a user can specify the name of a local file where the contents of the book.

=head3 pullBookText

Checks whether we are pulling the book text from Gutenberg or using a local file. Returns the contents of the book.


=head3 getNewFilename 

Returns the new name of the file where the contents of the Latex file will be written.

=head3 createLatextBook

Call the scripts that create the Latex format and writes it to the new filename.

=head3 getLatextFormat

Calls the script that pulls the book contents and then parses it so that the words in the dictionary hash are highlighted and footnoted. It also creates a user index with the wordlist.

=head3 printBook

Setups up the printable book format in Latext and returns it back to the calling function.


=cut


1;
