<xsl:stylesheet version="2.0"
    xmlns="http://www.mpx.org/mpx"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mpx="http://www.mpx.org/mpx" exclude-result-prefixes="mpx">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
    <xsl:strip-space elements="*" />


    <xsl:template match="/museumPlusExport/sammlungsobjekt">
        <xsl:variable name="id" select="@objId"/>
        <xsl:element name="{name()}">
            <xsl:attribute name="objId"><xsl:value-of select="$id"/></xsl:attribute>
            <xsl:attribute name="exportdatum"><xsl:value-of select="@exportdatum"/></xsl:attribute>

            <xsl:message>
                <xsl:text>lvlup-objId: </xsl:text>
                <xsl:value-of select="$id"/>
            </xsl:message>
            <!-- 
                sachbegriff bug: this one finds most, but not all sachbegriffe
                WHY? https://stackoverflow.com/questions/64335452/ 
            -->
            <xsl:for-each-group select="/museumPlusExport/sammlungsobjekt[@objId eq $id]/*" group-by="concat(name(), '|', string())">
                <xsl:sort select="name()" />
                <xsl:variable name="name" select="name()"/>
                <xsl:apply-templates select="."/>
            </xsl:for-each-group>
        </xsl:element>
    </xsl:template>


    <xsl:template match="/museumPlusExport/sammlungsobjekt/ausstellungTitel">
        <xsl:element name="ausstellung">
            <xsl:if test="../ausstellungSektion">
                <xsl:attribute name="sektion">
                        <xsl:value-of select="../ausstellungSektion" />
                </xsl:attribute>
            </xsl:if>

            <xsl:if test="../ausstellungEntscheid">
                <xsl:attribute name="entscheid">
                        <xsl:value-of select="../ausstellungEntscheid" />
                </xsl:attribute>
            </xsl:if>

            <xsl:if test="../ausstellungOrt">
                <xsl:attribute name="ort">
                        <xsl:value-of select="../ausstellungOrt" />
                </xsl:attribute>
            </xsl:if>

            <xsl:if test="../ausstellungJahr">
                <!-- should be lower-case: jahr -->
                <xsl:attribute name="jahr">
                        <xsl:value-of select="../ausstellungJahr" />
                </xsl:attribute>
            </xsl:if>

            <xsl:if test="../ausstellungDatumVon">
                <xsl:attribute name="datumVon">
                        <xsl:value-of select="../ausstellungDatumVon" />
                </xsl:attribute>
            </xsl:if>

            <xsl:if test="../ausstellungDatumBis">
                <xsl:attribute name="datumBis">
                        <xsl:value-of select="../ausstellungDatumBis" />
                </xsl:attribute>
            </xsl:if>

            <xsl:if test="../ausstellungKatalogNr">
                <xsl:attribute name="katalogNr">
                        <xsl:value-of select="../ausstellungKatalogNr" />
                </xsl:attribute>
            </xsl:if>

            <xsl:if test="../ausstellungInternExtern">
                <xsl:attribute name="internExtern">
                        <xsl:value-of select="../ausstellungInternExtern" />
                </xsl:attribute>
            </xsl:if>

            <xsl:value-of select="." />
        </xsl:element>
    </xsl:template>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/ausstellungInternExtern"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/ausstellungKatalogNr"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/ausstellungDatumBis"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/ausstellungDatumVon"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/ausstellungJahr"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/ausstellungOrt"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/ausstellungEntscheid"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/ausstellungSektion"/>
    

    <!-- rewrite Qualifikator as attribute-->
    <xsl:template match="/museumPlusExport/sammlungsobjekt/andereNr">
        <xsl:call-template name="wAttrib">
            <xsl:with-param name="attrib" select="../andereNrArt" />
            <xsl:with-param name="attrib2" select="../andereNrBemerkung" />
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/andereNrArt"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/andereNrBemerkung"/>


    <xsl:template match="/museumPlusExport/sammlungsobjekt/datierung">
        <xsl:element name="{name()}">
            <xsl:if test="../datierungArt">
                <xsl:attribute name="art">
                    <xsl:value-of select="../datierungArt" />
                </xsl:attribute>
            </xsl:if>

            <xsl:if test="../datierungBemerkung">
                <xsl:attribute name="bemerkung">
                    <xsl:value-of select="../datierungBemerkung" />
                </xsl:attribute>
            </xsl:if>

            <xsl:if test="../datierungJahrBis">
                <xsl:attribute name="bisJahr">
                    <xsl:value-of select="../datierungJahrBis" />
                </xsl:attribute>
            </xsl:if>

            <xsl:if    test="../datierungBisMonat|../datierungMonatBis">
                <xsl:attribute name="bisMonat">
                    <xsl:value-of select="../datierungBisMonat|../datierungMonatBis" />
                </xsl:attribute>
            </xsl:if>

            <xsl:if test="../datierungBisTag|../datierungTagBis">
                <xsl:attribute name="bisTag">
                    <xsl:value-of select="../datierungBisTag|../datierungTagBis" />
                </xsl:attribute>
            </xsl:if>

            <xsl:if test="../datierungVonJahr|../datierungJahrVon">
                <xsl:attribute name="vonJahr">
                    <xsl:value-of select="../datierungVonJahr|../datierungJahrVon" />
                </xsl:attribute>
            </xsl:if>

            <xsl:if test="../datierungVonMonat|../datierungMonatVon">
                <xsl:attribute name="vonMonat">
                    <xsl:value-of select="../datierungVonMonat|../datierungMonatVon" />
                </xsl:attribute>
            </xsl:if>

            <xsl:if test="../datierungVonTag|../datierungTagVon">
                <xsl:attribute name="vonTag">
                    <xsl:value-of select="../datierungVonTag|../datierungTagVon" />
                </xsl:attribute>
            </xsl:if>

            <xsl:if test="../datierungSort">
                <xsl:attribute name="sort">
                    <xsl:value-of select="../datierungSort" />
                </xsl:attribute>
            </xsl:if>

            <xsl:value-of select="." />
        </xsl:element>
    </xsl:template>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/datierungBemerkung
                |/museumPlusExport/sammlungsobjekt/datierungArt
                |/museumPlusExport/sammlungsobjekt/datierungSort
                |/museumPlusExport/sammlungsobjekt/datierungVonTag
                |/museumPlusExport/sammlungsobjekt/datierungTagVon
                |/museumPlusExport/sammlungsobjekt/datierungVonMonat
                |/museumPlusExport/sammlungsobjekt/datierungMonatVon
                |/museumPlusExport/sammlungsobjekt/datierungVonJahr
                |/museumPlusExport/sammlungsobjekt/datierungJahrVon
                |/museumPlusExport/sammlungsobjekt/datierungBisTag
                |/museumPlusExport/sammlungsobjekt/datierungTagBis
                |/museumPlusExport/sammlungsobjekt/datierungBisMonat
                |/museumPlusExport/sammlungsobjekt/datierungMonatBis
                |/museumPlusExport/sammlungsobjekt/datierungJahrBis"/>


    <xsl:template match="/museumPlusExport/sammlungsobjekt/erwerbNotiz">
        <xsl:call-template name="wAttrib">
            <xsl:with-param name="attrib" select="../erwerbNotizTyp" />
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/erwerbNotizTyp"/>


    <xsl:template match="/museumPlusExport/sammlungsobjekt/geogrBezug">
        <xsl:element name="{name()}">
            <xsl:if test="../geogrBezugBezeichnung">
                <xsl:attribute name="bezeichnung">
                    <xsl:value-of select="../geogrBezugBezeichnung" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="../geogrBezugArt">
                <xsl:attribute name="art">
                    <xsl:value-of select="../geogrBezugArt" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="../geogrBezugKommentar">
                <xsl:attribute name="kommentar">
                    <xsl:value-of select="../geogrBezugKommentar" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="../geogrBezugSort">
                <xsl:attribute name="sort">
                    <xsl:value-of select="../geogrBezugSort" />
                </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="." />
        </xsl:element>
    </xsl:template>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/geogrBezugArt"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/geogrBezugKommentar"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/geogrBezugBezeichnung"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/geogrBezugSort"/>


    <xsl:template match="/museumPlusExport/sammlungsobjekt/identNr">
        <xsl:call-template name="wAttrib">
            <xsl:with-param name="attrib" select="../identNrArt" />
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/identNrArt"/>


    <xsl:template match="/museumPlusExport/sammlungsobjekt/maßangaben">
        <xsl:call-template name="wAttrib">
            <xsl:with-param name="attrib" select="../maßangabenTyp" />
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/maßangabenTyp"/>

    
    <xsl:template match="/museumPlusExport/sammlungsobjekt/materialTechnik">
        <xsl:call-template name="wAttrib">
            <xsl:with-param name="attrib" select="../materialTechnikArt" />
            <xsl:with-param name="attrib2" select="../materialTechnikBesonderheit" />
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/materialTechnikBesonderheit"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/materialTechnikArt"/>


    <!-- this is a rename, avoid them in rst to avoid sorting later! -->
    <xsl:template match="/museumPlusExport/sammlungsobjekt/objBezIdentNr">
        <xsl:element name="oov">
            <xsl:if test="../objBezArt">
                <xsl:attribute name="art">
                    <xsl:value-of select="../objBezArt" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="../objBezBemerkung">
                <xsl:attribute name="bemerkung">
                    <xsl:value-of select="../objBezBemerkung" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="../objBezSachbegriff">
                <xsl:attribute name="sachbegriff">
                    <xsl:value-of select="../objBezSachbegriff" />
                </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="." />
        </xsl:element>
    </xsl:template>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/objBezSachbegriff"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/objBezBemerkung"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/objBezArt"/>


    <!-- irregular names? personKörperschaft oder personenKörperschaft -->
    <xsl:template match="/museumPlusExport/sammlungsobjekt/personenKörperschaften">
        <xsl:element name="{name()}">
            <xsl:if test="../personenKörperschaftenArtDesBe">
                <xsl:attribute name="art">
                    <xsl:value-of select="../personenKörperschaftenArtDesBe" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="../personenKörperschaftenFunktion">
                <xsl:attribute name="funktion">
                    <xsl:value-of select="../personenKörperschaftenFunktion" />
                </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="." />
        </xsl:element>
    </xsl:template>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/personenKörperschaftenFunktion"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/personenKörperschaftenArtDesBe"/>


    <!-- sachbegriff bug: on a few records this doesn't get called -->
    <xsl:template match="/museumPlusExport/sammlungsobjekt/sachbegriff">
        <xsl:if test="../@objId eq '141628'"> 
            <xsl:message>---------------------NEVER GET HERE
            <xsl:text>Sachbegriff: </xsl:text>
                <xsl:value-of select="../@objId"/>
            </xsl:message>
        </xsl:if>
        <xsl:call-template name="wAttrib">
            <xsl:with-param name="attrib" select="../sachbegriffArt" />
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/sachbegriffArt"/>


    <xsl:template match="/museumPlusExport/sammlungsobjekt/standort">
        <xsl:element name="{name()}">
            <xsl:if test="../standortStatus">
                <xsl:attribute name="status">
                    <xsl:value-of select="../standortStatus" />
                </xsl:attribute>
            </xsl:if>

            <xsl:if test="../standortArt">
                <xsl:attribute name="art">
                    <xsl:value-of select="../standortArt" />
                </xsl:attribute>
            </xsl:if>

            <xsl:if test="../standortDetail">
                <xsl:attribute name="detail">
                    <xsl:value-of select="../standortDetail" />
                </xsl:attribute>
            </xsl:if>

            <xsl:if test="../standortDatumVon">
                <xsl:attribute name="datumVon">
                    <xsl:value-of select="../standortDatumVon" />
                </xsl:attribute>
            </xsl:if>

            <xsl:if test="../standortDatumBis">
                <xsl:attribute name="datumBis">
                    <xsl:value-of select="../standortDatumBis" />
                </xsl:attribute>
            </xsl:if>
            
            <xsl:if test="../standortKommentar">
                <xsl:attribute name="kommentar">
                    <xsl:value-of select="../standortKommentar" />
                </xsl:attribute>
            </xsl:if>

            <xsl:if test="../standortBearbMit">
                <xsl:attribute name="bearbMit">
                    <xsl:value-of select="../standortBearbMit" />
                </xsl:attribute>
            </xsl:if>

            <xsl:if test="../standortBearbDat">
                <xsl:attribute name="bearbDat">
                    <xsl:value-of select="../standortBearbDat" />
                </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="." />
        </xsl:element>
    </xsl:template>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/standortStatus"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/standortArt"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/standortDetail"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/standortDatumVon"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/standortDatumBis"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/standortKommentar"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/standortBearbMit"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/standortBearbDat"/>


    <xsl:template match="/museumPlusExport/sammlungsobjekt/swd">
        <xsl:call-template name="wAttrib">
            <xsl:with-param name="attrib" select="../swdArt" />
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/swdArt"/>


    <xsl:template match="/museumPlusExport/sammlungsobjekt/titel">
        <xsl:call-template name="wAttrib">
            <xsl:with-param name="attrib" select="../titelArt" />
            <xsl:with-param name="attrib2" select="../titelBemerkung" />
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/titelArt"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/titelBemerkung"/>
</xsl:stylesheet>