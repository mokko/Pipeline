<xsl:stylesheet version="3.0"
    xmlns="http://www.mpx.org/mpx"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mpx="http://www.mpx.org/mpx" exclude-result-prefixes="mpx">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
    <xsl:strip-space elements="*"/>

    <xsl:template match="/museumPlusExport/personKörperschaft">
        <xsl:variable name="id" select="@kueId"/>
        <xsl:element name="{name()}">
            <xsl:attribute name="kueId"><xsl:value-of select="$id"/></xsl:attribute>
            <xsl:attribute name="exportdatum"><xsl:value-of select="@exportdatum"/></xsl:attribute>

            <xsl:message>
                <xsl:text>lvlup-kueId: </xsl:text>
                <xsl:value-of select="$id"/>
            </xsl:message>
            <xsl:for-each-group select="/museumPlusExport/personKörperschaft[@kueId eq $id]/*" 
                composite="yes" group-by="node-name(), string()">
                <xsl:sort data-type="text" select="name()" />
                <xsl:apply-templates select="."/>
            </xsl:for-each-group>
        </xsl:element>
    </xsl:template>


    <xsl:template match="/museumPlusExport/personKörperschaft/datierung">
        <xsl:call-template name="wAttrib">
            <xsl:with-param name="attrib" select="../datierungArt" />
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="/museumPlusExport/personKörperschaft/datierungArt"/>


    <xsl:template match="/museumPlusExport/personKörperschaft/geoBezug">
        <xsl:call-template name="wAttrib">
            <xsl:with-param name="attrib" select="../geoBezugBezeichnung" />
            <xsl:with-param name="attrib2" select="../geoBezugArt" />
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="/museumPlusExport/personKörperschaft/geoBezugBezeichnung"/>
    <xsl:template match="/museumPlusExport/personKörperschaft/geoBezugArt"/>


    <xsl:template match="/museumPlusExport/personKörperschaft/name">
        <xsl:call-template name="wAttrib">
            <xsl:with-param name="attrib" select="../nameArt" />
            <xsl:with-param name="attrib2" select="../nameBemerkung" />
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="/museumPlusExport/personKörperschaft/nameArt"/>
    <xsl:template match="/museumPlusExport/personKörperschaft/nameBemerkung"/>


    <xsl:template match="/museumPlusExport/personKörperschaft/nennform">
        <xsl:call-template name="wAttrib">
            <xsl:with-param name="attrib" select="../nennformArt" />
            <xsl:with-param name="attrib2" select="../nennformBemerkung" />
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="/museumPlusExport/personKörperschaft/nennformArt"/>
    <xsl:template match="/museumPlusExport/personKörperschaft/nennformBemerkung"/>
</xsl:stylesheet>