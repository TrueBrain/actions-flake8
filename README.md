# Flake8 with GitHub Actions -- including annotations for Pull Requests

[![GitHub License](https://img.shields.io/github/license/TrueBrain/actions-flake8)](https://github.com/TrueBrain/actions-flake8/blob/main/LICENSE)
[![GitHub Tag](https://img.shields.io/github/v/tag/TrueBrain/actions-flake8?include_prereleases&label=stable)](https://github.com/TrueBrain/actions-flake8/releases)
[![GitHub commits since latest release](https://img.shields.io/github/commits-since/TrueBrain/actions-flake8/latest/main)](https://github.com/TrueBrain/actions-flake8/commits/main)

This GitHub Actions runs flake8 over your code.
Any warnings or errors will be annotated in the Pull Request.

## Usage

```
steps:
- uses: actions/checkout@v2
- uses: TrueBrain/actions-flake8@v2
```

By default, it uses the default Python version as installed on the GitHub Runner.

### Different Python version

```
steps:
- uses: actions/checkout@v2
- uses: actions/setup-python@v2
  with:
    python-version: 3.9
- uses: TrueBrain/actions-flake8@v2
  with:
    path: src
```

### Parameter: flake8_version

In some cases you might want to pin a certain flake8 version.

This parameter is optional; by default the latest flake8 will be installed (if no flake8 is installed yet).

```
steps:
- uses: actions/checkout@v2
- uses: TrueBrain/actions-flake8@v2
  with:
    flake8_version: 3.8.0
```

Alternatively, you can pre-install flake8 before executing this action:

```
steps:
- uses: actions/checkout@v2
- run: pip install flake8==3.8.0
- uses: TrueBrain/actions-flake8@v2
```

If needed, this also allows you to install other flake8-plugins.

### Parameter: path

Indicates the path to run `flake8` in.
This can be useful if your project is more than Python code.

This parameter is optional; by default `flake8` will run on your whole repository.

```
steps:
- uses: actions/checkout@v2
- uses: TrueBrain/actions-flake8@v2
  with:
    path: src
```

### Parameter: ignore

Indicates errors and warnings to skip.

This parameter is optional; by default no alerts will be ignored

```
steps:
- uses: actions/checkout@v2
- uses: TrueBrain/actions-flake8@v2
  with:
    ignore: E4,W
```


### Parameter: max_line_length

Indicates the maximum allowed line length.

This parameter is optional; by default flake8's default line length will be used.

```
steps:
- uses: actions/checkout@v2
- uses: TrueBrain/actions-flake8@v2
  with:
    max_line_length: 90
```


### Parameter: only_warn

Only warn about problems.
All errors and warnings are annotated in Pull Requests, but it will act like everything was fine anyway.
(In other words, the exit code is always 0.)

This parameter is optional; setting this to any value will enable it.

```
steps:
- uses: actions/checkout@v2
- uses: TrueBrain/actions-flake8@v2
  with:
    only_warn: 1
```

### Parameter: plugins

List of plugins to install before running, This is passed directly to `pip install`.

This parameter is optional; setting this to any value will enable it.

```
steps:
- uses: actions/checkout@v2
- uses: TrueBrain/actions-flake8@v2
  with:
    plugins: flake8-bugbear cohesion==0.9.1
```

### Parameter: error_classes

List of flake8 error classes to classify as Error.

This parameter is optional; by default `E` and `F` classes will be considered errors.

```
steps:
- uses: actions/checkout@v2
- uses: TrueBrain/actions-flake8@v2
  with:
    error_classes: E,H
```

### Parameter: warning_classes

List of flake8 error classes to classify as Warning.

This parameter is optional; by default `W` class will be considered a warning.

```
steps:
- uses: actions/checkout@v2
- uses: TrueBrain/actions-flake8@v2
  with:
    warning_classes: W,B,D
```
