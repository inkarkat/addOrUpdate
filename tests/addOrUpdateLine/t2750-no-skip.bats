#!/usr/bin/env bats

load temp

@test "update with pattern skips all lines except one and updates that" {
    run -0 addOrUpdateLine --line "foo=new" --update-match "o=" --skip '1,$' --no-skip '/z/' "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
foo=new
# SECTION
foo=hi
EOF
}

@test "update with pattern skips matching lines except one and updates that" {
    run -0 addOrUpdateLine --line "foo=new" --update-match "o=" --skip '/^foo=/' --no-skip '/z/' "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
foo=new
# SECTION
foo=hi
EOF
}

@test "update with pattern skips matching lines except three and updates the first matching one" {
    run -0 addOrUpdateLine --line "foo=new" --update-match "o=" --skip '/^foo=/' --no-skip 33 --no-skip '/r/' --no-skip '/z/' "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=new
foo=hoo bar baz
# SECTION
foo=hi
EOF
}

@test "update with pattern skips matching lines except range and updates its first line" {
    run -0 addOrUpdateLine --line "foo=new" --update-match "o=" --skip '/^foo=/' --no-skip 3,5 "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
foo=new
# SECTION
foo=hi
EOF
}

@test "skipping the final section prevents appending at the end" {
    run -1 addOrUpdateLine --line "foo=new" --skip '/# SECTION/,$' --no-skip '/# SECTION/' "$FILE"
    assert_output - < "$FILE"
}

@test "skip the final section and prepend before it" {
    run -0 addOrUpdateLine --line "foo=new" --skip '/# SECTION/,$' --no-skip '/# SECTION/' --add-before '/# SECTION/' "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
foo=hoo bar baz
foo=new
# SECTION
foo=hi
EOF
}
