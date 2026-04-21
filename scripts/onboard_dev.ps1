$ErrorActionPreference = "Continue"

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "  Suburban SOC - Developer Onboarding Script" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "Checking required dependencies for development..." -ForegroundColor White
Write-Host ""

$missing_deps = @()

# 1. Git
if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Host "[x] Git is installed." -ForegroundColor Green
} else {
    Write-Host "[ ] Git is missing. Please install from https://git-scm.com/" -ForegroundColor Red
    $missing_deps += "Git"
}

# 2. GitHub CLI (gh)
if (Get-Command gh -ErrorAction SilentlyContinue) {
    Write-Host "[x] GitHub CLI (gh) is installed." -ForegroundColor Green
    
    # Check if authenticated
    try {
        $gh_status = (gh auth status 2>&1) | Out-String
        if ($gh_status -match "Logged in to github.com") {
            Write-Host "    -> You are authenticated with GitHub." -ForegroundColor Green
        } else {
            Write-Host "    -> You are NOT authenticated. Please run 'gh auth login' to use the Agile backend scripts." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "    -> Could not verify gh auth status. Please run 'gh auth login'." -ForegroundColor Yellow
    }
} else {
    Write-Host "[ ] GitHub CLI (gh) is missing. Please install from https://cli.github.com/ (required for Agile management scripts)" -ForegroundColor Red
    $missing_deps += "GitHub CLI (gh)"
}

# 3. Docker
if (Get-Command docker -ErrorAction SilentlyContinue) {
    Write-Host "[x] Docker is installed." -ForegroundColor Green
    
    # Check if Docker daemon is running
    try {
        $docker_info = (docker info 2>&1) | Out-String
        if ($docker_info -match "Server Version") {
            Write-Host "    -> Docker Engine is running." -ForegroundColor Green
        } else {
            Write-Host "    -> Docker is installed but the engine is not running. Please start Docker Desktop/Engine." -ForegroundColor Yellow
        }
    } catch {
       Write-Host "    -> Docker is installed but not running." -ForegroundColor Yellow
    }
} else {
    Write-Host "[ ] Docker is missing. Please install Docker Desktop (required to run Zeek locally and scripts/setup/ streams)" -ForegroundColor Red
    $missing_deps += "Docker Desktop"
}

# 4. SSH
if (Get-Command ssh -ErrorAction SilentlyContinue) {
    Write-Host "[x] OpenSSH is installed." -ForegroundColor Green
} else {
    Write-Host "[ ] OpenSSH is missing. Required for streaming data from the remote router (10.18.81.1)." -ForegroundColor Red
    $missing_deps += "OpenSSH"
}

# 5. WSL (for bash scripts on Windows)
if (Get-Command wsl -ErrorAction SilentlyContinue) {
    Write-Host "[x] WSL is available. You can run the setup/*.sh CLI scripts if needed." -ForegroundColor Green
} else {
    Write-Host "[ ] WSL is missing. You might need it to execute bash scripts locally on Windows." -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "=================================================" -ForegroundColor Cyan

if ($missing_deps.Count -gt 0) {
    Write-Host "Action Required: Please install the following missing dependencies:" -ForegroundColor Yellow
    foreach ($dep in $missing_deps) {
        Write-Host "- $dep" -ForegroundColor Yellow
    }
} else {
    Write-Host "All core dependencies seem to be met!" -ForegroundColor Green
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "1. Review the Agile powershell scripts in the root directory for issue management." -ForegroundColor White
    Write-Host "2. Navigate to scripts/setup/ to review data streaming and Zeek configurations." -ForegroundColor White
}

Write-Host "=================================================" -ForegroundColor Cyan
