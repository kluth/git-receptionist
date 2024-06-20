# Check if current working directory is actually a git repository
isGitRepo=$(git -C $(echo "$PWD") rev-parse 2>/dev/null; echo $? )

if [ "$isGitRepo" -eq 0 ]; then
    echo 'GIT REPO'
    git fetch --all
    for branch in $(git branch --format='%(refname:short)'); do
        upstream=$(git config --get branch.$branch.remote)/$(git config --get branch.$branch.merge | sed 's#^refs/heads/##')
        if ! git merge-base --is-ancestor $branch $upstream; then
            echo "Branch $branch has updates from $upstream."
        else
            echo "Branch $branch is up to date with $upstream."
        fi
    done
else
    echo 'NO GIT REPO'
fi
