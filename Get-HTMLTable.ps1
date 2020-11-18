param(
    [Parameter(Mandatory = $true)]
    [String] $inputFileOrURI,
    [int] $TableNumber = 0
)

<# For reference: https://www.leeholmes.com/blog/2015/01/05/extracting-tables-from-powershells-invoke-webrequest/ #>

if( (Test-Path -Path $inputFileOrURI -PathType Leaf) -eq $true ){
    $rawHTML = Get-Content -Path $inputFileOrURI -Raw
    $htmlBytes = [System.Text.Encoding]::Unicode.GetBytes( $rawHTML )
    $request = New-Object -COM "HTMLFILE"
    $request.write( $htmlBytes )
    $HTML = $request.Body
} else {
    $request = Invoke-WebRequest -URI $inputFileOrURI
    $HTML = $request.ParsedHTML
}

$table = @( $HTML.getElementsByTagName("TABLE") )[ $TableNumber ]
$rows = @( $table.rows )

$headerRow = $rows[0]
$headerCells = @( $headerRow.cells )

if( $headerCells[0].tagName -eq "TH" ){
    $headers = @( $headerCells | ForEach-Object{ ("" + $_.InnerText).Trim() })
} else {
    $headers = @( 1..$headerCells.count | ForEach-Object{ "P$_" })
}

for( $c1 = 0; $c1 -lt $rows.count-1; $c1++ ){

    $row = $rows[ $c1 ]
    $cells = @( $row.cells )

    $resultObject = [Ordered] @{ }
    for( $counter = 0; $counter -lt $cells.count; $counter++ ){
        $header = $headers[$counter]
        if( -not $header ){ continue }
        $resultObject[ $header ] = ("" + $cells[ $counter ].InnerText).Trim()
    }
    [PSCustomObject] $resultObject
}
