#!/bin/sh

# Copy the matcher to a shared volume with the host; otherwise "add-matcher"
# can't find it.
cp /code/flake8-matcher.json ${HOME}/
echo "::add-matcher::${HOME}/flake8-matcher.json"

# Create the flake8 arguments
echo "Running flake8 on '${INPUT_PATH}' with the following options:"
command_args=""
echo " - ignoring: '${INPUT_IGNORE}'"
if [ "x${INPUT_IGNORE}" != "x" ]; then
    command_args="${command_args} --ignore ${INPUT_IGNORE}"
fi
echo " - nax line length: '${INPUT_MAX_LINE_LENGTH}'"
if [ "x${INPUT_MAX_LINE_LENGTH}" != "x" ]; then
    command_args="${command_args} --max-line-length ${INPUT_MAX_LINE_LENGTH}"
fi
echo " - path: '${INPUT_PATH}'"
command_args="${command_args} ${INPUT_PATH}"
echo "Resulting command: flake8 ${command_args}"

# Run flake8
flake8 ${command_args}
if [ "$?" = "0" ]; then
    echo "Flake8 found no problems"
else
    echo "Flake8 found one or more problems"
fi

# Remove the matcher, so no other jobs hit it.
echo "::remove-matcher owner=flake8-error::"
echo "::remove-matcher owner=flake8-warning::"

# If we are in warn-only mode, return always as if we pass
if [ -n "${INPUT_ONLY_WARN}" ]; then
    exit 0
else
    exit $res
fi
