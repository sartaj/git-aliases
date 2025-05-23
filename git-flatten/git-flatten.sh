#!/bin/bash

# git flatten - Squash all commits since diverging from the base branch
#
# USAGE:
#   git flatten [-m <commit-message>]
#
# OPTIONS:
#   -m <message>    Specify a commit message for the squashed commit
#                   If not provided, uses the message from the last commit
#
# EXAMPLES:
#   git flatten                          # Squash commits using last commit's message
#   git flatten -m "Feature complete"    # Squash commits with a new message
#
# DESCRIPTION:
#   Squashes all commits on your current branch since it diverged from the
#   default base branch (main/master) into a single commit. This is useful
#   for cleaning up your commit history before merging a feature branch.
#   The command will preserve all your changes but combine them into one commit.


# Function to get origin
get_origin_name() {
    local ORIGIN_NAME=$(git remote | grep -m 1 origin || git remote | head -n 1)
    # Determine the base branch to use
    echo "${ORIGIN_NAME:-origin}"
}

# Function to detect the default base branch name
get_main_branch_name() {
    # Get the origin name - try to find "origin" or use the first remote if not found
    local ORIGIN_NAME=$(get_origin_name)
    # Get the full head reference
    local HEAD_REF=$(set -- `git ls-remote --symref $ORIGIN_NAME HEAD` && test $1 = ref: && echo $2)
    # Derive the branch name by removing the "refs/heads/" prefix
    local GIT_DEFAULT_BASE_BRANCH=${HEAD_REF#refs/heads/}
    # Determine the base branch to use
    echo "${GIT_DEFAULT_BASE_BRANCH:-master}"
}

# Function to squash commits since diverging from base branch
git_flatten() {

    ##
    ## Parse Args
    ##
    
    # Defaults
    local COMMIT_MESSAGE=""

    # Parse arguments for -m flag
    while getopts "m:" opt; do
        case $opt in
            m)
                COMMIT_MESSAGE="$OPTARG"
                ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                return 1
                ;;
        esac
    done

    ##
    ## Validators
    ##

    # Check for uncommitted changes
    if ! git diff --quiet || ! git diff --cached --quiet; then
        echo "Cannot flatten with uncommitted changes" >&2
        return 1
    fi


    ##
    ## Main Logic
    ##

    local ORIGIN_NAME=$(get_origin_name)
    # Make sure we have the latest changes from the remote
    git fetch $(get_origin_name) --prune

    local CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    local BASE_BRANCH=$(get_main_branch_name)
    local COMMIT=$(git merge-base $ORIGIN_NAME $BASE_BRANCH)

    echo "🔨 Squashing commits from this branch off of $BASE_BRANCH..."
    echo ""
    git reset --soft $COMMIT
    echo "📝 New git status:"
    git status --short
    echo ""

    if [[ -z "$COMMIT_MESSAGE" ]]; then
        # No commit message, just leave changes staged
        echo "✨ Changes have been squashed to $BASE_BRANCH and staged"
        echo ""
        echo "⏭️ Follow Up Commands"
        echo "git commit -m 'update'"
        echo "git push --force origin $CURRENT_BRANCH"
        echo ""
    else
        # Commit message is provided, create the commit
        echo "💬 Using commit message: $COMMIT_MESSAGE"
        git commit -m "$COMMIT_MESSAGE"
        echo "✨ Commits have been squashed locally from $BASE_BRANCH!"
        echo ""
        echo "⏭️ Follow Up Commands"
        echo "git push --force origin $CURRENT_BRANCH"
        echo ""
    fi

    return 0
}

# If this script is executed directly (not sourced), run the function
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    git_flatten "$@"
fi
