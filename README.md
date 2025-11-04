# DummyDataGenerator

PowerShell script for generating test files with random data. Includes GitHub Actions workflow for cloud-based generation with downloadable artifacts.

A flexible PowerShell tool designed for storage testing, performance benchmarks, backup validation, and application development. Run locally with full control or use GitHub Actions to generate files in the cloud and download as ZIP artifacts.

**Available on PowerShell Gallery:** `Install-Script -Name Create-DummyData`

## Features

- 🎲 **Flexible Sizing:** Create files with fixed sizes or random sizes within a specified range
- 📦 **Cloud Generation:** Use GitHub Actions to generate files in the cloud without local resources
- 🎬 **Video Files:** Download and duplicate Big Buck Bunny videos for media library testing
- 📊 **Size Controls:** Set maximum total size limits to prevent disk space issues
- 🏷️ **Custom Naming:** Configurable filename prefixes, suffixes, and extensions
- ⚡ **Fast Generation:** Cryptographically-secure random data generation
- 💾 **Large Scale:** Supports creating up to 64GB of total data (configurable)
- 📥 **Easy Distribution:** Download as GitHub Actions artifacts or clone the repo
- 🔢 **Smart Numbering:** Zero-padded file numbering for proper sorting

## Script Usage

### Local Usage

Generate random data files locally using PowerShell:

```powershell
# If installed from PowerShell Gallery
Create-DummyData.ps1

# Or if running from downloaded/cloned script
.\Create-DummyData.ps1

# Create 10 files with random sizes (1KB - 10MB) - default behavior
Create-DummyData.ps1

# Create 5 files with fixed 100MB size
Create-DummyData.ps1 -FileCount 5 -FixedSize 100MB

# Create files with custom naming and size range
Create-DummyData.ps1 -FileCount 20 -MinSize 512KB -MaxSize 5MB -FileNamePrefix "TestData" -FileExtension "bin"

# Create video files (Big Buck Bunny duplicates)
Create-DummyData.ps1 -CreateVideoFiles -VideoCount 10 -VideoQuality "720p"
```

### Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `FileCount` | Number of files to create | 10 |
| `FixedSize` | Fixed size for all files (bytes) | - |
| `MinSize` | Minimum file size for random (bytes) | 1KB |
| `MaxSize` | Maximum file size for random (bytes) | 10MB |
| `MaxTotalSize` | Maximum total size of all files | 64GB |
| `OutputPath` | Directory for created files | Current directory |
| `FileNamePrefix` | Prefix for filenames | "DummyFile" |
| `FileNameSuffix` | Suffix before extension | "" |
| `FileExtension` | File extension (without dot) | "dat" |
| `PaddingDigits` | Number of digits for numbering | 4 |
| `CreateVideoFiles` | Enable video file mode | false |
| `VideoCount` | Number of video duplicates | 5 |
| `VideoQuality` | Video quality (360p/480p/720p/1080p) | 720p |
| `VideoFileNamePrefix` | Prefix for video files | "Video" |
| `KeepOriginalVideo` | Keep source video after duplication | false |

## GitHub Actions Usage

### Automated Generation in the Cloud

This repository includes a GitHub Actions workflow that generates test files in the cloud and makes them available as downloadable artifacts.

### How to Use

1. **Go to the Actions tab** in this repository
2. **Select "Generate Test Files"** workflow
3. **Click "Run workflow"** button
4. **Configure parameters:**
   - Number of files
   - File size (fixed or random range)
   - Filename pattern
   - Maximum total size
   - Retention period
5. **Wait for workflow to complete**
6. **Download the artifact** (will be a ZIP file)

### Workflow Features

- ✅ Runs on Windows runners (native PowerShell)
- ✅ Customizable parameters via UI
- ✅ Creates downloadable artifacts (ZIP format)
- ✅ Includes generation info file
- ✅ Shows summary in workflow output
- ✅ Configurable retention period (1-90 days)
- ✅ Respects GitHub artifact size limits (~2GB)

### Example Workflow Configurations

**Small Test Set:**
- File Count: 10
- Fixed Size: 1 MB
- Total: ~10 MB

**Medium Test Set:**
- File Count: 50
- Random Size: 1 MB - 10 MB
- Total: ~250 MB

**Large Test Set:**
- File Count: 100
- Random Size: 5 MB - 20 MB
- Total: ~1.2 GB

### Artifact Limits

GitHub Actions artifacts have the following limits:
- **Maximum artifact size:** ~2 GB per artifact
- **Storage:** 500 MB free (public repos), 2 GB (paid)
- **Retention:** Up to 90 days (configurable)
- **Compression:** Automatic ZIP compression

## Installation

### Install from PowerShell Gallery (Recommended)

The easiest way to get the script:

```powershell
# Install the script from PowerShell Gallery
Install-Script -Name Create-DummyData

# Run it from anywhere
Create-DummyData.ps1 -FileCount 5 -FixedSize 10MB

# Or find the installed location
Get-InstalledScript -Name Create-DummyData
```

### Download Script Only

```powershell
# Download the script from GitHub
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/YOUR_USERNAME/DummyDataGenerator/main/Create-DummyData.ps1" -OutFile "Create-DummyData.ps1"

# Run it
.\Create-DummyData.ps1 -FileCount 5 -FixedSize 10MB
```

### Clone Repository

```bash
git clone https://github.com/YOUR_USERNAME/DummyDataGenerator.git
cd DummyDataGenerator
.\Create-DummyData.ps1
```

## Requirements

### Local Usage
- PowerShell 5.1 or later
- Windows, Linux, or macOS with PowerShell Core
- Sufficient disk space for generated files
- Install from PowerShell Gallery: `Install-Script -Name Create-DummyData`

### GitHub Actions
- GitHub account
- Repository with Actions enabled
- No local requirements (runs in cloud)

## Use Cases

- **Storage Testing:** Generate large amounts of data for storage capacity testing
- **Performance Testing:** Create test files for I/O performance benchmarks
- **Backup Testing:** Generate test data for backup/restore validation
- **Network Testing:** Create files for upload/download speed tests
- **Application Testing:** Provide realistic test data for file processing applications
- **Training Environments:** Generate dummy files for training and demonstrations

## License

MIT License - Feel free to use and modify as needed.

## Contributing

Issues and pull requests are welcome!

## Notes

- Video files (Big Buck Bunny) are **not** generated in GitHub Actions workflow (avoid large downloads)
- For video files, use the script locally with `-CreateVideoFiles` parameter
- Big Buck Bunny videos are downloaded from official Blender demo server
- Generated files contain cryptographically secure random data (not compressible)
- File names are zero-padded for proper sorting (e.g., File0001.dat, File0002.dat)
- GitHub Actions artifacts are automatically compressed as ZIP files
- Maximum artifact size in GitHub Actions is approximately 2GB

## Repository Name

**DummyDataGenerator** - Clear, professional, and describes the purpose perfectly.

## GitHub Topics

Suggested topics for better discoverability:
- `powershell`
- `powershell-gallery`
- `powershell-script`
- `testing`
- `test-data`
- `github-actions`
- `dummy-data`
- `file-generator`
- `testing-tools`
- `data-generation`
- `performance-testing`
- `storage-testing`

## PowerShell Gallery

This script is published on PowerShell Gallery as **Create-DummyData**

- **Gallery Link:** https://www.powershellgallery.com/packages/Create-DummyData
- **Install Command:** `Install-Script -Name Create-DummyData`
- **Update Command:** `Update-Script -Name Create-DummyData`
- **View Info:** `Find-Script -Name Create-DummyData`

### Publishing Updates

For maintainers publishing updates to PowerShell Gallery:

```powershell
# Publish to PowerShell Gallery (requires API key)
Publish-Script -Path .\Create-DummyData.ps1 -NuGetApiKey YOUR_API_KEY

# Update version in script before publishing
# Increment version number in the script metadata
```
