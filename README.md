# faster-branch-cleanup
An interactive way to clean up your git branch mess.

## 🧩 Install
Depending on your workflow:

-  **Single Repository?**
```markdown
curl -O https://raw.githubusercontent.com/KeremKahraman9/faster-branch-cleanup/main/single-repo/clean_branches.sh
```

-  **Multiple Repositories?**
```markdown
curl -O https://raw.githubusercontent.com/KeremKahraman9/faster-branch-cleanup/main/multiple-repo/clean_branches.sh
```

## ✅ First-Time Setup
Before running a script, you need to grant it execution permission **once**:

```markdown
chmod  +x  clean_branches.sh
```

Also you can add shortcut

for bash:
```markdown
echo 'alias clean_branches="./clean_branches.sh"' >> ~/.bashrc
source ~/.bashrc
```
for zsh:
```markdown
echo 'alias clean_branches="./clean_branches.sh"' >> ~/.zshrc
source ~/.zshrc
```

## ⚠️ Alert
Force  deletion  isn’t  an  option.  Unmerged  branches  must  be  handled  manually
