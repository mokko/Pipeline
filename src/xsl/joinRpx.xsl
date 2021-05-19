<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- 
	
		rpx stands for "MPX for RIA" which is my xml export from new version 
		of MuseumPlus.
		It's built with these principles in mind: 
		- the least changes to Zetcom's inbuilt xml export, i.e. we leave 
		  Objects and ObjectList in English and capitalization as provided by 
		  Zetcom 
		- basis for element tags are the screen labels
		- alphabetical order where possible
		- no xml arguments (with a few exceptions, only id)
		- no sonderzeichen: Zetcom doesn't allow sonderzeichen in element names, so 
  		  "masse" instead of "maße"
		- i use small camel capitalization for elements, leaving out spaces, 
		  periods etc.

	TODO:
		- Add objId to 3.2 Export
		- change "gruppen" to "gruppe" in gruppenList/gruppe[n]/letzteAenderung
		- dont export letzteAenderungVon, replace with letzteAenderung
	    - what to do with empty <materialTechnik> tags? just leave them?
	    - nationalität->nationalitaet
	    - erwerbungsjahr/datum
	    - erwerbungsart
	    - erwerbungVon

	STRATEGY	    
	As before, we want to ONE xml export to rule them all, so all fields can be 
	exported UNFILTERED. We filter elements, records and values later. 
	
	FILTER
	-what should we filter? certain fields
	-HF Ausstellung
	
	Which fields should I add next? What is priority? 
	-sachbegriff cluster
	-titel Cluster

	QUESTIONS	
	Should we fix Bereich? "EMSudundSudostasien"-> "EM-Süd- und Südostasien"?
	- not a priority, so no!
	
	PROBLEMS IN ZETCOM EXPORT
	- Sektion und Ausstellung sind nicht verbunden
	- XML Export exports only one data source, although several can be specified. 
	  (check again when id is included)
	
	-->

	<xsl:output method="xml" version="1.0" encoding="UTF-8"
		indent="yes" />
	<xsl:strip-space elements="*" />

	<!-- expects *.xml files directly fromRIA -->
	<xsl:variable name="collection" select="collection('.?select=*.xml')"/>

	<xsl:template match="/">
		<ObjectList>
			<xsl:for-each-group select="$collection/ObjectList/Object" group-by="id">
				<xsl:sort select="id" data-type="number" />
				<xsl:variable name="id" select="id"/>
				<xsl:message>
					<xsl:value-of select="$id"/>
				</xsl:message>
				<xsl:element name="Object">
					<xsl:attribute name="id">
						<xsl:value-of select="$id"/>
					</xsl:attribute>
					<xsl:apply-templates select="$collection/ObjectList/Object[id = $id]/*">
						<xsl:sort select="name()" />
					</xsl:apply-templates>
				</xsl:element>
			</xsl:for-each-group>
		</ObjectList>
	</xsl:template>

	<!-- leave out to avoid duplication -->
	<xsl:template match="$collection/ObjectList/Object/id"/>

	<!-- identity -->
	<xsl:template match="@*|node()">
		<!-- xsl:message>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="name()"/></xsl:message>
		-->
		<xsl:copy>
	    	<xsl:apply-templates select="@*|node()">
			</xsl:apply-templates>
	    </xsl:copy>
	  </xsl:template>
  
</xsl:stylesheet>