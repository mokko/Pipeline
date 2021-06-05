<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mpx="http://www.mpx.org/mpx" exclude-result-prefixes="mpx">

    <xsl:output method="html" name="html" version="1.0" encoding="UTF-8" indent="yes" />

    <xsl:template match="/">
        <ausstellungen>
            <ausstellung>
                <titel>
                    <xsl:value-of select="//mpx:ausstellung[contains (.,'HUFO') and contains (., 'Schaumagazin')][1]"/>
                </titel>
                <xsl:for-each select="distinct-values(//mpx:ausstellung[contains (.,'HUFO') and contains (., 'Schaumagazin')]/@sektion)">
                    <xsl:sort select="."/>
                    <sektion>
                        <xsl:value-of select="."/>
                    </sektion>
                </xsl:for-each>
            </ausstellung>
        </ausstellungen>
    </xsl:template>

</xsl:stylesheet>