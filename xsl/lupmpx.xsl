<xsl:stylesheet version="2.0"
    xmlns="http://www.mpx.org/mpx"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mpx="http://www.mpx.org/mpx" exclude-result-prefixes="mpx">

    <xsl:import href="lup/lowpriority.xsl" />
    <xsl:import href="lup/mm.xsl" />
    <xsl:import href="lup/pk.xsl" />
    <xsl:import href="lup/so.xsl" />
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
    <xsl:strip-space elements="*" />

    <!-- 
    transforms dirty to clean mpx 
    mostly 
    (1) rewrites wiederholfelder so that the single record has multiple attributes
    (2) rewrites Qualifikators as attributes
    
    It also renames a few elements and sorts output right
    -->

    <xsl:template match="/">
            <museumPlusExport level="clean" version="2.0">
                <xsl:for-each-group select="/museumPlusExport/multimediaobjekt" group-by="@mulId">
                    <xsl:sort data-type="number" select="current-grouping-key()" />
                        <xsl:apply-templates select=".[@mulId = current-grouping-key()]" />
                </xsl:for-each-group>
    
                <xsl:for-each-group select="/museumPlusExport/personenKörperschaften" group-by="@kueId">
                    <xsl:sort data-type="number" select="current-grouping-key()" />
                        <xsl:apply-templates select=".[@kueId = current-grouping-key()]" />
                </xsl:for-each-group>
    
                <xsl:for-each-group select="/museumPlusExport/sammlungsobjekt" group-by="@objId">
                    <xsl:sort data-type="number" select="current-grouping-key()" />
                        <xsl:apply-templates select=".[@objId = current-grouping-key()]" />
                </xsl:for-each-group>
            </museumPlusExport>
     </xsl:template>


    <xsl:template name="wAttrib">
        <xsl:param name="attrib" />
        <xsl:param name="attrib2" />
        <xsl:variable name="short" select="lower-case(substring-after(name($attrib),name()))"/>
        <xsl:variable name="short2" select="lower-case(substring-after(name($attrib2),name()))"/>
        <xsl:element name="{name()}">
            <xsl:if test="$attrib">
                <xsl:attribute name="{$short}">
                    <xsl:value-of select="$attrib" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$attrib2">
                <xsl:attribute name="{$short2}">
                    <xsl:value-of select="$attrib2" />
                </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="." />
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>