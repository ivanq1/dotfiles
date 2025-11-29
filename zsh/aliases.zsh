' Load all individual aliases from aliases.d
ALIASES_DIR="$HOME/dotfiles/zsh/aliases.d"
if [ -d "$ALIASES_DIR" ]; then
  for alias_file in $ALIASES_DIR/*.zsh(.N); do
    source "$alias_file"
  done
fi

# Helper: Add a new alias with optional description.
function alias-add() {
  local name="$1"
  local value="$2"
  local desc="$3"
  local file="$ALIASES_DIR/${name}.zsh"

  if [[ -z "$name" || -z "$value" ]]; then
    echo "Usage: alias-add <name> <command> [description]"
    return 1
  fi

  mkdir -p "$ALIASES_DIR"
  {
    [[ -n "$desc" ]] && echo "# $desc"
    echo "alias $name='$value'"
  } > "$file"

  source "$file"
  echo "Alias '$name' added."
  if [[ -n "$desc" ]]; then echo "Description: $desc"; fi
}

# Helper: List all aliases with descriptions if present
function alias-list() {
  for f in $ALIASES_DIR/*.zsh(.N); do
    name=$(basename "$f" .zsh)
    desc=""
    if grep -q "^#" "$f"; then
      desc=$(head -n 1 "$f" | sed 's/^# //')
    fi
    cmd=$(grep 'alias ' "$f" | sed "s/^alias $name='\(.*\)'$/\1/")
    printf "%16s → %-30s %s\n" "$name" "$cmd" "$desc"
  done
}