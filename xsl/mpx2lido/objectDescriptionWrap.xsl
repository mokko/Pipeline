<xsl:stylesheet version="2.0"
    xmlns:func="http://www.mpx.org/mpxfunc"
    xmlns:lido="http://www.lido-schema.org"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:mpx="http://www.mpx.org/mpx" exclude-result-prefixes="mpx"
    xsi:schemaLocation="http://www.lido-schema.org http://www.lido-schema.org/schema/v1.0/lido-v1.0.xsd">
    
    <xsl:output method="xml" version="1.0" encoding="UTF-8"
        indent="yes" />
    <xsl:strip-space elements="*" />

    <!-- 
    FIELDS: objectDescriptionSet

    We could include other descriptions, but we don't - to minimize confusion.  
    
    HISTORY:
    -in separate xsl. 20200411.
    -->

    <xsl:template match="mpx:onlineBeschreibung">
        <lido:objectDescriptionWrap>
            <lido:objectDescriptionSet>
                <lido:descriptiveNoteValue xml:lang="de" lido:encodinganalog="online Beschreibung">
                    <xsl:value-of select="." />
                </lido:descriptiveNoteValue>
                <xsl:variable name="translation" select="func:en-from-dict('onlineBeschreibung',.)" />
                <xsl:if test=". ne $translation">
                    <lido:descriptiveNoteValue xml:lang="en" lido:encodinganalog="translate.xlsx">
                        <xsl:value-of select="$translation" />
                    </lido:descriptiveNoteValue>
                </xsl:if>
            </lido:objectDescriptionSet>
        </lido:objectDescriptionWrap>
    </xsl:template>
</xsl:stylesheet>