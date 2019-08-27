$EMPTY = [int32]0
$EMPTYTOLIVE = [int32]1
$LIVE = [int32]6
$LIVETODEAD = [int32]7

$WIDTH = 60
$HEIGHT = 30

$global:count = 0

$grid =  @(,@(,@($EMPTY)*$WIDTH)*$HEIGHT)
for($i=0;$i -le $HEIGHT-1;$i++){
    $grid[$i] = @(,@([int32]$EMPTY)*$WIDTH)
}
 for($x=0;$x -le $grid.Count-1;$x++){
        for($y=0;$y -le $grid[$x].Count-1;$y++){
            $grid[$x][$y] = $EMPTY 
        }
    }
$grid[14][34] = $LIVE
$grid[15][33] = $LIVE
$grid[13][33] = $LIVE
$grid[16][32] = $LIVE
$grid[12][32] = $LIVE
$grid[13][31] = $LIVE
$grid[14][31] = $LIVE
$grid[15][31] = $LIVE
$grid[11][30] = $LIVE
$grid[12][30] = $LIVE
$grid[16][30] = $LIVE
$grid[17][30] = $LIVE
function Do-Conway{
    While($TRUE){
        Do-Life
        Start-Sleep -Milliseconds 1000
    }
}
function Draw-Grid{
    
    for($x=0;$x -le $grid.Count-1;$x++){
        $str = ""
        for($y=0;$y -le $grid[$x].Count-1;$y++){   
            $cell = $grid[$x][$y]
           # Write-Host $cell.GetType()
            if($cell -eq $EMPTY){
                $str += "."
            }
            if($cell -eq $LIVE){
                $str += "x"
            }
        }
        Write-Host $str
    }
    Write-Host $global:count
    $global:count++
}
function Do-Life{
    Clear-Host
    Draw-Grid
    Move-Cells
}
function Move-Cells{
    for($x=0;$x -le $grid.Count-1;$x++){
        for($y=0;$y -le $grid[$x].Count-1;$y++){
            $neighbors = Count-Neighbors $x $y
            #Write-Host $neighbors
            if($neighbors -eq 3 -and $grid[$x][$y] -eq $EMPTY){
                $grid[$x][$y] = $EMPTYTOLIVE
            }
            if(($neighbors -le 1 -or $neighbors -ge 4)-and $grid[$x][$y] -eq $LIVE){
                $grid[$x][$y] = $LIVETODEAD
            }
        }
    }
    for($x=0;$x -le $grid.Count-1;$x++){
        for($y=0;$y -le $grid[$x].Count-1;$y++){
            if($grid[$x][$y] -eq $LIVETODEAD){
                $grid[$x][$y] = $EMPTY
            }
            if($grid[$x][$y] -eq $EMPTYTOLIVE){
                $grid[$x][$y] = $LIVE
            }
        }
    }
}
function Count-Neighbors{
   
    $x = $args[0]
    $y = $args[1]
    $neigbhors = 0
    if($x -ge 1){
        if($grid[$x-1][$y] -ge 5){
            $neigbhors++
        }
    }
    if($x -le $grid.Count -2){
        if($grid[$x+1][$y] -ge 5){
            $neigbhors++
        }
    }
    if($y -ge 1){
        if($grid[$x][$y-1] -ge 5){
            $neigbhors++
        }
    }
    if($y -le $grid[0].Count -1){
        if($grid[$x][$y+1] -ge 5){
            $neigbhors++
        }
    }
    if($x -ge 1 -and $y -ge 1){
        if($grid[$x-1][$y-1] -ge 5){
            $neigbhors++
        }
    }
    if($x -ge 1 -and $y -le $grid[0].Count-1){
        if($grid[$x-1][$y+1] -ge 5){
            $neigbhors++
        }
    }
    if($x -le $grid.Count-2 -and $y -ge 1){
        if($grid[$x+1][$y-1] -ge 5){
            $neigbhors++
        }
    }
    if($x -le $grid.Count-2 -and $y -le $grid[0].Count-1){
        if($grid[$x+1][$y+1] -ge 5){
            $neigbhors++
        }
    }
    return [int32] $neigbhors

}
Do-Conway
#$neigh = Count-Neighbors 3 3
#Write-Host $neigh
