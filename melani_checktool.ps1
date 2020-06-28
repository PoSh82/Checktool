<#	
    .NOTES
    ===========================================================================
    Created on:   	07.12.2017
    Edited on:      	28.06.2020
    Created by:   	Anatolij Batmanov
    Filename:     	melani_checktool.ps1
    ===========================================================================
    .DESCRIPTION
    This script checks the database from https://www.checktool.ch if an email address is within the database of stolen logins.
#>

# list with mail addresses and their hashes
$hashes = '.\hashes.csv'

# results in csv file
$datapath = '.\result.csv'

# row counter
$i = 1;

$ErrorActionPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri 'https://www.checktool.ch' -OutFile .\dump_date.htm
$ErrorActionPreference = 'Continue'

$database_update = Get-Content .\dump_date.htm -Encoding UTF8 -ErrorAction SilentlyContinue
Remove-Item .\dump_date.htm -Force -Confirm:$false -ErrorAction SilentlyContinue

# checking last update of the database
$database_date = ((($database_update | Select-String -Pattern '<span class="hidden-xs">Reporting and Analysis Centre for Information Assurance MELANI / ([\s\S]+|[\d\D]+|[\w\W]+)</span>') -split '<span class="hidden-xs">Reporting and Analysis Centre for Information Assurance MELANI / ')[1] -split '</span>')[0]

Import-Csv $hashes | ForEach {
	
  # define email addresses and hashes
  $mailaddress = $_.Address
  $hash = $_.Hash
	
  # define url for english language search
  $snip_1 = 'https://www.checktool.ch/index.php?lang=en&hash='
  $snip_2 = $hash
  $final_url = $snip_1 + $snip_2
	
  Write-host " "`r`n
  $final_url
	
  # open the url and save the content to a dump file for affected or not affected user
  $ErrorActionPreference = 'SilentlyContinue'
  Invoke-WebRequest -Uri $final_url -OutFile .\dump.htm
  $ErrorActionPreference = 'Continue'
	
  # save info about affected user and delete the dump file
  $info = Get-Content .\dump.htm -Encoding UTF8 -ErrorAction SilentlyContinue
  Remove-Item .\dump.htm -Force -Confirm:$false -ErrorAction SilentlyContinue
	
  Write-Host "Working on user in row ${i}: $mailaddress"`r`n
	
  # if user is affected or not
  $positive = ($info | Select-String -Pattern 'Your e-mail address is listed in the database.')
  
  # select the date
  $date = ((($info | Select-String -Pattern '<tr><td>(\d{4}-\d{2}-\d{2})</td>') -split '<tr><td>')[1] -split '</td>')[0]
  
  # select the site
  $site = ((($info | Select-String -Pattern '</td><td>(\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,4}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)</td></tr>') -split '</td><td>')[1] -split '</td></tr>')[0]
  
  # if we have found it in the database
  if ($positive)
  {
    $results_positive = @()
		
    $Properties_positive = @{
			
      Address   = $mailaddress
      Date      = $date
      Site      = $site
    }
		
    $results_positive += New-Object PSObject -Property $Properties_positive
		
    $results_positive | Select-Object -Property Address, Date, Site | Export-CSV -NoTypeInformation -Append -Path $datapath
		
  } # end if we have found it in the database
  
  $i++;

} # end ForEach
Write-Host $database_date -ForegroundColor Red
