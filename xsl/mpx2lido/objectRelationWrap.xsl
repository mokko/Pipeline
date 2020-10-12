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
    FIELDs: subject, displaySubject, relatedWork

    LIDO SPEC: 
    A subject "may be the visual content (e.g. the iconography of a painting)
    or what the object is about."
    
    HISTORY:
    -We used to take systematikArt both for classification and subject. Now 
    only for classification. 20200411.
    -->

    <xsl:template name="objectRelationWrap">
        <xsl:if test="mpx:oov">
            <lido:objectRelationWrap>
                <lido:relatedWorksWrap>
                    <xsl:apply-templates select="mpx:oov"/>
                </lido:relatedWorksWrap>
            </lido:objectRelationWrap>
        </xsl:if>
    </xsl:template>

    <xsl:template match="mpx:oov">
        <lido:relatedWorkSet>
            <lido:relatedWork>
                <lido:displayObject>
                    <xsl:value-of select="."/>
                </lido:displayObject>
            </lido:relatedWork>
            <lido:relatedWorkRelType>
                <lido:term>
                    <xsl:value-of select="@art"/>
                </lido:term>
            </lido:relatedWorkRelType>
        </lido:relatedWorkSet>
    </xsl:template>
</xsl:stylesheet>