# git squash

To "squash" in Git means to combine multiple commits into one. You can do this at any point in time (by using Git's "Interactive Rebase" feature), though it is most often done when merging branches.

## command

squash the last 3 commits:

```
git rebase -i HEAD~3
```
