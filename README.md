# bxl-build

BuildXL builder with automated GitHub Actions workflow.

## Overview

This repository provides an automated build system for Microsoft's [BuildXL](https://github.com/microsoft/BuildXL) using GitHub Actions. It includes utilities for detecting the correct MSVC version and managing the BuildXL build process in a CI/CD environment.

## Features

- **Automated BuildXL compilation**: Builds Microsoft BuildXL using GitHub Actions
- **MSVC version detection**: Automatically detects and sets the appropriate MSVC version
- **Caching system**: Implements build cache management for faster subsequent builds
- **Artifact management**: Uploads build outputs and cache for reuse

## Components

### PowerShell Scripts

#### `Find-MsvcVersion.ps1`

A PowerShell script that automatically detects the installed MSVC version and sets the `MSVC_VERSION` environment variable for use in GitHub Actions workflows.

**Features:**
- Checks for existing `MSVC_VERSION` environment variable
- Uses `vswhere.exe` to locate Visual Studio installations
- Finds the latest MSVC toolset version from Visual Studio 2022
- Sets environment variable for GitHub Actions

**Usage:**
```powershell
./Find-MsvcVersion.ps1
```

### GitHub Actions Workflow

The repository includes a comprehensive GitHub Actions workflow (`build.yml`) that:

1. **Triggers on:**
   - Manual workflow dispatch
   - Push to main branch
   - Pull requests to main branch
   - Scheduled runs (weekly on Saturdays)

2. **Build Process:**
   - Checks out both this repository and Microsoft/BuildXL
   - Creates USN journal for Windows file system optimization
   - Restores build cache from previous successful runs
   - Detects MSVC version using the PowerShell script
   - Runs the BuildXL build process
   - Uploads build artifacts and cache

## Requirements

- **Operating System**: Windows (tested on Windows Server 2022)
- **PowerShell**: Version 6 or later (for GitHub Actions integration)
- **Visual Studio**: Version 17.x or 18.x with MSVC toolset
- **BuildXL**: Automatically checked out from Microsoft's repository

## Usage

### Running in GitHub Actions

The workflow runs automatically on the configured triggers. To manually trigger a build:

1. Go to the Actions tab in the GitHub repository
2. Select the "Build" workflow
3. Click "Run workflow"

### Local Development

To use the MSVC detection script locally:

```powershell
# Run the script to detect and set MSVC version
./Find-MsvcVersion.ps1

# The script will output the detected version
# MSVC_VERSION=14.xx.xxxxx
```

### BuildXL Integration

The repository works with the Microsoft BuildXL repository:

1. BuildXL is automatically checked out during the workflow
2. The build uses the Release configuration with deployment
3. Output artifacts are generated in `BuildXL/Out/Selfhost/`

## Build Artifacts

The workflow produces two main artifacts:

- **selfhost**: The complete BuildXL self-hosted build output
- **cache**: Build cache data for faster subsequent builds

## Caching Strategy

The repository implements an intelligent caching system:

- Downloads cache from the most recent successful build
- Uploads updated cache after each successful build  
- Excludes old log files to keep cache size manageable

## File Structure

```
bxl-build/
├── .github/
│   └── workflows/
│       └── build.yml          # GitHub Actions workflow
├── Find-MsvcVersion.ps1       # MSVC version detection script
├── .gitignore                 # Git ignore rules
└── README.md                  # This file
```

## License

This project is licensed under the MIT License. See the license header in `Find-MsvcVersion.ps1` for full details.

Copyright 2025 Linuxfront.com

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the changes locally if possible
5. Submit a pull request

## Related Projects

- [Microsoft BuildXL](https://github.com/microsoft/BuildXL) - The build system being compiled
- [GitHub Actions](https://github.com/features/actions) - CI/CD platform used

## Support

For issues related to:
- **This build automation**: Open an issue in this repository
- **BuildXL itself**: Refer to the [Microsoft BuildXL repository](https://github.com/microsoft/BuildXL)
- **GitHub Actions**: Check the [GitHub Actions documentation](https://docs.github.com/en/actions)
