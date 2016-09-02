<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="http://www.whitmanarchive.org/namespace">

  <xsl:import href="../../whitman-scripts/html/whitman_to_html.xsl"/>
  
  <!-- overrides -->

  <!-- THINGS JESSICA IS ADDING -->
  <xsl:template name="image_url">
    <xsl:value-of select="$externalfileroot"/>biography/correspondence<xsl:value-of select="@facs"/>
  </xsl:template>

  <!-- milestones...check with Nikki to make sure these are letters only -->
  <xsl:template match="milestone">
    <xsl:choose>
      <xsl:when test="@rend='horbar-full'">——————————<br/>
      </xsl:when>
      <xsl:when test="@rend='horbar-short-right'">
        <div class="rendRight">——— </div>
      </xsl:when>
      <xsl:when test="@rend='horbar-short-left'">
        <div class="rendLeft">———</div>
      </xsl:when>
      <xsl:when test="@rend='horbar-short-center'">———</xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- TODO the below is probably only relevant for correspondence? -->
  <xsl:template name="correspondents">
    <xsl:if test="//profileDesc//persName[@ref]">
      <div class="editorial_notes">
        <hr/>
        <xsl:choose>
          <xsl:when test="count(//profileDesc//persName[@ref])=1">
            <xsl:for-each select="//persName[@ref]">
              <xsl:variable name="pers_target">
                <xsl:value-of select="@ref"/>
              </xsl:variable>
              <p>
                <em>
                  <xsl:text>Correspondent:</xsl:text>
                </em>
                <br/>
                <xsl:apply-templates select="document('notes.xml')//body/descendant::note[@xml:id=$pers_target]"/>
              </p>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <p>
              <em>
                <xsl:text>Correspondents:</xsl:text>
              </em>
              <br/>
              <xsl:for-each select="//persName[@ref]">
                <xsl:variable name="pers_target">
                  <xsl:value-of select="@ref"/>
                </xsl:variable>
                <xsl:apply-templates select="document('notes.xml')//body/descendant::note[@xml:id=$pers_target]"/>
                <br/>
                <xsl:if test="following-sibling::persName[@ref]">
                  <br/>
                </xsl:if>
              </xsl:for-each>
            </p>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </xsl:if>
  </xsl:template>

  <!-- TODO moved out of general, but should move back if not correspondence specific -->
  <xsl:template name="editorial_notes">
    <div class="editorial_notes">
      <h4>Notes:</h4>
      <xsl:for-each select="//ptr">
        <xsl:choose>
          <xsl:when test="ancestor::teiHeader"/>
          <xsl:otherwise>
            <xsl:variable name="ptr_target">
              <xsl:value-of select="@target"/>
            </xsl:variable>
            <p>
              <xsl:attribute name="id">
                <xsl:value-of select="@target"/>
              </xsl:attribute>
              <xsl:number count="//body//ptr" level="any"/>
              <xsl:text>. </xsl:text>
              <xsl:apply-templates select="document('notes.xml')//body/descendant::note[@xml:id=$ptr_target]"/>
              <a>
                <xsl:attribute name="href">#r<xsl:number count="//body//ptr" level="any"/></xsl:attribute>[back]
              </a>
            </p>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </div>
  </xsl:template>


</xsl:stylesheet>
