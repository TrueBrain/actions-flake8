#!/usr/bin/env bats

# Tests using the Bats testing framework
# https://github.com/bats-core/bats-core

export RUNNER_TEMP="/foo/runner_temp"

# This function runs before every test
function setup() {
    # Simulate the Dockerfile COPY command
    [ -d "${RUNNER_TEMP}/code/" ] || sudo mkdir -p ${RUNNER_TEMP}/code/
    [ -f "${RUNNER_TEMP}/code/flake8-matcher.json" ] || sudo cp flake8-matcher.json ${RUNNER_TEMP}/code/
    #ls -alR ${RUNNER_TEMP}/code/
    [ -d "/code/" ] || sudo mkdir -p /code/
    [ -f "/code/flake8-matcher.json" ] || sudo cp flake8-matcher.json /code/
    #ls -alR /code/
    # Add a random place BATS tries to put it
    [ -d "/github/workflow/" ] || sudo mkdir -p /github/workflow/ && sudo chmod 777 /github/workflow/
    #ls -alR /github/workflow/
    
    # Set default input values
    export INPUT_IGNORE=""
    export INPUT_MAX_LINE_LENGTH=""
    export INPUT_PATH="./test/testdata"
    export INPUT_ONLY_WARN=""
}

@test "Run with defaults" {
    # codespell's exit status is the number of misspelled words found
    expectedExitStatus=1
    run "./entrypoint.sh"
    [ $status -eq $expectedExitStatus ]

    # Check output
    [ "${lines[1]}" == "::add-matcher::${RUNNER_TEMP}/_github_workflow/flake8-matcher.json" ]
    outputRegex="^Running flake8 on '${INPUT_PATH}'"
    [[ "${lines[2]}" =~ $outputRegex ]]
    [ "${lines[-2]}" == "Flake8 found one or more problems" ]
    [ "${lines[-1]}" == "::remove-matcher owner=flake8::" ]
}

@test "Check max line length" {
    expectedExitStatus=0
    INPUT_MAX_LINE_LENGTH=90
    INPUT_PATH="./test/testdata/testlinelength.py"
    run "./entrypoint.sh"
    [ $status -eq $expectedExitStatus ]
}

@test "Check the ignore option" {
    expectedExitStatus=0
    INPUT_IGNORE="E501"
    INPUT_PATH="./test/testdata/testlinelength.py"
    run "./entrypoint.sh"
    [ $status -eq $expectedExitStatus ]
}

@test "Custom path" {
    expectedExitStatus=0
    # The file in this folder has no errors
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
