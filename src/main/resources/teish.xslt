<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="#all"
>
    <xsl:output
        omit-xml-declaration="yes"
        method="html"
        version="5.0"
        media-type="text/html"
        indent="no"
    />

    <xsl:param name="full" as="xs:boolean" select="fn:false()"/>
    <xsl:param name="css" as="xs:string" select="'../../teish.css'"/>

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
        <xsl:attribute name="{fn:local-name()}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <!-- TEI document ==> HTML web page -->
    <xsl:template match="tei:TEI">
        <xsl:choose>
            <xsl:when test="$full">
                <html>
                    <head>
                        <meta charset="utf-8"/>
                        <xsl:element name="link">
                            <xsl:attribute name="rel">
                                <xsl:value-of select="'stylesheet'"/>
                            </xsl:attribute>
                            <xsl:attribute name="type">
                                <xsl:value-of select="'text/css'"/>
                            </xsl:attribute>
                            <xsl:attribute name="href">
                                <xsl:value-of select="$css"/>
                            </xsl:attribute>
                        </xsl:element>
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
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- TEI head ==> HTML header -->
    <xsl:template match="tei:head">
        <xsl:element name="header">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>

    <!-- TEI body ==> HTML div class=textBody -->
    <xsl:template match="tei:body">
        <xsl:element name="div">
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="class">
                <xsl:value-of select="'textBody'"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- TEI title ==> HTML span class=title -->
    <xsl:template match="tei:title">
        <xsl:element name="span">
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="class">
                <xsl:value-of select="fn:local-name()"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- TEI div ==> HTML div class=textDiv -->
    <xsl:template match="tei:div">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="class">
                <xsl:value-of select="'textDiv'"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!-- TEI ref target=url ==> HTML a class=teiRef href=url -->
    <xsl:template match="tei:ref[@target]">
        <xsl:element name="a">
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="class">
                <xsl:value-of select="'teiRef'"/>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:value-of select="@target"/>
            </xsl:attribute>
            <!-- if empty content, add target as text -->
            <xsl:choose>
                <xsl:when test="node()">
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@target"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <!-- TEI pb ==> HTML hr class=pb title=page:n(type) -->
    <xsl:template match="tei:pb">
        <xsl:element name="hr">
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="class">
                <xsl:value-of select="fn:local-name()"/>
            </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:value-of select="fn:concat('page: ',@n)"/>
                <xsl:if test="@type">
                    <xsl:value-of select="fn:concat(' (',@type,')')"/>
                </xsl:if>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- TEI list/head+item ==> HTML dl/dt+dd -->
    <xsl:template match="tei:list">
        <xsl:element name="dl">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates mode="list"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:head" mode="list">
        <xsl:element name="dt">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:item" mode="list">
        <xsl:element name="dd">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- TEI fw type ==> HTML fw title -->
    <xsl:template match="tei:fw[@type]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="title">
                <xsl:value-of select="@type"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!-- TEI date when ==> HTML date title -->
    <xsl:template match="tei:date[@when]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="title">
                <xsl:value-of select="fn:concat('date: ',@when)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!-- TEI date when-custom datingMethod ==> HTML date title -->
    <xsl:template match="tei:date[@when-custom]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="title">
                <xsl:value-of select="fn:concat('date: ',@when-custom,' (',@datingMethod,')')"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!-- TEI * ref/corresp ==> HTML * title -->
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

    <!-- TEI choice ==> HTML choice title -->
    <xsl:template match="tei:choice[tei:expan|tei:reg|tei:corr]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="title">
                <xsl:value-of select="fn:distinct-values((tei:expan,tei:reg,tei:corr))"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!-- TEI supplied ==> HTML [...] -->
    <xsl:template match="tei:supplied">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="class">
                <xsl:value-of select="'editorial'"/>
            </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:value-of select="fn:local-name()"/>
                <xsl:if test="@*">
                    <xsl:value-of select="': '"/>
                    <xsl:for-each select="@*">
                        <xsl:value-of select="fn:concat(fn:local-name(),'=',.,' ')"/>
                    </xsl:for-each>
                </xsl:if>
            </xsl:attribute>
            <xsl:value-of select="'['"/>
            <xsl:apply-templates/>
            <xsl:value-of select="']'"/>
        </xsl:copy>
    </xsl:template>

    <!-- TEI gap/unclear ==> HTML [...] -->
    <xsl:template match="tei:gap | tei:unclear">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="title">
                <xsl:value-of select="fn:local-name()"/>
                <xsl:if test="@*">
                    <xsl:value-of select="': '"/>
                    <xsl:for-each select="@*">
                        <xsl:value-of select="fn:concat(fn:local-name(),'=',.,' ')"/>
                    </xsl:for-each>
                </xsl:if>
            </xsl:attribute>
            <xsl:element name="span">
                <xsl:attribute name="class">
                    <xsl:value-of select="'editorial'"/>
                </xsl:attribute>
                <xsl:value-of select="'['"/>
            </xsl:element>
            <xsl:if test="fn:not(node())">
                <xsl:element name="span">
                    <xsl:attribute name="class">
                        <xsl:value-of select="'editorial'"/>
                    </xsl:attribute>
                    <xsl:value-of select="'?'"/>
                </xsl:element>
            </xsl:if>
            <xsl:apply-templates/>
            <xsl:element name="span">
                <xsl:attribute name="class">
                    <xsl:value-of select="'editorial'"/>
                </xsl:attribute>
                <xsl:value-of select="']'"/>
            </xsl:element>
        </xsl:copy>
    </xsl:template>

    <!-- expand TEI copyOf elements first, then do all other processing -->
    <xsl:template match="/">
        <xsl:variable name="expanded">
            <xsl:apply-templates mode="copyOf"/>
        </xsl:variable>
        <xsl:apply-templates select="$expanded/*"/>
    </xsl:template>

    <!-- * copyOf #ID ==> (deep copy of) * id=ID -->
    <xsl:template match="element()[@copyOf]" mode="copyOf">
        <xsl:variable name="ref" select="@copyOf"/>
        <xsl:if test="fn:starts-with($ref,'#')">
            <xsl:copy-of select="fn:element-with-id(fn:substring($ref,2))"/>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
