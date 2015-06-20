[array]$arr=Get-Process | where { $_.WS -gt 268435456} | %{$_.ProcessName}
[array]$arr1=Get-Process | where { $_.WS -gt 268435456} | %{$_.PM} 

            
 if ($arr.length -eq $null)

 {
    Write-Host "OK : Everyting is fine"
    exit 0;
 }

 foreach ($var in $arr)

 {

 $out += "`n$var"
 
 }
 $arr.Clear
 Write-Host "CRITICAL : $out Consumes $arr1 memory" 
 exit 2;
 
 
 