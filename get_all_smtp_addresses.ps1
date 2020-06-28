<#	
	.NOTES
	===========================================================================
	 Created on:   	15.12.2017
	 Created by:   	Anatolij Batmanov
	 Filename:     	get_all_smtp_addresses.ps1
	===========================================================================
	.DESCRIPTION
		Sort from A-Z all smtp addresses from distribution groups in a .csv file and make all characters to lower case.
#>

# Define the distribution groups
$addresses = ''

# Define filenames
$temp_file = '.\userlist_temp.csv'
$end_file = '.\userlist.csv'

Get-ADGroupMember -Identity $addresses -recursive | Get-ADObject -Properties mail | Select-Object mail | Export-Csv -Path $temp_file -NoTypeInformation -Encoding UTF8 -Append

Start-Sleep -Seconds 2

# Make all email addresses to lower case
(Get-Content $temp_file -Raw).ToLower() | Out-File $end_file

# Delete the temp userlist file
Remove-Item -Path $temp_file -Recurse -Force -Confirm:$false

# Remove the last empty line
$text_trim = [IO.File]::ReadAllText("C:\Scripts\MELANI\userlist.csv")
[IO.File]::WriteAllText("C:\Scripts\MELANI\userlist.csv", $text_trim.TrimEnd())

