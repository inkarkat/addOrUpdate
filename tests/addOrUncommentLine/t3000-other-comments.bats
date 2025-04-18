#!/usr/bin/env bats

load fixture

@test "update with SQL-style line comment prefix" {
    run -0 addOrUncommentLine --comment-prefix ';' --line 'disabled' <<'EOF'
First line
;SQL-style to end of line comment
;disabled
EOF

    assert_output - <<'EOF'
First line
;SQL-style to end of line comment
disabled
EOF
}

@test "update with C-style line comment prefix" {
    run -0 addOrUncommentLine --comment-prefix '//[[:space:]]*' --line 'disabled' <<'EOF'
First line
// C-style to end of line comment
// disabled
EOF

    assert_output - <<'EOF'
First line
// C-style to end of line comment
disabled
EOF
}

@test "update with C-style inline comment prefix and suffix" {
    run -0 addOrUncommentLine --comment-prefix '/\*[[:space:]]*' --comment-suffix '[[:space:]]*\*/' --line 'disabled' <<'EOF'
First line
/* C-style to end of line comment */
/* disabled */
last
EOF

    assert_output - <<'EOF'
First line
/* C-style to end of line comment */
disabled
last
EOF
}

@test "update with CSS-style important suffix" {
    run -0 addOrUncommentLine --comment-prefix '' --comment-suffix '[[:space:]]*!important' --line 'margin: wide' <<'EOF'
First line
margin: wide !important
border: 1px
EOF

    assert_output - <<'EOF'
First line
margin: wide
border: 1px
EOF
}
