# seed
function Seed {
    $tbl = @(
        @{
            ProductName = "Phone"
            Price       = 200
        },
        @{
            ProductName = "Charger"
            Price       = 20
        },
        @{
            ProductName = "Headphones"
            Price       = 100
        }
        @{
            ProductName = "Case"
            Price       = 40
        },
        @{
            ProductName = "Speaker"
            Price       = 90
        }
    )

    try {
        Write-Host "Creating seed."
        $tbl | ConvertTo-Json | Out-File .\seed.json
        Write-Host "seed.json created."
    }
    catch {
        Write-Error "Failed to create seed file. Error: {0}" -f $_
    }
}

# read seed
function ReadJson {
    Write-Debug "Checking if seed exists."
    if (Test-Path .\seed.json) {
        Write-Host "Reading seed.json."
        $content = Get-Content -Path .\seed.json -Raw -ErrorAction Stop | ConvertFrom-Json
        return $content
    }
    Write-Warning "seed.json not found." 
    return $null
}

# export csv
function GenerateReport {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $True)]
        [PSCustomObject]
        $Input
    )
    if(-not $Input) {
        Write-Host "Input is null."
        return
    }

    try {
        Write-Host "Exporting to csv."
        $Input | Select-Object productName, price | Where-Object price -gt 50 | Sort-Object productName | Export-Csv .\report.csv
        Write-Host "Export comleted to report.csv."
    }
    catch {
        Write-Error "Failed to export to CSV. Message: {0}" -f $_ 
    }
    
}

# cleanup
function Cleanup {
    Remove-Item .\seed.json
    Remove-Item .\report.csv -Force
}


function Run {
    [CmdletBinding()]
    param ()

    Seed
    ReadJson | GenerateReport
    #  Cleanup
}


Run -Verbose
