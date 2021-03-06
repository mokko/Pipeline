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
        
        1. mpx:Titel, 
        2. mpx:Sachbegriff (max. 2 Stück)
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
                    <tr><td colspan="3">
                        <h1 align="center">LIDO Datenblatt für rst</h1>
                    </td></tr>
                    <xsl:apply-templates select="/lido:lidoWrap/lido:lido">
                        <xsl:sort select="." data-type="number"/>
                    </xsl:apply-templates>
                        <tr>
                            <td colspan="3">
        N.B. In dieser Darstellung sind leere Felder leere Zellen in der Tabelle.
        Diese Darstellung folgt in der Reihenfolge und Struktur in LIDO, auch
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
            <tr>
                <td colspan="3">
                    <!-- INTRO -->
                    <xsl:element name="a">
                        <xsl:attribute name="name">
                            <xsl:value-of select="$lidoRecID" />
                        </xsl:attribute>
                    </xsl:element>
                    <h2 align="center">
                        lido RecId: 
                        <xsl:value-of select="$lidoRecID" />
                    </h2>
                </td>
            </tr>
            <tr>
                <td width="15%"><h4>M+</h4></td>
                <td width="15%"><h4>LIDO</h4></td>
                <td width="70%"><h4>Content</h4></td>
            </tr>
            <tr>
                <td>(objId)</td>
                <td>lidoRedID</td>
                <td><xsl:value-of select="lido:lidoRecID"/></td>
            </tr>
            <xsl:apply-templates select="lido:descriptiveMetadata"/>
            <xsl:apply-templates select="lido:administrativeMetadata"/>
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
        <p>LIDO hat möglicherweise mehr Sachbegriffe als das rst Datenblatt braucht. 
        Wenn nur ein Sachbegriff gewünscht ist, den mit kleinster sortorder wählen. 
        In m+ scheint es aber auch Fälle zu geben, wo mehrere Sachbegriffe ohne
        sortorder exportiert werden. Da kann ich nichts mappen. Ich schaue noch 
        einmal, ob M+ da überhaupt eine Möglichkei hat sort o. dergleichen zu 
        vergeben.</p>
        N.B.: lido:title kann auch mpx:Sachbegriff haben.<br/>
            </td>
        </tr>
        <tr>
            <td align="left" colspan="3"><h4>ObjectIdentificationWrap</h4></td>
        </tr>
        <tr>
            <td>Titel</td>
            <td>
                title (pref eq preferred, <br/>
                <xsl:text>encodinganalog: </xsl:text>
                <xsl:value-of select="lido:objectIdentificationWrap/lido:titleWrap/lido:titleSet/lido:appellationValue[
                    @lido:pref eq 'preferred']/@lido:encodinganalog"/>
                <xsl:text>)</xsl:text>
            </td>
            <td>
                <xsl:apply-templates select="lido:objectIdentificationWrap/lido:titleWrap/lido:titleSet[
                    lido:appellationValue/@lido:pref eq 'preferred']"/>
            </td>
        </tr>
        <tr>
            <td>Weitere Titel</td>
            <td>title (pref ne preferred
                <xsl:text>encodinganalog: </xsl:text>
                <xsl:value-of select="lido:objectIdentificationWrap/lido:titleWrap/lido:titleSet/lido:appellationValue[
                    @lido:pref ne 'preferred']/@lido:encodinganalog"/>
                <xsl:text>)</xsl:text>
            </td>
            <td>
                <xsl:apply-templates select="lido:objectIdentificationWrap/lido:titleWrap/lido:titleSet[
                lido:appellationValue/@lido:pref ne 'preferred']"/>
            </td>
        </tr>
        <tr>
            <td colspan="3">
        lido:titleSet wird aus mpx:titel gebaut oder, wenn kein mpx:titel 
        vorhanden ist, aus mpx:sachbegriff. Ursprungsfeld ist in @encodinganalog 
        verzeichnet. Haupttitel ist als pref gekennzeichnet.
            </td>
        </tr>
        <tr>
            <td>verwaltendeInstitution</td>
            <td>repositorySet [@type=current]/repositoryName</td>
            <td>
                <xsl:value-of select="lido:objectIdentificationWrap/lido:repositoryWrap/lido:repositorySet[@lido:type = 'current']/lido:repositoryName/lido:legalBodyName/lido:appellationValue"/>
            </td>
        </tr>
        <tr>
            <td>IdentNr</td>
            <td>repositorySet[@type=current]/workID</td>
            <td>
                <xsl:for-each select="lido:objectIdentificationWrap/lido:repositoryWrap/lido:repositorySet[@lido:type = 'current']/lido:workID">
                    <xsl:sort select="@sortorder" data-type="number"/>
                    <xsl:value-of select="."/>
                </xsl:for-each>
            </td>
        </tr>
        <tr>
            <td colspan="3">Es kann in m+ mehrere IdentNr.n pro Objekt bzw. Datensatz geben.</td>
        </tr>
        <tr>
            <td>m+Ausstellung und Sektion</td>
            <td>repositorySet[@type=rst]</td>
            <td>
                <xsl:value-of select="lido:objectIdentificationWrap/lido:repositoryWrap/lido:repositorySet[@lido:type eq 'rst']/lido:repositoryLocation/lido:placeID"/>
            </td>
        </tr>
        <tr>
            <td colspan="3">
            rst position hat mehrere Elemente: <ol><li>daf.rst.hf für alle Objekte in 
            Recherchestationen</li><li>Kennwort für die spezifische 
            Recherchestation</li><li>Sektion sollte so geschrieben sein, wie 
            analog auf Glas geplottet; noch nicht final.</li></ol>
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
        <xsl:text> (sortorder: </xsl:text>
        <xsl:value-of select="@lido:sortorder"/>)<br/>
        <xsl:for-each select="lido:term">
            <xsl:text>- </xsl:text>
            <xsl:value-of select="@xml:lang"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="."/><br/>
        </xsl:for-each>
    </xsl:template>


    <xsl:template match="lido:objectIdentificationWrap/lido:titleWrap/lido:titleSet">
        <xsl:for-each select="lido:appellationValue">
            <xsl:value-of select="@xml:lang"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="."/>
            <xsl:if test="@lido:pref">
                <xsl:text> (</xsl:text>
                <xsl:value-of select="@lido:pref"/>
                <xsl:text>)</xsl:text>
            </xsl:if>
            <br/>
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
            <td>verwaltendeInstitution</td>
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
            <td>Standardbild</td>
            <td>resourceSet [@lido:sortorder = 1]</td>
            <td>
                <xsl:apply-templates select="lido:resourceWrap/lido:resourceSet[@lido:sortorder = 1]"/> 
            </td>
        </tr>
        <tr>
            <td>Weitere Bilder</td>
            <td>resourceSet [@lido:sortorder != 1]</td>
            <td>
                <xsl:apply-templates select="lido:resourceWrap/lido:resourceSet[@lido:sortorder != 1]"/> 
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <xsl:for-each select="lido:resourceWrap/lido:resourceSet/lido:resourceRepresentation/lido:linkResource">
                    <xsl:sort select="@lido:sortorder" data-type="number" order="ascending"/>
                    <img width="300">
                        <xsl:attribute name="src">
                            <xsl:text>../../pix2/</xsl:text>
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </img>
                    <xsl:text> </xsl:text>
                </xsl:for-each>
            </td>
        </tr>
        <tr>
            <td colspan="3">
            Ich bin inzwischen, dass ich nur Bilder/Medien mit explizitem veröffentlichen = ja 
            für rst nach LIDO exportieren soll. rst bekommt Objekte unabhängig von ihrer 
            smb-digital Freigabe, SHF bekommt nur Objekte die für smb-digital freigegeben sind.
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="lido:resourceWrap/lido:resourceSet">
        <xsl:text>resourceId: </xsl:text>
        <xsl:value-of select="lido:resourceID"/>
        <xsl:text> (type:</xsl:text>
        <xsl:value-of select="@lido:type"/>
        <xsl:text>)</xsl:text><br/>
        <xsl:text>resourceRepresentation/linkResource: </xsl:text>
        <xsl:value-of select="lido:resourceRepresentation/lido:linkResource"/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="lido:resourceRepresentation/@lido:type"/>
        <xsl:text>)</xsl:text><br/>
        <xsl:text>resourceDateTaken/displayDate: </xsl:text>
        <xsl:value-of select="lido:resourceDateTaken/lido:displayDate"/><br/>
        <xsl:text>rights:</xsl:text><br/>
        <xsl:for-each select="lido:rightsResource/lido:rightsHolder/lido:legalBodyName/lido:appellationValue">
            - <xsl:value-of select="."/>
            <xsl:text> (</xsl:text>
            <xsl:value-of select="../../../lido:rightsType/lido:term"/>
            <xsl:text>)</xsl:text><br/>
        </xsl:for-each><br/>
    </xsl:template>    
    
    <xsl:template mode="Herstellung" match="lido:eventWrap/lido:eventSet">
            <tr>
                <td align="left" colspan="3"><h4>Event: Herstellung</h4></td>
            </tr>
            <tr>
                <td>PK/Hersteller, Geogr.Bezug[Ethnie|Kultur|Sprachgruppe]</td>
                <td>eventActor/displayActorInRole<br/>actorRole</td>
                <td>
                    <xsl:value-of select="lido:event/lido:eventActor/lido:displayActorInRole" /><br/>
                    <xsl:value-of select="lido:event/lido:eventActor/lido:actorInRole/lido:roleActor" />
                </td>
            </tr>
            <tr>
                <td>Datierung</td>
                <td>event/display date</td>
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
                        <xsl:sort select="@lido:sortorder" data-type="number" order="ascending"/>
                        <xsl:value-of select="lido:displayPlace[@xml:lang ='de']" />
                        <xsl:if test="position()!=last()">
                            <xsl:text> &gt;&gt; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <br/>en: 
                    <xsl:for-each select="lido:event/lido:eventPlace">
                        <xsl:sort select="@lido:sortorder" data-type="number" order="ascending"/>
                        <xsl:value-of select="lido:displayPlace[@xml:lang ='en']" />
                        <xsl:if test="position()!=last()">
                            <xsl:text> &gt;&gt; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    nach eventPlace@sortorder sortiert. SOLL: von Groß (China) zu Klein (Beijing). Im EM soll von großer nach
                    kleiner Zahl in sortorder sortiert werden; im AKu sind die sortorder Zahlen andersherum eingegeben. NEU: 
                    Daher drehe ich sie in LIDO so um, damit sie alle in gleicher Reihenfolge in LIDO sind.
                </td>
            </tr>
            <tr>
                <td>Geogr. Bezug</td>
                <td>place (@lido:geographicalEntity)</td>
                <td>
                    <xsl:text>de: </xsl:text><br/>
                    <xsl:apply-templates select="lido:event/lido:eventPlace/lido:place/lido:namePlaceSet/lido:appellationValue
                        [@xml:lang ='de']">
                        <xsl:sort select="../../../@lido:sortorder" data-type="number" order="ascending"/>
                        </xsl:apply-templates>
                    <xsl:text>en: </xsl:text><br/>
                    <xsl:apply-templates select="lido:event/lido:eventPlace/lido:place/lido:namePlaceSet/lido:appellationValue
                        [@xml:lang ='en']">
                        <xsl:sort select="../../../@lido:sortorder" data-type="number" order="ascending"/>
                    </xsl:apply-templates>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    <p>Viele der Orte in M+ sollten vielleicht mittels lido:partOfPlace 
                    dargestellt werden. Da scheint aber allein mit den Daten aus m+ 
                    unmöglich.</p><p>Qualifikator "Ortstyp" lässt sich in LIDO nicht 
                    übersetzen (https://github.com/mokko/Pipeline/issues/11).</p><p> 
                    TO DO: AKu-sortoder in LIDO umdrehen.</p>
                </td>
            </tr>
            <tr>
                <td>Material/Technik (@Ausgabe)</td>
                <td>displayMaterialsTech</td>
                <td>
                    <xsl:for-each select="lido:event/lido:eventMaterialsTech/lido:displayMaterialsTech">
                        <xsl:value-of select="@xml:lang"/>
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="."/>
                        <br/>
                    </xsl:for-each>
                </td>
            </tr>
    </xsl:template>
    
    <xsl:template match="lido:event/lido:eventPlace/lido:place/lido:namePlaceSet/lido:appellationValue">
        <xsl:if test="@lido:type">
            <xsl:value-of select="@lido:type" />
            <xsl:text>: </xsl:text>
        </xsl:if>
        <xsl:text>- </xsl:text>
        <xsl:value-of select="." />
        <xsl:text> (</xsl:text>
        <xsl:value-of select="../../@lido:geographicalEntity" />
        <xsl:value-of select="../../@lido:politicalEntity" />
        <xsl:text> sortoder: </xsl:text>
        <xsl:value-of select="../../../@lido:sortorder"/>
        <xsl:text>)</xsl:text><br/>
    </xsl:template>

    <xsl:template mode="Erwerb" match="lido:eventWrap/lido:eventSet">
            <tr>
                <td align="left" colspan="3"><h4>Event: Erwerb</h4></td>
            </tr>
            <tr>
                <td>
                    PK:Veräußerer<br/>
                    erwerbungVon</td>
                <td>displayActorInRole</td>
                <td>
                    <xsl:for-each select="lido:event/lido:eventActor/lido:displayActorInRole">
                        <xsl:value-of select="."/> 
                        <xsl:text> (encodinganalog: </xsl:text>
                        <xsl:value-of select="@encodinganalog"/>
                        <xsl:text>)</xsl:text>
                    </xsl:for-each>
                </td>
            </tr>
            <tr>
                <td>Datierung</td>
                <td>event/display date</td>
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
                    <xsl:for-each select="lido:event/lido:eventMethod/lido:term">
                        <xsl:value-of select="@xml:lang" />
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="." /><br/>
                    </xsl:for-each>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                Verwende encodinganalog, um zu entscheiden, ob Veräußerer aus 
                mpx:erwerbungVon oder mpx:personenKörperschaften kommt.
                </td>
            </tr>
    </xsl:template>
</xsl:stylesheet>