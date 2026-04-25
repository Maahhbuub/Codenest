# git command shortcuts
function add { git add . }

function commit {
    # 1. Define valid types for Conventional Commits
    $validTypes = '^(feat|fix|docs|style|refactor|perf|test|build|ci|chore)$'

    # 2. Case: No arguments provided
    if ($args.Count -eq 0) {
        $time = Get-Date -Format "HH:mm:ss"
        $msg = "manual commit at $time"
    }
    # 3. Case: Type, Scope, and Description (3+ args) 
    # Example: commit feat home added search bar
    elseif ($args.Count -ge 3 -and $args[0] -match $validTypes) {
        $type = $args[0]
        $scope = $args[1]
        $desc = $args[2..($args.Count - 1)] -join " "
        $msg = "$type($scope): $desc"
    }
    # 4. Case: Everything else (1 or 2 args, or 3+ args that don't match a 'type')
    # Example: commit fixed the login screen
    else {
        $msg = $args -join " "
    }

    # Execute the git command
    git commit -m "$msg"
}

function save {
    git add .
    commit @args
}

function ship {
    git add .
    commit @args
    git push
}

function branch {
    if ($args.Length -eq 0) {
        git branch
    } else {
        $name = $args[0]

        git rev-parse --verify $name 2>$null
        if ($LASTEXITCODE -eq 0) {
            git switch $name
        } else {
            git switch -c $name
        }
    }
}

function push { git push }
function pull { git pull } 
function setup { git push -u origin HEAD } # Set upstream and push current branch
function fetch { git fetch origin } # Fetch remote changes without merging

function status { git status }
function see { git branch --show-current }
function merge { git merge $args }

function clean { git reset --hard HEAD } # Discard all uncommitted changes
function restart { git clean -fd } # Remove untracked files and directories

function reset { git reset HEAD~1 } # Undo last commit (keep changes staged)
function revert { git revert HEAD } # Create a new commit that undoes last commit

function delete { git branch -d $args }
function Delete { git branch -D $args }

# npm command shortcuts
function tunnel($port) {
    npx cloudflared tunnel --url http://localhost:$port
}
function migrate($msg) {
    npx prisma migrate dev --name $msg
}
function generate { npx prisma generate }