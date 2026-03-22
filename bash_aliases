alias gg='git grep'
alias gt='git'
alias gb='git br'
alias fgrep='find . | grep'
alias gd='git diff'
alias gst='git status'
alias gls='git log --stat'
alias glpp='git log --pretty=oneline'
alias glp='git log -p'
alias gl='git log'
alias ga='git add'
alias gc='git commit'
alias gprom='git pull --rebase origin main'
alias editcreds='EDITOR=vi rails credentials:edit'

# git push origin local-name:remote-name
# alias to push from development br -> staging repo master branch
alias gpstaging='git push staging development:master'
# alias to push from development br -> production repo master branch
alias gpprod='git push production development:master'


alias sqltd='~/co/manage/cpp/sqlt/sqlt development-lt 5458'

alias less='less -R'

gitRebaseInteractive() {
    git rebase -i HEAD~$1
}
alias gri=gitRebaseInteractive

alias howcoolforschool='git log --author="vsai" --pretty=tformat: --numstat | gawk '"'"'{ add += $1; subs += $2; loc += $1-$2 } END {printf "added lines: %s removed lines: %s total lines: %s\n", add, subs, loc }'"'"

alias startZeus='cd ~/co/manage; script/zeus start'
zeusTestFile() {
  cd ~/co/manage; script/zeus test $1 -fd -rdebugger
}
alias testit=zeusTestFile

alias psqlstart='brew services start postgresql@14'
alias psqlstop='brew services stop postgresql@14'
alias psqlrestart='brew services restart postgresql@14'

alias cdp='cd ~/Documents/projects/'

alias solanaconfigsetlocal='solana config set --url localhost'
alias solanaconfigget='solana config get'
alias gitremotepruneorigin='git remote prune origin'

alias createvenv='python3 -m venv'
alias outputvenv='pip3 freeze > requirements.txt'

gcloudHelpOutput() {
  echo 'list all configurations: gcloud config configurations list'
  echo 'activate bonkbotbeta: gcloud config configurations activate bonkbotbeta'
  echo 'activate whatsappautomator: gcloud config configurations activate whatsapp'
  gcloud config list
}
alias gcphelp=gcloudHelpOutput
alias gcloudauth='gcloud auth application-default login'
alias gcpauth='gcloud auth login'
alias gcpwhatsapp='gcloud config configurations activate whatsapp'
alias gcpbonkbot='gcloud config configurations activate bonkbotbeta'
alias gcpsshwhatsapp='gcloud compute ssh whatsapp-automator'

alias bbredis='redis-cli -h 10.9.113.2'
alias bbpsql='psql -h 10.9.112.27 -p 5432 -U vish bonkbot'
alias deploywebapi='./deploy/deploy-bonkbot.sh -b webapi-beta'
alias deploybeta='./deploy/deploy-bonkbot.sh -b beta'
#git worktree remove directory/

alias gcpsshsignerbeta='gcloud compute ssh signer-local --project bonkbotbeta'
