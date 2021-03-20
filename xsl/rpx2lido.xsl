<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:lido="http://www.lido-schema.org"
    xmlns:func="http://www.mpx.org/mpxfunc"
    exclude-result-prefixes="func"  
    xsi:schemaLocation="http://www.lido-schema.org http://www.lido-schema.org/schema/v1.0/lido-v1.0.xsd">
    
    <xsl:import href="rpx2lido/category.xsl" />
    <!-- Descriptive Metadata -->
    <xsl:import href="rpx2lido/objectClassificationWrap.xsl" />
    <xsl:import href="rpx2lido/objectIdentificationWrap.xsl" />
    <xsl:import href="rpx2lido/eventWrap.xsl" />
    <xsl:import href="rpx2lido/objectRelationWrap.xsl" />
    <!-- Administrative Metadata -->
    <xsl:import href="rpx2lido/rightsWorkWrap.xsl" />
    <xsl:import href="rpx2lido/recordWrap.xsl" />
    <xsl:import href="rpx2lido/resourceWrap.xsl" />
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
    <xsl:strip-space elements="*" />

    <xsl:template match="/">
        <lido:lidoWrap>
            <xsl:apply-templates select="/ObjectList/Object" />
        </lido:lidoWrap>
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