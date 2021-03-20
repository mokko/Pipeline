<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- 
	
		rpx stands MPX for RIA which is my xml export from new version of MuseumPlus
		principles: 
		- no sonderzeichen: Zetcom doesn't allow sonderzeichen in element names, so 
  		  "masse" instead of "maße"
		- basis for elements are the screen labels
		- i use small camel capitalization for elements, leaving out spaces, periods etc.
		- the least changes possible, i.e. we leave Objects and ObjectList in English and
		  capitalization as provided by Zetcom 

	TODO:
		- Add objId to 3.2 Export
		- change "gruppen" to "gruppe"
		- dont export letzteAenderungVon, replace with letzteAenderung
	    - what to do with empty <materialTechnik> tags? just leave it?
	    
	As before we want to ONE xml export to rule them all, so all fields can be 
	exported UNFILTERED. We can filter elements, records and values later.
	
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