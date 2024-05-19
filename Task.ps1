function Get-MyComputerInfo {
    [CmdletBinding()]
    param(
        [ValidateSet('Basic', 'Full')]
        [string]$Mode = 'Basic'
    )
    
    
    
    if (-not $Mode) {
        Write-Host "Please provide a valid mode (Basic or Full)."
        return
    }
    
   
    $computerName = $env:COMPUTERNAME
    
    $timezone = Get-TimeZone
    
    $OperatingSystem = Get-WmiObject -Class Win32_OperatingSystem | Select-Object -ExpandProperty Caption
    
    $lastWindowsUpdate = Get-HotFix | Where-Object {$_.InstalledOn} | Sort-Object InstalledOn -Descending | Select-Object -First 1

    $formattedLastUpdate = Get-Date $lastWindowsUpdate.InstalledOn -Format "dddd, dd MMMM yyyy hh:mm:ss tt"

    Write-Host "Computer Name: $computerName"
    Write-Host "Operating System: $OperatingSystem"
    Write-Host "Timezone: $($timezone.DisplayName)"
    Write-Host "Windows Updated At: $formattedLastUpdate"
   

    if ($Mode -eq 'Full') {
        try {
            
            $totalServices = (Get-Service | Measure-Object).Count
    
            Write-Host "Services Total: $totalServices"
            
            $runningServices = Get-Service | Where-Object { $_.Status -eq 'Running' }
            Write-Host "Services Running : $($runningServices.Count)"
            
            $stoppedServices = Get-Service | Where-Object { $_.Status -eq 'Stopped' }
            Write-Host "Services Stopped : $($stoppedServices.Count)"
            
            $disabledServices = Get-Service | Where-Object { $_.StartType -eq 'Disabled' }
            Write-Host "Services Disabled : $($disabledServices.Count)"
        }
        catch {
            Write-Host "An error occurred while retrieving Windows services: $_"
        }
    }
}

Get-MyComputerInfo -Mode Full
