<#	
	.NOTES
	===========================================================================
	 Created on:   	15.12.2017
	 Created by:   	Anatolij Batmanov
	 Filename:     	get_stringhash.ps1
	===========================================================================
	.DESCRIPTION
		Imports a userlist from csv with email addresses and creates a SHA256 hash from the email address. Output will be in the file hashes.csv.
#>

Function Get-StringHash([String]$String, $HashName = "SHA256")
{
	$StringBuilder = New-Object System.Text.StringBuilder
	[System.Security.Cryptography.HashAlgorithm]::Create($HashName).ComputeHash([System.Text.Encoding]::UTF8.GetBytes($String)) | %{
		[Void]$StringBuilder.Append($_.ToString("x2"))
	}
	$StringBuilder.ToString()
}

$list = '.\userlist.csv'
$datapath = '.\hashes.csv'
$results = @()

Import-Csv $list | ForEach {
	
	$address = $_.mail
	$create_hash = Get-StringHash $address
	
	$properties = @{
		Address  = $address
		Hash = $create_hash
	}
	
	$results += New-Object PSObject -Property $properties
}

$results | Select-Object Address, Hash | Export-Csv -Path $datapath -NoTypeInformation

Start-Sleep -Seconds 2

# Remove the last empty line
$text_trim = [IO.File]::ReadAllText("C:\Scripts\MELANI\hashes.csv")
[IO.File]::WriteAllText("C:\Scripts\MELANI\hashes.csv", $text_trim.TrimEnd())

