<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.zetcom.com/ria/ws/module">

	<xsl:output method="xml" version="1.0" encoding="UTF-8"
		indent="yes" />
	<xsl:strip-space elements="*" />
	
	<!--
	We want to join *-clean-*.xml files to pack.xml
	-->
	
	<xsl:variable name="collection" select="collection('.?select=*.xml')"/> 	
	
	<xsl:template match="/">
		<application xmlns="http://www.zetcom.com/ria/ws/module">
			<modules>
				<xsl:if test="count($collection/*/*/*[@name = 'Exhibition']/*) &gt; 0">
					<module name="Exhibition" totalSize="{count($collection/*/*/*[@name = 'Exhibition']/*)}">
						<xsl:for-each select="$collection/*/*/*[@name = 'Exhibition']/*">
							<xsl:message>Exhibition</xsl:message>
							<xsl:copy-of select="." />
						</xsl:for-each>
					</module>
				</xsl:if>
				<xsl:if test="count($collection/*/*/*[@name = 'Multimedia']/*) &gt; 0">
					<module name="Multimedia" totalSize="{count($collection/*/*/*[@name = 'Multimedia']/*)}">
						<xsl:for-each select="$collection/*/*/*[@name = 'Multimedia']/*">
							<xsl:message>MM</xsl:message>
							<xsl:copy-of select="." />
						</xsl:for-each>
					</module>
				</xsl:if>
				<xsl:if test="count($collection/*/*/*[@name = 'Object']/*) &gt; 0">
					<module name="Object" totalSize="{count($collection/*/*/*[@name = 'Object']/*)}">
						<xsl:for-each select="$collection/*/*/*[@name = 'Object']/*">
							<xsl:message>Obj</xsl:message>
							<xsl:copy-of select="." />
						</xsl:for-each>
					</module>
				</xsl:if>
				<xsl:if test="count($collection/*/*/*[@name = 'Person']/*) &gt; 0">
					<module name="Person" totalSize="{count($collection/*/*/*[@name = 'Person']/*)}">
						<xsl:for-each select="$collection/*/*/*[@name = 'Person']/*">
							<xsl:message>Person</xsl:message>
							<xsl:copy-of select="." />
						</xsl:for-each>
					</module>
				</xsl:if>
				<xsl:if test="count($collection/*/*/*[@name = 'Registrar']/*) &gt; 0">
					<module name="Registrar" totalSize="{count($collection/*/*/*[@name = 'Registrar']/*)}">
						<xsl:for-each select="$collection/*/*/*[@name = 'Registrar']/*">
							<xsl:message>Registrar</xsl:message>
							<xsl:copy-of select="." />
						</xsl:for-each>
					</module>
				</xsl:if>
			</modules>
		</application>
	</xsl:template>
</xsl:stylesheet>