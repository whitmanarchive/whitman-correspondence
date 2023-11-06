<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:whitman="http://www.whitmanarchive.org/namespace"
  xpath-default-namespace="http://www.whitmanarchive.org/namespace" version="2.0"
  exclude-result-prefixes="xsl tei xs whitman">
  
  <!-- ==================================================================== -->
  <!--                             IMPORTS                                  -->
  <!-- ==================================================================== -->
  
  <xsl:import href="../.xslt-datura/tei_to_html/tei_to_html.xsl"/>
  <xsl:import href="../../../whitman-scripts/scripts/archive-wide/overrides.xsl"/>

  <xsl:output method="xml" indent="no" encoding="UTF-8" omit-xml-declaration="no"/>
  
  <!-- ==================================================================== -->
  <!--                    CORRESPONDENCE   OVERRIDES                        -->
  <!-- ==================================================================== -->
  
  
  <!-- template to parse id's to create links -->
  <xsl:template name="link_id">
    <xsl:param name="target"/>
    <xsl:choose>
      <xsl:when test="contains($target, '_')">
        <xsl:value-of select="substring-after($target, '_n')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring-after($target, 'n')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="//body//ptr">
    <xsl:if test="//keywords[@n = 'category']/term = 'biography-correspondence'">
      <xsl:variable name="link_id_local">
        <xsl:call-template name="link_id">
          <xsl:with-param name="target" select="@target"/>
        </xsl:call-template>
      </xsl:variable>
      
      <a href="#n{$link_id_local}" class="internal_link tei_ptr" id="r{$link_id_local}">
        <xsl:apply-templates/>
        <xsl:number level="any" count="//body//ptr"/>
      </a>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="text[@type = 'letter']">
    <xsl:variable name="doc_path">../../source/annotations/notes.xml</xsl:variable>
    <xsl:apply-templates/>
   
    <hr/>
    
    <h3>Notes:</h3>
    <ul class="correspondence_notes">
      <xsl:for-each select="//body//ptr">
        
        <xsl:variable name="link_id_local">
          <xsl:call-template name="link_id">
            <xsl:with-param name="target" select="@target"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="id" select="@target"/>
        
        <li>
          <xsl:attribute name="id">
            <xsl:text>n</xsl:text>
            <xsl:value-of select="$link_id_local"/>
          </xsl:attribute>
          
          
          <xsl:number level="any" count="//body//ptr"/>
          <xsl:text>. </xsl:text>
          <xsl:apply-templates select="document($doc_path)//body/descendant::note[@xml:id = $id]"/>
          
          <xsl:text> [</xsl:text>
          <a href="#r{$link_id_local}">
            <xsl:text>back</xsl:text>
          </a>
          <xsl:text>]</xsl:text>
          
          <!-- TODO reconsider links, from correspondenceP5.xsl
        Currently some links deliberately do not link, and others have special rules for paths. 
        When everything is in the API, and we've decided for sure that all documents will be at one level, the links may work, but we might still need to remove some of them. 
        -->
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>
  
  <!-- correspondence only? Will there be other internal links affected? How do we know, throughout the archive, if a link is internal or external? -->
  <xsl:template match="ref">
    <xsl:choose>
      <!-- When target starts with #, assume it is an in page link (anchor) -->
      <xsl:when test="starts-with(@target, '#')">
        <xsl:variable name="n" select="@target"/>
        <xsl:text> </xsl:text>
        <a>
          <xsl:attribute name="id">
            <xsl:text>ref</xsl:text>
            <xsl:value-of select="@target"/>
          </xsl:attribute>
          <xsl:attribute name="class">
            <xsl:text>inlinenote</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:text>#note</xsl:text>
            <xsl:value-of select="@target"/>
          </xsl:attribute>
          <xsl:text>[note </xsl:text>
          <xsl:apply-templates/>
          <xsl:text>]</xsl:text>
        </a>
        <xsl:text> </xsl:text>
      </xsl:when>
      <!-- when marked as link, treat as an external link -->
      <xsl:when test="@type = 'link'">
        <a href="{@target}">
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <!-- external link -->
      <xsl:when test="starts-with(@target, 'http://') or starts-with(@target, 'https://')">
        <a href="{@target}">
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <!-- if the above are not true, it is assumed to be an internal to the site link -->
      <xsl:when test="@type = 'sitelink'">
        <a href="../{@target}" class="internal_link">
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <!-- when there is no @n treat this as an internal link to another document
      todo: determine if this can be added to the datura script more universally-->
      <xsl:when test="not(@n)">
        <a href="{@target}">
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <!-- WHITMAN NOTES -->
      <xsl:when test=". = '' and @n">
        <a href="#{@target}" class="internal_link tei_ref_target" id="{@xml:id}">
          <xsl:apply-templates/>
          <xsl:value-of select="@n"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <!-- the below will generate a footnote / in page link -->
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="concat('#', @target)"/>
          </xsl:attribute>
          <xsl:attribute name="class">
            <xsl:text>internal_link</xsl:text>
          </xsl:attribute>
          <xsl:apply-templates/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
</xsl:stylesheet>
