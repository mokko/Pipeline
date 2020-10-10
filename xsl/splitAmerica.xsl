<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:mpx="http://www.mpx.org/mpx">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
    <xsl:strip-space elements="*" />

    <!-- 
    expects single mpx file: levelup.mpx 
    outputs two mpx files Keramik.mpx and Plains.mpx
    https://stackoverflow.com/questions/57380561/split-xml-file-into-multiple-files-using-xslt    
    --> 

    <xsl:template match="/">
        <xsl:variable name="sep">150.30 Pferd</xsl:variable>
        <xsl:result-document href="Keramik.levelup.mpx">
            <museumPlusExport xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                              xmlns="http://www.mpx.org/mpx"
                              level="clean"
                              version="2.0">
                <xsl:variable name="selected" select="/mpx:museumPlusExport/mpx:sammlungsobjekt/mpx:ausstellung[
                    . = 'HUFO - Ersteinrichtung - Amerika (Schaumagazin)' 
                    and @sektion &lt; $sep or @sektion = '150.56. N.N.']/.. "/>
                <xsl:for-each select="$selected">
                    <xsl:variable name="objId" select="@objId"/>
                    <xsl:apply-templates select="/mpx:museumPlusExport/mpx:multimediaobjekt[mpx:verknüpftesObjekt eq $objId]">
                        <xsl:sort select="./@mulId" data-type="number"/>
                    </xsl:apply-templates>
                </xsl:for-each>

                <xsl:apply-templates select="$selected">
                            <xsl:sort select="@objId" data-type="number"/>
                </xsl:apply-templates>
            </museumPlusExport>
      </xsl:result-document>
      <xsl:result-document href="Plains.levelup.mpx">
            <museumPlusExport xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                              xmlns="http://www.mpx.org/mpx"
                              level="clean"
                              version="2.0">
                <xsl:variable name="selected" select="/mpx:museumPlusExport/mpx:sammlungsobjekt/mpx:ausstellung[
                    . = 'HUFO - Ersteinrichtung - Amerika (Schaumagazin)' 
                    and @sektion &gt;= $sep and not (@sektion = '150.56. N.N.')]/.."/>
                <xsl:for-each select="$selected">
                    <xsl:variable name="objId" select="./@objId"/>
                    <xsl:apply-templates select="/mpx:museumPlusExport/mpx:multimediaobjekt[mpx:verknüpftesObjekt eq $objId]">
                        <xsl:sort select="./@mulId" data-type="number"/>
                    </xsl:apply-templates>
                </xsl:for-each>
                <xsl:apply-templates select="$selected">
                            <xsl:sort select="@objId" data-type="number"/>
                </xsl:apply-templates>
            </museumPlusExport>
      </xsl:result-document>
    </xsl:template>

    <xsl:template match="@* | node()">
      <xsl:copy>
        <xsl:apply-templates select="@* | node()"/>
      </xsl:copy>
    </xsl:template>

</xsl:stylesheet>