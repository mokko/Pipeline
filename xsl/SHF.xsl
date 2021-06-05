<xsl:stylesheet version="2.0"
    xmlns="http://www.mpx.org/npx"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:mpx="http://www.mpx.org/mpx" xmlns:npx="http://www.mpx.org/npx"

    exclude-result-prefixes="mpx npx">

    <xsl:output method="xml" version="1.0" encoding="UTF-8"
        indent="yes" />
    <xsl:strip-space elements="*" />

    <!-- strict push sequence -->

    <xsl:template match="/">
        <shf version="20200330">
            <xsl:comment>
                <xsl:text>npx format: 
(1) only elements, no xml attributes;
(2) repeated values are written as list in single element separated by semicolon; 
(3) NEW qualifiers are either in post position as "value [qualifier]"; or
(4) NEW in preposition as "[qualifier] value";
(5) NEW no more qualifiers in consecutive elements position since this works only with 
    elements that are not repeated and there are none of those at the moment.</xsl:text>
            </xsl:comment>

            <!-- FIRST ALL STANDARDBILDER THEN ALL FREIGEBENE THAT ARE NOT STANDARDBILD -->
            <xsl:apply-templates select="/mpx:museumPlusExport/mpx:multimediaobjekt[
                lower-case(mpx:veröffentlichen) eq 'ja']">
                <xsl:sort select="@mulId" data-type="number"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="/mpx:museumPlusExport/mpx:sammlungsobjekt" />
        </shf>
    </xsl:template>

    <!-- 
        MULTIMEDIAOBJEKT 
    -->

    <xsl:template match="/mpx:museumPlusExport/mpx:multimediaobjekt">
        <xsl:element name="multimediaobjekt">
            <xsl:apply-templates select="@mulId, @exportdatum, node()">
                <xsl:sort select="name()"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>

    <!-- 
        SAMMLUNGSOBJEKT
    -->
    <xsl:template match="/mpx:museumPlusExport/mpx:sammlungsobjekt">
        <xsl:variable name="objId" select="@objId" />

        <xsl:element name="sammlungsobjekt">
            <xsl:apply-templates select="mpx:anzahlTeile"/>
            <xsl:apply-templates select="mpx:ausstellung"/>
            <!-- referenziertes Feld (works only with $objId not with @objId) -->
            <xsl:apply-templates select="/mpx:museumPlusExport/mpx:ausstellung/mpx:objekt[. = $objId]"/>

            <xsl:apply-templates select="
                        mpx:bearbDatum|
                        mpx:credits" />

            <!-- attributes in post position [vonJahr - bisJahr]-->
            <xsl:if test="mpx:datierung">
                <xsl:element name="datierung">
                    <xsl:for-each select="mpx:datierung">
                        <xsl:if test="@sort">
                            <xsl:text>[S:</xsl:text>
                            <xsl:value-of select="@sort"/>
                            <xsl:text>] </xsl:text>
                        </xsl:if>
                        <xsl:value-of select="."/>
                        <xsl:if test="@bisJahr or @vonJahr">
                            <xsl:text> [</xsl:text>
                                <xsl:value-of select="@vonJahr" />
                            <xsl:text> - </xsl:text>
                                <xsl:value-of select="@bisJahr" />
                            <xsl:text>]</xsl:text>
                        </xsl:if>
                        <xsl:if test="position()!=last()">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:element>
            </xsl:if>


            <!-- erwerbNotizAusgabe-->
            <xsl:if test="(mpx:verwaltendeInstitution 
                and mpx:erwerbungsart 
                and mpx:erwerbDatum) 
                or mpx:erwerbNotiz[@Ausgabe]">
                <xsl:element name="erwerbNotizAusgabe">
                    <xsl:choose>
                        <xsl:when test="mpx:erwerbNotiz[@Ausgabe]">
                            <xsl:value-of select="." />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when
                                    test="mpx:verwaltendeInstitution and mpx:erwerbDatum and mpx:erwerbungsart">
                                    <xsl:text>Das </xsl:text>
                                    <xsl:value-of select="mpx:verwaltendeInstitution" />
                                    <xsl:text> oder eine Vorgängerinstitution erwarb das Objekt </xsl:text>
                                    <xsl:value-of select="mpx:erwerbDatum" />
                                    <xsl:text> durch </xsl:text>
                                    <xsl:value-of select="mpx:erwerbungsart" />
                                    <xsl:text>.</xsl:text>
                                </xsl:when>
                                <xsl:when
                                    test="mpx:verwaltendeInstitution and mpx:erwerbDatum">
                                    <xsl:text>Das </xsl:text>
                                    <xsl:value-of select="mpx:verwaltendeInstitution" />
                                    <xsl:text> oder eine Vorgängerinstitution erwarb das Objekt </xsl:text>
                                    <xsl:value-of select="mpx:erwerbDatum" />
                                    <xsl:text>.</xsl:text>
                                </xsl:when>
                                <xsl:when
                                    test="mpx:verwaltendeInstitution and mpx:erwerbungsart">
                                    <xsl:text>Das </xsl:text>
                                    <xsl:value-of select="mpx:verwaltendeInstitution" />
                                    <xsl:text> oder eine Vorgängerinstitution erwarb das Objekt </xsl:text>
                                    <xsl:value-of select="mpx:erwerbDatum" />
                                    <xsl:text>.</xsl:text>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:if>

            <xsl:apply-templates select="@exportdatum"/>

            <!-- geogrBezug -->        
            <xsl:if test="/mpx:museumPlusExport/mpx:sammlungsobjekt[@objId eq $objId]/mpx:geogrBezug">
                <xsl:element name="geogrBezug">
                    <xsl:for-each
                        select="/mpx:museumPlusExport/mpx:sammlungsobjekt[@objId eq $objId]/mpx:geogrBezug">
                        <xsl:if test="@art">
                            <xsl:text>[</xsl:text>
                            <xsl:value-of select="@art" />
                            <xsl:text>] </xsl:text>
                        </xsl:if>
                        <xsl:value-of select="normalize-space()" />
                        <xsl:if test="@bezeichnung or @sort">
                            <xsl:text> [</xsl:text>
                            <xsl:if test="@bezeichnung">
                                <xsl:value-of select="@bezeichnung" />
                                <xsl:text> </xsl:text>
                            </xsl:if>
                            <xsl:if test="@sort">
                                <xsl:text>S:</xsl:text>
                                <xsl:value-of select="@sort" />
                            </xsl:if>
                            <xsl:text>]</xsl:text>
                        </xsl:if>
                        
                        <xsl:if test="position()!=last()">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:element>
            </xsl:if>

            <!-- gewicht: auf speziellen Wunsch der SHF ist Gewicht jetzt eigenes Feld und nicht mehr Teil von Maßangabe-->
            <xsl:apply-templates select="/mpx:museumPlusExport/mpx:sammlungsobjekt[@objId eq $objId]/mpx:maßangaben[@typ eq 'Gewicht']"/>

            <xsl:apply-templates select="mpx:handlingVerpackungTransport"/>

            <!-- Hersteller -->
            <xsl:apply-templates select="/mpx:museumPlusExport/mpx:sammlungsobjekt[@objId eq $objId]/mpx:personenKörperschaften[@funktion eq 'Hersteller']" />


            <xsl:element name="identNr">
                <xsl:for-each select="mpx:identNr">
                    <xsl:sort select="."/>
                    <!-- xsl:message>
                        <xsl:value-of select="../@objId" />
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="." />
                    </xsl:message-->
                        <xsl:value-of select="." />
                        <xsl:if test="@art">
                            <xsl:text> [</xsl:text>
                            <xsl:value-of select="@art"/>
                            <xsl:text>]</xsl:text>
                        </xsl:if>
                        <xsl:if test="position()!=last()">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                </xsl:for-each>
            </xsl:element>
            
            <xsl:apply-templates select="
                mpx:kABeleuchtung|
                mpx:kALuftfeuchtigkeit|
                mpx:kABemLeihfähigkeit|
                mpx:kATemperatur"/>

            <!-- Künstler-->
            <xsl:apply-templates select="/mpx:museumPlusExport/mpx:sammlungsobjekt[
                @objId eq $objId]/mpx:personenKörperschaften[@funktion eq 'Künstler' 
                    or @funktion eq 'Objektkünstler' ]" />

            <!-- Quali in the back -->
            <xsl:if test="/mpx:museumPlusExport/mpx:sammlungsobjekt[@objId eq $objId]/mpx:maßangaben[@typ ne 'Gewicht']">
                <xsl:element name="maßangaben">
                    <xsl:for-each select="/mpx:museumPlusExport/mpx:sammlungsobjekt[@objId eq $objId]/mpx:maßangaben">
                        <xsl:value-of select="normalize-space()" />
                        <xsl:if test="@typ">
                            <xsl:text> [</xsl:text>
                            <xsl:value-of select="@typ" />
                            <xsl:text>]</xsl:text>
                        </xsl:if>
                        <xsl:if test="position()!=last()">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:element>
            </xsl:if>

            <xsl:apply-templates select="mpx:materialTechnik[@art eq 'Ausgabe']" />
            <xsl:apply-templates select="@objId" />
            <xsl:apply-templates select="mpx:onlineBeschreibung" />

            <xsl:if test="/mpx:museumPlusExport/mpx:sammlungsobjekt[@objId eq $objId]/mpx:sachbegriff">
                <xsl:element name="sachbegriff">
                    <xsl:for-each
                        select="/mpx:museumPlusExport/mpx:sammlungsobjekt[@objId eq $objId]/mpx:sachbegriff">
                        <xsl:value-of select="normalize-space()" />
                        <xsl:if test="@art">
                            <xsl:text> [</xsl:text>
                            <xsl:value-of select="@art" />
                            <xsl:text>]</xsl:text>
                        </xsl:if>
                        <xsl:if test="position()!=last()">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:element>
            </xsl:if>

            <xsl:apply-templates
                select="/mpx:museumPlusExport/mpx:multimediaobjekt[mpx:verknüpftesObjekt eq $objId]/mpx:standardbild" />

            <xsl:apply-templates
                select="mpx:titel|
                    mpx:verantwortlich|
                    mpx:verwaltendeInstitution|
                    mpx:wGAusVorgaben|
                    mpx:wGRestzeit_gh|
                    mpx:wGStänderung|
                    mpx:wGZustand" />
        </xsl:element>
    </xsl:template>


    <!-- ***TEMPLATES ON FEATURES LEVEL from sammlungsobjekt AND multimediaobjekt***-->

    
    <!-- no attributes ever -->
    <xsl:template match="
                mpx:anzahlTeile|
                mpx:anfertDat|
                mpx:bearbDatum|
                mpx:credits|
                mpx:dateiname|
                mpx:erweiterung|
                @exportdatum|
                mpx:farbe|
                mpx:funktion|
                mpx:format|
                mpx:fotoNegNr|
                mpx:handlingVerpackungTransport|
                mpx:inhaltAnsicht|
                mpx:kABeleuchtung|
                mpx:kABemLeihfähigkeit|
                mpx:kALuftfeuchtigkeit|
                mpx:kATemperatur|
                mpx:matTechn|
                @mulId|
                @objId|
                mpx:onlineBeschreibung|
                mpx:personenKörperschaften|
                mpx:pfadangabe|
                mpx:standardbild|
                mpx:typ|
                mpx:urhebFotograf|
                mpx:verantwortlich|
                mpx:verknüpftesObjekt|
                mpx:veröffentlichen|
                mpx:vervielfVon|
                mpx:verwaltendeInstitution|
                mpx:wGAusVorgaben|
                mpx:wGRestzeit_gh|
                mpx:wGStänderung|
                mpx:wGZustand">
        <xsl:element name="{name()}">
            <xsl:value-of select="." />
        </xsl:element>
    </xsl:template>

    <!-- Ich nehme hier mal an, dass jedes Objekt immer nur in einer HF Ausstellung 
        zu sehen sein wird; es ist aber durchaus möglich, dass ein Objekt von einer 
        in die andere Ausstellung wechselt, also ist diese Annahme nicht sehr 
        zukunftstauglich. -->
    <xsl:template match="/mpx:museumPlusExport/mpx:sammlungsobjekt/mpx:ausstellung">
        <xsl:if test="matches(., 'HUFO')">
            <xsl:element name="{name()}">
                <xsl:value-of select="." />
            </xsl:element>
            <xsl:element name="ausstellungSektion">
                <xsl:value-of select="@sektion" />
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <!-- GIBTS' PRAKTISCH NICHT MEHR IN MPX. ICH LASSE DAS TROTZDEM MAL HIER
    ausstellung as separate entity is attribute as consecutive element position-->
    <xsl:template match="/mpx:museumPlusExport/mpx:ausstellung/mpx:objekt">
        <xsl:element name="ausstellung">
            <xsl:value-of select="../mpx:titel" />
        </xsl:element>
        <xsl:element name="ausstellungSektion">
            <xsl:value-of select="@sektion" />
        </xsl:element>
    </xsl:template>

    <!-- Hersteller und Künstler-->
    <xsl:template match="/mpx:museumPlusExport/mpx:sammlungsobjekt/mpx:personenKörperschaften">
        <!--xsl:message><xsl:value-of select="."/></xsl:message-->
            <xsl:choose>
                <xsl:when test="@funktion = 'Hersteller'">
                    <xsl:element name="{lower-case(@funktion)}">
                        <xsl:value-of select="."/>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="@funktion = 'Künstler' or @funktion = 'Objektkünstler'">
                    <xsl:element name="künstler">
                        <xsl:value-of select="."/>
                    </xsl:element>
                </xsl:when>
            </xsl:choose>
    </xsl:template>

    <xsl:template match="/mpx:museumPlusExport/mpx:sammlungsobjekt/mpx:maßangaben">
        <xsl:element name="gewicht">
            <xsl:value-of select="." />
        </xsl:element>
    </xsl:template>

    <!-- attribute name in element name-->
    <xsl:template match="/mpx:museumPlusExport/mpx:sammlungsobjekt/mpx:materialTechnik[@art eq 'Ausgabe']">
        <xsl:element name="materialTechnikAusgabe">
            <xsl:value-of select="." />
        </xsl:element>
    </xsl:template>

    <!-- attributes in post position -->
    <xsl:template match="/mpx:museumPlusExport/mpx:sammlungsobjekt/mpx:titel">
        <xsl:element name="{name()}">
            <xsl:value-of select="." />
            <!-- @kommentar bislang nicht exportiert -->
            <xsl:if test="@art">
                <xsl:text> [</xsl:text>
                    <xsl:value-of select="@art" />
                <xsl:text>]</xsl:text>
            </xsl:if>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
