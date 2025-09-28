# bxl-build Repository - BuildXL Wrapper

bxl-build is a wrapper repository for building Microsoft's BuildXL (Build Accelerator) project on Windows. This repository contains configuration scripts and GitHub Actions workflows to automate the BuildXL build process for unofficial public Windows builds.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Working Effectively

### Prerequisites and Environment Setup

#### Windows Environment Requirements
- Install Windows 10+ (required for BuildXL)
- Download and install [Visual Studio 2022 Build Tools](https://visualstudio.microsoft.com/downloads/). On the downloads page, scroll down to "All Downloads" and select "Build Tools for Visual Studio 2022".
- In Visual Studio installer, under "Individual Components", search and install: "MSVC (v142) - VS 2022 C++ x64/x86 Spectre-mitigated libs" (the exact version will be detected automatically by Find-MsvcVersion.ps1)
- Install PowerShell Core 7+ (`winget install Microsoft.PowerShell`)

### Repository Structure and Bootstrap Process

#### Clone and Initial Setup
- Clone this repository: `git clone <repo-url>`
- The repository automatically clones microsoft/BuildXL during GitHub Actions workflow
- Manual clone of BuildXL (if needed): `git clone https://github.com/microsoft/BuildXL.git`

### Build Commands and Timing Expectations

#### Windows Build Process
**CRITICAL TIMING: NEVER CANCEL THESE COMMANDS - Set 90+ minute timeouts**

1. **MSVC Version Detection** (30 seconds):
   ```powershell
   .\Find-MsvcVersion.ps1
   ```
   Sets `MSVC_VERSION` environment variable for BuildXL automatically. For manual builds without the script, set the environment variable manually:
   ```powershell
   $env:MSVC_VERSION = "14.XX.XXXXX"  # Replace with your installed MSVC version
   ```

2. **Minimal BuildXL Build** (45-60 minutes):
   ```cmd
   cd BuildXL
   .\bxl.cmd -minimal
   ```
   **NEVER CANCEL: Takes 45-60 minutes. Set timeout to 90+ minutes.**

3. **Full BuildXL Build** (60-90 minutes):
   ```cmd
   cd BuildXL
   .\bxl.cmd
   ```
   **NEVER CANCEL: Takes 60-90 minutes. Set timeout to 120+ minutes.**

4. **Release Build** (60-90 minutes):
   ```cmd
   cd BuildXL
   .\bxl.cmd -deployconfig Release -minimal
   ```
   **NEVER CANCEL: Takes 60-90 minutes. Set timeout to 120+ minutes.**

### Network Requirements

#### Public Builds
- This repository is configured for public builds using publicly available packages
- No Microsoft internal authentication is required
- If build fails with network connectivity issues, check your internet connection and firewall settings

### Validation and Testing

#### Post-Build Validation Scenarios
After making changes, always validate:

1. **Verify Build Output Structure**:
   ```cmd
   # Check if build artifacts exist
   dir .\BuildXL\Out\Bin\debug\win-x64\
   ```

2. **Test BuildXL Functionality** (if build succeeds):
   ```cmd
   # Test with a simple example
   cd .\BuildXL\Examples\HelloWorld\
   # Follow example-specific build instructions
   ```

3. **Repository Structure Verification**:
   ```cmd
   # Verify key files exist
   dir Find-MsvcVersion.ps1 .github\workflows\build.yml
   ```

#### Manual Testing Requirements
- **ALWAYS** test the complete build process after making changes to build scripts
- **ALWAYS** verify GitHub Actions workflow syntax and logic
- Validate PowerShell scripts using `pwsh -File script.ps1`

### Common Tasks

#### Update Build Configuration
- Modify `.github/workflows/build.yml` for CI/CD changes
- Update `Find-MsvcVersion.ps1` for Visual Studio version requirements
- Test changes using GitHub Actions workflow dispatch

#### Troubleshooting Build Issues
1. **MSVC Version Problems**: Check Visual Studio 2022 installation and run `Find-MsvcVersion.ps1`
2. **Long Build Times**: Normal - BuildXL builds take 45+ minutes, DO NOT cancel
3. **Out of Memory**: BuildXL is memory-intensive, ensure adequate RAM (16GB+ recommended)

### Repository Quick Reference

#### File Structure
```
.
├── .github/
│   └── workflows/
│       └── build.yml          # Main CI/CD workflow
├── .gitignore                 # Build artifacts exclusions
├── Find-MsvcVersion.ps1       # MSVC detection script
└── README.md                  # Basic project description
```

#### Key Commands Summary
- **Minimal Build**: `cd BuildXL && .\bxl.cmd -minimal` (45-60 min)
- **Full Build**: `cd BuildXL && .\bxl.cmd` (60-90 min)
- **Release Build**: `cd BuildXL && .\bxl.cmd -deployconfig Release -minimal` (60-90 min)
- **MSVC Detection**: `.\Find-MsvcVersion.ps1` (30 sec)
- **Workflow Validation**: Check `.github/workflows/build.yml` syntax

#### GitHub Actions Workflow Behavior
- Runs on `windows-2022` runner
- Creates USN journal: `fsutil usn createjournal m=0x20000000 a=0x8000000 D:`
- Clones microsoft/BuildXL to `./BuildXL/`
- Caches BuildXL build outputs in `./BuildXL/Out/Cache`
- Uploads build artifacts from `./BuildXL/Out/Bin`

### Critical Reminders
- **NEVER CANCEL** long-running build commands - they may take up to 90 minutes
- **ALWAYS** set appropriate timeouts (90+ minutes for builds, 30+ minutes for tests)
- **WINDOWS ONLY** - This repository supports Windows builds only
- **MEMORY USAGE** is high during builds - monitor system resources
- **BUILD TIMING** varies significantly based on hardware and network conditions

### Error Recovery
- Clean build state: `git clean -fdx` (removes all untracked files)
- Reset BuildXL: `rmdir /s BuildXL` then `git clone https://github.com/microsoft/BuildXL.git`
- Clear .NET caches: `dotnet nuget locals all --clear`