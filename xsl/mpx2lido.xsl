<xsl:stylesheet version="2.0"
    xmlns:lido="http://www.lido-schema.org"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:func="http://www.mpx.org/mpxfunc"
    xmlns:mpx="http://www.mpx.org/mpx" exclude-result-prefixes="mpx func"
    xsi:schemaLocation="http://www.lido-schema.org http://www.lido-schema.org/schema/v1.0/lido-v1.0.xsd">

    <xsl:import href="mpx2lido/category.xsl" />
    <!-- Descriptive Metadata -->
    <xsl:import href="mpx2lido/objectClassificationWrap.xsl" />
    <xsl:import href="mpx2lido/objectIdentificationWrap.xsl" />
    <xsl:import href="mpx2lido/eventWrap.xsl" />
    <xsl:import href="mpx2lido/objectRelationWrap.xsl" />
    <!-- Administrative Metadata -->
    <xsl:import href="mpx2lido/rightsWorkWrap.xsl" />
    <xsl:import href="mpx2lido/recordWrap.xsl" />
    <xsl:import href="mpx2lido/resourceWrap.xsl" />

    <!-- 
        FIELDS: lidoRecID
        
        HISTORY:
        general stuff (applying to more than one field)
        -let's try to map every mpx-field to only one LIDO field
        as long that makes sense semantically; e.g. let's try and use 
        mpx:objekttyp only for lido:category. 20200411

        specific to one field
        -lido:category moved to separate xsl file        
     -->

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
    <xsl:strip-space elements="*" />

    <xsl:template match="/">
        <lido:lidoWrap xsi:schemaLocation="http://www.lido-schema.org http://www.lido-schema.org/schema/v1.0/lido-v1.0.xsd">
            <xsl:apply-templates select="/mpx:museumPlusExport/mpx:sammlungsobjekt" />
        </lido:lidoWrap>
    </xsl:template>

    <xsl:template match="/mpx:museumPlusExport/mpx:sammlungsobjekt">
        <!-- xsl:message>
            <xsl:text>2LIDO-objId: </xsl:text>
            <xsl:value-of select="@objId" />
        -->
        <lido:lido>
            <lido:lidoRecID>
                <xsl:attribute name="lido:source">
                    <xsl:text>Staatliche Museen zu Berlin</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="lido:type">local</xsl:attribute>
                <xsl:text>objId/</xsl:text>
                <xsl:value-of select="@objId" />
            </lido:lidoRecID>

            <!-- lido:category -->
            <xsl:apply-templates mode="category" select="mpx:objekttyp" />

            <lido:descriptiveMetadata xml:lang="de">
                <xsl:call-template name="objectClassificationWrap"/>
                <xsl:call-template name="objectIdentificationWrap"/>
                <xsl:call-template name="eventWrap"/>
                <xsl:call-template name="objectRelationWrap"/>
            </lido:descriptiveMetadata>

            <lido:administrativeMetadata xml:lang="en">
                <xsl:call-template name="rightsWorkWrap"/>
                <xsl:call-template name="recordWrap"/>
                <xsl:call-template name="resourceWrap"/>
            </lido:administrativeMetadata>
        </lido:lido>
    </xsl:template>

    <xsl:function name="func:en-from-dict">
        <xsl:param name="context"/>
        <xsl:param name="nterm"/>
        <xsl:variable name="dict" select="document('../data/mpxvoc.xml')"/>
        <xsl:variable name="en" select="$dict/mpxvoc/context[@name eq $context]/concept[
            substring (pref[@lang = 'de'],1,100) = substring($nterm,1,100)]
            /pref[@lang eq 'en'][1]"/>
        <xsl:choose>
            <xsl:when test ="exists($en)">
                <xsl:value-of select="$en"/>
                <xsl:message>
                    <xsl:text>objId/</xsl:text>
                    <xsl:value-of select="$nterm/../@objId"/>
                    <xsl:text> </xsl:text>
                    <xsl:text>en-from-dict: </xsl:text> 
                    <xsl:value-of select="$context"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$nterm"/>
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="$en"/>
                </xsl:message>
            </xsl:when>
            <!-- if there is no English translation, use original needle -->
            <xsl:otherwise>
                <xsl:value-of select="$nterm"/>
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:function>
</xsl:stylesheet>