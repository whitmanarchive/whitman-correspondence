<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xpath-default-namespace="http://www.whitmanarchive.org/namespace"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  exclude-result-prefixes="#all">

  <!-- ==================================================================== -->
  <!--                               IMPORTS                                -->
  <!-- ==================================================================== -->

  <xsl:import href="../../whitman-scripts/solr/whitman_to_solr.xsl"/>

  <xsl:output indent="yes" omit-xml-declaration="yes"/>

  <!-- ==================================================================== -->
  <!--                           PARAMETERS                                 -->
  <!-- ==================================================================== -->

  <!-- Defined in project config files -->
  <xsl:param name="fig_location"/>  <!-- url for figures -->
  <xsl:param name="file_location"/> <!-- url for tei files -->
  <xsl:param name="figures"/>       <!-- boolean for if figs should be displayed (not for this script, for html script) -->
  <xsl:param name="fw"/>            <!-- boolean for html not for this script -->
  <xsl:param name="pb"/>            <!-- boolean for page breaks in html, not this script -->
  <xsl:param name="project"/>       <!-- longer name of project -->
  <xsl:param name="slug"/>          <!-- slug of project -->
  <xsl:param name="site_url"/>
  <xsl:param name="site_location"/> <!-- being used by something -->
        

  <!-- ==================================================================== -->
  <!--                            OVERRIDES                                 -->
  <!-- ==================================================================== -->

  <!-- Individual projects can override matched templates from the
       imported stylesheets above by including new templates here -->
  <!-- Named templates can be overridden if included in matched templates
       here.  You cannot call a named template from directly within the stylesheet tag
       but you can redefine one here to be called by an imported template -->

      <!-- The below will override the entire text matching template -->
      <!-- <xsl:template match="text">
        <xsl:call-template name="fake_template"/>
      </xsl:template> -->

      <!-- The below will override templates with the same name -->
      <!-- <xsl:template name="fake_template">
        This fake template would override fake_template if it was defined
        in one of the imported files
      </xsl:template> 
  -->

  <!-- ========== category ========== -->

  <xsl:template name="category">
    <field name="category">
      <xsl:text>biography</xsl:text>
    </field>
  </xsl:template>

  <!-- ========== subCategory ========== -->

  <xsl:template name="subCategory">
    <field name="subCategory">
      <xsl:text>correspondence</xsl:text>
    </field>
  </xsl:template>

  <!-- ========== recipients ========== -->
  <!-- TODO refactor -->

  <xsl:template name="recipients">
    <xsl:if test="/TEI/teiHeader/profileDesc/particDesc/person/@role='recipient'">
      <!-- All in one field -->
      <field name="recipient">
        <xsl:if test="count(//person[@role='recipient']) = 1">
          <xsl:value-of select="//person[@role='recipient']/persName/attribute::key"/></xsl:if>
        <xsl:if test="count(//person[@role='recipient']) = 2">
          <xsl:value-of select="//person[@role='recipient'][1]/persName/attribute::key"/>
          <xsl:text>; </xsl:text>
          <xsl:value-of select="//person[@role='recipient'][2]/persName/attribute::key"/>
        </xsl:if>
        <xsl:if test="count(//person[@role='recipient']) = 3">
          <xsl:value-of select="//person[@role='recipient'][1]/persName/attribute::key"/>
          <xsl:text>; </xsl:text>
          <xsl:value-of select="//person[@role='recipient'][2]/persName/attribute::key"/>
          <xsl:text>; </xsl:text>
          <xsl:value-of select="//person[@role='recipient'][3]/persName/attribute::key"/>
        </xsl:if>
        <xsl:if test="count(//person[@role='recipient']) &gt; 3">
          <xsl:value-of select="//person[@role='recipient'][1]/persName/attribute::key"/>
          <xsl:text>; </xsl:text>
          <xsl:value-of select="//person[@role='recipient'][2]/persName/attribute::key"/>
          <xsl:text>; </xsl:text>
          <xsl:value-of select="//person[@role='recipient'][3]/persName/attribute::key"/>
          <xsl:text> and others</xsl:text>
        </xsl:if>
      </field>
      <!-- Individual fields -->
      <xsl:for-each select="/TEI/teiHeader/profileDesc/particDesc/person[@role='recipient']/persName/@key">
        <field name="recipients">
          <xsl:value-of select="."></xsl:value-of>
        </field>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template name="text_footnotes">
    <xsl:for-each select="//ptr">
      <xsl:variable name="ptr_target">
        <xsl:value-of select="@target"></xsl:value-of>
      </xsl:variable>
      <xsl:value-of select="document('notes.xml')//body/descendant::note[@xml:id=$ptr_target]"/><xsl:text>&#13;</xsl:text>
    </xsl:for-each>
    <xsl:for-each select="//profileDesc//persName[@ref]">
      <xsl:variable name="ref_target">
        <xsl:value-of select="@ref"/>
      </xsl:variable>
      <xsl:value-of select="document('notes.xml')//body/descendant::note[@xml:id=$ref_target]"/><xsl:text>&#13;</xsl:text>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
