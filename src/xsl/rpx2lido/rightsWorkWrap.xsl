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
    SPEC: 
    (1) rightsWorkWrap: rights information about the object / work described
    (2) rightsWorkSet: Information about rights management; may include copyright and
    other intellectual property statements about the object / work. 
    
    Rights for the record in rightsRecord
    Rights for the resource in rightsResource
    
    Credits hat wohl einen Bezug zu rightsWork 
    Bei DLG hat jemand anders die Rechte?
    -->

    <xsl:template name="rightsWorkWrap">
        <lido:rightsWorkWrap>
            <lido:rightsWorkSet>
                <xsl:call-template name="defaultRightsHolder"/>
                <xsl:apply-templates select="mpx:credits"/>
            </lido:rightsWorkSet>
        </lido:rightsWorkWrap>
    </xsl:template>

    <xsl:template match="mpx:credits">
        <lido:creditLine>
            <xsl:value-of select="."/>
        </lido:creditLine>
    </xsl:template>

    <xsl:template name="defaultRightsHolder">
        <lido:rightsHolder>
            <xsl:choose>
                <xsl:when test="mpx:verwaltendeInstitution eq 'Ethnologisches Museum, Staatliche Museen zu Berlin'">
                    <lido:legalBodyID lido:type="concept-ID" lido:source="ISIL (ISO 15511)">DE-MUS-019118</lido:legalBodyID>
                    <lido:legalBodyName>
                        <lido:appellationValue>Ethnologisches Museum, Staatliche Museen zu Berlin</lido:appellationValue>
                    </lido:legalBodyName>
                    <lido:legalBodyWeblink>http://www.smb.museum/em</lido:legalBodyWeblink>
                </xsl:when>
                <xsl:when test="mpx:verwaltendeInstitution eq 'Museum für Asiatische Kunst, Staatliche Museen zu Berlin'">
                    <lido:legalBodyID lido:type="concept-ID" lido:source="ISIL (ISO 15511)">DE-MUS-019014</lido:legalBodyID>
                    <lido:legalBodyName>
                        <lido:appellationValue>Museum für Asiatische Kunst, Staatliche Museen zu Berlin</lido:appellationValue>
                    </lido:legalBodyName>
                    <lido:legalBodyWeblink>http://www.smb.museum/aku</lido:legalBodyWeblink>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message>
                        <xsl:text>Error: Unknown institution in defaultRightsHolder</xsl:text>
                    </xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </lido:rightsHolder>
    </xsl:template>
</xsl:stylesheet>