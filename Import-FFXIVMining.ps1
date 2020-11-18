param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [PSCustomObject[]] $node
)

Begin{
    $nodes = @{ }
}

Process{
    <# node has a level, type, zone, coordinate, items, and extra property #>
    $key = "$($node.zone) $($node.coordinate)"
    if( -not $nodes.ContainsKey( $key ) ) {
        $nodes.add($key, @( $node.items -split ","))
    }
}

End{
    $nodes
}
