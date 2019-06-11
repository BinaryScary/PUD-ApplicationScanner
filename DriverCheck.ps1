$global:drivers = $null
$global:found = 0

function checkDrivers{
    $temp = Driverquery.exe /V

    if($temp.Length -eq $global:drivers.Length){
        return
    }

    Write-Output "[---] Driver Installed"
    Compare-Object -ReferenceObject $global:drivers -DifferenceObject $temp | Write-Host
    $global:drivers = $temp
    $global:found += 1
}

Write-Output "[+] Parsing initial drivers..."
$global:drivers = Driverquery.exe /V
Write-Output "[+] Parsing complete`n"
Write-Output "[+] Scanning for Driver Installs..."
Write-Output "[+] Press 'q' to quit`n"
while ($true){
    if ($Host.UI.RawUI.KeyAvailable -and ("q" -eq $Host.UI.RawUI.ReadKey("IncludeKeyUp,NoEcho").Character)) {
        if($global:found -gt 0){
            Write-Host "Exiting now... Found $found Drivers" -Background DarkRed
        }else{
            Write-Host "Exiting now... 0 Drivers installed"
        }
        break;
    }

    checkDrivers
    start-sleep -seconds 5
}