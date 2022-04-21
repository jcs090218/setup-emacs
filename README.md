[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Release Tag](https://img.shields.io/github/tag/jcs090218/setup-emacs.svg?label=release&logo=github)](https://github.com/jcs090218/setup-emacs/releases/latest)

# Set up Emacs
> Github action which installs a given Emacs version

[![Build Status](https://github.com/jcs090218/setup-emacs/workflows/CI/badge.svg)](https://github.com/jcs090218/setup-emacs/actions)
[![Build](https://github.com/jcs090218/setup-emacs/actions/workflows/build.yml/badge.svg)](https://github.com/jcs090218/setup-emacs/actions/workflows/build.yml)
[![dependencies Status](https://status.david-dm.org/gh/jcs090218/setup-emacs.svg)](https://david-dm.org/jcs090218/setup-emacs)

This is a simple action that merges these two actions 🎉

- [purcell/setup-emacs](https://github.com/purcell/setup-emacs)
- [jcs090218/setup-emacs-windows](https://github.com/jcs090218/setup-emacs-windows)

This allow us to use Emacs across all operating systems!

## 🔨 Usage

```yaml
uses: jcs090218/setup-emacs@master
with:
  version: 24.5
```

## ❓ What does it solve?

You use to have this,

```yaml
    steps:
    - uses: actions/checkout@v2

    # Install Emacs on Linux/macOS
    - uses: purcell/setup-emacs@master
      if: matrix.os == 'ubuntu-latest' || matrix.os == 'macos-latest'
      with:
        version: ${{ matrix.emacs-version }}

    # Install Emacs on Windows
    - uses: jcs090218/setup-emacs-windows@master
      if: matrix.os == 'windows-latest'
      with:
        version: ${{ matrix.emacs-version }}
```

now you can replace all by this:

```yaml
    steps:
    - uses: actions/checkout@v2

    # Install Emacs on all platforms
    - uses: jcs090218/setup-emacs@master
      with:
        version: ${{ matrix.emacs-version }}
```

## License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
