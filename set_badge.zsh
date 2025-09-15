# NOTE: iterm2 duplicates the badge on new terms. I recommend calling `set_badge ""`
# in zshrc to clear it.
set_badge() {
    local text="$1"
    printf "\033]1337;SetBadgeFormat=%s\007"  "$(echo "$1" | base64)"
}
