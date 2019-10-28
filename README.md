# teish

Simple TEI to HTML converter.

## usage

This github repository is deprecated now. The TEISH components have moved to
[Tei-Server](https://github.com/cmosher01/Tei-Server).

This repository will remain here, archived, for reference purposes only, It will not be
maintained. All new revisions will be made in Tei-Server. The links below have
been updated to reflect this new location, and will continue to work with any
new updates to Tei-Server.

There are two components of __TEISH__:

* https://raw.githack.com/cmosher01/Tei-Server/master/src/main/resources/teish.xslt
* https://raw.githack.com/cmosher01/Tei-Server/master/src/main/resources/teish.css

Use `teish.xslt` to transform your TEI XML file into HTML.
Use that resulting HTML somewhere in the body of a web page
that uses `teish.css` to style it correctly.

__TEISH__ is tested using Saxon 9.9 Home Edition
XSLT 3.0 transformer, and Chromium 75.0 browser.

## demo

Deprecated. Use [Tei-Server](https://github.com/cmosher01/Tei-Server) instead.

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
