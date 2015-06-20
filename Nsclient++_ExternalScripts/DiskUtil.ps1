$DISK_SPACE=Get-WmiObject Win32_LogicalDisk -filter "DeviceID='c:'" -ComputerName EXCH-TEST | Select DeviceID,@{Name="Size(GB)";Expression={"{0:N1}" -f($_.size/1gb)}},@{Name="FreeSpaceGB";Expression={"{0:N1}" -f($_.freespace/1gb)}},`
@{Name="UsedGB";Expression={"{0:N2}" -f (($_.size - $_.freespace)/1GB) }}

$DEVICE_ID=$DISK_SPACE.DeviceID

$USED_SPACE=$DISK_SPACE.UsedGB

$FREE_SPACE=$DISK_SPACE.FreeSpaceGB

$DEVICE_PATH="$DEVICE_ID\Disk\"

#Write-Host "The Path to be checked :  $DEVICE_PATH"

#$FREE_SPACE

if($USED_SPACE -lt 12.85)
{
Write-Host "OK : Space Available, The Space utilised is $USED_SPACE"
exit 0;
}

Write-Host "CRITICAL : Space crossed the threshold limit, The Space utilised is $USED_SPACE"
exit 2;
