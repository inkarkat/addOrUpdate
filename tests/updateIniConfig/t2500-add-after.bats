#!/usr/bin/env bats

load temp

@test "update with existing configuration after the passed line keeps contents and returns 99" {
    run -99 updateIniConfig --add-after 8 --section default --key foo --value bar "$FILE"
    assert_output - < "$INPUT"
}
