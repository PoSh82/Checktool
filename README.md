# Checktool
Search the database of MELANI for email addresses which might be stolen from hacked websites

The Reporting and Analysis Centre for Information Assurance (MELANI https://www.melani.admin.ch/melani/en/home.html) has a database with email addresses which were used on websites to login and those websites were compromised.
You can also check the email address here https://www.checktool.ch

With this PowerShell script you'll be able to automatically lookup for email addresses from a list which are stored to a csv file whith the SHA256 hash of the address.

The script combines the URL and the SHA256 hash of the email address and post the request. Then it stores the information in a dump file and then it is looking for the specific text, if the email address is in the database.
It will also show the date and the specific website where this email address has been used.

Use the file: get_all_smtp_addresses.ps1
to export all email addresses from a specific distribution list. Define the distribution list name in the row 13.

Use the file: get_stringhash.ps1
to be able to export the email addresses from users with all lower case characters and also the SHA256 hash of each email address.

If you use the file get_stringhash.ps1 you need a file with the name userlist.csv
Please note: The header (first line) of the file userlist.csv needs just to be:
mail
and after this (starting from the second row) the addresses are following row by row without anything at the end of the line.

Important note: If you don't use the file get_stringhash.ps1 and you want to create the SHA256 hash value on your own (with tools or scripts you desire), then you have to make sure that all characters of the email address are lower case before you generate the SHA256 hash value.

Either you use the file get_stringhash.ps1 to create the list of addresses and hashes or you have this list created by your own already, then give the file the name:
hashes.csv
Please note: The header of the file hashes.csv needs to be:
"Address","Hash"

Use this file: melani_checktool.ps1
to go through all rows and wait until the scipt has finished its work.

After the script is done, you'll get a csv file with the name result.csv with all information inside.
If there is no result.csv file after the script has finished its work, then no addresses have been found in the database.
