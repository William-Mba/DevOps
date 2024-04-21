# This file contains some very simple yet powerful utilities functions

<# 
Author: William Mba
Creation: 2023-10-18 
#>

function CopyAndRename {
    [CmdletBinding()] 
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()] 
        [string] $Source,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()] 
        [string] $Destination,
        [ValidateNotNullOrEmpty()] 
        [string] $Type = "V", # Migration type : V, R, beforeMigrate, afterMigrate etc.
        [ValidateNotNullOrEmpty()] 
        [string] $Prefix = "", # Filename prefix. Exemple: -Prefix Seed_Data_Fixed
        [ValidateNotNullOrEmpty()] 
        [string] $Filter = "*.sql",
        [ValidateNotNullOrEmpty()] 
        [Int32] $Major = 2,
        [ValidateNotNullOrEmpty()] 
        [Int32] $Minor = 5,
        [ValidateNotNullOrEmpty()] 
        [Int32] $Patch = 0,
        [ValidateNotNullOrEmpty()] 
        [Int32] $Build = 0
    )
    
    ## Copy and rename file ##
    $files = Get-ChildItem -Path $Source -File -Filter $Filter
    # Loop through files at the source.
    ForEach ($file in $files) {
        $description = "$($Prefix)_$($file.BaseName)$($file.Extension)"

        if ($Type = "V") {
            $newfile = "$($Type)$($Major)_$($Minor)_$($Patch)_$($Build)__$($description)"
            $Patch++
        }        
        else {
            $newfile = "$($Type)__$($description)"
        }
        # Pipe file into Copy-Item command to be copied.
        # Join-Path joins the $Destination with the new filename, $newfile
        $file | Copy-Item -Destination (Join-Path $Destination $newfile) -Force
    }
}

#Find and replace expressions
function FindAndReplace {
    [CmdletBinding()] 
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()] 
        [string] $Source,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()] 
        [string] $OldExp,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $NewExp,
        [ValidateNotNullOrEmpty()] 
        [string] $Filter = "*.sql"
    )

    Get-ChildItem -Path $Source -File -Filter $Filter | Rename-Item -NewName { $_.Name -replace $OldExp, $NewExp }
}