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
        FIELDS: objectWorkType

        sort        
        "Sachbegriff" before "Weiterer Sachbegriff", using position() over 
        xsl:number

        HISTORY:
        -20200412. separate file. 
        -20200114: sortorder added, TODO: not sure it's always in the right 
        order, currently known attributes "Sachbegriff" and "weiterer 
        Sachbegriff".
        
        gets called in objectClassificationWrap
        
        TODO: ideally translation from ExcelTool only gets written when 
        "Sachbegriff engl." doesn't exist. eg. 4733
    -->

    <xsl:template name="objectWorkTypeWrap">
        <lido:objectWorkTypeWrap>
            <xsl:apply-templates mode="workType"
                select="mpx:sachbegriff[not(@art = 'Einheimische Bezeichnung (lokal)')]">
                <xsl:sort select="@art" />
            </xsl:apply-templates>
            <xsl:apply-templates select="mpx:sachbegriffHierarchisch"/>
            <xsl:if test="not (mpx:sachbegriff[not(@art = 'Einheimische Bezeichnung (lokal)')]) 
                and not (mpx:sachbegriffHierarchisch)">
                <lido:objectWorkType>
                    <lido:term>kein Sachbegriff</lido:term>
                    <xsl:message>
                        <xsl:text>FEHLER: kein Sachbegriff, in m+ korrigeren!</xsl:text>
                    </xsl:message>
                </lido:objectWorkType>
            </xsl:if>
        </lido:objectWorkTypeWrap>
    </xsl:template>

    <xsl:template match="/mpx:museumPlusExport/mpx:sammlungsobjekt/mpx:sachbegriff" 
        mode="workType">
        <!-- 
            translations could just be sibling terms (with different lang 
            attributes), but if translation comes from m+, there is no way
            to know to which German term they refer to.
            
            Soll einheimische Bezeichnung ein lido:workType werden? Wohl eher 
            nicht.
            -->

        <lido:objectWorkType>
            <xsl:attribute name="lido:type">
                <xsl:choose>
                    <xsl:when test="@art">
                        <xsl:value-of select="@art"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>Sachbegriff</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="lido:sortorder">
                <xsl:value-of select="position()"/>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="@art = 'Sachbegriff engl.'">
                    <lido:term xml:lang="en">
                        <xsl:value-of select="." />
                    </lido:term>
                </xsl:when>
                <xsl:otherwise>
                    <lido:term xml:lang="de">
                        <xsl:value-of select="." />
                    </lido:term>
                    <xsl:variable name="translation" select="func:en-from-dict('sachbegriffnot(@artSachb...',.)"/>
                    <xsl:if test=". ne $translation">
                        <lido:term xml:lang="en">
                            <xsl:value-of select="$translation" />
                        </lido:term>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </lido:objectWorkType>
    </xsl:template>
    
    <xsl:template match="/mpx:museumPlusExport/mpx:sammlungsobjekt/mpx:sachbegriffHierarchisch">
        <lido:objectWorkType>
            <xsl:attribute name="lido:type">Sachbegriff (Hierarchie)</xsl:attribute>
            <xsl:attribute name="lido:sortorder">
                <xsl:value-of select="100"/>
            </xsl:attribute>
            <lido:term xml:lang="de">
                <xsl:value-of select="." />
            </lido:term>
        </lido:objectWorkType>
    </xsl:template>
</xsl:stylesheet>