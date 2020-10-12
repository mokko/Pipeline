<xsl:stylesheet version="2.0"
    xmlns:lido="http://www.lido-schema.org"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:mpx="http://www.mpx.org/mpx" exclude-result-prefixes="mpx"
    xsi:schemaLocation="http://www.lido-schema.org http://www.lido-schema.org/schema/v1.0/lido-v1.0.xsd">

    <xsl:output method="xml" version="1.0" encoding="UTF-8"
        indent="yes" />
    <xsl:strip-space elements="*" />

    <!-- m3 rst: Neuer Event aus Ewerbsinformationen. -->
    <xsl:template name="Erwerb">
        <lido:eventSet>
            <lido:displayEvent xml:lang="de">Erwerb</lido:displayEvent>
            <lido:event>
                <lido:eventType>
                    <lido:conceptID lido:type="URI" lido:source="LIDO-Terminologie">http://terminology.lido-schema.org/lido00001</lido:conceptID>
                    <lido:term xml:lang="de">Erwerb</lido:term>
                </lido:eventType>

                <!-- lido:eventActor -->
                <xsl:apply-templates select="mpx:erwerbungVon"/>

                <!-- lido:eventDate -->
                <xsl:apply-templates select="mpx:erwerbDatum"/>

                <!-- lido:eventMethod (m3: neuer Platz für Erwerbungsart nach Empfehlung FvH)-->
                <xsl:apply-templates select="mpx:erwerbungsart"/>
            </lido:event>
        </lido:eventSet>
    </xsl:template>

    <xsl:template match="mpx:erwerbDatum">
        <lido:eventDate>
            <lido:displayDate>
                <xsl:value-of select="."/>
            </lido:displayDate>
            <lido:date>
                <lido:earliestDate>
                    <xsl:value-of select="."/>
                </lido:earliestDate>
                <lido:latestDate>
                    <xsl:value-of select="."/>
                </lido:latestDate>
            </lido:date>
        </lido:eventDate>
    </xsl:template>

    <xsl:template match="mpx:erwerbungVon">
        <lido:eventActor>
            <lido:displayActorInRole>
                <xsl:value-of select="."/>
                <xsl:text> (Veräußerer)</xsl:text>
                <!-- todo: PK(Veräußerer) -->
            </lido:displayActorInRole>
            <lido:actorInRole>
                <!-- todo -->
                <lido:actor lido:type="Person">
                    <!-- kein ID an dieser Stelle in M+ vorhanden (Register Erwerb); möglicherweise in RIA-->
                    <lido:nameActorSet>
                        <lido:appellationValue>
                            <xsl:value-of select="."/>
                        </lido:appellationValue>
                    </lido:nameActorSet>
                </lido:actor>
                <lido:roleActor>
                    <lido:term lido:addedSearchTerm="no">Veräußerer</lido:term>
                </lido:roleActor>
            </lido:actorInRole>
        </lido:eventActor>
    </xsl:template>

    <xsl:template match="mpx:erwerbungsart">
        <lido:eventMethod>
            <lido:term>Ankauf</lido:term>
        </lido:eventMethod>
    </xsl:template>
</xsl:stylesheet>