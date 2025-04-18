#!/usr/bin/env bats

load fixture

@test "update with commented-out line uncomments the first found" {
    run -0 addOrUncommentLine --line "disabled" <<'EOF'
First line
# disabled
third line
# disabled
# disabled
Last line
EOF
    assert_output - <<'EOF'
First line
disabled
third line
# disabled
# disabled
Last line
EOF
}
