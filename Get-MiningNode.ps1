
param(
    [Parameter(Mandatory=$true)][AllowEmptyString()]
    [Alias("item")]
    [String] $i,
    [Parameter(Mandatory=$true)]
    [Alias("url","file")]
    [String] $urlOrHTMLFile = "test.html"
)

$nodes = .\Get-HTMLTable.ps1 $urlOrHTMLFile | .\Import-FFXIVMining.ps1
$useritems = @(( $i -split "," ) | ForEach-Object{ $_.Trim() })

foreach( $useritem in $useritems ){

    $result = @{ }
    $result.add( $useritem, [System.Collections.ArrayList]@( ) )

    foreach( $location in $nodes.keys ){
        foreach( $item in $nodes[$location] ){
            if( $item -like "*$useritem*" ){
                [void] $result[$useritem].add( [PSCustomObject]@{ "area" = $location; "items" = $nodes[$location] })
                break
            }
        }
    }
}

$result.keys | ForEach-Object{

    $key = $_
    $message = ""

    if( $key -eq "" ){
        $message += "All Nodes`n"
    } else {
        $message += "$key`n"
    }

    $message += "-------------------------------------------------------`n"

    $result[$key] | Sort-Object -Property $area | ForEach-Object{
        $item = $_
        $message += "Area: $($item.area)`n"
        $message +="Items: $($item.items)`n"
    }

    $message += "-------------------------------------------------------`n"

    write-host $message

}
