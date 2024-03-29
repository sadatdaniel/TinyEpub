# TinyEpub

TinyEpub is a tool to reduce the size of a heavy EPUB file by resizing the images it contains. It is intended for the people who sideload EPUB files on their E-Readers and when space becomes a matter of concern. However, if your EPUB file does not contain any images TinyEpub cannot reduce it's file size.

## Installation

  * Install Elixir on your system. You can follow the instuctions here [`Elixir Installation Guide`](https://elixir-lang.org/install.html)
  * Install ImageMagick from here [`ImageMagick`](https://imagemagick.org/script/download.php)
  * Load the project and install dependencies with `mix deps.get`
  * Now pass the path of your Epub directory or Epub file you would love to compress with `mix run -e "TinyEpub.init" -- "/home/user/folder"`

## Screencast

![](Screencast.gif)

## Note

Please make sure to read the code before using. I am not responsible for any damage. Do not run an unknown program without reading the code first. Enjoy!
