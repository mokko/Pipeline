<xsl:stylesheet version="2.0"
    xmlns:lido="http://www.lido-schema.org"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:h="http://www.w3.org/1999/xhtml"
    xmlns:mpx="http://www.mpx.org/mpx" exclude-result-prefixes="lido xsi h">

    <xsl:output method="html" name="html" version="1.0" encoding="UTF-8" indent="yes" />
    <xsl:strip-space elements="*" />

    <!-- 
        @Expects LIDO as input 
        @outputs RST Deckblatt as html
        
        Nur Felder des m+ Datenblatts! Dafür ist primitives push Design Pattern
        durchaus geeignet:
        
        1. Titelzeile: mpx:Titel, 
        2. Titelzeile: mpx:Sachbegriff (max. 2 Stück)
        3. GeogrBezug (Wiederholfeld, @bezeichnung wird angezeigt)
        4. Mat/Technik@Ausgabe
        5. Maßangaben (ohne Anzeige der Dimensionen)
        6. OnlineBeschreibung
        7. Provenienz: Vorbesitzer (Sammler, Veräußerer, erworbenVon)
        8. Provenienz: Verwaltende Institution
        9. Provenienz: Eingangsdatum
        10. Provenienz: Erwerbungsart
        11. Provenienz: Inventarnummer
        12. Creditline Foto
        13. Hauptbild, Weitere Medien
    -->

    <xsl:template match="/">
            <html>
                <head>
                    <title>Datenblatt aus LIDO</title>
                    <meta charset="UTF-8" />
                    <style>
                        h2 {
                        padding-top: 20px;
                        }
                    </style>
                </head>
                <body>
                    <table border="1" width="1000">
                        <tr>
                            <td colspan="3" align="center">
                                <h1>LIDO Datenblatt </h1>
                            </td>
                        </tr>
                    <xsl:apply-templates select="/lido:lidoWrap/lido:lido">
                        <xsl:sort select="/lido:lidoWrap/lido:lido/lido:lidoRecID"/>
                    </xsl:apply-templates>
                        <tr>
                            <td colspan="3">
        In dieser Darstellung sind leere Felder leere Zellen in der Tabelle.
        Diese Darstellung folgt in der Reihenfolge und Struktur LIDO, auch
        wenn sie in erster Spalte M+ Felder anzeigt. Gezeigt werden nur Felder,
        die für das Datenblatt ausgewählt wurden.
                            </td>
                        </tr>
                    </table>
                </body>
            </html>
    </xsl:template>

    <!-- DATENBLATT -->

    <xsl:template match="/lido:lidoWrap/lido:lido">
        <xsl:variable name="lidoRecID" select="lido:lidoRecID" />
        <xsl:message>
            <xsl:text>datenblatt-lidoRecID: </xsl:text>
            <xsl:value-of select="$lidoRecID" />
        </xsl:message>

        <!-- INTRO -->
        <xsl:element name="a">
            <xsl:attribute name="name">
                <xsl:value-of select="$lidoRecID" />
            </xsl:attribute>
        </xsl:element>
            <tr>
                <td width="15%"><h4>M+</h4></td>
                <td width="15%"><h4>LIDO</h4></td>
                <td width="70%"><h4>Content</h4></td>
            </tr>
            <tr>
                <td>objId</td>
                <td>lidoRedID</td>
                <td><xsl:value-of select="lido:lidoRecID"/></td>
            </tr>
            <xsl:apply-templates select="lido:descriptiveMetadata"/>
            <xsl:apply-templates select="lido:administrativeMetadata"/>
        <br/>
        <br/>
    </xsl:template>

    <xsl:template match="lido:descriptiveMetadata">
        <tr>
            <td align="center" colspan="3"><h4>Descriptive Metadata</h4></td>
        </tr>
        <tr>
            <td align="left" colspan="3"><h4>ObjectClassificationWrap</h4></td>
        </tr>
        <tr>
            <td>Sachbegriff</td>
            <td>objectWorkType</td>
            <td>
                <xsl:apply-templates select="lido:objectClassificationWrap/lido:objectWorkTypeWrap/lido:objectWorkType"/>
            </td>
        </tr>
        <tr>
            <td colspan="3">
        Hier werden u.U. mehr Sachbegriffe angezeigt als in rst. Wenn nur ein 
        Sachbegriff gewünscht ist, den mit kleinster sortorder wählen. 
        Sachbegriff (Hierarchie) kann noch zu lido:classification werden.
            </td>
        </tr>
        <tr>
            <td align="left" colspan="3"><h4>ObjectIdentificationWrap</h4></td>
        </tr>
        <tr>
            <td>Titel</td>
            <td>title (min sortorder)</td>
            <td>
                <xsl:apply-templates select="lido:objectIdentificationWrap/lido:titleWrap/lido:titleSet[min (@lido:sortorder)]"/>
            </td>
        </tr>
        <tr>
            <td>Weitere Titel</td>
            <td>title</td>
            <td>
                <xsl:for-each 
                    select="lido:objectIdentificationWrap/lido:titleWrap/lido:titleSet[not (min (@lido:sortorder))]">
                    <xsl:text>sortorder: </xsl:text>
                    <xsl:value-of select="@lido:sortorder"/><br/>
                    <xsl:for-each select="lido:appellationValue">
                        <xsl:value-of select="@xml:lang"/>
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="."/><br/>
                    </xsl:for-each>
                </xsl:for-each> 
            </td>
        </tr>
        <tr>
            <td colspan="3">
        lido:titleSet wird aus mpx:titel gebaut oder, wenn kein mpx:titel 
        vorhanden ist, aus mpx:sachbegriff. Haupttitle mit kleinster sortorder
        wird oben angezeigt. Alle weiteren, unter Weitere.
            </td>
        </tr>
        <tr>
            <td>verwaltendeInstitution</td>
            <td>repositorySet [@type=current]/ repositoryName</td>
            <td>
                <xsl:value-of select="lido:objectIdentificationWrap/lido:repositoryWrap/lido:repositorySet[@lido:type = 'current']/lido:repositoryName/lido:legalBodyName/lido:appellationValue"/>
            </td>
        </tr>
        <tr>
            <td>IdentNr</td>
            <td>repositorySet [@type=current]/ workID</td>
            <td>
                <xsl:for-each select="lido:objectIdentificationWrap/lido:repositoryWrap/lido:repositorySet[@lido:type = 'current']/lido:workID">
                    <xsl:sort select="@sortorder" data-type="number"/>
                    <xsl:value-of select="."/>
                </xsl:for-each>
            </td>
        </tr>
        <tr>
            <td colspan="3">Es kann mehrere IdentNr.n geben.</td>
        </tr>
        <tr>
            <td>rst STO [m+Ausstellung, AndereNr]</td>
            <td>repositorySet[@type=rst]/ repositoryLocation</td>
            <td>
                <xsl:value-of select="lido:objectIdentificationWrap/lido:repositoryWrap/lido:repositorySet[@lido:type = 'rst']/lido:repositoryLocation/lido:placeID"/>
            </td>
        </tr>
        <tr>
            <td colspan="3">
            rst.sto hat mehrere Elemente (1) daf.rst.hf für alle Objekte in Recherchestationen 
            (2) Kennwort für die spezifische Recherchestation; (3) Segment;  (4) Position (v.l.n.r.). 
            (2) kommt Ausstellungstitel; (3) könnte aus Sektion kommen; (4) muss manuell in AndereNr. 
            eingegeben werden. Alternativ könnte man sicher auch m+sto verwenden.
            </td>
        </tr>
        <tr>
            <td>Maßangaben</td>
            <td>displayObjectMeasurements</td>
            <td>
                <xsl:for-each select="lido:objectIdentificationWrap/lido:objectMeasurementsWrap/lido:objectMeasurementsSet/lido:displayObjectMeasurements">
                    <xsl:value-of select="."/>
                    <xsl:if test="position()!=last()">
                        <xsl:text>; </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </td>
        </tr>
        <xsl:apply-templates mode="Herstellung" select="lido:eventWrap/lido:eventSet[lido:event/lido:eventType/lido:term = 'Herstellung']"/>
        <xsl:apply-templates mode="Erwerb" select="lido:eventWrap/lido:eventSet[lido:event/lido:eventType/lido:term = 'Erwerb']"/>
    </xsl:template>

    <xsl:template match="lido:objectClassificationWrap/lido:objectWorkTypeWrap/lido:objectWorkType">
        <xsl:value-of select="@lido:type"/>
        <xsl:text> sortorder: </xsl:text>
        <xsl:value-of select="@lido:sortorder"/><br/>
        <xsl:for-each select="lido:term">
            <xsl:text>- </xsl:text>
            <xsl:value-of select="@xml:lang"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="."/><br/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="lido:objectIdentificationWrap/lido:titleWrap/lido:titleSet[min (@lido:sortorder)]">
        <xsl:text>sortorder: </xsl:text>
        <xsl:value-of select="@lido:sortorder"/><br/>
        <xsl:for-each select="lido:appellationValue">
            <xsl:value-of select="@xml:lang"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="."/><br/>
        </xsl:for-each>
    </xsl:template> 

    <xsl:template match="lido:administrativeMetadata">
        <tr>
            <td align="center" colspan="3"><h4>Administrative Metadata</h4></td>
        </tr>
        <tr>
            <td align="left" colspan="3"><h4>rightsWorkWrap</h4></td>
        </tr>
        <tr>
            <td>Credits?</td>
            <td>rightsWorkSet</td>
            <td>
                <xsl:value-of select="lido:rightsWorkWrap/lido:rightsWorkSet/lido:rightsHolder/lido:legalBodyName/lido:appellationValue" />
            </td>
        </tr>
        <tr>
            <td>Credits</td>
            <td>creditLine (object)</td>
            <td>
                <xsl:value-of select="lido:rightsWorkWrap/lido:rightsWorkSet/lido:creditLine" />
            </td>
        </tr>
        <tr>
            <td align="left" colspan="3"><h4>recordWrap</h4></td>
        </tr>
        <tr>
            <td>smb-digital.de</td>
            <td>recordInfoLink</td>
            <td>
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="lido:recordWrap/lido:recordInfoSet/lido:recordInfoLink" />
                    </xsl:attribute>
                    <xsl:value-of select="lido:recordWrap/lido:recordInfoSet/lido:recordInfoLink" />
                </a>
            </td>
        </tr>
        <tr>
            <td align="left" colspan="3"><h4>resourceWrap</h4></td>
        </tr>
        <tr>
            <td>MM.Erweiterung, mulId</td>
            <td>linkResource [@lido:sortorder = 1] (entspricht Standardbild)</td>
            <td>
                <xsl:value-of select="lido:resourceWrap/lido:resourceSet[@lido:sortorder = 1]/lido:resourceRepresentation/lido:linkResource" />
            </td>
        </tr>
        <tr>
            <td colspan="3">Standardbild in M+ wird zu lido:resourceSet[@sortorder = 1]</td>
        </tr>
        <tr>
            <td>Urheb/Fotograf</td>
            <td>rightsholder (Urheber)</td>
            <td>
                <xsl:value-of select="lido:resourceWrap/lido:resourceSet[@lido:sortorder = 1]/lido:rightsResource[lido:rightsType/lido:term ='Urheber']/lido:rightsHolder/lido:legalBodyName/lido:appellationValue" />
            </td>
        </tr>
    </xsl:template>
    
    <xsl:template mode="Herstellung" match="lido:eventWrap/lido:eventSet">
            <tr>
                <td align="left" colspan="3"><h4>Event: Herstellung</h4></td>
            </tr>
            <tr>
                <td>Datierung</td>
                <td>event, display date</td>
                <td>
                    <xsl:value-of select="lido:event/lido:eventDate/lido:displayDate" />
                </td>
            </tr>
            <tr>
                <td>Datierung (@von-@bis)</td>
                <td>date (earlierst-latest)</td>
                <td>
                    <xsl:if test="lido:event/lido:eventDate/lido:date/lido:earliestDate 
                        or lido:event/lido:eventDate/lido:date/lido:latestDate">
                        <xsl:value-of select="lido:event/lido:eventDate/lido:date/lido:earliestDate" />
                        <xsl:text> - </xsl:text>
                        <xsl:value-of select="lido:event/lido:eventDate/lido:date/lido:latestDate" />
                    </xsl:if>
                </td>
            </tr>
            <tr>
                <td colspan="3">In Lido kann es praktisch nur ein Datum pro 
                Event geben. In diesem Lido wird nur M+Datierung mit
                niedrigstem Sort berücksichtigt.
                </td>
            </tr>

            <tr>
                <td>Geogr. Bezug</td>
                <td>display place</td>
                <td>de: 
                    <xsl:for-each select="lido:event/lido:eventPlace">
                        <xsl:sort select="@sortorder" data-type="number" order="descending"/>
                        <xsl:value-of select="lido:displayPlace[@xml:lang ='de']" />
                        <xsl:if test="position()!=last()">
                            <xsl:text> &gt;&gt; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <br/>en: 
                    <xsl:for-each select="lido:event/lido:eventPlace">
                        <xsl:sort select="@sortorder" data-type="number" order="descending"/>
                        <xsl:value-of select="lido:displayPlace[@xml:lang ='en']" />
                        <xsl:if test="position()!=last()">
                            <xsl:text> &gt;&gt; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    nach eventPlace@sortorder sortiert (von großer Zahl nach
                    kleiner)
                </td>
            </tr>
            <tr>
                <td>Geogr. Bezug</td>
                <td>place (@lido:geographicalEntity)</td>
                <td>
                    <xsl:for-each select="lido:event/lido:eventPlace">
                        <xsl:sort select="@sortorder" data-type="number" order="descending"/>
                        <xsl:if test="@lido:type">
                            <xsl:value-of select="@lido:type" />
                            <xsl:text>: </xsl:text>
                        </xsl:if>
                        <xsl:value-of select="lido:place/lido:namePlaceSet/lido:appellationValue[@xml:lang ='de']" />
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="lido:place/lido:namePlaceSet/lido:appellationValue[@xml:lang ='en']" />
                        <xsl:text> (</xsl:text>
                        <xsl:value-of select="lido:place/@lido:geographicalEntity" />
                        <xsl:value-of select="lido:place/@lido:politicalEntity" />
                        <xsl:text>)</xsl:text>
                        <br/>
                    </xsl:for-each>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    Viele der unterschiedlichen Orte in M+ sollten mittels 
                    lido:partOfPlace dargestellt werden. Allerdings gibt es
                    keine Möglichkeit partOfPlace von nicht-partOfPlace
                    maschinell zu erkennen.
                </td>
            </tr>
            <tr>
                <td>Mat/Technik (@Ausgabe)</td>
                <td>displayMaterialsTech</td>
                <td>
                    <xsl:value-of select="lido:event/lido:eventMaterialsTech/lido:displayMaterialsTech"/>
                </td>
            </tr>
    </xsl:template>

    <xsl:template mode="Erwerb" match="lido:eventWrap/lido:eventSet">
            <tr>
                <td align="left" colspan="3"><h4>Event: Erwerb</h4></td>
            </tr>
            <tr>
                <td>Veräußerer; erwerbungVon</td>
                <td>displayActorInRole</td>
                <td>
                    <xsl:value-of select="lido:event/lido:eventActor/lido:displayActorInRole"/>
                </td>
            </tr>
            <tr>
                <td>Datierung</td>
                <td>event, display date</td>
                <td>
                    <xsl:value-of select="lido:event/lido:eventDate/lido:displayDate" />
                </td>
            </tr>
            <tr>
                <td>Datierung (@von-@bis)</td>
                <td>date (earlierst-latest)</td>
                <td>
                    <xsl:if test="lido:event/lido:eventDate/lido:date/lido:earliestDate 
                        or lido:event/lido:eventDate/lido:date/lido:latestDate">
                        <xsl:value-of select="lido:event/lido:eventDate/lido:date/lido:earliestDate" />
                        <xsl:text> - </xsl:text>
                        <xsl:value-of select="lido:event/lido:eventDate/lido:date/lido:latestDate" />
                    </xsl:if>
                </td>
            </tr>
            <tr>
                <td>Erwerbungsart</td>
                <td>eventMethod</td>
                <td>
                    <xsl:value-of select="lido:event/lido:eventMethod/lido:term" />
                </td>
            </tr>
</xsl:template>
    
</xsl:stylesheet>