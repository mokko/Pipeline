<xsl:stylesheet version="2.0"
    xmlns="http://www.mpx.org/npx"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:mpx="http://www.mpx.org/mpx">

    <xsl:output method="xml" version="1.0" encoding="UTF-8"
        indent="yes" />
    <xsl:strip-space elements="*" />

    <xsl:template match="@*|node()">
            <xsl:copy>
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="node()">
                    <xsl:sort select="name()"/>
                    <xsl:sort select="@objId|@mulId" data-type="number"/>
                </xsl:apply-templates>
            </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
