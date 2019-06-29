# teish

Simple TEI to HTML converter.

## usage

There are two components of __TEISH__:

* https://cdn.jsdelivr.net/gh/cmosher01/teish@master/src/main/resources/teish.xslt
* https://cdn.jsdelivr.net/gh/cmosher01/teish@master/src/main/resources/teish.css

Instead of `master` (which always pulls the latest stable version)
you can specify a specific version number
(see [releases](../../releases) for the latest release).

Use `teish.xslt` to transform your TEI XML file into HTML.
Use that resulting HTML somewhere in the body of a web page
that uses `teish.css` to style it correctly.

__TEISH__ is tested using Saxon 9.8 Home Edition
XSLT 3.0 transformer, and Chromium 75.0 browser.

## demo

This project contains a simple web server to demonstrate
how to read a TEI XML file, transform it using
`teish.xslt`, and displaying the resulting HTML in
your favorite browser.

Prerequisite for the demo is having *Java* installed.

To run the server:

```sh
./gradlew run --args ./tei
```

Then browse to the home page at http://127.0.0.1:4567 to see the demo.

If you want to use the demo application to serve your own
TEI (`.xml`) source files, place them into the `tei`
directory, and refresh the home page.
