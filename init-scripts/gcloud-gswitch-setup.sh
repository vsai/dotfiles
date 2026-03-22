#!/usr/bin/env bash
# gswitch - Fast GCP account/project switcher
# Source this file in your shell: source ~/gcloudsetups/gswitch.sh

# ── Colors ──────────────────────────────────────────────────────────
_gs_bold='\033[1m'
_gs_dim='\033[2m'
_gs_green='\033[32m'
_gs_yellow='\033[33m'
_gs_cyan='\033[36m'
_gs_red='\033[31m'
_gs_reset='\033[0m'

# ── gswitch: Interactive config switcher ────────────────────────────
gswitch() {
  if [[ "$1" != "" ]]; then
    # Direct switch by config name
    if gcloud config configurations activate "$1" 2>/dev/null; then
      _gs_show_active
    else
      echo -e "${_gs_red}Config '$1' not found.${_gs_reset} Run ${_gs_cyan}gcls${_gs_reset} to see available configs."
    fi
    return
  fi

  # Interactive mode
  local configs
  configs=$(gcloud config configurations list --format="table[no-heading](name,is_active.yesno(yes='*',no=' '),properties.core.account,properties.core.project)" 2>/dev/null)

  if [[ -z "$configs" ]]; then
    echo "No configurations found. Run gnew to create one."
    return 1
  fi

  # Use fzf if available
  if command -v fzf &>/dev/null; then
    local selection
    selection=$(echo "$configs" | fzf --prompt="Switch to config > " --height=15 --reverse --ansi \
      --header="NAME  ACTIVE  ACCOUNT  PROJECT" \
      --preview="gcloud config configurations describe {1} 2>/dev/null")
    if [[ -n "$selection" ]]; then
      local name
      name=$(echo "$selection" | awk '{print $1}')
      gcloud config configurations activate "$name" 2>/dev/null
      _gs_show_active
    fi
  else
    # Numbered menu fallback
    echo -e "${_gs_bold}  #  NAME              ACCOUNT                   PROJECT${_gs_reset}"
    echo    "  ─  ────              ───────                   ───────"
    local i=1
    local names=()
    while IFS= read -r line; do
      local name active account project
      name=$(echo "$line" | awk '{print $1}')
      active=$(echo "$line" | awk '{print $2}')
      account=$(echo "$line" | awk '{print $3}')
      project=$(echo "$line" | awk '{print $4}')
      names+=("$name")

      local marker="  "
      if [[ "$active" == "*" ]]; then
        marker="${_gs_green}*${_gs_reset} "
      fi

      printf "  ${marker}${_gs_cyan}%d${_gs_reset}  %-18s %-26s %s\n" "$i" "$name" "$account" "$project"
      ((i++))
    done <<< "$configs"

    echo ""
    read -rp "Select config [1-$((i-1))]: " choice

    if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice < i )); then
      gcloud config configurations activate "${names[$((choice-1))]}" 2>/dev/null
      _gs_show_active
    else
      echo "Cancelled."
    fi
  fi
}

# ── gnew: Create a new named configuration ─────────────────────────
gnew() {
  local name="$1"
  local account="$2"
  local project="$3"

  if [[ -z "$name" ]]; then
    read -rp "Config name (short, memorable): " name
  fi

  if gcloud config configurations describe "$name" &>/dev/null; then
    echo -e "${_gs_yellow}Config '$name' already exists.${_gs_reset} Use gswitch $name to activate it."
    return 1
  fi

  # Pick account
  if [[ -z "$account" ]]; then
    echo -e "\n${_gs_bold}Authenticated accounts:${_gs_reset}"
    local accounts
    accounts=$(gcloud auth list --format="value(account)" 2>/dev/null)
    local i=1
    local acct_list=()
    while IFS= read -r a; do
      acct_list+=("$a")
      printf "  ${_gs_cyan}%d${_gs_reset}  %s\n" "$i" "$a"
      ((i++))
    done <<< "$accounts"

    echo -e "  ${_gs_cyan}$i${_gs_reset}  ${_gs_dim}+ Login new account${_gs_reset}"
    read -rp "Select account [1-$i]: " achoice

    if [[ "$achoice" == "$i" ]]; then
      gcloud auth login --no-launch-browser 2>/dev/null
      account=$(gcloud auth list --filter="status:ACTIVE" --format="value(account)" 2>/dev/null)
    elif [[ "$achoice" =~ ^[0-9]+$ ]] && (( achoice >= 1 && achoice < i )); then
      account="${acct_list[$((achoice-1))]}"
    else
      echo "Cancelled."
      return 1
    fi
  fi

  # Pick project
  if [[ -z "$project" ]]; then
    echo -e "\n${_gs_bold}Fetching projects for ${account}...${_gs_reset}"
    local projects
    projects=$(gcloud projects list --account="$account" --format="value(projectId)" 2>/dev/null)

    if [[ -n "$projects" ]]; then
      local i=1
      local proj_list=()
      while IFS= read -r p; do
        proj_list+=("$p")
        printf "  ${_gs_cyan}%d${_gs_reset}  %s\n" "$i" "$p"
        ((i++))
      done <<< "$projects"

      read -rp "Select project [1-$((i-1))] or type ID: " pchoice

      if [[ "$pchoice" =~ ^[0-9]+$ ]] && (( pchoice >= 1 && pchoice < i )); then
        project="${proj_list[$((pchoice-1))]}"
      else
        project="$pchoice"
      fi
    else
      read -rp "No projects found. Enter project ID manually: " project
    fi
  fi

  # Create config
  gcloud config configurations create "$name" 2>/dev/null
  gcloud config set account "$account" --configuration="$name" 2>/dev/null
  gcloud config set project "$project" --configuration="$name" 2>/dev/null

  echo -e "\n${_gs_green}Created config '${name}':${_gs_reset} ${account} → ${project}"
  echo -e "Activating..."
  gcloud config configurations activate "$name" 2>/dev/null
  _gs_show_active
}

# ── gls: List all configurations ───────────────────────────────────
gcls() {
  echo -e "${_gs_bold}GCP Configurations:${_gs_reset}\n"
  gcloud config configurations list --format="table(name,is_active.yesno(yes='✓',no=''),properties.core.account,properties.core.project)" 2>/dev/null
  echo ""

  echo -e "${_gs_bold}Authenticated Accounts:${_gs_reset}\n"
  gcloud auth list 2>/dev/null
}

# ── gproject: Quick project switch (keeps same account) ────────────
gproject() {
  local project="$1"
  if [[ -z "$project" ]]; then
    local account
    account=$(gcloud config get account 2>/dev/null)
    echo -e "${_gs_bold}Projects for ${account}:${_gs_reset}"
    local projects
    projects=$(gcloud projects list --format="value(projectId)" 2>/dev/null)

    if command -v fzf &>/dev/null; then
      project=$(echo "$projects" | fzf --prompt="Switch to project > " --height=15 --reverse)
    else
      local i=1
      local proj_list=()
      while IFS= read -r p; do
        proj_list+=("$p")
        printf "  ${_gs_cyan}%d${_gs_reset}  %s\n" "$i" "$p"
        ((i++))
      done <<< "$projects"
      read -rp "Select project [1-$((i-1))]: " pchoice
      if [[ "$pchoice" =~ ^[0-9]+$ ]] && (( pchoice >= 1 && pchoice < i )); then
        project="${proj_list[$((pchoice-1))]}"
      fi
    fi
  fi

  if [[ -n "$project" ]]; then
    gcloud config set project "$project" 2>/dev/null
    _gs_show_active
  fi
}

# ── gauth: Re-authenticate current or specified account ────────────
gauth() {
  local account="${1:-$(gcloud config get account 2>/dev/null)}"
  echo -e "Re-authenticating ${_gs_cyan}${account}${_gs_reset}..."
  gcloud auth login "$account" --update-adc 2>/dev/null
  echo -e "${_gs_green}Done.${_gs_reset} ADC also updated."
}

# ── gauthall: Refresh auth for all accounts ────────────────────────
gauthall() {
  echo -e "${_gs_bold}Refreshing all account tokens...${_gs_reset}\n"
  local accounts
  accounts=$(gcloud auth list --format="value(account)" 2>/dev/null)
  while IFS= read -r account; do
    echo -e "  ${_gs_cyan}→${_gs_reset} $account"
    gcloud auth print-access-token --account="$account" >/dev/null 2>&1 && \
      echo -e "    ${_gs_green}✓ token valid${_gs_reset}" || \
      echo -e "    ${_gs_yellow}⚠ needs re-auth: run gauth $account${_gs_reset}"
  done <<< "$accounts"
}

# ── _gs_show_active: Display current active config ─────────────────
_gs_show_active() {
  local config account project
  config=$(gcloud config configurations list --filter="is_active=true" --format="value(name)" 2>/dev/null)
  account=$(gcloud config get account 2>/dev/null)
  project=$(gcloud config get project 2>/dev/null)
  echo -e "\n${_gs_green}Active:${_gs_reset} ${_gs_bold}${config}${_gs_reset} │ ${account} │ ${project}"
}

# ── Shell prompt integration (optional) ────────────────────────────
gcp_prompt() {
  local config account project
  config=$(gcloud config configurations list --filter="is_active=true" --format="value(name)" 2>/dev/null)
  project=$(gcloud config get project 2>/dev/null)
  echo "[gcp:${config}/${project}]"
}

# gswitch loaded silently. Run `gswitch` for usage.
