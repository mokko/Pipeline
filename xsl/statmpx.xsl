<xsl:stylesheet version="2.0"
    xmlns="http://www.mpx.org/mpx"
    xmlns:mpx="http://www.mpx.org/mpx"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <xsl:output method="text"/>

    <xsl:template match="/">
        <xsl:text>Multimediaobjekte: </xsl:text> 
        <xsl:value-of select="count(/mpx:museumPlusExport/mpx:multimediaobjekt)"/><xsl:text>
</xsl:text>
        <xsl:text>davon mit mpx:erweiterung: </xsl:text>
        <xsl:value-of select="count(/mpx:museumPlusExport/mpx:multimediaobjekt/mpx:erweiterung)"/><xsl:text>
</xsl:text>
        <xsl:text>davon mit mpx:verantwortlichen = ja: </xsl:text>
        <xsl:value-of select="count(/mpx:museumPlusExport/mpx:multimediaobjekt[
            mpx:erweiterung and lower-case(mpx:veröffentlichen) eq 'ja'])"/><xsl:text>
</xsl:text>
        <xsl:text>PersonenKörperschaften: </xsl:text>
        <xsl:value-of select="count(/mpx:museumPlusExport/mpx:personenKörperschaften)"/><xsl:text>
</xsl:text>
        <xsl:text>Sammlungsobjekte: </xsl:text>
        <xsl:value-of select="count(/mpx:museumPlusExport/mpx:sammlungsobjekt)"/><xsl:text>
</xsl:text>
        <xsl:text>davon mit mpx:bearbStand = Daten freigegeben für SMB-digital: </xsl:text>
        <xsl:value-of select="count(/mpx:museumPlusExport/mpx:sammlungsobjekt[
            lower-case(mpx:bearbStand) eq 'daten freigegeben für smb-digital'])"/><xsl:text>
</xsl:text>
    </xsl:template>
</xsl:stylesheet>
