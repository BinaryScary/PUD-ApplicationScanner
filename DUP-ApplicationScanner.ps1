# TODO: Fix output (verbose / output)

$global:drivers = $null
$global:lUsers = $null
$global:privileges = $null
# $global:dUsers = $null
$global:findings = $null

function checkPrivileges{
    $temp = whoami.exe /priv

    if($temp.Length -eq $global:privileges.Length){
        return
    }

    Write-Output "[---] Privileges changed"
    $global:findings += "Privilege: " + $(Compare-Object -ReferenceObject $global:privileges -DifferenceObject $temp) + "`n"
    $global:privileges = $temp
}
function checkDrivers{
    $temp = Driverquery.exe /V

    if($temp.Length -eq $global:drivers.Length){
        return
    }

    Write-Output "[---] Driver Installed"
    $global:findings += "Driver: " + $(Compare-Object -ReferenceObject $global:drivers -DifferenceObject $temp) + "`n"
    $global:drivers = $temp
}

function checkUsers{
    $temp = net.exe users

    if($temp.Length -eq $global:lUsers.Length){
        return
    }

    Write-Output "[---] User Added"
    $global:findings += "User: " + $(Compare-Object -ReferenceObject $global:lUsers -DifferenceObject $temp) + "`n"
    $global:lUsers = $temp
}

function setup{
    Write-Output "[+] Parsing initial drivers..."
    $global:drivers = Driverquery.exe /V
    $global:lUsers = net.exe users
    $global:privileges = whoami.exe /priv
    $global:findings = ""
    Write-Output "[+] Parsing complete`n"

}
function scan{
    Write-Output "[+] Scanning for Driver, User, and Privilege installs..."
    Write-Output "[+] Press 'q' to receive results`n"
    while ($true){
        if ($Host.UI.RawUI.KeyAvailable -and ("q" -eq $Host.UI.RawUI.ReadKey("IncludeKeyUp,NoEcho").Character)) {
            Write-Host "[+]Exiting now..."

            if(![string]::IsNullOrEmpty($global:findings)){
                $str = $global:findings.Substring(0,$global:findings.Length-1)
                Write-Host $str -Background DarkRed
            }else{
                Write-Host "[+]no drivers, users, or privileges added." -BackgroundColor Green -ForegroundColor Black
            }
            break;
        }

        checkDrivers
        checkUsers
        checkPrivileges
        start-sleep -seconds 5
    }
}

# Main
setup
scan