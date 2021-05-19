<xsl:stylesheet version="2.0"
    xmlns:lido="http://www.lido-schema.org"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:mpx="http://www.mpx.org/mpx" exclude-result-prefixes="mpx"
    xsi:schemaLocation="http://www.lido-schema.org http://www.lido-schema.org/schema/v1.0/lido-v1.0.xsd">

    <xsl:output method="xml" version="1.0" encoding="UTF-8"
        indent="yes" />
    <xsl:strip-space elements="*" />

    <xsl:template name="Sammeln">
        <lido:eventSet>
            <lido:displayEvent>Sammeltätigkeit</lido:displayEvent>
            <lido:event>
                <lido:eventType>
                    <lido:conceptID lido:type="URI" lido:source="LIDO-Terminologie">http://terminology.lido-schema.org/lido00010</lido:conceptID>
                    <lido:term>Sammeltätigkeit</lido:term>
                </lido:eventType>
                <lido:eventActor>
                    <lido:displayActorInRole>
                        <xsl:value-of select="mpx:personenKörperschaften[@funktion eq 'Sammler']"/>
                        <xsl:text> (Sammler)</xsl:text>
                    </lido:displayActorInRole>
                    <lido:actorInRole>
                        <lido:actor lido:type="Person">
                            <!-- I don't have the kueId currently
                                 lido:actorID lido:type="local" lido:source="Kue.Id.">2297</lido:actorID> 
                                 not necessary for RST
                            -->
                            <lido:nameActorSet>
                                <lido:appellationValue lido:pref="preferred" lido:label="Nachname, Vorname">
                                    <xsl:value-of select="mpx:personenKörperschaften[@funktion eq 'Sammler']"/>
                                </lido:appellationValue>
                            </lido:nameActorSet>
                            <!-- not necessary for RST
                                lido:vitalDatesActor />
                                lido:genderActor  -->
                        </lido:actor>
                        <lido:roleActor>
                            <lido:term lido:addedSearchTerm="no">Sammler</lido:term>
                        </lido:roleActor>
                    </lido:actorInRole>
                </lido:eventActor>
            </lido:event>
        </lido:eventSet>
    </xsl:template>
</xsl:stylesheet>