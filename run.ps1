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
        $tbl | ConvertTo-Json | Out-File .\seed.json
    }
    catch {
        Write-Error "Failed to create seed file. Error: {0}" -f $_
    }
}

# read seed
function ReadJson {
    if (Test-Path .\seed.json) {
        $content = Get-Content -Path .\seed.json -Raw -ErrorAction Stop | ConvertFrom-Json
        return $content
    }
    return $null
}

# export csv
function GenerateReport {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, ValueFromPipeline = $True)]
        [PSCustomObject]
        $Input
    )

    $Input | Select-Object productName, price | Where-Object price -gt 50 | Sort-Object productName | Export-Csv .\report.csv
}

# cleanup
function Cleanup {
    Remove-Item .\seed.json
    Remove-Item .\report.csv -Force
}


function Run {
    Seed
    ReadJson | GenerateReport
    #  Cleanup
}


Run