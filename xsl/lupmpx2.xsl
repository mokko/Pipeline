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


	<!-- triple default -->	
	<xsl:template match="/museumPlusExport/*/*">
		<xsl:element name="{name()}">
			<xsl:value-of select="." />
		</xsl:element>
	</xsl:template>


	<xsl:template match="/">
		<museumPlusExport level="clean" version="2.0">
            <xsl:for-each-group select="/museumPlusExport/ausstellung" group-by="@ausId">
				<xsl:sort data-type="number" select="current-grouping-key()" />
					<xsl:apply-templates select=".[@ausId = current-grouping-key()]" />
			</xsl:for-each-group>

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

	<!-- Ausstellungen als separate Entität: dazu muss Ausstellung exportiert werden; alternativ 
    kann man auch die Eigenschaft als ausgestellt worden sein auch exportieren mit RST SO7 -->


	<xsl:template match="/museumPlusExport/ausstellung">
		<xsl:variable name="ausId" select="@ausId"/>
		<xsl:element name="{name()}">
			<xsl:attribute name="ausId"><xsl:value-of select="$ausId"/></xsl:attribute>
			<xsl:attribute name="exportdatum"><xsl:value-of select="@exportdatum"/></xsl:attribute>

			<xsl:message>
                <xsl:text>lvlup-auss: </xsl:text>
				<xsl:value-of select="$ausId"/>
			</xsl:message>
			<xsl:for-each-group select="/museumPlusExport/ausstellung[@ausId eq $ausId]/*" group-by="string()">
				<xsl:sort data-type="text" select="name()" />
				<xsl:apply-templates select="."/>
			</xsl:for-each-group>
		</xsl:element>
	</xsl:template>


	<xsl:template match="/museumPlusExport/ausstellung/objId">
		<xsl:element name="objekt">
			<xsl:if test="../objektIdentNr">
				<xsl:attribute name="identNr">
					<xsl:value-of select="../objektIdentNr" />
				</xsl:attribute>
			</xsl:if>

			<xsl:if test="../sektion">
				<xsl:attribute name="sektion">
					<xsl:value-of select="../sektion" />
				</xsl:attribute>
			</xsl:if>

			<xsl:if test="../entscheid">
				<xsl:attribute name="entscheid">
					<xsl:value-of select="../entscheid" />
				</xsl:attribute>
			</xsl:if>

			<xsl:if test="../katNr">
				<xsl:attribute name="katNr">
					<xsl:value-of select="../katNr" />
				</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="." />
		</xsl:element>
	</xsl:template>
	<xsl:template match="/museumPlusExport/ausstellung/objektIdentNr"/>
	<xsl:template match="/museumPlusExport/ausstellung/sektion"/>
	<xsl:template match="/museumPlusExport/ausstellung/entscheid"/>
	<xsl:template match="/museumPlusExport/ausstellung/katNr"/>

    
	<!-- MM -->


	<xsl:template match="/museumPlusExport/multimediaobjekt">
		<xsl:variable name="mulId" select="@mulId"/>
		<xsl:element name="{name()}">
			<xsl:attribute name="mulId"><xsl:value-of select="$mulId"/></xsl:attribute>
			<xsl:attribute name="exportdatum"><xsl:value-of select="@exportdatum"/></xsl:attribute>

			<xsl:message>
				<xsl:text>lvlup-mulId: </xsl:text>
				<xsl:value-of select="$mulId"/>
			</xsl:message>
			<xsl:for-each-group select="/museumPlusExport/multimediaobjekt[@mulId eq $mulId]/*" group-by="string()">
				<xsl:sort data-type="text" lang="de" select="name()" />
				<!--xsl:message>
					<xsl:text>   </xsl:text>
					<xsl:value-of select="name()"/>
				</xsl:message-->
				<xsl:if test="name() ne 'objId'">
					<xsl:apply-templates select="."/>
				</xsl:if>
			</xsl:for-each-group>
			<!-- UrhebFotograf fehlte Warum? -->
			<xsl:apply-templates select="/museumPlusExport/multimediaobjekt[@mulId eq $mulId]/urhebFotograf"/>
			<!-- verknüpftesObjekt: jetzt alphabetisch! -->
			<xsl:apply-templates select="/museumPlusExport/multimediaobjekt[@mulId eq $mulId]/objId"/>
		</xsl:element>
	</xsl:template>

	<!-- delete duplicate; can also be eliminated from RST Liste -->
	<xsl:template match="/museumPlusExport/multimediaobjekt/personenKörperschaften"/>

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

    <!-- rename tag-->
	<xsl:template match="/museumPlusExport/multimediaobjekt/objId">
		<xsl:element name="verknüpftesObjekt">
			<xsl:value-of select="." />
		</xsl:element>
	</xsl:template>

	<!-- why would that be necessary? but it is apparently -->
	<xsl:template match="/museumPlusExport/multimediaobjekt/urheberFotograf">
		<xsl:element name="urheberFotograf">
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
				<xsl:sort data-type="text"
					select="name()" />
				<xsl:apply-templates select="."/>
			</xsl:for-each-group>
		</xsl:element>
	</xsl:template>


	<xsl:template match="/museumPlusExport/personKörperschaft/datierung">
		<xsl:call-template name="wAttrib">
			<xsl:with-param name="attrib" select="../datierungArt" />
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="/museumPlusExport/personKörperschaft/datierungArt"/>


	<xsl:template match="/museumPlusExport/personKörperschaft/geoBezug">
		<xsl:call-template name="wAttrib">
			<xsl:with-param name="attrib" select="../geoBezugBezeichnung" />
			<xsl:with-param name="attrib2" select="../geoBezugArt" />
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="/museumPlusExport/personKörperschaft/geoBezugBezeichnung"/>
	<xsl:template match="/museumPlusExport/personKörperschaft/geoBezugArt"/>


	<xsl:template match="/museumPlusExport/personKörperschaft/name">
		<xsl:call-template name="wAttrib">
			<xsl:with-param name="attrib" select="../nameArt" />
			<xsl:with-param name="attrib2" select="../nameBemerkung" />
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="/museumPlusExport/personKörperschaft/nameArt"/>
	<xsl:template match="/museumPlusExport/personKörperschaft/nameBemerkung"/>


	<xsl:template match="/museumPlusExport/personKörperschaft/nennform">
		<xsl:call-template name="wAttrib">
			<xsl:with-param name="attrib" select="../nennformArt" />
			<xsl:with-param name="attrib2" select="../nennformBemerkung" />
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="/museumPlusExport/personKörperschaft/nennformArt"/>
	<xsl:template match="/museumPlusExport/personKörperschaft/nennformBemerkung"/>


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
				<xsl:sort data-type="text"
					select="name()" />
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

			<xsl:if	test="../datierungBisMonat|../datierungMonatBis">
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
	"/>
	
	
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


	<xsl:template match="/museumPlusExport/sammlungsobjekt/sachbegriff">
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