<xsl:stylesheet version="2.0"
    xmlns:lido="http://www.lido-schema.org"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:mpx="http://www.mpx.org/mpx" exclude-result-prefixes="mpx"
    xsi:schemaLocation="http://www.lido-schema.org http://www.lido-schema.org/schema/v1.0/lido-v1.0.xsd">
    
    <xsl:output method="xml" version="1.0" encoding="UTF-8"
        indent="yes" />
    <xsl:strip-space elements="*" />

    <!-- 
        FIELDS: inscriptions
        
        HISTORY:
        -in separate xsl. 20200411.

        Todo: 
        (1) For Datenblatt I recently extracted main IdentNr from mpx records. 
        Sophisticated mapping is still to be implemented here
        (2) not sure this is always the intended sortorder, may want to switch
         to sort and position
    -->
    <xsl:template mode="workID" match="/mpx:museumPlusExport/mpx:sammlungsobjekt/mpx:identNr">
        <lido:workID>
            <xsl:attribute name="lido:encodinganalog">Ident. Nr.</xsl:attribute>
            <xsl:attribute name="lido:type">Inventory number</xsl:attribute>
            <xsl:if test="@art">
                <xsl:attribute name="lido:label">
                    <xsl:value-of select="@art" />
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="lido:sortorder">
                <xsl:number />
            </xsl:attribute>
            <xsl:value-of select="." />
        </lido:workID>
    </xsl:template>
</xsl:stylesheet>