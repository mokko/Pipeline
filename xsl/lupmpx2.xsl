<xsl:stylesheet version="2.0"
    xmlns="http://www.mpx.org/mpx"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mpx="http://www.mpx.org/mpx" exclude-result-prefixes="mpx"
    >
    <!-- doesnt work like this: xsi:schemaLocation="http://www.mpx.org/mpx ../../lib/mpx20.xsd" -->

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
    <xsl:strip-space elements="*" />

    <!-- 
    transforms dirty to clean mpx 
    mostly 
    (1) rewrites wiederholfelder so that the single record has multiple attributes
    (2) rewrites Qualifikators as attributes
    
    It also renames a few elements and sorts output right
    -->

    <xsl:template match="/">
            <museumPlusExport level="clean" version="2.0">
                <xsl:for-each-group select="/museumPlusExport/multimediaobjekt" group-by="@mulId">
                    <xsl:sort data-type="number" select="current-grouping-key()" />
                        <xsl:apply-templates select=".[@mulId = current-grouping-key()]" />
                </xsl:for-each-group>
    
                <xsl:for-each-group select="/museumPlusExport/personenKörperschaften" group-by="@kueId">
                    <xsl:sort data-type="number" select="current-grouping-key()" />
                        <xsl:apply-templates select=".[@kueId = current-grouping-key()]" />
                </xsl:for-each-group>
    
                <xsl:for-each-group select="/museumPlusExport/sammlungsobjekt" group-by="@objId">
                    <xsl:sort data-type="number" select="current-grouping-key()" />
                        <xsl:apply-templates select=".[@objId = current-grouping-key()]" />
                </xsl:for-each-group>
            </museumPlusExport>
     </xsl:template>


    <xsl:template name="wAttrib">
        <xsl:param name="attrib" />
        <xsl:param name="attrib2" />
        <xsl:variable name="short" select="lower-case(substring-after(name($attrib),name()))"/>
        <xsl:variable name="short2" select="lower-case(substring-after(name($attrib2),name()))"/>
        <xsl:element name="{name()}">
            <xsl:if test="$attrib">
                <xsl:attribute name="{$short}">
                    <xsl:value-of select="$attrib" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$attrib2">
                <xsl:attribute name="{$short2}">
                    <xsl:value-of select="$attrib2" />
                </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="." />
        </xsl:element>
    </xsl:template>


    <!-- triple default: for elements whose name I don't know yet -->
    <xsl:template match="/museumPlusExport/*/*" priority="1">
        <xsl:element name="{name()}">
            <xsl:value-of select="." />
        </xsl:element>
    </xsl:template>

    <!-- MM -->
    <xsl:template match="/museumPlusExport/multimediaobjekt">
        <xsl:variable name="mulId" select="@mulId"/>
        <xsl:element name="{name()}">
            <xsl:attribute name="mulId">
                <xsl:value-of select="$mulId"/>
            </xsl:attribute>
            <xsl:attribute name="exportdatum">
                <xsl:value-of select="@exportdatum"/>
            </xsl:attribute>

            <xsl:message>
                <xsl:text>lvlup-mulId: </xsl:text>
                <xsl:value-of select="$mulId"/>
            </xsl:message>
            <xsl:for-each-group select="/museumPlusExport/multimediaobjekt[@mulId eq $mulId]/*" group-by="string()">
                <xsl:sort select="name()" />
                <!--xsl:message>
                    <xsl:text>   </xsl:text>
                    <xsl:value-of select="name()"/>
                </xsl:message-->
                <xsl:if test="name() ne 'objId'">
                    <xsl:apply-templates select="."/>
                </xsl:if>
            </xsl:for-each-group>
            <!-- UrhebFotograf fehlte Warum? jetzt in falscher Reihenfolge --> 
            <xsl:apply-templates select="/museumPlusExport/multimediaobjekt[@mulId eq $mulId]/urhebFotograf"/>
            <!-- verknüpftesObjekt: jetzt in falscher Reihenfolge alphabetisch! -->
            <xsl:apply-templates select="/museumPlusExport/multimediaobjekt[@mulId eq $mulId]/objId"/>
        </xsl:element>
    </xsl:template>

    <!-- delete duplicate; can also be eliminated from RST Liste -->
    <xsl:template match="/museumPlusExport/multimediaobjekt/personenKörperschaften" priority="10"/>

    <!-- only include element standardbild if this mume is standardbild-->
    <xsl:template match="/museumPlusExport/multimediaobjekt/standardbild">
            <xsl:if test=". eq ../@mulId">
                <!--xsl:message>
                    <xsl:text>STANDARDBILD: </xsl:text>
                    <xsl:value-of select="../@mulId" />
                </xsl:message-->
                <xsl:element name="{name()}">
                    <xsl:value-of select="." />
                </xsl:element>
            </xsl:if>
    </xsl:template>

    <!-- rename tag: better rename in rst to avoid sorting mess-->
    <xsl:template match="/museumPlusExport/multimediaobjekt/objId" priority="10">
        <xsl:element name="verknüpftesObjekt">
            <xsl:value-of select="." />
        </xsl:element>
    </xsl:template>

    <!-- PK -->
    <xsl:template match="/museumPlusExport/personKörperschaft">
        <xsl:variable name="id" select="@kueId"/>
        <xsl:element name="{name()}">
            <xsl:attribute name="kueId"><xsl:value-of select="$id"/></xsl:attribute>
            <xsl:attribute name="exportdatum"><xsl:value-of select="@exportdatum"/></xsl:attribute>

            <xsl:message>
                <xsl:text>lvlup-kueId: </xsl:text>
                <xsl:value-of select="$id"/>
            </xsl:message>
            <xsl:for-each-group select="/museumPlusExport/personKörperschaft[@kueId eq $id]/*" group-by="string()">
                <xsl:sort data-type="text" select="name()" />
                <xsl:apply-templates select="."/>
            </xsl:for-each-group>
        </xsl:element>
    </xsl:template>


    <xsl:template match="/museumPlusExport/personKörperschaft/datierung" priority="10">
        <xsl:call-template name="wAttrib">
            <xsl:with-param name="attrib" select="../datierungArt" />
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="/museumPlusExport/personKörperschaft/datierungArt" priority="10"/>


    <xsl:template match="/museumPlusExport/personKörperschaft/geoBezug" priority="10">
        <xsl:call-template name="wAttrib">
            <xsl:with-param name="attrib" select="../geoBezugBezeichnung" />
            <xsl:with-param name="attrib2" select="../geoBezugArt" />
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="/museumPlusExport/personKörperschaft/geoBezugBezeichnung" priority="10"/>
    <xsl:template match="/museumPlusExport/personKörperschaft/geoBezugArt" priority="10"/>


    <xsl:template match="/museumPlusExport/personKörperschaft/name" priority="10">
        <xsl:call-template name="wAttrib">
            <xsl:with-param name="attrib" select="../nameArt" />
            <xsl:with-param name="attrib2" select="../nameBemerkung" />
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="/museumPlusExport/personKörperschaft/nameArt" priority="10"/>
    <xsl:template match="/museumPlusExport/personKörperschaft/nameBemerkung" priority="10"/>


    <xsl:template match="/museumPlusExport/personKörperschaft/nennform" priority="10">
        <xsl:call-template name="wAttrib">
            <xsl:with-param name="attrib" select="../nennformArt" />
            <xsl:with-param name="attrib2" select="../nennformBemerkung" />
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="/museumPlusExport/personKörperschaft/nennformArt" priority="10"/>
    <xsl:template match="/museumPlusExport/personKörperschaft/nennformBemerkung" priority="10"/>


    <!-- SO -->
    <xsl:template match="/museumPlusExport/sammlungsobjekt">
        <xsl:variable name="id" select="@objId"/>
        <xsl:element name="{name()}">
            <xsl:attribute name="objId"><xsl:value-of select="$id"/></xsl:attribute>
            <xsl:attribute name="exportdatum"><xsl:value-of select="@exportdatum"/></xsl:attribute>

            <xsl:message>
                <xsl:text>lvlup-objId: </xsl:text>
                <xsl:value-of select="$id"/>
            </xsl:message>
            <xsl:for-each-group select="/museumPlusExport/sammlungsobjekt[@objId eq $id]/*" group-by="string()">
                <xsl:sort select="name()" />
                <xsl:apply-templates select="."/>
            </xsl:for-each-group>
        </xsl:element>
    </xsl:template>


    <xsl:template match="/museumPlusExport/sammlungsobjekt/ausstellungTitel" priority="10">
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
    <xsl:template match="/museumPlusExport/sammlungsobjekt/ausstellungInternExtern" priority="10"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/ausstellungKatalogNr" priority="10"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/ausstellungDatumBis" priority="10"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/ausstellungDatumVon" priority="10"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/ausstellungJahr" priority="10"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/ausstellungOrt" priority="10"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/ausstellungEntscheid" priority="10"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/ausstellungSektion" priority="10"/>
    
    <!-- rewrite Qualifikator as attribute-->
    <xsl:template match="/museumPlusExport/sammlungsobjekt/andereNr" priority="10">
        <xsl:call-template name="wAttrib">
            <xsl:with-param name="attrib" select="../andereNrArt" />
            <xsl:with-param name="attrib2" select="../andereNrBemerkung" />
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/andereNrArt" priority="10"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/andereNrBemerkung" priority="10"/>


    <xsl:template match="/museumPlusExport/sammlungsobjekt/datierung" priority="10">
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
                |/museumPlusExport/sammlungsobjekt/datierungJahrBis
    " priority="10"/>
    
    
    <xsl:template match="/museumPlusExport/sammlungsobjekt/erwerbNotiz" priority="10">
        <xsl:call-template name="wAttrib">
            <xsl:with-param name="attrib" select="../erwerbNotizTyp" />
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/erwerbNotizTyp" priority="10"/>


    <xsl:template match="/museumPlusExport/sammlungsobjekt/geogrBezug" priority="10">
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
    <xsl:template match="/museumPlusExport/sammlungsobjekt/geogrBezugArt" priority="10"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/geogrBezugKommentar" priority="10"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/geogrBezugBezeichnung" priority="10"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/geogrBezugSort" priority="10"/>
    

    <xsl:template match="/museumPlusExport/sammlungsobjekt/identNr" priority="10">
        <xsl:call-template name="wAttrib">
            <xsl:with-param name="attrib" select="../identNrArt" />
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/identNrArt" priority="10"/>


    <xsl:template match="/museumPlusExport/sammlungsobjekt/maßangaben" priority="10">
        <xsl:call-template name="wAttrib">
            <xsl:with-param name="attrib" select="../maßangabenTyp" />
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/maßangabenTyp" priority="10"/>

    
    <xsl:template match="/museumPlusExport/sammlungsobjekt/materialTechnik" priority="10">
        <xsl:call-template name="wAttrib">
            <xsl:with-param name="attrib" select="../materialTechnikArt" />
            <xsl:with-param name="attrib2" select="../materialTechnikBesonderheit" />
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/materialTechnikBesonderheit" priority="10"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/materialTechnikArt" priority="10"/>


    <xsl:template match="/museumPlusExport/sammlungsobjekt/objBezIdentNr" priority="10">
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
    <xsl:template match="/museumPlusExport/sammlungsobjekt/objBezSachbegriff" priority="10"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/objBezBemerkung" priority="10"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/objBezArt" priority="10"/>


    <!-- irregular names? personKörperschaft oder personenKörperschaft -->
    <xsl:template match="/museumPlusExport/sammlungsobjekt/personenKörperschaften" priority="10">
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
    <xsl:template match="/museumPlusExport/sammlungsobjekt/personenKörperschaftenFunktion" priority="10"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/personenKörperschaftenArtDesBe" priority="10"/>


    <xsl:template match="/museumPlusExport/sammlungsobjekt/sachbegriff" priority="10">
        <xsl:call-template name="wAttrib">
            <xsl:with-param name="attrib" select="../sachbegriffArt" />
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/sachbegriffArt" priority="10"/>


    <xsl:template match="/museumPlusExport/sammlungsobjekt/standort" priority="10">
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
    <xsl:template match="/museumPlusExport/sammlungsobjekt/standortStatus" priority="10"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/standortArt" priority="10"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/standortDetail" priority="10"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/standortDatumVon" priority="10"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/standortDatumBis" priority="10"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/standortKommentar" priority="10"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/standortBearbMit" priority="10"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/standortBearbDat" priority="10"/>


    <xsl:template match="/museumPlusExport/sammlungsobjekt/swd" priority="10">
        <xsl:call-template name="wAttrib">
            <xsl:with-param name="attrib" select="../swdArt" />
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/swdArt" priority="10"/>


    <xsl:template match="/museumPlusExport/sammlungsobjekt/titel" priority="10">
        <xsl:call-template name="wAttrib">
            <xsl:with-param name="attrib" select="../titelArt" />
            <xsl:with-param name="attrib2" select="../titelBemerkung" />
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/titelArt" priority="10"/>
    <xsl:template match="/museumPlusExport/sammlungsobjekt/titelBemerkung" priority="10"/>
</xsl:stylesheet>