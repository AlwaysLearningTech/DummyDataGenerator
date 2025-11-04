<#
.SYNOPSIS
    Creates files with random data for testing purposes.

.DESCRIPTION
    This script generates multiple files filled with random data. You can specify:
    - Number of files to create
    - Fixed size for all files OR random sizes within a range
    - Output filename pattern and extension
    - Output directory

.PARAMETER FileCount
    Number of files to create. Default is 10.

.PARAMETER FixedSize
    Fixed size for all files in bytes. If not specified, random sizes will be used.

.PARAMETER MinSize
    Minimum file size in bytes when using random sizes. Default is 1KB.

.PARAMETER MaxSize
    Maximum file size in bytes when using random sizes. Default is 10MB.

.PARAMETER MaxTotalSize
    Maximum total size of all files combined in bytes. Default is 64GB.
    Script will stop creating files if this limit would be exceeded.

.PARAMETER OutputPath
    Directory where files will be created. Default is current directory.

.PARAMETER FileNamePrefix
    Prefix for generated filenames. Default is "DummyFile".

.PARAMETER FileNameSuffix
    Suffix for generated filenames (before extension). Default is empty.

.PARAMETER FileExtension
    File extension (without dot). Default is "dat".

.PARAMETER PaddingDigits
    Number of digits to use for file numbering. Default is 4.

.PARAMETER CreateVideoFiles
    Switch to enable video file creation mode. Downloads Big Buck Bunny and creates duplicates.

.PARAMETER VideoCount
    Number of video files to create when CreateVideoFiles is enabled. Default is 5.

.PARAMETER VideoQuality
    Quality/size of Big Buck Bunny to download. Options: "360p", "480p", "720p", "1080p". Default is "720p".

.PARAMETER VideoFileNamePrefix
    Prefix for video filenames. Default is "Video".

.PARAMETER KeepOriginalVideo
    Switch to keep the original downloaded video file after creating duplicates.

.EXAMPLE
    .\Create-DummyData.ps1 -FileCount 5 -FixedSize 1MB
    Creates 5 files, each exactly 1MB in size.

.EXAMPLE
    .\Create-DummyData.ps1 -FileCount 20 -MinSize 512KB -MaxSize 5MB -FileNamePrefix "TestData" -FileExtension "bin"
    Creates 20 files with random sizes between 512KB and 5MB, named TestData0001.bin through TestData0020.bin.

.EXAMPLE
    .\Create-DummyData.ps1 -FileCount 3 -FixedSize 100KB -OutputPath "C:\Temp\TestFiles" -FileNamePrefix "Sample" -FileNameSuffix "_Test"
    Creates 3 files of 100KB each in C:\Temp\TestFiles, named Sample0001_Test.dat through Sample0003_Test.dat.

.EXAMPLE
    .\Create-DummyData.ps1 -CreateVideoFiles -VideoCount 10 -VideoQuality "720p" -OutputPath "C:\Videos"
    Downloads Big Buck Bunny in 720p and creates 10 duplicate video files with different names.

.EXAMPLE
    .\Create-DummyData.ps1 -CreateVideoFiles -VideoCount 20 -VideoQuality "1080p" -VideoFileNamePrefix "Movie" -KeepOriginalVideo
    Downloads Big Buck Bunny in 1080p, creates 20 duplicates named Movie0001.mp4 through Movie0020.mp4, and keeps the original.
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [ValidateRange(1, 10000)]
    [int]$FileCount = 10,

    [Parameter(Mandatory = $false)]
    [ValidateRange(1, [long]::MaxValue)]
    [long]$FixedSize,

    [Parameter(Mandatory = $false)]
    [ValidateRange(1, [long]::MaxValue)]
    [long]$MinSize = 1KB,

    [Parameter(Mandatory = $false)]
    [ValidateRange(1, [long]::MaxValue)]
    [long]$MaxSize = 10MB,

    [Parameter(Mandatory = $false)]
    [ValidateRange(1, [long]::MaxValue)]
    [long]$MaxTotalSize = 64GB,

    [Parameter(Mandatory = $false)]
    [string]$OutputPath = ".",

    [Parameter(Mandatory = $false)]
    [string]$FileNamePrefix = "DummyFile",

    [Parameter(Mandatory = $false)]
    [string]$FileNameSuffix = "",

    [Parameter(Mandatory = $false)]
    [string]$FileExtension = "dat",

    [Parameter(Mandatory = $false)]
    [ValidateRange(1, 10)]
    [int]$PaddingDigits = 4,

    [Parameter(Mandatory = $false)]
    [switch]$CreateVideoFiles,

    [Parameter(Mandatory = $false)]
    [ValidateRange(1, 10000)]
    [int]$VideoCount = 5,

    [Parameter(Mandatory = $false)]
    [ValidateSet("360p", "480p", "720p", "1080p")]
    [string]$VideoQuality = "720p",

    [Parameter(Mandatory = $false)]
    [string]$VideoFileNamePrefix = "Video",

    [Parameter(Mandatory = $false)]
    [switch]$KeepOriginalVideo
)

# Function to generate random data
function New-RandomData {
    param (
        [long]$Size
    )
    
    $buffer = New-Object byte[] $Size
    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    $rng.GetBytes($buffer)
    $rng.Dispose()
    
    return $buffer
}

# Function to format file size for display
function Format-FileSize {
    param ([long]$Size)
    
    if ($Size -ge 1GB) {
        return "{0:N2} GB" -f ($Size / 1GB)
    }
    elseif ($Size -ge 1MB) {
        return "{0:N2} MB" -f ($Size / 1MB)
    }
    elseif ($Size -ge 1KB) {
        return "{0:N2} KB" -f ($Size / 1KB)
    }
    else {
        return "{0} bytes" -f $Size
    }
}

# Function to get Big Buck Bunny download URL based on quality
function Get-BBBVideoUrl {
    param ([string]$Quality)
    
    $urls = @{
        "360p" = "https://download.blender.org/demo/movies/BBB/bbb_sunflower_1080p_30fps_normal.mp4.zip"  # Will use smaller version
        "480p" = "https://download.blender.org/demo/movies/BBB/bbb_sunflower_1080p_30fps_normal.mp4.zip"
        "720p" = "https://download.blender.org/demo/movies/BBB/bbb_sunflower_1080p_30fps_normal.mp4.zip"
        "1080p" = "https://download.blender.org/demo/movies/BBB/bbb_sunflower_1080p_30fps_normal.mp4.zip"
    }
    
    return $urls[$Quality]
}

# Function to download Big Buck Bunny video
function Get-BigBuckBunny {
    param (
        [string]$Quality,
        [string]$OutputPath
    )
    
    $url = Get-BBBVideoUrl -Quality $Quality
    $tempZip = Join-Path -Path $OutputPath -ChildPath "bbb_temp.zip"
    $videoFile = Join-Path -Path $OutputPath -ChildPath "bbb_source.mp4"
    
    Write-Host "`nDownloading Big Buck Bunny ($Quality)..." -ForegroundColor Cyan
    Write-Host "Source: $url" -ForegroundColor Gray
    
    try {
        # Download with progress
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $url -OutFile $tempZip -UseBasicParsing
        $ProgressPreference = 'Continue'
        
        Write-Host "Download complete. Extracting..." -ForegroundColor Green
        
        # Extract the video file
        Expand-Archive -Path $tempZip -DestinationPath $OutputPath -Force
        
        # Find the extracted MP4 file
        $extractedFiles = Get-ChildItem -Path $OutputPath -Filter "*.mp4" | Where-Object { $_.Name -ne "bbb_source.mp4" }
        if ($extractedFiles) {
            $extractedFile = $extractedFiles[0]
            Move-Item -Path $extractedFile.FullName -Destination $videoFile -Force
        }
        
        # Clean up zip file
        Remove-Item -Path $tempZip -Force
        
        if (Test-Path $videoFile) {
            $fileSize = (Get-Item $videoFile).Length
            Write-Host "Video extracted successfully: $(Format-FileSize -Size $fileSize)" -ForegroundColor Green
            return $videoFile
        }
        else {
            throw "Video file not found after extraction"
        }
    }
    catch {
        Write-Error "Failed to download Big Buck Bunny: $_"
        if (Test-Path $tempZip) { Remove-Item -Path $tempZip -Force }
        return $null
    }
}

# Function to create video file duplicates
function New-VideoFileDuplicates {
    param (
        [string]$SourceVideo,
        [int]$Count,
        [string]$OutputPath,
        [string]$Prefix,
        [int]$PaddingDigits,
        [long]$MaxTotalSize
    )
    
    if (-not (Test-Path $SourceVideo)) {
        Write-Error "Source video file not found: $SourceVideo"
        return @()
    }
    
    $sourceSize = (Get-Item $SourceVideo).Length
    $createdFiles = @()
    $totalBytes = $sourceSize  # Start with source file size
    
    Write-Host "`nCreating video file duplicates..." -ForegroundColor Cyan
    Write-Host "Source file size: $(Format-FileSize -Size $sourceSize)" -ForegroundColor White
    
    for ($i = 1; $i -le $Count; $i++) {
        # Check if adding this file would exceed max total size
        if (($totalBytes + $sourceSize) -gt $MaxTotalSize) {
            Write-Warning "Stopping: Adding file $i would exceed MaxTotalSize limit ($(Format-FileSize -Size $MaxTotalSize))"
            Write-Host "Current total: $(Format-FileSize -Size $totalBytes)" -ForegroundColor Yellow
            break
        }
        
        $paddedNumber = $i.ToString().PadLeft($PaddingDigits, '0')
        $fileName = "$Prefix$paddedNumber.mp4"
        $filePath = Join-Path -Path $OutputPath -ChildPath $fileName
        
        Write-Host "[$i/$Count] Creating $fileName..." -NoNewline
        
        try {
            Copy-Item -Path $SourceVideo -Destination $filePath -Force
            $createdFiles += $filePath
            $totalBytes += $sourceSize
            Write-Host " Done" -ForegroundColor Green
        }
        catch {
            Write-Host " Failed" -ForegroundColor Red
            Write-Warning "Error creating file ${fileName}: $_"
        }
    }
    
    return @{
        Files = $createdFiles
        TotalBytes = $totalBytes
    }
}

# Main script logic
try {
    # Check if video mode is enabled
    if ($CreateVideoFiles) {
        # Video file creation mode
        Write-Host "`n===================================================" -ForegroundColor Cyan
        Write-Host "  Video File Generator (Big Buck Bunny)" -ForegroundColor Cyan
        Write-Host "===================================================" -ForegroundColor Cyan
        Write-Host "Video quality: $VideoQuality" -ForegroundColor White
        Write-Host "Videos to create: $VideoCount" -ForegroundColor White
        Write-Host "Output directory: $(if ($OutputPath -eq '.') { (Get-Location).Path } else { $OutputPath })" -ForegroundColor White
        Write-Host "Max total size: $(Format-FileSize -Size $MaxTotalSize)" -ForegroundColor White
        Write-Host "===================================================`n" -ForegroundColor Cyan
        
        # Ensure output directory exists
        if (-not (Test-Path -Path $OutputPath)) {
            Write-Host "Creating output directory: $OutputPath" -ForegroundColor Yellow
            New-Item -Path $OutputPath -ItemType Directory -Force | Out-Null
        }
        
        $OutputPath = (Resolve-Path -Path $OutputPath).Path
        
        $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
        
        # Download Big Buck Bunny
        $sourceVideo = Get-BigBuckBunny -Quality $VideoQuality -OutputPath $OutputPath
        
        if ($null -eq $sourceVideo) {
            throw "Failed to download video file"
        }
        
        # Create duplicates
        $result = New-VideoFileDuplicates -SourceVideo $sourceVideo -Count $VideoCount -OutputPath $OutputPath -Prefix $VideoFileNamePrefix -PaddingDigits $PaddingDigits -MaxTotalSize $MaxTotalSize
        
        # Clean up source video if not keeping it
        if (-not $KeepOriginalVideo) {
            Write-Host "`nRemoving original source video..." -ForegroundColor Yellow
            Remove-Item -Path $sourceVideo -Force
        }
        
        $stopwatch.Stop()
        
        # Display summary
        Write-Host "`n===================================================" -ForegroundColor Cyan
        Write-Host "  Summary" -ForegroundColor Cyan
        Write-Host "===================================================" -ForegroundColor Cyan
        Write-Host "Video files created: $($result.Files.Count) of $VideoCount" -ForegroundColor White
        Write-Host "Total data written: $(Format-FileSize -Size $result.TotalBytes)" -ForegroundColor White
        Write-Host "Time elapsed: $($stopwatch.Elapsed.TotalSeconds.ToString('F2')) seconds" -ForegroundColor White
        if ($KeepOriginalVideo) {
            Write-Host "Original video kept: $(Split-Path $sourceVideo -Leaf)" -ForegroundColor White
        }
        Write-Host "===================================================`n" -ForegroundColor Cyan
        
        if ($result.Files.Count -eq $VideoCount) {
            Write-Host "All video files created successfully!" -ForegroundColor Green
        }
        else {
            Write-Warning "Some video files failed to create. Check the output above for details."
        }
        
        return
    }
    
    # Original random data file creation mode
    # Validate parameters
    if (-not $FixedSize -and $MinSize -gt $MaxSize) {
        throw "MinSize cannot be greater than MaxSize."
    }

    # Check if fixed size configuration would exceed max total size
    if ($FixedSize -and ($FixedSize * $FileCount) -gt $MaxTotalSize) {
        throw "Total size of files ($($FixedSize * $FileCount) bytes) would exceed MaxTotalSize ($MaxTotalSize bytes). Reduce FileCount or FixedSize."
    }

    # Ensure output directory exists
    if (-not (Test-Path -Path $OutputPath)) {
        Write-Host "Creating output directory: $OutputPath" -ForegroundColor Yellow
        New-Item -Path $OutputPath -ItemType Directory -Force | Out-Null
    }

    # Get absolute path
    $OutputPath = (Resolve-Path -Path $OutputPath).Path

    Write-Host "`n===================================================" -ForegroundColor Cyan
    Write-Host "  Random Data File Generator" -ForegroundColor Cyan
    Write-Host "===================================================" -ForegroundColor Cyan
    Write-Host "Files to create: $FileCount" -ForegroundColor White
    
    if ($FixedSize) {
        Write-Host "File size: $(Format-FileSize -Size $FixedSize) (fixed)" -ForegroundColor White
    }
    else {
        Write-Host "File size range: $(Format-FileSize -Size $MinSize) - $(Format-FileSize -Size $MaxSize) (random)" -ForegroundColor White
    }
    
    Write-Host "Output directory: $OutputPath" -ForegroundColor White
    Write-Host "Filename pattern: $FileNamePrefix{NUMBER}$FileNameSuffix.$FileExtension" -ForegroundColor White
    Write-Host "Max total size: $(Format-FileSize -Size $MaxTotalSize)" -ForegroundColor White
    Write-Host "===================================================`n" -ForegroundColor Cyan

    $totalBytes = 0
    $successCount = 0
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

    # Create files
    for ($i = 1; $i -le $FileCount; $i++) {
        # Determine file size
        if ($FixedSize) {
            $fileSize = $FixedSize
        }
        else {
            $fileSize = Get-Random -Minimum $MinSize -Maximum ($MaxSize + 1)
        }

        # Check if adding this file would exceed max total size
        if (($totalBytes + $fileSize) -gt $MaxTotalSize) {
            Write-Warning "Stopping: Adding file $i would exceed MaxTotalSize limit ($(Format-FileSize -Size $MaxTotalSize))"
            Write-Host "Current total: $(Format-FileSize -Size $totalBytes), Proposed file size: $(Format-FileSize -Size $fileSize)" -ForegroundColor Yellow
            break
        }

        # Generate filename
        $paddedNumber = $i.ToString().PadLeft($PaddingDigits, '0')
        $fileName = "$FileNamePrefix$paddedNumber$FileNameSuffix.$FileExtension"
        $filePath = Join-Path -Path $OutputPath -ChildPath $fileName

        # Generate and write random data
        Write-Host "[$i/$FileCount] Creating $fileName ($(Format-FileSize -Size $fileSize))..." -NoNewline
        
        try {
            $randomData = New-RandomData -Size $fileSize
            [System.IO.File]::WriteAllBytes($filePath, $randomData)
            
            $totalBytes += $fileSize
            $successCount++
            Write-Host " Done" -ForegroundColor Green
        }
        catch {
            Write-Host " Failed" -ForegroundColor Red
            Write-Warning "Error creating file ${fileName}: $_"
        }
    }

    $stopwatch.Stop()

    # Display summary
    Write-Host "`n===================================================" -ForegroundColor Cyan
    Write-Host "  Summary" -ForegroundColor Cyan
    Write-Host "===================================================" -ForegroundColor Cyan
    Write-Host "Files created: $successCount of $FileCount" -ForegroundColor White
    Write-Host "Total data written: $(Format-FileSize -Size $totalBytes)" -ForegroundColor White
    Write-Host "Time elapsed: $($stopwatch.Elapsed.TotalSeconds.ToString('F2')) seconds" -ForegroundColor White
    Write-Host "Average speed: $(Format-FileSize -Size ($totalBytes / $stopwatch.Elapsed.TotalSeconds))/sec" -ForegroundColor White
    Write-Host "===================================================`n" -ForegroundColor Cyan

    if ($successCount -eq $FileCount) {
        Write-Host "All files created successfully!" -ForegroundColor Green
    }
    else {
        Write-Warning "Some files failed to create. Check the output above for details."
    }
}
catch {
    Write-Error "An error occurred: $_"
    exit 1
}
