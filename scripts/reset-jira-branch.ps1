param (
    [string]$TargetBranch = "main"
)

$CurrentBranch = (git rev-parse --abbrev-ref HEAD).Trim()
$JiraMatch = [regex]::Match($CurrentBranch, '[A-Za-z]+-[0-9]+')
$TempBranch = $CurrentBranch

if (-not $JiraMatch.Success) {
    Write-Error "Error: No JIRA issue number found in current branch name ('$CurrentBranch')."
    exit 1
}

$JiraKey = $JiraMatch.Value
Write-Host "Extracted JIRA Key: $JiraKey"

git checkout $TargetBranch
if ($LASTEXITCODE -ne 0) { exit 1 }

git branch -D $CurrentBranch
git pull
if ($LASTEXITCODE -ne 0) { exit 1 }

$NewBranch = $TempBranch
git checkout -b $NewBranch
Write-Host "Successfully created new branch '$NewBranch' from '$TargetBranch'."