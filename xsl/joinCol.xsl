<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:mpx="http://www.mpx.org/mpx">

	<xsl:output method="xml" version="1.0" encoding="UTF-8"
		indent="yes" />
	<xsl:strip-space elements="*" />

	<!-- 
	TODO: copy this file to 1-XML and use it from there 
	expects a xml "dirty" mpx file where Wiederholfelder lead to separate records and without attributes
	expects that there are no records without indexes (mulId, objId, kueId)
	expects that on /museumPlusExport/*/* level elements are sorted alphabetically
	-->
	<xsl:variable name="collection" select="collection('.?select=*.xml')"/>

	<xsl:template match="/">
		<museumPlusExport level="join" version="2.0">
			<xsl:for-each select="$collection/*/*">
				<xsl:sort select="name()" order="ascending" />
				<xsl:sort select="@mulId|@kueId|@objId" data-type="number" />
				<xsl:message>join <xsl:value-of select="name()"/></xsl:message>
				<xsl:copy-of select="." />
			</xsl:for-each>
		</museumPlusExport>
	</xsl:template>

</xsl:stylesheet>