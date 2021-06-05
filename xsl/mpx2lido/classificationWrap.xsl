<xsl:stylesheet version="2.0"
    xmlns:lido="http://www.lido-schema.org"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:mpx="http://www.mpx.org/mpx" exclude-result-prefixes="mpx"
    xsi:schemaLocation="http://www.lido-schema.org http://www.lido-schema.org/schema/v1.0/lido-v1.0.xsd">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
    <xsl:strip-space elements="*" />

    <!-- 
        FIELDS: classification
        
        HISTORY: 
        20200412 - separate xsl file
        20200411 - begrudgingly accept terms from two sources, mainly 
            systematikArt, but also terms from Objekttyp that don't 
            fit into category.
    -->

    <xsl:template name="classificationWrap">
        <xsl:if test="mpx:systematikArt or mpx:objekttyp ne 'Allgemein'">
            <lido:classificationWrap>
                <xsl:apply-templates select="mpx:systematikArt" />
                <xsl:apply-templates mode="classification" select="mpx:objekttyp [. eq 'Musikinstrument']" />
            </lido:classificationWrap>
        </xsl:if>
    </xsl:template>

    <xsl:template match="/mpx:museumPlusExport/mpx:sammlungsobjekt/mpx:systematikArt">
            <lido:classification>
                <xsl:attribute name="lido:type">SystematikArt</xsl:attribute>
                <xsl:attribute name="lido:sortorder">
                    <xsl:number />
                </xsl:attribute>
                <lido:term>
                    <xsl:value-of select="." />
                </lido:term>
            </lido:classification>
    </xsl:template>

    <!-- only called when with certain terms, see above -->    
    <xsl:template mode="classification" 
        match="/mpx:museumPlusExport/mpx:sammlungsobjekt/mpx:objekttyp">
        <lido:classification>
            <xsl:attribute name="lido:type">Objekttyp</xsl:attribute>
            <lido:term>
                <xsl:value-of select="." />
            </lido:term>
        </lido:classification>
    </xsl:template>
</xsl:stylesheet>