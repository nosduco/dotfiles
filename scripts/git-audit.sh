#!/usr/bin/env bash

set -euo pipefail

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "git audit must be run inside a git repository." >&2
  exit 1
fi

repo_root="$(git rev-parse --show-toplevel)"
repo_name="$(basename "${repo_root}")"
current_branch="$(git branch --show-current 2>/dev/null || true)"
if [[ -z "${current_branch}" ]]; then
  current_branch="(detached HEAD)"
fi

if [[ -n "$(git status --short)" ]]; then
  worktree_state="dirty"
else
  worktree_state="clean"
fi

last_commit_sha="$(git rev-parse --short HEAD)"
last_commit_subject="$(git log -1 --pretty=%s)"
origin_url="$(git remote get-url origin 2>/dev/null || true)"

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  c_reset=$'\033[0m'
  c_bold=$'\033[1m'
  c_dim=$'\033[2m'
  c_muted=$'\033[38;5;245m'
  c_blue=$'\033[38;5;111m'
  c_cyan=$'\033[38;5;117m'
  c_green=$'\033[38;5;149m'
  c_yellow=$'\033[38;5;223m'
  c_orange=$'\033[38;5;215m'
  c_red=$'\033[38;5;203m'
  c_magenta=$'\033[38;5;176m'
else
  c_reset=""
  c_bold=""
  c_dim=""
  c_muted=""
  c_blue=""
  c_cyan=""
  c_green=""
  c_yellow=""
  c_orange=""
  c_red=""
  c_magenta=""
fi

churn_cmd='git log --format=format: --name-only --since="1 year ago" | sort | uniq -c | sort -nr | head -20'
shortlog_cmd='git shortlog -sn --no-merges HEAD'
bug_cmd='git log -i -E --grep="fix|bug|broken" --name-only --format='\'''\'' | sort | uniq -c | sort -nr | head -20'
monthly_cmd='git log --format='\''%ad'\'' --date=format:'\''%Y-%m'\'' | sort | uniq -c'
firefight_cmd='git log --oneline --since="1 year ago" | grep -iE '\''revert|hotfix|emergency|rollback'\'''

readarray -t churn_lines < <(eval "${churn_cmd}" || true)
readarray -t shortlog_lines < <(eval "${shortlog_cmd}" || true)
readarray -t bug_lines < <(eval "${bug_cmd}" || true)
readarray -t monthly_lines < <(eval "${monthly_cmd}" || true)
readarray -t firefight_lines < <(eval "${firefight_cmd}" || true)

extract_count() {
  sed -E 's/^[[:space:]]*([0-9]+).*/\1/'
}

extract_label() {
  sed -E 's/^[[:space:]]*[0-9]+[[:space:]]+//'
}

trim() {
  sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//'
}

filter_ranked_lines() {
  local line label
  for line in "$@"; do
    [[ -z "${line}" ]] && continue
    label="$(printf '%s\n' "${line}" | extract_label | trim)"
    [[ -z "${label}" ]] && continue
    printf '%s\n' "${line}"
  done
}

append_filtered_lines() {
  local -n out_ref="$1"
  shift
  local line label

  out_ref=()
  for line in "$@"; do
    [[ -z "${line}" ]] && continue
    label="$(printf '%s\n' "${line}" | extract_label | trim)"
    [[ -z "${label}" ]] && continue
    out_ref+=("${line}")
  done
}

make_bar() {
  local count="$1"
  local max="$2"
  local width="$3"
  local filled=0
  local bar=""

  if (( max > 0 )); then
    filled=$(( count * width / max ))
  fi
  (( filled < 1 && count > 0 )) && filled=1
  while (( ${#bar} < filled )); do
    bar+="#"
  done
  printf '%s' "${bar}"
}

print_rule() {
  printf '%s\n' "${c_muted}-------------------------------------------------------------------------------${c_reset}"
}

print_title() {
  print_rule
  printf '%s%sGit Audit%s %s(%s)%s\n' "${c_bold}" "${c_blue}" "${c_reset}" "${c_dim}" "${repo_name}" "${c_reset}"
  print_rule
}

print_meta() {
  local worktree_color="${c_green}"
  if [[ "${worktree_state}" == "dirty" ]]; then
    worktree_color="${c_yellow}"
  fi

  printf '%sRepo:%s      %s\n' "${c_bold}" "${c_reset}" "${repo_root}"
  printf '%sBranch:%s    %s\n' "${c_bold}" "${c_reset}" "${current_branch}"
  printf '%sWorktree:%s  %s%s%s\n' "${c_bold}" "${c_reset}" "${worktree_color}" "${worktree_state}" "${c_reset}"
  printf '%sHEAD:%s      %s%s%s  %s\n' "${c_bold}" "${c_reset}" "${c_magenta}" "${last_commit_sha}" "${c_reset}" "${last_commit_subject}"
  if [[ -n "${origin_url}" ]]; then
    printf '%sOrigin:%s    %s\n' "${c_bold}" "${c_reset}" "${origin_url}"
  fi
  echo
}

print_section() {
  local title="$1"
  local command="$2"
  echo
  printf '%s[%s]%s %s\n' "${c_bold}" "${title}" "${c_reset}" "${c_dim}${command}${c_reset}"
}

print_ranked_table() {
  local accent="$1"
  shift
  local -a lines=("$@")
  local filtered=()
  local line label count max_count=0 shown=0

  append_filtered_lines filtered "${lines[@]}"
  for line in "${filtered[@]}"; do
    count="$(printf '%s\n' "${line}" | extract_count)"
    (( count > max_count )) && max_count="${count}"
  done

  if [[ ${#filtered[@]} -eq 0 ]]; then
    printf '  %sNo data.%s\n' "${c_dim}" "${c_reset}"
    return
  fi

  printf '  %sCount   File / Author%*sSignal%s\n' "${c_bold}" 29 '' "${c_reset}"
  for line in "${filtered[@]}"; do
    count="$(printf '%s\n' "${line}" | extract_count)"
    label="$(printf '%s\n' "${line}" | extract_label | trim)"
    printf '  %s%6s%s  %-48.48s %s%s%s\n' \
      "${accent}" "${count}" "${c_reset}" "${label}" \
      "${accent}" "$(make_bar "${count}" "${max_count}" 18)" "${c_reset}"
    shown=$(( shown + 1 ))
    (( shown >= 12 )) && break
  done
}

print_contributors() {
  local -a lines=("$@")
  local filtered=()
  local line label count total=0 max_count=0 shown=0 pct

  append_filtered_lines filtered "${lines[@]}"
  for line in "${filtered[@]}"; do
    count="$(printf '%s\n' "${line}" | extract_count)"
    total=$(( total + count ))
    (( count > max_count )) && max_count="${count}"
  done

  if [[ ${#filtered[@]} -eq 0 ]]; then
    printf '  %sNo contributor data.%s\n' "${c_dim}" "${c_reset}"
    return
  fi

  printf '  %sCommits  Share   Author%*sSignal%s\n' "${c_bold}" 31 '' "${c_reset}"
  for line in "${filtered[@]}"; do
    count="$(printf '%s\n' "${line}" | extract_count)"
    label="$(printf '%s\n' "${line}" | extract_label | trim)"
    pct=0
    if (( total > 0 )); then
      pct=$(( count * 100 / total ))
    fi
    printf '  %s%7s%s  %3s%%   %-36.36s %s%s%s\n' \
      "${c_cyan}" "${count}" "${c_reset}" "${pct}" "${label}" \
      "${c_cyan}" "$(make_bar "${count}" "${max_count}" 20)" "${c_reset}"
    shown=$(( shown + 1 ))
    (( shown >= 10 )) && break
  done
}

print_activity() {
  local -a lines=("$@")
  local total="${#lines[@]}"
  local start max_count=0 line label count

  if (( total == 0 )); then
    printf '  %sNo activity data.%s\n' "${c_dim}" "${c_reset}"
    return
  fi

  start=$(( total > 12 ? total - 12 : 0 ))
  printf '  %sMonth    Commits  Trend%s\n' "${c_bold}" "${c_reset}"
  for ((i = start; i < total; i++)); do
    count="$(printf '%s\n' "${lines[i]}" | extract_count)"
    (( count > max_count )) && max_count="${count}"
  done

  for ((i = start; i < total; i++)); do
    count="$(printf '%s\n' "${lines[i]}" | extract_count)"
    label="$(printf '%s\n' "${lines[i]}" | extract_label | trim)"
    printf '  %s%-7s%s %7s  %s%s%s\n' \
      "${c_yellow}" "${label}" "${c_reset}" "${count}" \
      "${c_yellow}" "$(make_bar "${count}" "${max_count}" 24)" "${c_reset}"
  done
}

print_firefights() {
  local -a lines=("$@")
  local shown=0 line sha subject

  if [[ ${#lines[@]} -eq 0 ]]; then
    printf '  %sNo firefighting commits matched in the last year.%s\n' "${c_dim}" "${c_reset}"
    return
  fi

  for line in "${lines[@]}"; do
    sha="${line%% *}"
    subject="${line#* }"
    printf '  %s%s%s  %s\n' "${c_red}" "${sha}" "${c_reset}" "${subject}"
    shown=$(( shown + 1 ))
    (( shown >= 12 )) && break
  done

  if (( ${#lines[@]} > shown )); then
    printf '  %s... and %s more%s\n' "${c_dim}" "$(( ${#lines[@]} - shown ))" "${c_reset}"
  fi
}

top_line_from() {
  local line label
  for line in "$@"; do
    label="$(printf '%s\n' "${line}" | extract_label | trim)"
    [[ -z "${label}" ]] && continue
    printf '%s\n' "${line}"
    return 0
  done
  return 1
}

top_churn_count=0
top_churn_file="none"
if top_line="$(top_line_from "${churn_lines[@]}")"; then
  top_churn_count="$(printf '%s\n' "${top_line}" | extract_count)"
  top_churn_file="$(printf '%s\n' "${top_line}" | extract_label | trim)"
fi

top_bug_count=0
top_bug_file="none"
if top_line="$(top_line_from "${bug_lines[@]}")"; then
  top_bug_count="$(printf '%s\n' "${top_line}" | extract_count)"
  top_bug_file="$(printf '%s\n' "${top_line}" | extract_label | trim)"
fi

declare -A churn_map=()
declare -A bug_map=()
filtered_churn_lines=()
filtered_bug_lines=()
append_filtered_lines filtered_churn_lines "${churn_lines[@]}"
append_filtered_lines filtered_bug_lines "${bug_lines[@]}"

for line in "${filtered_churn_lines[@]}"; do
  label="$(printf '%s\n' "${line}" | extract_label | trim)"
  churn_map["${label}"]="$(printf '%s\n' "${line}" | extract_count)"
done

for line in "${filtered_bug_lines[@]}"; do
  label="$(printf '%s\n' "${line}" | extract_label | trim)"
  bug_map["${label}"]="$(printf '%s\n' "${line}" | extract_count)"
done

shared_hotspot="none"
shared_hotspot_score=0
for file in "${!churn_map[@]}"; do
  if [[ -n "${bug_map[$file]:-}" ]]; then
    score=$(( churn_map["$file"] + bug_map["$file"] ))
    if (( score > shared_hotspot_score )); then
      shared_hotspot_score=$score
      shared_hotspot="${file}"
    fi
  fi
done

top_author="none"
top_author_commits=0
total_commits=0
if top_line="$(top_line_from "${shortlog_lines[@]}")"; then
  top_author_commits="$(printf '%s\n' "${top_line}" | extract_count)"
  top_author="$(printf '%s\n' "${top_line}" | extract_label | trim)"
fi

filtered_shortlog_lines=()
append_filtered_lines filtered_shortlog_lines "${shortlog_lines[@]}"
for line in "${filtered_shortlog_lines[@]}"; do
  total_commits=$(( total_commits + $(printf '%s\n' "${line}" | extract_count) ))
done

bus_factor_note="No contributor concentration signal."
if (( total_commits > 0 )); then
  top_author_pct=$(( top_author_commits * 100 / total_commits ))
  if (( top_author_pct >= 60 )); then
    bus_factor_note="${top_author} owns ${top_author_pct}% of non-merge commits."
  else
    bus_factor_note="${top_author} leads with ${top_author_pct}% of non-merge commits."
  fi
fi

monthly_total=${#monthly_lines[@]}
last_month="none"
recent_half=0
previous_half=0
if (( monthly_total > 0 )); then
  last_month="$(printf '%s\n' "${monthly_lines[monthly_total-1]}" | extract_label | trim)"
fi
start_recent=$(( monthly_total > 6 ? monthly_total - 6 : 0 ))
start_previous=$(( monthly_total > 12 ? monthly_total - 12 : 0 ))
end_previous=$(( monthly_total > 6 ? monthly_total - 6 : 0 ))

for ((i = start_recent; i < monthly_total; i++)); do
  recent_half=$(( recent_half + $(printf '%s\n' "${monthly_lines[i]}" | extract_count) ))
done

for ((i = start_previous; i < end_previous; i++)); do
  previous_half=$(( previous_half + $(printf '%s\n' "${monthly_lines[i]}" | extract_count) ))
done

activity_note="Activity data is too sparse to compare."
if (( monthly_total > 0 )); then
  activity_note="Last commit month: ${last_month}."
  if (( previous_half > 0 )); then
    if (( recent_half > previous_half )); then
      activity_note="${activity_note} Last 6 months are busier than the prior 6 (${recent_half} vs ${previous_half} commits)."
    elif (( recent_half < previous_half )); then
      activity_note="${activity_note} Last 6 months are quieter than the prior 6 (${recent_half} vs ${previous_half} commits)."
    else
      activity_note="${activity_note} Last 6 months match the prior 6 (${recent_half} commits each)."
    fi
  fi
fi

firefight_count=${#firefight_lines[@]}
firefight_note="No firefighting commits matched the keyword scan in the last year."
if (( firefight_count == 1 )); then
  firefight_note="1 firefighting-style commit matched in the last year."
elif (( firefight_count > 1 )); then
  firefight_note="${firefight_count} firefighting-style commits matched in the last year."
fi

print_title
print_meta

print_section "Summary" "derived from the five repo-history probes below"
printf '  %sTop churn:%s    %s (%s touches in the last year)\n' "${c_bold}" "${c_reset}" "${top_churn_file}" "${top_churn_count}"
printf '  %sTop bug:%s      %s (%s bug/fix mentions)\n' "${c_bold}" "${c_reset}" "${top_bug_file}" "${top_bug_count}"
if [[ "${shared_hotspot}" == "none" ]]; then
  printf '  %sOverlap:%s      no shared file appeared in both top-20 lists\n' "${c_bold}" "${c_reset}"
else
  printf '  %sOverlap:%s      %s appears in both churn and bug hotspots\n' "${c_bold}" "${c_reset}" "${shared_hotspot}"
fi
printf '  %sOwnership:%s    %s\n' "${c_bold}" "${c_reset}" "${bus_factor_note}"
printf '  %sActivity:%s     %s\n' "${c_bold}" "${c_reset}" "${activity_note}"
printf '  %sFirefights:%s  %s\n' "${c_bold}" "${c_reset}" "${firefight_note}"

print_section "What Changes the Most" "${churn_cmd}"
print_ranked_table "${c_orange}" "${churn_lines[@]}"

print_section "Who Built This" "${shortlog_cmd}"
print_contributors "${shortlog_lines[@]}"

print_section "Where Do Bugs Cluster" "${bug_cmd}"
print_ranked_table "${c_red}" "${bug_lines[@]}"

print_section "Is This Project Accelerating or Dying" "${monthly_cmd}"
print_activity "${monthly_lines[@]}"

print_section "How Often Is the Team Firefighting" "${firefight_cmd}"
print_firefights "${firefight_lines[@]}"
