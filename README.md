# teish

Simple TEI to HTML converter.

## usage

There are two components of __TEISH__:

* https://cdn.rawgit.com/cmosher01/teish/1.1/src/main/resources/teish.xslt
* https://cdn.rawgit.com/cmosher01/teish/1.1/src/main/resources/teish.css

Use `teish.xslt` to transform your TEI XML file into HTML.
Use that resulting HTML somewhere in the body of a web page
that uses `teish.css` to style it correctly.

__TEISH__ is tested using Saxon 9.8 Home Edition
XSLT 3.0 transformer, and Chromium 62.0 browser.

## demo

This project contains a simple web server to demonstrate
how to read a TEI XML file, transform it using
`teish.xslt`, and displaying the resulting HTML in
your favorite browser.

Prerequisite for the demo is having *Java 8* installed.

To run the server:

```sh
./gradlew --daemon build serve
```

Then browse to the home page at http://127.0.0.1:4567 to see the demo.

To stop the server:

```sh
./gradlew --stop
```

If you want to use the demo application to server your own
TEI (`.xml`) source files, place them into the `tei`
directory, and refresh the home page.
