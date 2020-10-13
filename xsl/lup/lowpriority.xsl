<xsl:stylesheet version="2.0"
    xmlns="http://www.mpx.org/mpx"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mpx="http://www.mpx.org/mpx" exclude-result-prefixes="mpx">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
    <xsl:strip-space elements="*" />

    <!-- third level default: for elements whose name I don't know yet -->
    <xsl:template match="/museumPlusExport/*/*">
        <xsl:element name="{name()}">
            <xsl:value-of select="." />
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>