#!/usr/local/bin/perl


use Classics::Book;
use Classics::Dictionary;
use strict;
use warnings;


#my $book = Book->new({
#	'title' => 'Pride and Prejudice',
#	'author' => 'Jane Austen',
#	'url' => 'https://www.gutenberg.org/cache/epub/1342/pg1342.txt',
#});

# Use the Classics:Book package to define and footnote SAT words for 'A Tale of Two Cities'

my $book = Book->new({
	'title' => 'A Tale of Two Cities',
	'author' => 'Charles Dickens',
	'textfile' => 'taletwo.txt',
});
$book->createLatexBook('ttc.tex');

