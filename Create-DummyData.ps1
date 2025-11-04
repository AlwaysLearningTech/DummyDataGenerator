@{
    # Version number of this script.
    ModuleVersion = '1.0.0'

    # ID used to uniquely identify this script
    GUID = '3a72bc74-c8a0-4a90-8b04-11c2d35b3786'

    # Author of this script
    Author = 'David Snyder'

    # Company or vendor of this script
    CompanyName = 'N/A'

    # Copyright statement for this script
    Copyright = '(c) 2025. All rights reserved.'

    # Description of the functionality provided by this script
    Description = 'PowerShell script for generating test files with random data. Create dummy files locally with customizable sizes, quantities, and naming patterns. Includes video file duplication support for Big Buck Bunny. Perfect for storage testing, performance benchmarks, backup validation, and application development.'

    # Minimum version of the PowerShell engine required by this script
    PowerShellVersion = '5.1'

    # Private data to pass to the module specified in RootModule/ModuleToProcess
    PrivateData = @{
        PSData = @{
            # Tags applied to this module to aid in search
            Tags = @(
                'Testing',
                'Test-Data',
                'Dummy-Data',
                'File-Generator',
                'Random-Data',
                'Storage-Testing',
                'Performance-Testing',
                'Backup-Testing',
                'PowerShell',
                'Utilities',
                'Tools'
            )

            # A URL to the license for this module.
            LicenseUri = 'https://github.com/YOUR_USERNAME/DummyDataGenerator/blob/main/LICENSE'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/YOUR_USERNAME/DummyDataGenerator'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            ReleaseNotes = @'
# Version 1.0.0
- Initial release
- Generate files with random data
- Support for fixed or random file sizes
- Configurable file naming patterns
- Video file duplication (Big Buck Bunny)
- Maximum total size controls
- Cryptographically secure random data generation
- Cross-platform support (Windows, Linux, macOS)
'@

            # Prerelease string of this module
            # Prerelease = ''

            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            # RequireLicenseAcceptance = $false

            # External dependent modules of this module
            # ExternalModuleDependencies = @()
        }
    }

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''
}
