# seed
$tbl = @(
    @{
        ProductName="Phone"
        Price=200
    },
    @{
        ProductName="Charger"
        Price=20
    },
    @{
        ProductName="Headphones"
        Price=100
    }
    @{
        ProductName="Case"
        Price=40
    },
    @{
        ProductName="Speaker"
        Price=90
    }
)

$json = $tbl | ConvertTo-Json

$json | Out-File .\seed.json


# read seed and export csv

if(Test-Path .\seed.json) {

    $content = Get-Content -Path .\seed.json -Raw -ErrorAction Stop | ConvertFrom-Json
    $content | select productName, price | where price -gt 50 | sort productName | Export-Csv .\report.csv

}


## clean up

# rm .\seed.json
# rm .\report.csv -Force