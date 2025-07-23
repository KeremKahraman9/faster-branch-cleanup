#!/usr/bin/env bash
set -e

all_branches_raw=""
unmerged_raw=""
to_delete=()
protected=("master")
proceed_with_deletion=false

if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "Error: This is not a Git repository."
  exit 1
fi

all_branches_raw=$(git branch | sed 's/^[* ]*//')
if [ -z "$all_branches_raw" ]; then
  echo "Warning: No local branches found."
  exit 0
fi
IFS=$'\n' all_branches=($all_branches_raw)
unset IFS

unmerged_raw=$(git branch --no-merged | sed 's/^[* ]*//')
unmerged_branches=()
if [[ -n "$unmerged_raw" ]]; then
    IFS=$'\n' unmerged_branches=($unmerged_raw)
    unset IFS
    protected+=("${unmerged_branches[@]}")
fi

while true; do
  protected=($(printf "%s\n" "${protected[@]}" | sort -u))
  to_delete=()
  for b in "${all_branches[@]}"; do
    is_protected=false
    for p in "${protected[@]}"; do if [[ "$b" == "$p" ]]; then is_protected=true; break; fi; done
    if ! $is_protected; then to_delete+=("$b"); fi
  done

  clear
  echo ">>> BRANCH CLEANUP <<<"
  echo
  echo "The following branches will be protected:"
  for p in "${protected[@]}"; do
    label=""
    is_unmerged=false
    for unmerged_b in "${unmerged_branches[@]}"; do if [[ "$p" == "$unmerged_b" ]]; then is_unmerged=true; break; fi; done
    if $is_unmerged && [[ "$p" != "master" && "$p" != "staging" && "$p" != "genie" ]]; then
        label=" - not merged yet."
    fi
    echo "  - $p$label"
  done
  
  if [ ${#to_delete[@]} -eq 0 ]; then
    echo
    echo "-> No branches to delete."
    exit 0
  fi

  echo
  echo "The following branches will be deleted:"
  i=1
  for b in "${to_delete[@]}"; do echo "  [$i] $b"; ((i++)); done

  echo
  read -p "Enter [y] to delete, [N] to cancel, or number(s) to protect: " ans

  case "$ans" in
    [Yy])
      proceed_with_deletion=true
      break
      ;;
    [Nn])
      proceed_with_deletion=false
      break
      ;;
    *)
      sanitized_ans=$(echo "$ans" | tr -d ' ')

      if [[ -z "$sanitized_ans" ]]; then
        echo "-> Please make a valid selection."
        sleep 1
        continue
      fi

      if [[ "$sanitized_ans" =~ [^0-9,] ]]; then
        echo "-> Invalid input. Please enter [y], [N], or numbers (e.g., 1,2,3)."
        sleep 1
        continue
      fi

      IFS=',' read -r -a nums_to_protect <<< "$sanitized_ans"
      
      branches_to_add=()
      invalid_nums=()

      for num in "${nums_to_protect[@]}"; do
        if [[ -z "$num" ]]; then continue; fi

        if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "${#to_delete[@]}" ]; then
          index=$((num - 1))
          branch="${to_delete[$index]}"
          branches_to_add+=("$branch")
        else
          invalid_nums+=("$num")
        fi
      done

      if [ ${#invalid_nums[@]} -gt 0 ]; then
        echo "-> Invalid or out-of-range number(s): ${invalid_nums[*]}. Please try again."
        sleep 2
      else
        protected+=("${branches_to_add[@]}")
      fi
      ;;
  esac
done

if $proceed_with_deletion; then
  echo
  echo "--------------------------------"
  for b in "${to_delete[@]}"; do
    if ! git branch -d "$b"; then
      echo "-> Could not delete '$b' (probably unmerged or another issue)."
    fi
  done
  echo "--------------------------------"
elif [ ${#to_delete[@]} -gt 0 ]; then
    echo
    echo "Cancelled. No branches were deleted."
fi

echo "Operation completed." 