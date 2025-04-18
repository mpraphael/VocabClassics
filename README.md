# VocabClassics
Define challenging words in your favorite novel for acquiring a larger vocabulary.

Project Description:

This Perl package allows you to define, bold and footnote difficult or high level words in your favorite books or texts so that you can learn them while reading. The program will return to you a Latex formatted file with the words from the dictionary file footnoted and bolded. This script is perfect for a high school teen wanting to expand their vocabulary or study for the SAT. 

The package requires the following input in order to work:

1) A url where the program can find the text file or the filename of a local textfile
2) A tab or space delimited file with the words you want defined in your book

Usage with a url:

my $book = Book->new({
       'title' => 'Pride and Prejudice',
       'author' => 'Jane Austen',
       'url' => 'https://www.gutenberg.org/cache/epub/1342/pg1342.txt',
});

$book->createLatexBook('mybook.tex');

Usage with a local file:

my $book = Book->new({
        'title' => 'A Tale of Two Cities',
        'author' => 'Charles Dickens',
        'textfile' => 'taletwo.txt',
});

$book->createLatexBook('ttc.tex');

The program will return to you a Latex formatted file with the words from the dictionary file footnoted and bolded. This script is perfect for a high school teen wanting to expand their vocabulary or study for the SAT.






