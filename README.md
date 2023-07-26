# Discogs Prices Perl Script

## Description

This Perl script fetches pricing information from Discogs.com for a collection of items exported as a CSV file. The script reads the CSV file, retrieves the lowest, median, and highest prices for each item from its Discogs release page, and creates a new CSV file with the pricing information.

## Prerequisites

Before running the script, ensure that you have the following installed:

1. Perl: Make sure you have Perl installed on your system. You can check by running:

perl --version


If Perl is not installed, you can download it from https://www.perl.org/get.html.

2. Required Perl Modules: The script uses the Text::CSV_XS and LWP::Simple Perl modules. To install them, run:

cpan install Text::CSV_XS LWP::Simple


If you don't have cpan installed, you can install it using a package manager or download it from https://www.cpan.org/modules/INSTALL.html.

## Download ZIP File (Option 1)

1. Go to the GitHub repository page: https://github.com/your_username/discogs_prices_perl

2. Click on the green "Code" button.

3. Select "Download ZIP" from the drop-down menu.

4. Extract the downloaded ZIP file to a location on your computer.

## Clone the Repository (Option 2)

1. Clone the GitHub repository to your local machine using the following command:

git clone https://github.com/your_username/discogs_prices_perl.git


Replace `your_username` with your actual GitHub username.

2. Navigate to the Directory: Change into the project directory:

cd discogs_prices_perl


## Usage

To run the script, use the following command:

perl discogs_prices.pl file.csv


Replace `file.csv` with the path to your exported collection CSV file from Discogs. The script will read the file, fetch pricing information from Discogs.com, and create a new CSV file with the pricing details named `NEW-file.csv`.

## Notes

- The script makes web requests to Discogs.com. Be mindful of Discogs' usage policy and avoid excessive requests that could lead to IP blocking.

- The script will display a progress tracker as it processes each record.

- The output file will contain columns for "Lowest," "Median," "Highest," and "Release_Link," which includes a hyperlink to each item's Discogs release page.

- The script handles wide characters and assumes the CSV input file is in UTF-8 encoding.

## Author

hefvandz

Built by iterating on this project https://sourceforge.net/projects/discogs-prices/ with the help of ChatGPT 3.5



