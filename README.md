# Flake8 with GitHub Actions -- including annotations for Pull Requests

[![GitHub License](https://img.shields.io/github/license/TrueBrain/actions-flake8)](https://github.com/TrueBrain/actions-flake8/blob/main/LICENSE)
[![GitHub Tag](https://img.shields.io/github/v/tag/TrueBrain/actions-flake8?include_prereleases&label=stable)](https://github.com/TrueBrain/actions-flake8/releases)
[![GitHub commits since latest release](https://img.shields.io/github/commits-since/TrueBrain/actions-flake8/latest/main)](https://github.com/TrueBrain/actions-flake8/commits/main)

This GitHub Actions runs flake8 over your code.
Any warnings or errors will be annotated in the Pull Request.

## Usage

```
uses: TrueBrain/actions-flake8@v1
```

### Parameter: path

Indicates the path to run `flake8` in.
This can be useful if your project is more than Python code.

This parameter is optional; by default `flake8` will run on your whole repository.

```
uses: TrueBrain/actions-flake8@v1
with:
  path: src
```

### Parameter: ignore

Indicates errors and warnings to skip.

This parameter is optional; by default no alerts will be ignored

```
uses: TrueBrain/actions-flake8@v1
with:
  ignore: E4,W
```


### Parameter: max_line_length

Indicates the maximum allowed line length.

This parameter is optional; by default flake8's default line length will be used.

```
uses: TrueBrain/actions-flake8@v1
with:
  max_line_length: 90
```


### Parameter: only_warn

Only warn about problems.
All errors and warnings are annotated in Pull Requests, but it will act like everything was fine anyway.
(In other words, the exit code is always 0.)

This parameter is optional; setting this to any value will enable it.

```
uses: TrueBrain/actions-flake8@v1
with:
  only_warn: 1
```
