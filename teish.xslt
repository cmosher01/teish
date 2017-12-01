<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0">
    <xsl:output
        encoding="UTF-8"
        method="html"
        media-type="text/html"
        omit-xml-declaration="yes"
        doctype-system="about:legacy-compat"
    />
    <!-- identity (copy all nodes and attributes) -->
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <!-- whitespace processing (compress all whitespace, don't trim) -->
    <xsl:template match="text()">
        <xsl:if test="normalize-space(substring(.,1,1)) = ''">
            <xsl:text>&#x0020;</xsl:text>
        </xsl:if>
        <xsl:value-of select="normalize-space()"/>
        <xsl:if test="normalize-space(substring(.,string-length(.))) = ''">
            <xsl:text>&#x0020;</xsl:text>
        </xsl:if>
    </xsl:template>
    <!-- remove xml namespace from attributes -->
    <xsl:template match="@xml:*">
        <xsl:attribute name="{local-name()}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    <!-- main TEI page template -->
    <xsl:template match="tei:TEI">
        <html>
            <head>
                <meta charset="utf-8"/>
                <link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/normalize/7.0.0/normalize.css"/>
                <link rel="stylesheet/less" type="text/css" href="http://mosher.mine.nu/tei/teish.less"/>
                <title>
                    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
                </title>
            </head>
            <body onload="main();">
                <xsl:apply-templates/>
                <script src="http://mosher.mine.nu/tei/teish.js"/>
                <script src="//cdnjs.cloudflare.com/ajax/libs/less.js/2.7.2/less.js"/>
            </body>
        </html>
    </xsl:template>
    <!-- other TEI handling -->
    <xsl:template match="tei:head">
        <xsl:element name="header">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
