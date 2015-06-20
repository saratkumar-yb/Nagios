$PROCESS="notepad"
$ARR=Get-Process notepad -ErrorAction SilentlyContinue | %{$_.PM} 

 if ($ARR -eq $null)
 {
    Write-Host "Ok : Process $PROCESS is not running"
    exit 0;
 }
 foreach ($var in $ARR)
 {
 $out += "$var"
 }
 $ARR.clear
 
 Write-Host "CRITICAL : Process $PROCESS Consumes $ARR Bytes of memory" 
 exit 2;