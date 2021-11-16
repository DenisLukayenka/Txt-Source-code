$CurrentDir = Get-Location;
$OutputFile = "${CurrentDir}\all.txt";

$FilesToInclude = "*.cs"
$FilesToExclude = "*Assembly*.cs"
$DirectoriesToExclude = "*Migrations*"

function WriteToOutput {
    param ($Data)
    
    $Data | Out-File -FilePath $OutputFile -Append
}

if (Test-Path $OutputFile) {
    Remove-Item -Path $OutputFile
}

Get-ChildItem `
    -Path $CurrentDir `
    -Recurse `
    -Include $FilesToInclude `
    -Exclude $FilesToExclude `
| Where-Object { $_.FullName -notlike $DirectoriesToExclude } `
| ForEach-Object `
{ 'begin' } `
{
    Write-Host $_.Name
    WriteToOutput($_.Name)
    WriteToOutput("`n")
    WriteToOutput(Get-Content $_.FullName)
    WriteToOutput("`n")
} `
{ 'end' }

