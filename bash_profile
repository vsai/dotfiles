
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

. "$HOME/.cargo/env"

export PATH="/Users/vishalsaidaswani/.local/share/solana/install/active_release/bin:$PATH"

source /Users/vishalsaidaswani/.docker/init-bash.sh || true # Added by Docker Desktop
. "/Users/vishalsaidaswani/.deno/env"