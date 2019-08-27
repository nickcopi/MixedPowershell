$EMPTY = [int32]0
$SOLID = [int32]1
$PATH = [int32]2


$WIDTH = 60
$HEIGHT = 30

$grid =  @(,@(,@($EMPTY)*$WIDTH)*$HEIGHT)
for($i=0;$i -le $HEIGHT-1;$i++){
    $grid[$i] = @(,@([int32]$EMPTY)*$WIDTH)
}
 for($x=0;$x -le $grid.Count-1;$x++){
    for($y=0;$y -le $grid[$x].Count-1;$y++){
        $obj = New-Object -TypeName psobject
        $obj | Add-Member -MemberType NoteProperty -Name type -Value $EMPTY
        $obj | Add-Member -MemberType NoteProperty -Name f -Value 0
        $obj | Add-Member -MemberType NoteProperty -Name g -Value 0
        $obj | Add-Member -MemberType NoteProperty -Name parent -Value $null
        $obj | Add-Member -MemberType NoteProperty -Name x -Value $x
        $obj | Add-Member -MemberType NoteProperty -Name y -Value $y
        $grid[$x][$y] = $obj
    }
}



#$grid[14][34] = $LIVE
#$grid[15][33] = $LIVE
#$grid[13][33] = $LIVE
#$grid[16][32] = $LIVE
#$grid[12][32] = $LIVE
#$grid[13][31] = $LIVE
#$grid[14][31] = $LIVE
#$grid[15][31] = $LIVE
#$grid[11][30] = $LIVE
#$grid[12][30] = $LIVE
#$grid[16][30] = $LIVE
#$grid[17][30] = $LIVE

function Randomize-Obstacles{
    for($x=0;$x -le $grid.Count-1;$x++){
        for($y=0;$y -le $grid[$x].Count-1;$y++){
            $rand = Get-Random -Maximum 100
            if($rand -ge 80){
             $grid[$x][$y].type = $SOLID
            }
        }
    }
    $grid[0][0].type = $EMPTY
    $grid[$HEIGHT-1][$WIDTH-1].type = $EMPTY
}
function Do-Astar{
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
            $found = 0

            if($path -ne $null){
                $current = $path
                while($current -ne $null){
                    if($current.x -eq $x -and $current.y -eq $y){
                          $str += "x"
                             $found = 1
                             $turboDone[0] = 1
                            break
                    }
                    $current = $current.parent
                }
            }
            if($found -eq 1){
                continue
            }
            for($i = 0; $i -lt $closedList.Count;$i++){
                if($closedList[$i].x -eq $x -and $closedList[$i].y -eq $y){
                    $str += "C"
                    $found = 1
                    break
                }
            }
            if($found -eq 1){
                continue
            }
            for($i = 0; $i -lt $openList.Count;$i++){
                if($openList[$i].x -eq $x -and $openList[$i].y -eq $y){
                    $str += "O"
                    $found = 1
                    break
                }
            }
            if($found -eq 1){
                continue
            }
           # Write-Host $cell.GetType()
            if($cell.type -eq $EMPTY){
                $str += "."
            }
            if($cell.type -eq $SOLID){
                $str += " "
            }
            if($cell.type -eq $PATH){
                $str += "x"
            }
        }
        Write-Host $str
    }
    #Write-Host are we done + $done

}
function Do-Life{
    if($turboDone -eq 1) {return}
    Clear-Host
    Draw-Grid
    Find-Path
}
[System.Collections.ArrayList]$openList = @()
$openList.Add($grid[0][0])
[System.Collections.ArrayList]$closedList = @()
$end = $grid[$HEIGHT-1][$WIDTH-1]
Set-Variable -Name "done" -Value 0 -Scope global 
$turboDone = @(0)
$path = @($null)
function Find-Path{
    if($done -eq 1){
        return
    }
    if($openList.Count -gt 0){
    #Write-Host "AAAA"
        $winner = 0
        for($i = 0; $i -lt $openList.Count; $i++){
            if($openList[$winner].f -gt $openList[$i].f){
                $winner = $i
            }

        }
        $current = $openList[$winner]
        #Write-Host Current x: $current.x Current Y: $current.y ($end.x,$end.y)
        if($current.x -eq $end.x -and $current.y -eq $end.y){
            $path[0] = $current
            $done = 1
            return 
        }
        
        $openList.Remove($current)
        $closedList.Add($current) > $null
        for($i = 0; $i -lt $current.neighbors.Count; $i++){
            $neighbor = $current.neighbors[$i]
            if($closedList.Contains($neighbor) -or $neighbor.type -eq $SOLID){
                continue
            }
            $tempG = $current.g  + 1
            if($openList.Contains($neighbor)){
                if($tempG -ge $neighbor.g){
                    continue
                }
            } else {
                $openList.Add($neighbor) > $null
            }
            $neighbor.g = $tempG
            $distance = Dist-Point $neighbor.x $neighbor.y $end.x $end.y
            $neighbor.f = $tempG + $distance
            $neighbor.parent = $current

        }
    }
}

function Dist-Point{
    return [Math]::Pow([Math]::Pow($args[2]-$args[0],2) + [Math]::Pow($args[3]-$args[1],2),.5)
}

function Get-Neighbors{
    $x = $args[0]
    $y = $args[1]
     [System.Collections.ArrayList]$neighbors = @()
    #Write-Host "AAAAAAAAA"
    if($x -ge 1){
        $neighbors.Add($grid[$x-1][$y]) > $null
    }
    if($x -le $grid.Count -2){
        $neighbors.Add($grid[$x+1][$y]) > $null
    }
    if($y -ge 1){
        $neighbors.Add($grid[$x][$y-1]) > $null
    }
    if($y -le $grid[0].Count -1){
        $neighbors.Add($grid[$x][$y+1]) > $null
    }
    if($x -ge 1 -and $y -ge 1){
        $neighbors.Add($grid[$x-1][$y-1]) > $null
    }
    if($x -ge 1 -and $y -le $grid[0].Count-1){
        $neighbors.Add($grid[$x-1][$y+1]) > $null
    }
    if($x -le $grid.Count-2 -and $y -ge 1){
        $neighbors.Add($grid[$x+1][$y-1]) > $null
    }
    if($x -le $grid.Count-2 -and $y -le $grid[0].Count-1){
        $neighbors.Add($grid[$x+1][$y+1]) > $null
    }
    return $neighbors

}
Randomize-Obstacles
for($x=0;$x -le $grid.Count-1;$x++){
    for($y=0;$y -le $grid[$x].Count-1;$y++){
        $neighbors = Get-Neighbors $x $y
         $grid[$x][$y] | Add-Member -MemberType NoteProperty -Name neighbors -Value $neighbors
        #Write-Host $neighbors.Count

    }
}
Do-Astar
