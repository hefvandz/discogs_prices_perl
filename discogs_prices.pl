#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;            # LWP::Simple for basic web fetching
use Text::CSV_XS;           # For handling CSV files
use open qw(:std :utf8);    # Set UTF-8 mode for input and output

# Check command-line arguments
my $FILE = $ARGV[0];
unless ($FILE) {
    die "Syntax: $0 [file.csv]\n";
}

# Open the input CSV file
open(my $in_fh, '<', $FILE) or die "Cannot open $FILE: $!\n";

# Count the total number of records in the CSV file
my $total_records = 0;
while (<$in_fh>) {
    $total_records++;
}
close $in_fh;

# Reopen the input CSV file to read from the beginning
open($in_fh, '<', $FILE) or die "Cannot open $FILE: $!\n";

# Create a new CSV output file
open(my $out_fh, '>:encoding(utf-8)', "NEW-$FILE") or die "Cannot write file: $!\n";

# Set up CSV objects for both input and output files
my $csv_in = Text::CSV_XS->new({ binary => 1, auto_diag => 1 });
my $csv_out = Text::CSV_XS->new({ always_quote => 1, binary => 1, auto_diag => 1, eol => "\n" });

# Read the header row from the input CSV file and write it to the output file
my $header = $csv_in->getline($in_fh);
$csv_out->print($out_fh, [@$header, "Lowest", "Median", "Highest", "Release_Link"]);

# Process each line in the input CSV file
my $processed_records = 0;
while (my $row = $csv_in->getline($in_fh)) {
    my @fields = @$row;
    my $release_id = $fields[7];

    # Fetch the Discogs release page
    my $url = "https://www.discogs.com/release/$release_id";
    my $html = get($url);

    # Extract price information using regular expressions
    my ($low_price, $med_price, $hi_price) = extract_prices_from_html($html);

    # Remove "CA" prefix from the prices
    $low_price =~ s/^CA//;
    $med_price =~ s/^CA//;
    $hi_price =~ s/^CA//;

    # Add the price information and hyperlink to the output CSV
    $csv_out->print($out_fh, [ @fields, $low_price, $med_price, $hi_price, $url ]);

    $processed_records++;
    my $percent_complete = int(($processed_records / $total_records) * 100);
    print "\rProcessing: $percent_complete% complete";

    print "\n" if $processed_records == $total_records; # Print a newline when done
}

# Close the file handles
close $in_fh;
close $out_fh;

print "\nOutput file: NEW-$FILE\n";

# Function to extract price information from the HTML using regular expressions
sub extract_prices_from_html {
    my ($html) = @_;

    my ($low_price, $med_price, $hi_price) = ("", "", "");

    # Regular expressions to match the pricing information
    if ($html =~ /<span class="name_34rAK">Lowest<!-- -->:<\/span>\s*<span>(.*?)<\/span>/is) {
        $low_price = $1;
    }

    if ($html =~ /<span class="name_34rAK">Median<!-- -->:<\/span>\s*<span>(.*?)<\/span>/is) {
        $med_price = $1;
    }

    if ($html =~ /<span class="name_34rAK">Highest<!-- -->:<\/span>\s*<span>(.*?)<\/span>/is) {
        $hi_price = $1;
    }

    return ($low_price, $med_price, $hi_price);
}
