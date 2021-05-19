<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
    <xsl:strip-space elements="*" />

     <xsl:template match="/">
         <root>
             <xsl:variable name="dict" select="document('../data/mpxvoc.xml')"/>
             <xsl:message>
                 <xsl:value-of select="doc-available('../data/mpxvoc.xml')"/>
                 <xsl:value-of select="$dict/*/*[1]"/>
             </xsl:message>
         </root>
     </xsl:template>
</xsl:stylesheet>