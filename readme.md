[![Tests](https://github.com/sartaj/git-aliases/actions/workflows/test.yml/badge.svg)](https://github.com/sartaj/git-aliases/actions/workflows/test.yml)

# Git Aliases

A collection of useful git aliases to help improve your git workflow, especially around creating branches that are larger changes and being able to split it into smaller changes.

Works well with Magit ([Emacs](https://magit.vc/)) ([VSCode](https://github.com/kahole/edamagit)) for partial file staging.

## Quick Install Everything

```bash
for a in git-splinter git-flatten git-reroot; do curl -s "https://raw.githubusercontent.com/sartaj/git-aliases/refs/heads/main/$a/install.sh" | bash; done
```

## Available Commands

| Command                                     | Description                                                             | Individual Install Command                                                                                      |
| ------------------------------------------- | ----------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| `git reroot`                                | Update local main branch with remote changes without switching branches | `curl -s https://raw.githubusercontent.com/sartaj/git-aliases/refs/heads/main/git-reroot/install.sh \| bash` |
| `git splinter <branch-name> [-m <message>]` | Push staged changes to a new branch without switching branches          | `curl -s https://raw.githubusercontent.com/sartaj/git-aliases/refs/heads/main/git-splinter/install.sh \| bash`  |
| `git flatten [-m <message>]`                | Squash all commits since diverging from the base branch                 | `curl -s https://raw.githubusercontent.com/sartaj/git-aliases/refs/heads/main/git-flatten/install.sh \| bash`   |

## Contributing

### Add new script

Add a folder. Each folder should have an `install.sh` script that adds the alias. In the above install all script, add the folder added.

## License

[MIT License](LICENSE)
