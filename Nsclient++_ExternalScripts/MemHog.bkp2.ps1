$arr=Get-Process notepad -ErrorAction SilentlyContinue | %{$_.PM} 

 if ($arr -eq $null)
 {
    Write-Host "Ok : Process Notepad is not running"
    exit 0;
 }
 foreach ($var in $arr)
 {
 $out += "$var"
 }
 $arr.clear
 Write-Host "CRITICAL : Process Notepad Consumes $arr memory" 
 exit 2;