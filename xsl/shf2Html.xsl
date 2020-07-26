<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:npx="http://www.mpx.org/npx">
<!-- shf to html transformation; should be as generic as possible -->

   <xsl:output method="html" name="html" version="1.0" encoding="UTF-8" indent="yes" />
   <xsl:strip-space elements="*" />

    <xsl:template match="/*">
        <html>
            <xsl:call-template name="htmlHead"/>
            <body>
                <table>
                    <xsl:apply-templates select="/npx:shf/npx:sammlungsobjekt">
                        <xsl:sort select="npx:objId" data-type="number"/>
                    </xsl:apply-templates>
                </table>
            </body>
        </html>
    </xsl:template>

    <xsl:template name="htmlHead">
        <head>
            <meta charset="UTF-8" />
            <title>SHF HTML-Visualisierung 0.1</title>
            <style>h1 {padding-top: 20px;}</style>
        </head>
    </xsl:template>

    <xsl:template match="/npx:shf/npx:sammlungsobjekt">
        <xsl:variable name="objId" select="npx:objId" />
        <xsl:variable name="stdbld" select="../npx:multimediaobjekt[npx:verknüpftesObjekt eq $objId 
            and npx:standardbild 
            and lower-case(npx:veröffentlichen) eq 'ja']" />
        <tr>
            <td colspan="2">
                <h1>
                    <xsl:value-of select="$objId"/>
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="npx:identNr[1]"/>
                </h1>
            </td>
        </tr>
        <xsl:apply-templates select="node()"/>
        <xsl:if test="$stdbld">
            <xsl:variable name="src">
                <xsl:text>../../pix/</xsl:text>
                <xsl:value-of select="$stdbld/npx:mulId" />
                <xsl:text>.</xsl:text>
                <xsl:value-of select="$stdbld/npx:dateiname" />
                <xsl:text>.</xsl:text>
                <xsl:value-of select="lower-case($stdbld/npx:erweiterung)" />
            </xsl:variable>
            <tr style="background-color: #AAAAAA;">
                <td>Standardbild</td>
                <td>
                    <xsl:value-of select="$src"/>
                </td>
            </tr>
            <xsl:apply-templates select="$stdbld/*"/>
        </xsl:if>
        <xsl:for-each select="../npx:multimediaobjekt[npx:verknüpftesObjekt eq $objId 
            and not(npx:standardbild)]">
            <xsl:variable name="src">
                <xsl:text>../../pix/</xsl:text>
                <xsl:value-of select="npx:mulId" />
                <xsl:text>.</xsl:text>
                <xsl:value-of select="npx:dateiname" />
                <xsl:text>.</xsl:text>
                <xsl:value-of select="lower-case(npx:erweiterung)" />
            </xsl:variable>
            <tr style="background-color: #BBBBBB;">
                <td>Weitere Medien</td>
                <td>
                    <xsl:value-of select="$src"/>
                </td>
            </tr>
            <xsl:apply-templates select="node()"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="/npx:shf/npx:sammlungsobjekt/*|/npx:shf/npx:multimediaobjekt/*">
        <tr>
            <td><xsl:value-of select="name()"/></td>
            <td><xsl:value-of select="."/></td>
        </tr>
    </xsl:template>

</xsl:stylesheet>