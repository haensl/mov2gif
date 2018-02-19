# mov2gif

Bash script to convert `.mov` videos to GIF animations based on [tskaggs/OSX-Convert-MOV-GIF](https://gist.github.com/tskaggs/6394639).

## Installation

### Prerequisites

**mov2gif** depends on

* [ffmpeg](https://www.ffmpeg.org)
* [imagemagick](https://www.imagemagick.org/script/index.php)

Plese make sure they are installed on your system.

### Linux

1. Clone this repository
2. `make install`

### OSX

1. `brew tap haensl/haensl`
2. `brew install mov2gif`

## Usage

For additional usage information please consider consulting the man page.

### Synopsis

```bash
mov2gif  [-hv]
         [-o ouput-path] [-w width]
         file.mov
```

### Options

#### `-h, --help`

Display usage information.

#### `-o output-path, --output output-path`

Set the path for the generated GIF animation. If the given path does not end in `.gif`, the extension is appended. If omitted the generated GIF animation is saved next to the input file.

#### `-v, --version`

Display version information

#### `-w width, --width width`

Set the width in pixel of the generated GIF animation. Height is inferred by input aspect ratio. If omitted width is set to input width.

#### [Changelog](CHANGELOG.md)

#### [License](LICENSE)
