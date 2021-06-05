<xsl:stylesheet version="2.0"
    xmlns:z="http://www.zetcom.com/ria/ws/module"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template match="/">
			<xsl:message>
				<xsl:text>moduleItems total: </xsl:text>
				<xsl:value-of select="count(/z:application/z:modules/z:module/z:moduleItem)"/>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>items by module type&#xa;</xsl:text>
				<xsl:for-each select="/z:application/z:modules/z:module/@name">
					<xsl:variable name="name" select="."/>
					<xsl:text>    </xsl:text>
					<xsl:value-of select="$name"/>
					<xsl:text>:</xsl:text> 
					<xsl:value-of select="count(/z:application/z:modules/z:module[@name = $name]/z:moduleItem)"/>
					<xsl:text>&#xa;</xsl:text>
				</xsl:for-each>
				<xsl:text>Ids that are not unique:&#xa;</xsl:text>
				<xsl:for-each select="/z:application/z:modules/z:module">
					<xsl:text>    </xsl:text>
					<xsl:value-of select="@name"/>
					<xsl:text>&#xa;</xsl:text> 
					<xsl:for-each-group select="z:moduleItem" group-by="@id">
						<xsl:if test="count(current-group()) &gt; 1">
							<xsl:text>        </xsl:text>
							<xsl:value-of select="@id"/>
							<xsl:text>: </xsl:text>
							<xsl:value-of select="count(current-group())"/>
							<xsl:text>&#xa;</xsl:text>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:for-each>
			</xsl:message>
	</xsl:template>	
	
	<xsl:template match="bla">
		
	</xsl:template>
	
</xsl:stylesheet>