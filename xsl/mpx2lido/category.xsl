<xsl:stylesheet version="2.0"
    xmlns:lido="http://www.lido-schema.org"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:mpx="http://www.mpx.org/mpx" exclude-result-prefixes="mpx"
    xsi:schemaLocation="http://www.lido-schema.org http://www.lido-schema.org/schema/v1.0/lido-v1.0.xsd">

    <xsl:output method="xml" version="1.0" encoding="UTF-8"
        indent="yes" />
    <xsl:strip-space elements="*" />

    <!-- 
        FIELDS: category
        
        DF: "category of which this item is an instance"
        
        EXAMPLES FROM SPEC:
        "CIDOC-CRM concept definitions are given at 
        http://www.cidoccrm.org/crm-concepts/
        Data values in the sub-element term may often be: 
        - Man-Made Object (with conceptID "http://www.cidoc-crm.org/
          crm-concepts/E22"), 
        - Man-Made Feature (http://www.cidoc-crm.org/crmconcepts/E25), 
        - Collection* (http://www.cidoc-crm.org/crmconcepts/E78).
        
        E20 Biological Object?        

        My point of view after reading for CIDOC for 20min: badly defined 
        field. As is, mostly useless. Might be useful for joining hetereo-
        genous collections (e.g. natural history and art). I cant find a
        concept for information carrier.
        
        E78 information carrier is deprecated
        
        HISTORY: 
        -20200412 E22 Human-Made-Object instead of Man-Made-Object
        -20200412 category: I used to take category terms literally from objekttyp; 
        now I do a voc mapping where some objekttyp terms are related to basic
        CIDOC terms.
        -20200412 objekttyp=Musikinstrument remains at lido: classification; 
        it's certainly not a category in the Aristotelian sense (no top-level 
        classification). 
        
        Todo: implement E36 Visual Item
    -->

    <xsl:template mode="category" match="/mpx:museumPlusExport/mpx:sammlungsobjekt/mpx:objekttyp">
        <lido:category>
            <xsl:choose>
                <xsl:when test=". eq 'Allgemein' 
                    or . eq 'Musikinstrument' 
                    or . eq 'Audio'">
                    <lido:conceptID lido:type="URI">
                        <xsl:text>http://www.cidoc-crm.org/crm-concepts/E22</xsl:text>
                    </lido:conceptID>
                    <lido:term xml:lang="en">
                        <xsl:text>Human-Made Object</xsl:text>
                    </lido:term>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message>
                        WARNING: Unknown LIDO category!
                        <xsl:value-of select="."/>
                    </xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </lido:category>
    </xsl:template>
</xsl:stylesheet>