<xsl:stylesheet version="2.0"
    xmlns="http://www.mpx.org/mpx"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mpx="http://www.mpx.org/mpx" exclude-result-prefixes="mpx">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
    <xsl:strip-space elements="*" />

    <xsl:template match="/museumPlusExport/multimediaobjekt">
        <xsl:variable name="mulId" select="@mulId"/>
        <xsl:element name="{name()}">
            <xsl:attribute name="mulId">
                <xsl:value-of select="$mulId"/>
            </xsl:attribute>
            <xsl:attribute name="exportdatum">
                <xsl:value-of select="@exportdatum"/>
            </xsl:attribute>

            <xsl:message>
                <xsl:text>lvlup-mulId: </xsl:text>
                <xsl:value-of select="$mulId"/>
            </xsl:message>
            <xsl:for-each-group select="/museumPlusExport/multimediaobjekt[@mulId eq $mulId]/*" group-by="string()">
                <xsl:sort select="name()" />
                <!--xsl:message>
                    <xsl:text>   </xsl:text>
                    <xsl:value-of select="name()"/>
                </xsl:message-->
                <xsl:if test="name() ne 'objId'">
                    <xsl:apply-templates select="."/>
                </xsl:if>
            </xsl:for-each-group>
        </xsl:element>
    </xsl:template>

    <!-- delete duplicate; can also be eliminated from RST mm -->
    <xsl:template match="/museumPlusExport/multimediaobjekt/personenKörperschaften">
        <xsl:message>
            deprecate: Please remove "personenKörperschaften" from rst mm. Use 
            urhebFotograf instead.
        </xsl:message>
    </xsl:template>

    <!-- only include element standardbild if this mume is standardbild-->
    <xsl:template match="/museumPlusExport/multimediaobjekt/standardbild">
            <xsl:if test=". eq ../@mulId">
                <!--xsl:message>
                    <xsl:text>STANDARDBILD: </xsl:text>
                    <xsl:value-of select="../@mulId" />
                </xsl:message-->
                <xsl:element name="{name()}">
                    <xsl:value-of select="." />
                </xsl:element>
            </xsl:if>
    </xsl:template>

    <!-- rename tag: better rename in rst to avoid sorting mess-->
    <xsl:template match="/museumPlusExport/multimediaobjekt/objId">
        <xsl:message>
            deprecated: Please replace "objId" with "verknüpftesObjekt" in rst mm.
        </xsl:message>
        <xsl:element name="verknüpftesObjekt">
            <xsl:value-of select="." />
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>