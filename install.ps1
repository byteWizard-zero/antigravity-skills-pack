<#
.SYNOPSIS
    Automated Installer for Antigravity Skills & Plugins Suite
.DESCRIPTION
    Installs 32 curated skills, 7 plugins, global rules (AGENTS.md), and configuration
    into either the Global Antigravity environment or a specific workspace.
.PARAMETER Scope
    'Global' (default) installs to ~/.gemini/config
    'Workspace' installs to a specific project's .agents directory
.PARAMETER WorkspacePath
    Required if Scope is 'Workspace'. Target directory of the project.
.EXAMPLE
    .\install.ps1
.EXAMPLE
    .\install.ps1 -Scope Workspace -WorkspacePath "C:\path\to\my-app"
#>

[CmdletBinding()]
param (
    [ValidateSet("Global", "Workspace")]
    [string]$Scope = "Global",

    [string]$WorkspacePath = ""
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "`n🚀 Antigravity Skills & Plugins Pack Installer`n" -ForegroundColor Cyan

if ($Scope -eq "Global") {
    $ConfigDir = Join-Path $env:USERPROFILE ".gemini\config"
    Write-Host "Target: Global environment ($ConfigDir)" -ForegroundColor Yellow

    if (!(Test-Path $ConfigDir)) {
        New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
    }

    # 1. Install Skills
    $TargetSkills = Join-Path $ConfigDir "skills"
    if (!(Test-Path $TargetSkills)) { New-Item -ItemType Directory -Path $TargetSkills -Force | Out-Null }
    Write-Host "📦 Installing 32 skills to $TargetSkills..." -ForegroundColor Gray
    Copy-Item -Path (Join-Path $ScriptDir "skills\*") -Destination $TargetSkills -Recurse -Force

    # Also install meta-learner in ~/.gemini/antigravity/skills if needed
    $AgySkillsDir = Join-Path $env:USERPROFILE ".gemini\antigravity\skills"
    if (Test-Path (Join-Path $ScriptDir "skills\global-meta-learner")) {
        if (!(Test-Path $AgySkillsDir)) { New-Item -ItemType Directory -Path $AgySkillsDir -Force | Out-Null }
        Copy-Item -Path (Join-Path $ScriptDir "skills\global-meta-learner") -Destination $AgySkillsDir -Recurse -Force
    }

    # 2. Install Plugins
    $TargetPlugins = Join-Path $ConfigDir "plugins"
    if (!(Test-Path $TargetPlugins)) { New-Item -ItemType Directory -Path $TargetPlugins -Force | Out-Null }
    Write-Host "🔌 Installing 7 plugins to $TargetPlugins..." -ForegroundColor Gray
    Copy-Item -Path (Join-Path $ScriptDir "plugins\*") -Destination $TargetPlugins -Recurse -Force

    # 3. Configure plugins in config.json
    $ConfigFile = Join-Path $ConfigDir "config.json"
    $configObj = @{}
    if (Test-Path $ConfigFile) {
        try {
            $rawContent = Get-Content $ConfigFile -Raw
            if (![string]::IsNullOrWhiteSpace($rawContent)) {
                $configObj = $rawContent | ConvertFrom-Json
            }
        } catch {
            Write-Warning "Could not parse existing config.json as JSON. Creating a backup and reinitializing plugin settings."
            Copy-Item $ConfigFile "$ConfigFile.bak" -Force
            $configObj = [PSCustomObject]@{}
        }
    }

    if ($null -eq $configObj.plugins) {
        $configObj | Add-Member -MemberType NoteProperty -Name "plugins" -Value ([PSCustomObject]@{}) -Force
    }

    $pluginsToEnable = @(
        "android-cli-plugin",
        "chrome-devtools-plugin",
        "flutter",
        "google-antigravity-sdk",
        "modern-web-guidance-plugin",
        "ponytail",
        "ui-ux-pro-max-plugin"
    )

    foreach ($p in $pluginsToEnable) {
        if ($null -eq $configObj.plugins.$p) {
            $configObj.plugins | Add-Member -MemberType NoteProperty -Name $p -Value ([PSCustomObject]@{ enabled = $true }) -Force
        } else {
            $configObj.plugins.$p.enabled = $true
        }
    }

    $configObj | ConvertTo-Json -Depth 10 | Set-Content -Path $ConfigFile
    Write-Host "⚙️  Registered and enabled all plugins in config.json" -ForegroundColor Gray

    # 4. Rules (AGENTS.md)
    $TargetAgentsMd = Join-Path $ConfigDir "AGENTS.md"
    $SourceAgentsMd = Join-Path $ScriptDir "AGENTS.md"
    if (Test-Path $SourceAgentsMd) {
        if (!(Test-Path $TargetAgentsMd)) {
            Copy-Item -Path $SourceAgentsMd -Destination $TargetAgentsMd -Force
            Write-Host "📜 Installed global rules to $TargetAgentsMd" -ForegroundColor Gray
        } else {
            $existingRules = Get-Content $TargetAgentsMd -Raw
            $newRules = Get-Content $SourceAgentsMd -Raw
            if (!$existingRules.Contains("GSAP Animations")) {
                Add-Content -Path $TargetAgentsMd -Value "`n$newRules"
                Write-Host "📜 Appended GSAP & TinyFish rules to existing AGENTS.md" -ForegroundColor Gray
            }
        }
    }

    # 5. MCP Config Template
    $TargetMcp = Join-Path $ConfigDir "mcp_config.json"
    $SourceMcpTemplate = Join-Path $ScriptDir "mcp_config.template.json"
    if (!(Test-Path $TargetMcp) -and (Test-Path $SourceMcpTemplate)) {
        Copy-Item -Path $SourceMcpTemplate -Destination $TargetMcp -Force
        Write-Host "🔗 Created default mcp_config.json from template" -ForegroundColor Gray
    }

    Write-Host "`n✅ Global Installation Complete!" -ForegroundColor Green
    Write-Host "Please restart Antigravity to activate all new plugins and skills.`n" -ForegroundColor Cyan
}
else {
    if ([string]::IsNullOrWhiteSpace($WorkspacePath)) {
        throw "WorkspacePath is required when Scope is 'Workspace'."
    }
    if (!(Test-Path $WorkspacePath)) {
        throw "Workspace path '$WorkspacePath' does not exist."
    }

    $AgentsDir = Join-Path $WorkspacePath ".agents"
    $TargetSkills = Join-Path $AgentsDir "skills"
    if (!(Test-Path $TargetSkills)) { New-Item -ItemType Directory -Path $TargetSkills -Force | Out-Null }

    Write-Host "📦 Installing skills to workspace: $TargetSkills..." -ForegroundColor Gray
    Copy-Item -Path (Join-Path $ScriptDir "skills\*") -Destination $TargetSkills -Recurse -Force

    $WorkspaceAgentsMd = Join-Path $WorkspacePath "AGENTS.md"
    $SourceAgentsMd = Join-Path $ScriptDir "AGENTS.md"
    if (!(Test-Path $WorkspaceAgentsMd) -and (Test-Path $SourceAgentsMd)) {
        Copy-Item -Path $SourceAgentsMd -Destination $WorkspaceAgentsMd -Force
        Write-Host "📜 Added AGENTS.md to workspace root" -ForegroundColor Gray
    }

    Write-Host "`n✅ Workspace Installation Complete for '$WorkspacePath'!" -ForegroundColor Green
    Write-Host "Antigravity will automatically load these skills when opening this project.`n" -ForegroundColor Cyan
}
