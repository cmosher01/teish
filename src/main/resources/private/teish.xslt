<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="#all"
>
    <xsl:output
        omit-xml-declaration="yes"
        doctype-system="about:legacy-compat"
        method="html"
        media-type="text/html"
        indent="no"
    />

    <!-- identity (copy all elements and attributes) -->
    <xsl:template match="element() | comment() | processing-instruction() | @*" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>

    <!-- normalize text (compress all whitespace, don't trim; NFC) -->
    <xsl:template match="text()">
        <xsl:choose>
            <xsl:when test="fn:matches(.,'^\s*$')">
                <xsl:value-of select="fn:string('&#x0020;')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="fn:matches(.,'^\s')">
                    <xsl:value-of select="fn:string('&#x0020;')"/>
                </xsl:if>
                <xsl:value-of select="fn:normalize-unicode(fn:normalize-space())"/>
                <xsl:if test="fn:matches(.,'\s$')">
                    <xsl:value-of select="fn:string('&#x0020;')"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
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
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
                <meta charset="utf-8"/>
                <link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/normalize/7.0.0/normalize.css"/>
                <style>
                    teiHeader { display: none; }
                    div { display: inline; }
                    lb::before { content: "\a"; white-space: pre; }
                    [rend~=sup], [type=turnover] { position: relative; font-size: 75%; top: -0.5em; }
                    [rend~=sub], [type=turnunder] { position: relative; font-size: 75%; top: 0.5em; }
                    [type=turnover] > lb, [type=turnunder] > lb { display: none; }
                    [ref], [corresp], date, choice { cursor: help; }
                    [ref]:hover, [corresp]:hover, date:hover, choice:hover { background-color: #a0a0a040; }
                    choice > expan, choice > reg, choice > corr { display: none; }
                </style>
                <title>
                    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
                </title>
            </head>
            <body>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </body>
        </html>
    </xsl:template>

    <!-- other TEI handling -->
    <xsl:template match="tei:head">
        <xsl:element name="header">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:body">
        <xsl:element name="div" namespace="">
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="type">
                <xsl:value-of select="'textBody'"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:date[@when]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="title">
                <xsl:value-of select="fn:concat('date: ',@when)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="tei:date[@when-custom]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="title">
                <xsl:value-of select="fn:concat('date: ',@when-custom,' (',@datingMethod,')')"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="element()[@ref|@corresp]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:variable name="ref" select="fn:distinct-values((@ref,@corresp))"/>
            <xsl:if test="fn:starts-with($ref,'#')">
                <xsl:attribute name="title">
                    <xsl:value-of select="fn:element-with-id(fn:substring($ref,2))"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="tei:choice[tei:expan|tei:reg|tei:corr]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="title">
                <xsl:value-of select="fn:distinct-values((tei:expan,tei:reg,tei:corr))"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="tei:gap | tei:unclear">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="title">
                <xsl:value-of select="fn:local-name()"/>
                <xsl:if test="@*">
                    <xsl:value-of select="': '"/>
                    <xsl:for-each select="@*">
                        <xsl:value-of select="fn:concat(name(),'=',.,' ')"/>
                    </xsl:for-each>
                </xsl:if>
            </xsl:attribute>
            <xsl:value-of select="'['"/>
            <xsl:if test="fn:not(node())">
                <xsl:value-of select="'?'"/>
            </xsl:if>
            <xsl:apply-templates/>
            <xsl:value-of select="']'"/>
        </xsl:copy>
    </xsl:template>

    <!-- expand copyOf elements first, then do all other processing -->
    <xsl:template match="/">
        <xsl:variable name="expanded">
            <xsl:apply-templates mode="copyOf"/>
        </xsl:variable>
        <xsl:apply-templates select="$expanded/*"/>
    </xsl:template>

    <xsl:template match="element()[@copyOf]" mode="copyOf">
        <xsl:variable name="ref" select="@copyOf"/>
        <xsl:if test="fn:starts-with($ref,'#')">
            <xsl:copy-of select="fn:element-with-id(fn:substring($ref,2))"/>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
