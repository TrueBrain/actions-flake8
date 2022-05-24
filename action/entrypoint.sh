#!/bin/sh

# Enable the matcher.
ACTION_FOLDER=$(dirname ${0})
echo " - error_classes: '${INPUT_ERROR_CLASSES}'"
error_classes=$(echo "${INPUT_ERROR_CLASSES}" | sed "s/,//g")
sed -i "s/{{error_classes}}/${error_classes}/g" "${ACTION_FOLDER}/flake8-matcher.json"

echo " - warning_classes: '${INPUT_WARNING_CLASSES}'"
if [ -n "${INPUT_WARNING_CLASSES}" ]; then
  warning_classes=$(echo "${INPUT_WARNING_CLASSES}" | sed "s/,//g")
  sed -i "s/{{warning_classes}}/${warning_classes}/g" "${ACTION_FOLDER}/flake8-matcher.json"
else
  sed -i "s/{{warning_classes}}/^${error_classes}/g" "${ACTION_FOLDER}/flake8-matcher.json"
fi
echo "::add-matcher::${ACTION_FOLDER}/flake8-matcher.json"

# Create the flake8 arguments.
echo "Running flake8 on '${INPUT_PATH}' with the following options:"

command_args=""

echo " - ignoring: '${INPUT_IGNORE}'"
if [ "x${INPUT_IGNORE}" != "x" ]; then
    command_args="${command_args} --ignore ${INPUT_IGNORE}"
fi

echo " - max line length: '${INPUT_MAX_LINE_LENGTH}'"
if [ "x${INPUT_MAX_LINE_LENGTH}" != "x" ]; then
    command_args="${command_args} --max-line-length ${INPUT_MAX_LINE_LENGTH}"
fi

echo " - path: '${INPUT_PATH}'"
command_args="${command_args} ${INPUT_PATH}"

echo " - extra arguments: '${INPUT_EXTRA_ARGUMENTS}'"
if [ "x${INPUT_EXTRA_ARGUMENTS}" != "x" ]; then
    command_args="${command_args} ${INPUT_EXTRA_ARGUMENTS}"
fi

echo "Resulting command: flake8 ${command_args}"

# Run flake8.
flake8 ${command_args}
res=$?
if [ "$res" = "0" ]; then
    echo "Flake8 found no problems"
else
    echo "Flake8 found one or more problems"
fi

# Remove the matcher, so no other jobs hit it.
echo "::remove-matcher owner=flake8-error::"
echo "::remove-matcher owner=flake8-warning::"

# If we are in warn-only mode, return always as if we pass.
if [ -n "${INPUT_ONLY_WARN}" ]; then
    exit 0
else
    exit $res
fi
