# DerpiDL

**A very simple command-line downloader for Derpibooru**

____

## Usage

* `--key` or `-K` to pass your API key
* `--limit` or `-L` to set the limit of pages
* Any other strings passed as arguments are treated as tags to search for

Search syntax is the same as on Depribooru/Philomena, that is `some tag, another tag`
and not `some_tag another_tag`.

## Building from source

```
> dart2native src/main.dart -o bin/derpi-dl
```

## Running from source

```
> cd src
> dart main.dart
```
