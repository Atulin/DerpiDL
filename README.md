# DerpiDL

**A very simple command-line downloader for Derpibooru**

____

## Download

From the [releases page](https://github.com/Atulin/DerpiDL/releases/latest)

## Usage

* `--key` or `-K` to pass your API key. You only need to supply it once, it's saved in `derpidl.cfg`
* `--limit` or `-L` to set the limit of pages
* Any other strings passed as arguments are treated as tags to search for
* If you need to pass tags that contain non-alphanumeric characters like `-fluttershy` 
or `my:upvotes` enclose all tags in quotes

Search syntax is the same as on Depribooru/Philomena, that is `some tag, another tag`
and not `some_tag another_tag`.

## Sample commands

* `derpi-dl.exe -L 2 applejack, rainbow dash, safe`
    * Downloads first 2 pages of images tagged with `applejack`, `rainbow dash` and `safe`.
* `derpi-dl.exe "fluttershy, -rarity"`
    * Downloads all images tagged with `fluttershy` but not tagged with `rarity`.
* `derpi-dl.exe -K <your derpibooru key> -L 5 "pinkie pie, flurry heart"`
    * Saves `<your derpibooru key>` as the API key, and downloads 5 pages of images tagged with
    `pinkie pie` and `flurry heart`, applying your personal settings to the search.

## Building from source

```
> dart2native src/main.dart -o bin/derpi-dl
```

## Running from source

```
> cd src
> dart main.dart
```
