alias gg='git grep'
alias gt='git'
alias gb='git br'
alias cdcm='cd ~/co/manage/'
alias cdcr='cd ~/co/router/'
alias cdcmr='cd ~/co/manage-released/'
alias fgrep='find . | grep'
alias gsr='git svn rebase'
alias gd='git diff'
alias gst='git status'
alias gls='git log --stat'
alias glpp='git log --pretty=oneline'
alias glp='git log -p'
alias gl='git log'
alias ga='git add'
alias gc='git commit'
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


alias clone_dotfiles='git clone dev:~/meraki_dotfiles'

alias make_router_powerpc_tftp='cd ~/co/router; time make -j8 -C base BOARD=wired-powerpc tftp'

alias push_to_gerrit='git push origin HEAD:refs/for/master'

alias howcoolforschool='git log --author="vsai" --pretty=tformat: --numstat | gawk '"'"'{ add += $1; subs += $2; loc += $1-$2 } END {printf "added lines: %s removed lines: %s total lines: %s\n", add, subs, loc }'"'"

alias startZeus='cd ~/co/manage; script/zeus start'
zeusTestFile() {
  cd ~/co/manage; script/zeus test $1 -fd -rdebugger
}
alias testit=zeusTestFile

alias psqlstart='brew services start postgresql'
alias psqlstop='brew services stop postgresql'
alias psqlrestart='brew services restart postgresql'

alias cdp='cd ~/Documents/projects/'

alias cdpp='cd ~/Documents/projects/propty/'
alias cdeh='cd ~/Documents/projects/easyhomey/'
alias cdsy='cd ~/Documents/projects/synergy/synergizer/'
alias cdsm='cd ~/Documents/projects/synergy/synergy-mobile/'
