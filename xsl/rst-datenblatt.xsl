<xsl:stylesheet version="2.0"
    xmlns:lido="http://www.lido-schema.org"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:h="http://www.w3.org/1999/xhtml"
    xmlns:mpx="http://www.mpx.org/mpx" exclude-result-prefixes="lido xsi h">

    <xsl:output method="html" name="html" version="1.0"
        encoding="UTF-8" indent="yes" />
    <xsl:strip-space elements="*" />

    <!-- 
    @Expects mpx as input 
    @outputs RST Deckblatt as html 
    -->

    <xsl:template match="/">
        <html>
            <head>
                <meta charset="UTF-8" />
                <title>Datenblatt v0.3</title>
                <style>h2 {padding-top: 20px;}</style>
            </head>
            <body>
                <xsl:text>[* Inhalte in eckigen Klammern werden auf Datenblatt NICHT angezeigt.]</xsl:text>
                <xsl:apply-templates select="/mpx:museumPlusExport/mpx:sammlungsobjekt">
                    <xsl:sort select="@objId" data-type="number"/>
                </xsl:apply-templates>
            </body>
        </html>
    </xsl:template>


    <!-- DATENBLATT -->

    <xsl:template match="/mpx:museumPlusExport/mpx:sammlungsobjekt">
        <xsl:variable name="objId" select="@objId" />
        <xsl:variable name="stdbld" select="/mpx:museumPlusExport/mpx:multimediaobjekt[
            mpx:standardbild and mpx:verknüpftesObjekt eq $objId]" />
        <!-- xsl:message>
            STDBLD: <xsl:value-of select="$stdbld/@mulId"/>
        -->

        <!-- INTRO -->
        <xsl:element name="a">
            <xsl:attribute name="name">
                <xsl:value-of select="$objId" />
            </xsl:attribute>
        </xsl:element>
        <table border="0" width="800">
            <tr>
                <td colspan="2">
                    <xsl:call-template name="titleBar"/>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="right" valign="top">
                    <xsl:if test="$stdbld">
                        <xsl:element name="img">
                            <xsl:attribute name="style">width: 50%</xsl:attribute>
                            <xsl:attribute name="src">
                                <xsl:text>../../pix/</xsl:text>
                                <xsl:value-of select="$stdbld/@mulId" />
                                <xsl:text>.</xsl:text>
                                <xsl:value-of select="$stdbld/mpx:dateiname" />
                                <xsl:text>.</xsl:text>
                                <xsl:value-of select="lower-case($stdbld/mpx:erweiterung)" />
                            </xsl:attribute>
                        </xsl:element>
                        <br/>
                    </xsl:if>
                        <xsl:if test="$stdbld/mpx:urhebFotograf">
                            <xsl:text> Foto: </xsl:text>
                            <xsl:value-of select="$stdbld/mpx:urhebFotograf" />
                        </xsl:if>
                    <br/>
                </td>
            </tr>

            <!-- HERSTELLUNG implizit-->
            <!-- an Herstellung beteiligte PK -->
            <xsl:apply-templates select="mpx:personenKörperschaften[
                @funktion eq 'Hersteller' or 
                @funktion eq 'Maler' or
                @funktion eq 'Künstler']" />

            <xsl:if test="mpx:datierung">
                <tr>
                    <td width="20%">Datierung</td>
                    <td width="80%">
                        <xsl:for-each select="mpx:datierung[not (@art) or @art != 'Datierung engl.']">
                            <xsl:sort select="@sort" data-type="number"/>
                            <xsl:choose>
                                <xsl:when test="@vonJahr and @bisJahr">
                                    <xsl:value-of select="." />
                                    <xsl:text> (</xsl:text>
                                    <xsl:value-of select="@vonJahr" />
                                    <xsl:text> - </xsl:text>
                                    <xsl:value-of select="@bisJahr" />
                                    <xsl:text>)</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="." />
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="@art or @sort">
                                <xsl:text> [</xsl:text>
                                <xsl:if test="@art">
                                    <xsl:value-of select="@art" />
                                </xsl:if>
                                <xsl:if test="@art and @sort">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:if test="@sort">
                                    <xsl:text>s:</xsl:text>
                                    <xsl:value-of select="@sort" />
                                </xsl:if>
                                <xsl:text>]</xsl:text>
                            </xsl:if>
                            <xsl:if test="position()!=last()">
                                <xsl:text>; </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
            </xsl:if>

            <xsl:variable name="Ort" select="mpx:geogrBezug[@bezeichnung ne 'Kultur' 
                and @bezeichnung ne 'Ethnie' 
                and @bezeichnung ne 'Sprachgruppe'
                or not(@bezeichnung)]"/>
            <xsl:variable name="Gruppe" select="mpx:geogrBezug[@bezeichnung eq 'Kultur' 
                or @bezeichnung eq 'Ethnie'
                or @bezeichnung eq 'Sprachgruppe']"/>

            <xsl:if test="$Ort">
                <tr>
                    <td style="padding-top: 7px;" valign="top">
                        Geographischer Bezug
                    </td>
                    <td style="padding-top: 7px;" valign="top">
                        <!-- Soll: große Einheiten wie Kontinente oder Länder zu erst
                            if AKu: descending, default: ascending -->
                        <xsl:choose>
                            <xsl:when test="mpx:verwaltendeInstitution eq 
                                'Museum für Asiatische Kunst, Staatliche Museen zu Berlin'">
                                <xsl:apply-templates mode="GeoName" select="$Ort">
                                    <xsl:sort select="@sort" data-type="number" order="descending"/>
                                </xsl:apply-templates>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates mode="GeoName" select="$Ort">
                                     <xsl:sort select="@sort" data-type="number" order="ascending"/>
                                </xsl:apply-templates>
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>
            </xsl:if>

            <xsl:if test="$Gruppe">
                <tr>
                    <td valign="top">Gruppe/Kultur</td>
                    <td>
                        <xsl:apply-templates mode="Gruppe" select="$Gruppe">
                             <xsl:sort select="@sort" data-type="number"/>
                        </xsl:apply-templates>
                    </td>
                </tr>
            </xsl:if>

            <xsl:apply-templates select="mpx:materialTechnik[@art='Ausgabe']" />
            <xsl:apply-templates select="mpx:maßangaben" />
            <xsl:apply-templates select="mpx:onlineBeschreibung" />

            <!-- PROVENIENZ -->
            <tr>
                <td colspan="2">
                    <h2>Provenienz</h2>
                </td>
            </tr>
            <xsl:variable name="Vorbesitzer" select="mpx:personenKörperschaften[
                @funktion eq 'Sammler' or
                @funktion eq 'Vorbesitzer' or
                @funktion eq 'Veräußerer' or
                @funktion eq 'Vorbesitzer (historische Angabe)']
                |mpx:erwerbungVon[not (mpx:personenKörperschaften/@funktion eq 'Veräußerer')]"/>

            <xsl:if test="$Vorbesitzer">
                <tr>
                    <td valign="top">Vorbesitzer</td>
                    <td valign="top">
                        <xsl:for-each select="$Vorbesitzer">
                            <xsl:sort select="name()" order="descending"/>
                            <xsl:value-of select="."/>
                            <xsl:choose>
                                 <xsl:when test="@funktion or @art">
                                     <xsl:text> (</xsl:text>
                                     <xsl:value-of select="@funktion"/>
                                     <xsl:if test="@funktion and @art">
                                        <xsl:text>, </xsl:text>
                                     </xsl:if>
                                     <xsl:value-of select="@art"/>
                                     <xsl:text>)</xsl:text>
                                 </xsl:when>
                                 <xsl:otherwise> (erworben von)</xsl:otherwise>
                             </xsl:choose>
                             <xsl:if test="position() != last()">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
            </xsl:if>
            <xsl:apply-templates select="mpx:verwaltendeInstitution" />
            <xsl:apply-templates select="mpx:erwerbDatum" />
            <xsl:apply-templates select="mpx:erwerbungsart" />
            <xsl:apply-templates select="mpx:credits" />

            <xsl:apply-templates select="mpx:identNr[not(@art) or @art='Ident. Nr.']" />
            <xsl:if test="count (mpx:identNr) = 1">
                <xsl:apply-templates select="mpx:identNr[@art='Ident. Unternummer']" />
            </xsl:if>

            <xsl:if test="/mpx:museumPlusExport/mpx:multimediaobjekt[
                mpx:verknüpftesObjekt = $objId and 
                lower-case(mpx:veröffentlichen) = 'ja' and
                not(mpx:standardbild)]">
                <tr>
                    <td colspan="2">
                        <h2>Weitere Medien</h2>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <xsl:for-each select="/mpx:museumPlusExport/mpx:multimediaobjekt[
                                mpx:verknüpftesObjekt = $objId and 
                                lower-case(mpx:veröffentlichen) = 'ja' and
                                not(mpx:standardbild)]">
                            <xsl:variable name="pfad">
                                    <xsl:text>../../pix/</xsl:text>
                                    <xsl:value-of select="@mulId" />
                                    <xsl:text>.</xsl:text>
                                    <xsl:value-of select="mpx:dateiname" />
                                    <xsl:text>.</xsl:text>
                                    <xsl:value-of select="lower-case(mpx:erweiterung)" />
                            </xsl:variable>
                            <xsl:element name="img">
                                <xsl:attribute name="style">width: 25%</xsl:attribute>
                                <xsl:attribute name="src">
                                <xsl:value-of select="$pfad"/>
                                </xsl:attribute>
                            </xsl:element>
                            <xsl:text> </xsl:text>
                        </xsl:for-each>
                    </td>
                </tr>
            </xsl:if>
            <tr>
                <td colspan="2">
                    <h2>[Unsichtbares]</h2>
                </td>
            </tr>
            <xsl:if test="mpx:sachbegriff[@art = 'Weiterer Sachbegriff']">
                <tr>
                    <td width="140" valign="top">
                        <xsl:text>Weitere Sachbegriffe</xsl:text>
                    </td>
                    <td valign="top">
                        <xsl:for-each select="mpx:sachbegriff[@art = 'Weiterer Sachbegriff']">
                            <xsl:value-of select="."/>
                            <xsl:if test="position()!=last()">
                                <xsl:text>; </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
            </xsl:if>

            <xsl:if test="mpx:sachbegriff[@art = 'Sachbegriff engl.']">
                <tr>
                    <td valign="top">
                        <xsl:text>Englischer SB:</xsl:text>
                    </td>
                    <td valign="top">
                        <xsl:for-each select="mpx:sachbegriff[@art = 'Sachbegriff engl.']">
                            <xsl:value-of select="."/>
                            <xsl:if test="position()!=last()">
                                <xsl:text>; </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
            </xsl:if>
            <xsl:apply-templates select="mpx:sachbegriffHierarchisch" />
            <xsl:apply-templates select="mpx:systematikArt" />
            <xsl:apply-templates select="mpx:langeBeschreibung" />

            <xsl:if test="mpx:erwerbungVon">
                <tr>
                    <td valign="top">ErwerbungVon (nicht gezeigt, wenn PK Veräußerer hat)</td>
                    <td valign="top">
                        <xsl:value-of select="mpx:erwerbungVon"/>
                    </td>
                </tr>
            </xsl:if>
            <tr>
                <xsl:variable name="link">
                    <xsl:text>http://smb-digital.de/eMuseumPlus?service=ExternalInterface</xsl:text>
                    <xsl:text>&amp;module=collection&amp;objectId=</xsl:text>
                    <xsl:value-of select="$objId"/>
                    <xsl:text>&amp;viewType=detailView</xsl:text>
                </xsl:variable>
                <td>SMB Digital Link</td>
                <td>
                    <xsl:element name="a">
                    <xsl:attribute name="href"><xsl:value-of select="$link"/></xsl:attribute>
                        <xsl:value-of select="$link"/>
                    </xsl:element>
                </td>
            </tr>
            <xsl:apply-templates select="mpx:bearbStand" />
            <xsl:apply-templates select="mpx:ausstellung[starts-with(., 'HUFO')]" />
        </table>
        <br />
        <br />
    </xsl:template>

    <!-- Derzeit nur der erste Titel-->
    <xsl:template name="Titel">
        <!-- copy italics for einheimischen Bezeichnung here--> 
        <xsl:choose>
            <xsl:when test="@art eq 'Einheimische Bezeichnung (lokal)'">
                <i><xsl:value-of select="mpx:titel" /></i>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="mpx:titel" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="Sachbegriff">
        <!-- only one sachbegriff for AKu as default?-->
        <xsl:choose>
            <xsl:when test="mpx:verwaltendeInstitution eq 'Ethnologisches Museum, Staatliche Museen zu Berlin'">
                <xsl:call-template name="emSachbegriff"/>
            </xsl:when>
            <xsl:otherwise>
                <!-- [o:] -->
                <xsl:value-of select="mpx:sachbegriff[1]" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="emSachbegriff">
        <!-- emSachbegriff: -->
        <xsl:for-each select="mpx:sachbegriff[not(
            @art eq 'weiterer Sachbegriff' or 
            @art eq 'Weiterer Sachbegriff' or 
            @art eq 'Sachbegriff engl.' or 
            @art eq 'Alte Bezeichnung')]">
            <xsl:value-of select="."/>
            <xsl:if test="position() &lt; 2">
                <xsl:if test="position() &lt; 2 and position() &lt; last()">
                    <xsl:text>, </xsl:text>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!-- TODO: multiple titles and sachbegriffe -->
    <xsl:template name="titleBar">
        <xsl:choose>
            <xsl:when test="mpx:titel and mpx:sachbegriff">
                <h1><xsl:call-template name="Titel"/> [t]</h1>
                <h2><xsl:call-template name="Sachbegriff"/> [sb]</h2>
            </xsl:when>
            <xsl:when test="not(mpx:titel) and mpx:sachbegriff">
                <h1><xsl:call-template name="Sachbegriff"/> [sb]</h1>
            </xsl:when>
            <xsl:when test="mpx:titel and not(mpx:sachbegriff)">
                <h1><xsl:call-template name="Titel"/> [t]</h1>
            </xsl:when>
        </xsl:choose>

        <h3>
            <xsl:text> [objId </xsl:text>
            <xsl:value-of select="@objId" />
            <xsl:text>]</xsl:text>
        </h3>
    </xsl:template>

    <xsl:template match="mpx:langeBeschreibung">
        <tr>
            <td valign="top">Lange Beschreibung (wird nicht angezeigt)
                <xsl:value-of select="string-length(.)" /> Zeichen)
            </td>
            <td valign="top"><xsl:value-of select="." /></td>
        </tr>
    </xsl:template>
    
    <xsl:template mode="Gruppe" match="mpx:geogrBezug">
        <xsl:value-of select="." />
        <xsl:if test="@bezeichnung or @art or @sort or @kommentar">
           <xsl:text> [</xsl:text>
           <xsl:if test="@bezeichnung">
                <xsl:text>b: </xsl:text>
                <xsl:value-of select="@bezeichnung" />
                <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:if test="@art">
                <xsl:text>ot: </xsl:text>
                <xsl:value-of select="@art" />
                <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:if test="@kommentar">
                <xsl:text>k: </xsl:text>
                <xsl:value-of select="@kommentar" />
                <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:if test="@sort">
                <xsl:text>s: </xsl:text>
                <xsl:value-of select="@sort" />
            </xsl:if>
            <xsl:text>]</xsl:text>
        </xsl:if>
        <xsl:if test="position() != last()">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template mode="GeoName" match="mpx:geogrBezug">
        <xsl:value-of select="." />
        <!-- 
            I would prefer a list of items that are sorted out, and anyways to 
            have to name them only once 
        -->
        <xsl:if test="@bezeichnung or @art[
            . ne 'historische Bezeichnung' 
            and . ne 'Bezug' 
            and . ne 'Herkunft']">
            <xsl:text> (</xsl:text>
            <xsl:value-of select="@bezeichnung, @art[
                . ne 'historische Bezeichnung' 
                and . ne 'Bezug' 
                and . ne 'Herkunft']" separator=", " />
            <xsl:text>)</xsl:text>
        </xsl:if>

        <xsl:if test="@sort or @kommentar">
            <xsl:text> [</xsl:text>
            <xsl:if test="@sort">
                <xsl:text>s: </xsl:text>
                <xsl:value-of select="@sort" />
            </xsl:if>
            <xsl:if test="@sort and @kommentar">
                <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:if test="@kommentar">
                    <xsl:text>k: </xsl:text>
                    <xsl:value-of select="@kommentar" />
            </xsl:if>
            <xsl:text>]</xsl:text>
        </xsl:if>
        <br/>
    </xsl:template>
    <!-- INDIVIDUAL FIELDS -->

    <xsl:template match="mpx:ausstellung">
        <tr>
            <td>Ausstellung</td>
            <td>
                <xsl:value-of select="." />
            </td>
        </tr>
        <tr>
            <td>Sektion</td>
            <td>
                <xsl:value-of select="@sektion" />
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="mpx:bearbStand">
        <xsl:call-template name="genericRow">
            <xsl:with-param name="header">BearbStand</xsl:with-param>
            <xsl:with-param name="node"><xsl:value-of select="." /></xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="mpx:credits">
        <xsl:call-template name="genericRow">
            <xsl:with-param name="header">Credit</xsl:with-param>
            <xsl:with-param name="node"><xsl:value-of select="." /></xsl:with-param>
        </xsl:call-template>
    </xsl:template>


    <xsl:template match="mpx:erwerbDatum">
        <xsl:call-template name="genericRow">
            <xsl:with-param name="header">Eingangsdatum</xsl:with-param>
            <xsl:with-param name="node"><xsl:value-of select="." /></xsl:with-param>
        </xsl:call-template>
    </xsl:template>


    <xsl:template match="mpx:erwerbungsart">
        <tr>
            <td>Erwerbungsart</td>
            <td>
                <xsl:value-of select="." />
            </td>
        </tr>
    </xsl:template>


    <xsl:template match="mpx:identNr">
        <tr>
            <td>Inventarnummer</td>
            <td>
                <xsl:value-of select="." /> 
            </td>
        </tr>
    </xsl:template>


    <xsl:template match="mpx:materialTechnik">
        <tr>
            <td>Material/Technik</td>
            <td>
                <xsl:value-of select="." />
                <xsl:text> [Ausgabe]</xsl:text>
            </td>
        </tr>
    </xsl:template>


    <xsl:template match="mpx:maßangaben">
        <tr>
            <td>Maße</td>
            <td>
                <xsl:value-of select="." />
                <xsl:text> [</xsl:text>
                    <xsl:value-of select="@typ" />
                <xsl:text>]</xsl:text>
            </td>
        </tr>
    </xsl:template>


    <xsl:template match="mpx:onlineBeschreibung">
        <tr>
            <td valign="top">Beschreibung [online]
            (<xsl:value-of select="string-length(.)" /> Zeichen)
            </td>
            <td>
                <xsl:call-template name="replace">
                    <xsl:with-param name="string" select="."/>
                </xsl:call-template>
            </td>
        </tr>
    </xsl:template>


    <xsl:template name="replace">
        <xsl:param name="string"/>
        <xsl:choose>
            <xsl:when test="contains($string,'&#10;')">
                <xsl:value-of select="substring-before($string,'&#xA;')"/>
                <br/>
                <xsl:call-template name="replace">
                    <xsl:with-param name="string" select="substring-after($string,'&#xA;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$string"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="mpx:sachbegriffHierarchisch">
        <xsl:call-template name="genericRow">
            <xsl:with-param name="header">Sachbegriff hierarchisch</xsl:with-param>
            <xsl:with-param name="node"><xsl:value-of select="." /></xsl:with-param>
        </xsl:call-template>
    </xsl:template>


    <xsl:template match="mpx:sammlungsobjekt/mpx:personenKörperschaften[
        not(@funktion eq 'Veräußerer' or @funktion eq 'Sammler')]">
        <tr>
            <td>
                <xsl:value-of select="@funktion"/>
            </td>
            <td>
                <xsl:value-of select="." />
            </td>
        </tr>
    </xsl:template>


    <xsl:template match="mpx:sammlungsobjekt/mpx:personenKörperschaften[
        @funktion = 'Veräußerer' or @funktion = 'Sammler']">
        <tr>
            <td>
                <xsl:value-of select="@funktion"/>
                <xsl:text> [PK]</xsl:text>
            </td>
            <td>
                <xsl:value-of select="." />
            </td>
        </tr>
    </xsl:template>


    <xsl:template match="mpx:systematikArt">
        <xsl:call-template name="genericRow">
            <xsl:with-param name="header">SystematikArt</xsl:with-param>
            <xsl:with-param name="node"><xsl:value-of select="." /></xsl:with-param>
        </xsl:call-template>
    </xsl:template>


    <xsl:template match="mpx:verwaltendeInstitution">
        <xsl:call-template name="genericRow">
            <xsl:with-param name="header">Verwaltende Institution</xsl:with-param>
            <xsl:with-param name="node"><xsl:value-of select="." /></xsl:with-param>
        </xsl:call-template>
    </xsl:template>


    <!--  NAMED TEMPLATES -->

    <xsl:template name="genericRow">
        <xsl:param name="header" />
        <xsl:param name="node" />
        <tr>
            <td valign="top">
                <xsl:value-of select="$header"/>
            </td>
            <td valign="top">
                <xsl:value-of select="$node" />
            </td>
        </tr>
    </xsl:template>
</xsl:stylesheet>