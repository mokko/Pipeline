<xsl:stylesheet version="2.0"
    xmlns:lido="http://www.lido-schema.org"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:mpx="http://www.mpx.org/mpx" exclude-result-prefixes="mpx"
    xsi:schemaLocation="http://www.lido-schema.org http://www.lido-schema.org/schema/v1.0/lido-v1.0.xsd">
    
    <xsl:import href="objectWorkTypeWrap.xsl" />
    <xsl:import href="classificationWrap.xsl" />
    
    <xsl:output method="xml" version="1.0" encoding="UTF-8"
        indent="yes" />
    <xsl:strip-space elements="*" />

    <!-- 
        FIELDS: none 
    -->

    <xsl:template name="objectClassificationWrap">
        <lido:objectClassificationWrap>
            <xsl:call-template name="objectWorkTypeWrap"/>
            <xsl:call-template name="classificationWrap"/>
        </lido:objectClassificationWrap>
    </xsl:template>
</xsl:stylesheet>