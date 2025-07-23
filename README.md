# faster-branch-cleanup
An interactive way to clean up your git branch mess.

## 🧩 Usage
Depending on your workflow:

-  **Single Repository?**
Use the script inside the `single-repo/` folder.

-  **Multiple Repositories?**
Use the script in the `multiple-repo/` folder.  

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