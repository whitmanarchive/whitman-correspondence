<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xpath-default-namespace="http://www.whitmanarchive.org/namespace"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dc="http://purl.org/dc/elements/1.1/">
    <xsl:output indent="yes" omit-xml-declaration="yes"/>
    
    <!-- This is a really hacky way to do this and is hopefully temporary. The problem is that if results come up they
    won't necessarily be viewable in the results, which could be confusing. -kmd -->
    
    <xsl:template name="include_metadata">
        
        
        <xsl:text> </xsl:text>
        
        <!-- ==========================
            Work ID
            ============================ -->
        
        <!-- Taking this one in addition to the filename for now -->
        
        
        
        <xsl:value-of select="//work/@ref" separator=" "/>
        
        <xsl:text> </xsl:text>
        
        <!-- include ID -->
        <!-- once this is generalized, include $filenamepart, until then called from main template -->
        
        <xsl:text> </xsl:text>
        
        <!-- ==========================
            ID
            ============================ -->
        
        <!-- Taking this one in addition to the filename for now -->
        
        <xsl:value-of select="TEI/teiHeader/fileDesc/publicationStmt/idno"/>
        
        <xsl:text> </xsl:text>
        
        <!-- =============================
            Creator
            ============================= -->
        
        <!-- creator from correspondence -->
        <xsl:choose>
            <!-- When handled in header -->
            <xsl:when test="/TEI/teiHeader/fileDesc/titleStmt/author != ''">
                <!-- All in one field -->
                
                <xsl:for-each select="/TEI/teiHeader/fileDesc/titleStmt/author">
                    <xsl:value-of select="normalize-space(.)"/>
                    <xsl:if test="position() != last()"><xsl:text>; </xsl:text></xsl:if>
                </xsl:for-each>
                
            </xsl:when>
            
            <!-- When handled in document -->
            <xsl:when test="//persName[@type = 'author']">
                <!-- All in one field -->
                
                <xsl:for-each-group select="//persName[@type = 'author']" group-by="substring-after(@key,'#')">
                    <xsl:sort select="substring-after(@key,'#')"/>
                    <xsl:value-of select="current-grouping-key()"/>
                    <xsl:if test="position() != last()"><xsl:text>; </xsl:text></xsl:if>
                </xsl:for-each-group>
                
            </xsl:when>
            
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
        
        <!-- /creator / correspondence -->
        
        <xsl:text> </xsl:text>
        
        <!-- =========================
            Recipient
            ========================= -->
        
        <!-- from correspondence -->
        
        <xsl:for-each select="/TEI/teiHeader/profileDesc/particDesc/person[@role='recipient']/persName/@key">
            
            <xsl:value-of select="."></xsl:value-of>
            
        </xsl:for-each>
        
        
        <xsl:text>  </xsl:text>
        
        <!-- =========================
            RightsHolder / Repository
            ========================== -->
        
        <xsl:value-of select="//sourceDesc/bibl/orgName"/>
        
        <xsl:text> </xsl:text>
        
        <!-- ========================
            Date
            ========================= -->
        
        <xsl:value-of select="//sourceDesc/bibl/date"/>
        
        <xsl:text> </xsl:text>
        
        
        
    </xsl:template>
    
</xsl:stylesheet>