
param(
    [Parameter(Mandatory=$true)][AllowEmptyString()]
    [String] $item,
    [Parameter(Mandatory=$true)]
    [String] $file
)

$nodes = .\Get-HTMLTable.ps1 $file | .\Import-FFXIVMining.ps1
$useritems = @(( $item -split "," ) | ForEach-Object{ $_.Trim() })

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