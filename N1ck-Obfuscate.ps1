


Function bin2Str($binString){
    $out = ""
    $binString.toCharArray() | ForEach{
        if($_ -eq '1'){
            $out += 'I'
        } else {
            $out += 'l'
        }
    }
    return $out
}

Function str2Bin($lString){
    $out = ""
    $lString.toCharArray()| ForEach{
        if($_ -eq 'I'){
            $out += '1'
        } else {
            $out += '0'
        }
    }
    return $out
}


Function Nlck-Encode($str){
    $out = ""
    $str.ToCharArray() | ForEach{
        $bin = bin2Str([System.Convert]::ToString(([int64]$_ + 20),2).PadLeft(9,'0'))
        $out += $bin
    }
    return $out
}

Function Nlck-Decode($str){
    $out = ""
    $current = ""
    $bin =  (str2Bin($str))
    $bin.toCharArray() | ForEach{
        $current += $_
        if($current.Length -eq 9){
            $out += [char]([System.Convert]::ToByte($current,2) -20)
            $current = ""
        }
    }
    return $out
}