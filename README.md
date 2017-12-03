# teish

Simple TEI to HTML converter.

## usage

The XSLT (3.0) stylesheet is
[teish.xslt](src/main/resources/private/teish.xslt)

Just use it as an XSLT transform on your TEI XML file,
using your favorite XSLT 3.0 tool.

Alternatively, include the following stylesheet processing instruction
in your TEI XML file:

```xml
<?xml-stylesheet type="text/xsl" href="https://cdn.rawgit.com/cmosher01/teish/1.0/src/main/resources/private/teish.xslt"?>
```

(where `1.0` is the version number of `teish.xslt` you want to use).

The stylesheet is tested using Saxon 9.8 Home Edition
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

Then browse to http://127.0.0.1:4567 to see the demo.

To stop the server:

```sh
./gradlew --stop
```
