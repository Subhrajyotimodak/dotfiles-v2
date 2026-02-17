#!/usr/bin/env bash
set -euo pipefail

prog_name="$(basename "$0")"

usage() {
  cat <<'EOF'
github-switch - view and switch git identity per-repo

Usage:
  github-switch current
  github-switch list
  github-switch use <profile>
  github-switch help

Accounts file (local-only, not committed):
  $XDG_CONFIG_HOME/github-switch/accounts.conf
  or ~/.config/github-switch/accounts.conf

Format (tab-separated):
  <profile>\t<name>\t<email>
EOF
}

die() {
  echo "error: $*" >&2
  exit 1
}

in_git_repo() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1
}

accounts_file() {
  if [[ -n "${GITHUB_SWITCH_ACCOUNTS_FILE:-}" ]]; then
    echo "$GITHUB_SWITCH_ACCOUNTS_FILE"
    return 0
  fi

  local xdg="${XDG_CONFIG_HOME:-$HOME/.config}"
  echo "$xdg/github-switch/accounts.conf"
}

require_accounts_file() {
  local f
  f="$(accounts_file)"
  [[ -f "$f" ]] || die "accounts file not found: $f (create it or copy from accounts.conf.example)"
  echo "$f"
}

effective_git_config_get() {
  local key="$1"

  if in_git_repo; then
    git config --local --get "$key" 2>/dev/null \
      || git config --global --get "$key" 2>/dev/null \
      || true
  else
    git config --global --get "$key" 2>/dev/null || true
  fi
}

cmd_current() {
  local name email
  name="$(effective_git_config_get user.name)"
  email="$(effective_git_config_get user.email)"

  [[ -n "$name" ]] || name="<unset>"
  [[ -n "$email" ]] || email="<unset>"

  echo "user.name:  $name"
  echo "user.email: $email"
}

cmd_list() {
  local f
  f="$(require_accounts_file)"

  local line_no=0
  while IFS= read -r line || [[ -n "$line" ]]; do
    line_no=$((line_no + 1))
    [[ -z "$line" ]] && continue
    [[ "$line" =~ ^[[:space:]]*# ]] && continue

    local profile name email
    IFS=$'\t' read -r profile name email _rest <<<"$line"

    if [[ -z "${profile:-}" || -z "${name:-}" || -z "${email:-}" ]]; then
      die "invalid line $line_no in $f (expected: <profile>\\t<name>\\t<email>)"
    fi

    printf '%s\n' "$profile"
  done <"$f"
}

lookup_profile() {
  local wanted="$1"
  local f
  f="$(require_accounts_file)"

  local line_no=0
  while IFS= read -r line || [[ -n "$line" ]]; do
    line_no=$((line_no + 1))
    [[ -z "$line" ]] && continue
    [[ "$line" =~ ^[[:space:]]*# ]] && continue

    local profile name email
    IFS=$'\t' read -r profile name email _rest <<<"$line"
    if [[ -z "${profile:-}" || -z "${name:-}" || -z "${email:-}" ]]; then
      die "invalid line $line_no in $f (expected: <profile>\\t<name>\\t<email>)"
    fi

    if [[ "$profile" == "$wanted" ]]; then
      printf '%s\t%s\n' "$name" "$email"
      return 0
    fi
  done <"$f"

  return 1
}

cmd_use() {
  local profile="${1:-}"
  [[ -n "$profile" ]] || die "missing profile (try: $prog_name list)"

  in_git_repo || die "not inside a git repository (this command sets per-repo config)"

  local result name email
  if ! result="$(lookup_profile "$profile")"; then
    die "profile not found: $profile (try: $prog_name list)"
  fi

  IFS=$'\t' read -r name email <<<"$result"
  [[ -n "$name" && -n "$email" ]] || die "profile '$profile' is invalid"

  git config --local user.name "$name"
  git config --local user.email "$email"

  echo "switched repo identity to: $profile"
  cmd_current
}

cmd_help() {
  usage
}

main() {
  local cmd="${1:-help}"
  shift || true

  case "$cmd" in
    current) cmd_current "$@" ;;
    list) cmd_list "$@" ;;
    use) cmd_use "$@" ;;
    help|-h|--help) cmd_help ;;
    *)
      usage >&2
      die "unknown command: $cmd"
      ;;
  esac
}

main "$@"
