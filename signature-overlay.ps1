Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$form = New-Object System.Windows.Forms.Form

#$graphics.RenderingOrigin = New-Object System.Drawing.Size(10,10)
$form.Text = "Device Signature"
#$form.Width = 2560
#$form.Height = 1440
#$form.Top = 0
#$form.Left = 0
$form.AutoScale = $true
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
$form.WindowState = [System.Windows.Forms.FormWindowState]::Maximized
$form.StartPosition = "CenterScreen"
$graphics = $form.CreateGraphics()
#$form.Size = New-Object System.Drawing.Size(1000,1000)
$PIXEL_WIDTH = 5*5
$SQUARE_WIDTH = 500 * 5
$backlog = [System.IO.File]::ReadAllBytes("signature-overlay.ps1")
$global:index = 0;
$form.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#123456")


$form.TransparencyKey = $form.BackColor

function Draw-Pixel($x,$y,$color){
    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml($color))
    $rect = New-Object System.Drawing.Rectangle($x,$y,$PIXEL_WIDTH,$PIXEL_WIDTH)
    $graphics.fillRectangle($brush,$rect)
    $brush.Dispose()
}
function Draw-Grid{
    #return;
    for($x=0;$x -lt $SQUARE_WIDTH;$x+=$PIXEL_WIDTH){
        for($y=0;$y -lt $SQUARE_WIDTH;$y+=$PIXEL_WIDTH){
            $color = Next-Color
            Draw-Pixel -x $x -y $y -color $color
        }
    }
}

function Random-Color{
    return "#{0:X6}" -f ((Get-Random -Maximum 0x1000000 ) )
}
function Next-Index{
    $global:index++
    if($global:index -ge $backlog.Length){
        $global:index = 0
    }
    return $global:index
}
function Next-Color{
    $color = "";
    $ne = Next-Index
    $color += "#{0:X2}" -f $backlog[$ne]
    $ne = Next-Index
    $color += "{0:X2}" -f $backlog[$ne]
    $ne = Next-Index
    $color += "{0:X2}" -f $backlog[$ne]
    return $color
}

#Draw-Something
$form.add_paint({
    Draw-Grid
})
#$temp = Next-Color
#Write-Host $temp
$form.ShowDialog()
#$temp = Random-Color
#Write-Host $temp