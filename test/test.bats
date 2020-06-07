#!/usr/bin/env bats

# Tests using the Bats testing framework
# https://github.com/bats-core/bats-core

ROOT_ERROR_COUNT=5

export RUNNER_TEMP="/foo/runner_temp"

# This function runs before every test
function setup() {
    # Set default input values
    export INPUT_IGNORE=""
    export INPUT_MAX_LINE_LENGTH=""
    export INPUT_PATH="./test/testdata"
    export INPUT_ONLY_WARN=""
}

@test "Run with defaults" {
    # codespell's exit status is the number of misspelled words found
    expectedExitStatus=$((ROOT_MISSPELLING_COUNT + HIDDEN_MISSPELLING_COUNT + SUBFOLDER_MISSPELLING_COUNT))
    run "./entrypoint.sh"
    [ $status -eq $expectedExitStatus ]

    # Check output
    [ "${lines[1]}" == "::add-matcher::${RUNNER_TEMP}/_github_workflow/flake8-matcher.json" ]
    outputRegex="^Running flake8 on '${INPUT_PATH}'"
    [[ "${lines[2]}" =~ $outputRegex ]]
    [ "${lines[-3]}" == "flake8 found one or more problems" ]
    [ "${lines[-1]}" == "::remove-matcher owner=flake8::" ]
}

@test "Check max line length" {
    expectedExitStatus=0
    INPUT_PATH="./test/testdata/.hidden"
    run "./entrypoint.sh"
    [ $status -eq $expectedExitStatus ]
}

@test "Check the ignore option" {
    expectedExitStatus=$((ROOT_MISSPELLING_COUNT + HIDDEN_MISSPELLING_COUNT + SUBFOLDER_MISSPELLING_COUNT - EXCLUDED_MISSPELLING_COUNT))
    INPUT_EXCLUDE_FILE="./test/exclude-file.txt"
    run "./entrypoint.sh"
    [ $status -eq $expectedExitStatus ]
}

@test "Custom path" {
    expectedExitStatus=$((SUBFOLDER_MISSPELLING_COUNT))
    INPUT_PATH="./test/testdata/subfolder"
    run "./entrypoint.sh"
    [ $status -eq $expectedExitStatus ]
}

@test "Only warn" {
    expectedExitStatus=0
    INPUT_ONLY_WARN=true
    run "./entrypoint.sh"
    [ $status -eq $expectedExitStatus ]
}
