# teish
Simple TEI to HTML converter

# usage
Add this line to your TEI file:
```xml
<?xml-stylesheet type="text/xsl" href="http://mosher.mine.nu/tei/teish.xslt"?>
```

# example
```xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" schematypens="http://relaxng.org/ns/structure/1.0"?>
<?xml-stylesheet type="text/xsl" href="http://mosher.mine.nu/tei/teish.xslt"?>
<TEI xml:lang="en" xmlns="http://www.tei-c.org/ns/1.0">
  <teiHeader>
    <fileDesc>
      <titleStmt>
        <title>Foobar: a digital transcription</title>
      </titleStmt>
      <publicationStmt>
        <p>https://github.com/cmosher01/teish</p>
      </publicationStmt>
      <sourceDesc>
        <p>Born digital.</p>
      </sourceDesc>
    </fileDesc>
  </teiHeader>
  <text xml:lang="en">
    <body>
      <p>Foobar.</p>
    </body>
  </text>
</TEI>
```
