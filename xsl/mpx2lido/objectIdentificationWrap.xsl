<xsl:stylesheet version="2.0"
    xmlns:lido="http://www.lido-schema.org"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:mpx="http://www.mpx.org/mpx" exclude-result-prefixes="mpx"
    xsi:schemaLocation="http://www.lido-schema.org http://www.lido-schema.org/schema/v1.0/lido-v1.0.xsd">

    <xsl:import href="titleWrap.xsl" />
    <xsl:import href="inscriptionsWrap.xsl" />
    <xsl:import href="repositoryWrap.xsl" />
    <xsl:import href="objectDescriptionWrap.xsl" />
    <xsl:import href="objectMeasurementsWrap.xsl" />

    <xsl:output method="xml" version="1.0" encoding="UTF-8"
        indent="yes" />
    <xsl:strip-space elements="*" />

    <!-- 
    FIELDS: repositorySet 
    
    HISTORY:
    - split into many files. 20200411.
    -->

    <xsl:template name="objectIdentificationWrap">
        <lido:objectIdentificationWrap>
            <xsl:call-template name="titleWrap"/>
            <xsl:call-template name="inscriptionsWrap"/>
            <xsl:call-template name="repositoryWrap"/>
            <!-- lido:displayStateEditionWrap: A wrapper for the state and edition of the object / work (optional) -->
            <xsl:apply-templates select="mpx:onlineBeschreibung"/>    
            <xsl:apply-templates select="mpx:maßangaben"/>    
        </lido:objectIdentificationWrap>
    </xsl:template>
</xsl:stylesheet>