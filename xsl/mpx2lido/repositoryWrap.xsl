<xsl:stylesheet version="2.0"
    xmlns:lido="http://www.lido-schema.org"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:mpx="http://www.mpx.org/mpx" exclude-result-prefixes="mpx"
    xsi:schemaLocation="http://www.lido-schema.org http://www.lido-schema.org/schema/v1.0/lido-v1.0.xsd">

    <xsl:import href="workID.xsl" />
    
    <xsl:output method="xml" version="1.0" encoding="UTF-8"
        indent="yes" />
    <xsl:strip-space elements="*" />

    <!-- 
        FIELDS: repositorySet, repositoryName, repositoryLocation
        
        HISTORY:
        -in separate xsl. 20200411.
    -->
    <xsl:template name="repositoryWrap">
        <lido:repositoryWrap>
            <lido:repositorySet lido:type="current">
                <lido:repositoryName>
                    <xsl:choose>
                        <xsl:when test="mpx:verwaltendeInstitution eq 'Ethnologisches Museum, Staatliche Museen zu Berlin'">
                            <lido:legalBodyID lido:type="URI" lido:source="ISIL (ISO 15511)">http://www.museen-in-deutschland.de/singleview.php?muges=019118</lido:legalBodyID>
                            <lido:legalBodyID lido:type="concept-ID" lido:source="ISIL (ISO 15511)">DE-MUS-019118</lido:legalBodyID>
                            <xsl:call-template name="legalBodyName"/>
                            <lido:legalBodyWeblink>http://www.smb.museum/em</lido:legalBodyWeblink>
                        </xsl:when>
                        <!-- verwaltendeInstiution AKu untested -->
                        <xsl:when test="mpx:verwaltendeInstitution eq 'Museum für Asiatische Kunst, Staatliche Museen zu Berlin'">
                            <lido:legalBodyID lido:type="URI" lido:source="ISIL (ISO 15511)">http://www.museen-in-deutschland.de/singleview.php?muges=019014</lido:legalBodyID>
                            <lido:legalBodyID lido:type="concept-ID" lido:source="ISIL (ISO 15511)">DE-MUS-019014</lido:legalBodyID>
                            <xsl:call-template name="legalBodyName"/>
                            <lido:legalBodyWeblink>http://www.smb.museum/aku</lido:legalBodyWeblink>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:message>
                                <xsl:text>Error: Unknown Institution</xsl:text>
                            </xsl:message>
                        </xsl:otherwise>
                    </xsl:choose>
                </lido:repositoryName>
    
                <xsl:apply-templates mode="workID" select="mpx:identNr" />
                
                <lido:repositoryLocation lido:politicalEntity="inhabited place">
                    <lido:placeID lido:type="URI" lido:source="http://vocab.getty.edu/tgn/">http://vocab.getty.edu/tgn/7003712</lido:placeID>
                    <lido:placeID lido:type="URI" lido:source="http://sws.geonames.org/">http://sws.geonames.org/2950159</lido:placeID>
                    <lido:namePlaceSet>
                        <lido:appellationValue>Berlin</lido:appellationValue>
                    </lido:namePlaceSet>
                    <lido:partOfPlace lido:politicalEntity="State">
                        <lido:placeID lido:type="URI" lido:source="http://vocab.getty.edu/tgn/">http://vocab.getty.edu/tgn/7003670</lido:placeID>
                        <lido:placeID lido:type="URI" lido:source="http://sws.geonames.org/">http://sws.geonames.org/2950157</lido:placeID>
                        <lido:namePlaceSet>
                            <lido:appellationValue>Berlin</lido:appellationValue>
                        </lido:namePlaceSet>
                        <lido:partOfPlace lido:politicalEntity="nation">
                            <lido:placeID lido:type="URI" lido:source="http://vocab.getty.edu/tgn/">http://vocab.getty.edu/tgn/7000084</lido:placeID>
                            <lido:placeID lido:type="URI" lido:source="http://sws.geonames.org/">http://sws.geonames.org/2921044</lido:placeID>
                            <lido:namePlaceSet>
                                <lido:appellationValue>Deutschland</lido:appellationValue>
                            </lido:namePlaceSet>
                        </lido:partOfPlace>
                    </lido:partOfPlace>
                </lido:repositoryLocation>
            </lido:repositorySet>

            <!-- 
                TODO
                m3 rst: Versuch Standort im Schaumagazin innerhalb von repositoryLocation zu kodieren, wie von FvH vorgeschlagen. 
                Sollen dann die classification tags entfallen? JA
                
                SPEC: Location of the object, especially relevant for architecture and archaeological sites.
            -->
            <lido:repositorySet lido:type="rst">
                <lido:repositoryLocation>
                    <lido:placeID lido:type="URI">daf.rst.hf/Südsee/Fidschi/1/1234 (todo)</lido:placeID>
                </lido:repositoryLocation>
            </lido:repositorySet>
        </lido:repositoryWrap>
    </xsl:template>
    
    <xsl:template name="legalBodyName">
        <lido:legalBodyName>
            <lido:appellationValue>
                <xsl:value-of select="mpx:verwaltendeInstitution" />
            </lido:appellationValue>
        </lido:legalBodyName>
    </xsl:template>
</xsl:stylesheet>