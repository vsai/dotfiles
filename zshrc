# ~/.zshrc — interactive shell config

# ── Completion ──────────────────────────────────────────
autoload -Uz compinit
compinit -u

# ── Prompt ──────────────────────────────────────────────
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%b)'
setopt PROMPT_SUBST
PROMPT='%F{red}vsai %F{yellow}%1~%F{cyan}${vcs_info_msg_0_} %F{yellow}$ %f'

# Directory colors
export LSCOLORS='Exfxcxdxbxegedabagacad'

# ── Aliases ─────────────────────────────────────────────
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# ── Python (pyenv) ──────────────────────────────────────
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# ── Node (nvm) ──────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ── Google Cloud SDK ────────────────────────────────────
if [ -f "$HOME/Documents/google-cloud-sdk/path.zsh.inc" ]; then
  source "$HOME/Documents/google-cloud-sdk/path.zsh.inc"
fi
if [ -f "$HOME/Documents/google-cloud-sdk/completion.zsh.inc" ]; then
  source "$HOME/Documents/google-cloud-sdk/completion.zsh.inc"
fi
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# GCP account/project switcher
source ~/dotfiles/init-scripts/gcloud-gswitch-setup.sh

# ── Bun ─────────────────────────────────────────────────
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# ── Deno ────────────────────────────────────────────────
. "$HOME/.deno/env"

# ── Yarn ────────────────────────────────────────────────
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# ── Claude CLI ──────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

# ── Ruby (rbenv) ────────────────────────────────────────
if command -v rbenv 1>/dev/null 2>&1; then
  eval "$(rbenv init - zsh)"
fi
