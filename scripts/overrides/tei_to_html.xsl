<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:whitman="http://www.whitmanarchive.org/namespace"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0"
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
  
  <!-- path to notes file -->
  <xsl:variable name="doc_path">../../source/annotations/notes.xml</xsl:variable>
  
  
  <xsl:variable name="top_metadata">
    <ul>
      <li>
        <strong>Source: </strong>

        <xsl:apply-templates select="TEI/teiHeader/fileDesc/sourceDesc/bibl[1]/orgName[1]"/>
        <xsl:if test="TEI/teiHeader/fileDesc/sourceDesc/bibl[1]/orgName[2]"><xsl:text>; </xsl:text><xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/bibl/orgName[2]"/></xsl:if>
        <xsl:if test="TEI/teiHeader/fileDesc/sourceDesc/bibl[1]/orgName[3]"><xsl:text>; </xsl:text><xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/bibl/orgName[3]"/></xsl:if>
        <xsl:if test="TEI/teiHeader/fileDesc/sourceDesc/bibl[2]/orgName[1]"><xsl:text>; </xsl:text><xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/bibl[2]/orgName[1]"/></xsl:if>
        <xsl:if test="not(ends-with(TEI//sourceDesc//bibl[not(following-sibling::bibl)]/orgName[not(following-sibling::orgName)], '.'))"><xsl:text>.</xsl:text></xsl:if><xsl:text> </xsl:text> 
        <xsl:choose>
          <xsl:when test="TEI/teiHeader/fileDesc/sourceDesc/biblStruct">
            <xsl:choose>
              <xsl:when test="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/analytic">
                <!-- I have added the following <xsl:choose> to account for letters that are derived from newspapers (specifcally, the New Orleans Crescent material); the <xsl:otherwise> at the end of this choose is the code that previously existed for items that had biblStruct/analytic. KM, 9/16/22 -->
                <xsl:choose>
                  <xsl:when test="TEI/teiHeader/fileDesc/sourceDesc/biblStruct[@type='newspaper']">The transcription presented here is derived from <em><xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/title"/></em> (<xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr//date"/>): <xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr//biblScope[@unit='page']"/>. For a description of the editorial rationale behind our treatment of the correspondence, see our <a href="../about/editorial-policies#correspondence">statement of editorial policy</a>.</xsl:when>
                  
                  <xsl:otherwise>The transcription presented here is derived from  <xsl:if test="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/analytic/author"><xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/analytic/author"/>, </xsl:if> "<xsl:apply-templates select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/analytic/title"/>," <em><xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/title"/></em>, <!--ed. <xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/editor[1]"/><xsl:if test="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/editor[2]"><xsl:text> and </xsl:text><xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/editor[2]"/></xsl:if>--> <xsl:if test="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr//biblScope[@type='volume']"><xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr//biblScope[@type='volume']"/> (<xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr//date"/>), </xsl:if><xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr//biblScope[@unit='page']"/>. For a description of the editorial rationale behind our treatment of the correspondence, see our <a href="../about/editorial-policies#correspondence">statement of editorial policy</a>.</xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              
              <xsl:otherwise>
                The transcription presented here is derived from  <xsl:if test="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/author"><xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/author"/>, </xsl:if> <em><xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/title"/></em><xsl:if test="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/editor">, ed. <xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/editor[1]"/><xsl:if test="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/editor[2]"><xsl:text> and </xsl:text><xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/editor[2]"/></xsl:if></xsl:if> (<xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr//pubPlace"/>: <xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr//publisher"/>, <xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr//date"/>), <xsl:if test="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr//biblScope[@type='volume']"><xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr//biblScope[@type='volume']"/>:</xsl:if><xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr//biblScope[@unit='page']"/>. For a description of the editorial rationale behind our treatment of the correspondence, see our <a href="../about/editorial-policies#correspondence">statement of editorial policy</a>.
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          
          <xsl:otherwise>Transcribed from digital images or a microfilm reproduction of the original item. For a description of the editorial rationale behind our treatment of the correspondence, see our <a href="../about/editorial-policies#correspondence">statement of editorial policy</a>.
            
            <xsl:if test="descendant::ptr">
              <xsl:variable name="ptr_target_1">
                <xsl:value-of select="string(descendant::ptr[1]/@target)"/>
              </xsl:variable>
              <xsl:variable name="resp_1">
                <xsl:value-of select="document($doc_path)//body/descendant::note[@xml:id=$ptr_target_1]/@resp"/>
              </xsl:variable>
              <xsl:variable name="ptr_target_2">
                <xsl:value-of select="string(descendant::ptr[2]/@target)"/>
              </xsl:variable>
              <xsl:variable name="resp_2">
                <xsl:value-of select="document($doc_path)//body/descendant::note[@xml:id=$ptr_target_2]/@resp"/>
              </xsl:variable>
              <xsl:variable name="ptr_target_3">
                <xsl:value-of select="string(descendant::ptr[3]/@target)"/>
              </xsl:variable>
              <xsl:variable name="resp_3">
                <xsl:value-of select="document($doc_path)//body/descendant::note[@xml:id=$ptr_target_3]/@resp"/>
              </xsl:variable>
              <xsl:variable name="ptr_target_4">
                <xsl:value-of select="string(descendant::ptr[4]/@target)"/>
              </xsl:variable>
              <xsl:variable name="resp_4">
                <xsl:value-of select="document($doc_path)//body/descendant::note[@xml:id=$ptr_target_4]/@resp"/>
              </xsl:variable>
              <xsl:variable name="ptr_target_5">
                <xsl:value-of select="string(descendant::ptr[5]/@target)"/>
              </xsl:variable>
              <xsl:variable name="resp_5">
                <xsl:value-of select="document($doc_path)//body/descendant::note[@xml:id=$ptr_target_5]/@resp"/>
              </xsl:variable>
              
              <xsl:choose>
                <xsl:when test="$resp_1 | $resp_2 | $resp_3 | $resp_4 | $resp_5 = 'miller'">
                  <br/><br/><!--Notes for this letter were written by the listed contributors to this digital file, by the editors of the <em>Whitman Archive</em>, and/or have been derived from Walt Whitman, <em>The Correspondence</em>, ed. Edwin Haviland Miller, 6 vols. (New York: New York University Press, 1961&#8211;1977).-->
                  Notes for this letter were created by <em>Whitman Archive</em> staff and/or were derived from Walt Whitman, <em>The Correspondence</em>, ed. Edwin Haviland Miller, 6 vols. (New York: New York University Press, 1961&#8211;1977), and supplemented or updated by <em>Whitman Archive</em> staff.
                </xsl:when>
                <xsl:when test="$resp_1 | $resp_2 | $resp_3 | $resp_4 | $resp_5 = 'frenz'">
                  <br/><br/>Notes for this letter were created by <em>Whitman Archive</em> staff and/or were derived from <em>Whitman and Rolleston: A Correspondence</em>, ed. Horst Frenz (Bloomington, IN: Indiana University Press, 1951), and supplemented or updated by <em>Whitman Archive</em> staff. The material appears here courtesy of Indiana University Press.
                </xsl:when>
                <xsl:when test="$resp_1 | $resp_2 | $resp_3 | $resp_4 | $resp_5 = 'lozynsky'">
                  <br/><br/>Notes for this letter were created by <em>Whitman Archive</em> staff and/or were derived from <em>The Letters of Dr. Richard Maurice Bucke to Walt Whitman</em>, ed. Artem Lozynsky (Detroit: Wayne State University Press, 1977), and supplemented or updated by <em>Whitman Archive</em> staff.
                </xsl:when>
                <xsl:when test="$resp_1 | $resp_2 | $resp_3 | $resp_4 | $resp_5 = 'berthold'">
                  <br/><br/>Notes for this letter were created by <em>Whitman Archive</em> staff and/or were derived from <em>Dear Brother Walt: The Letters of Thomas Jefferson Whitman</em>, ed. Dennis Berthold and Kenneth M. Price (Kent, OH: Kent State University Press, 1984), and supplemented or updated by <em>Whitman Archive</em> staff.
                </xsl:when>
                <xsl:when test="$resp_1 | $resp_2 | $resp_3 | $resp_4 | $resp_5 = 'Berthold'">
                  <br/><br/>Notes for this letter were created by <em>Whitman Archive</em> staff and/or were derived from <em>Dear Brother Walt: The Letters of Thomas Jefferson Whitman</em>, ed. Dennis Berthold and Kenneth M. Price (Kent, OH: Kent State University Press, 1984), and supplemented or updated by <em>Whitman Archive</em> staff.
                </xsl:when>
                <xsl:when test="$resp_1 | $resp_2 | $resp_3 | $resp_4 | $resp_5 = 'birney'">
                  <br/><br/>Notes for this letter were created by <em>Whitman Archive</em> staff and/or were derived from Alice Lotvin Birney, "Whitman to C. W. Post: A Lost Letter Located," <em>Walt Whitman Quarterly Review</em>, ed. Ed Folsom (Summer 1993), 30&#8211;31, and supplemented or updated by <em>Whitman Archive</em> staff.
                </xsl:when>
                <xsl:when test="$resp_1 | $resp_2 | $resp_3 | $resp_4 | $resp_5 = 'genoways'">
                  <br/><br/>Notes for this letter were created by <em>Whitman Archive</em> staff and/or were derived from Walt Whitman, <em>The Correspondence</em>, ed. Ted Genoways (Iowa City: University of Iowa Press, 2004), vol. 7, and supplemented or updated by <em>Whitman Archive</em> staff.
                </xsl:when>
                <xsl:when test="$resp_1 | $resp_2 | $resp_3 | $resp_4 | $resp_5 = 'waldron'">
                  <br/><br/>Notes for this letter were created by <em>Whitman Archive</em> staff and/or were derived from <em>The Letters of Martha Mitchell Whitman</em>, ed. Randall H. Waldron (New York: New York University Press, 1977), and supplemented or updated by <em>Whitman Archive</em> staff.
                </xsl:when>
                <xsl:when test="$resp_1 | $resp_2 | $resp_3 | $resp_4 | $resp_5 = 'Loving'">
                  <br/><br/>Notes for this letter were created by <em>Whitman Archive</em> staff and/or were derived from <em>Civil War Letters of George Washington Whitman</em>, ed. Jerome M. Loving (Durham, NC: Duke University Press, 1975), and supplemented or updated by <em>Whitman Archive</em> staff.
                </xsl:when>
                <xsl:otherwise> </xsl:otherwise>
              </xsl:choose></xsl:if>
          </xsl:otherwise>
        </xsl:choose>

      </li> 
    </ul>
  </xsl:variable>
  
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
    
      <xsl:variable name="link_id_local">
        <xsl:call-template name="link_id">
          <xsl:with-param name="target" select="@target"/>
        </xsl:call-template>
      </xsl:variable>
      
      <a href="#n{$link_id_local}" class="internal_link tei_ptr" id="r{$link_id_local}">
        <xsl:apply-templates/>
        <xsl:number level="any" count="//body//ptr"/>
      </a>
    
  </xsl:template>
  
  <xsl:template match="text[@type = 'letter']">
    <xsl:apply-templates/>
    
    <xsl:if test="//profileDesc//persName[@ref]">
      <div class="editorial_notes">
        <hr/>
        <xsl:choose>
          <xsl:when test="count(//profileDesc//persName[@ref])=1">
            <xsl:for-each select="//persName[@ref]">
              <xsl:variable name="pers_target">
                <xsl:value-of select="@ref"></xsl:value-of></xsl:variable>
              <p><em><xsl:text>Correspondent:</xsl:text></em><br/>
                <xsl:apply-templates select="document($doc_path)//body/descendant::note[@xml:id=$pers_target]"/></p>
              
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <p><em><xsl:text>Correspondents:</xsl:text></em><br/>
              <xsl:for-each select="//persName[@ref]">
                <xsl:variable name="pers_target">
                  <xsl:value-of select="@ref"></xsl:value-of></xsl:variable>
                <xsl:apply-templates select="document($doc_path)//body/descendant::note[@xml:id=$pers_target]"/><br/><xsl:if test="following-sibling::persName[@ref]"><br/></xsl:if></xsl:for-each></p>
            
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </xsl:if>
   
    <xsl:if test="//body//ptr">
      <hr/>
      
      <h3>Notes</h3>
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
            <xsl:apply-templates select="document($doc_path)//note[@xml:id = $id]" />
            
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
    </xsl:if>
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
  
  
  <!-- notes on ancillary files -->
  
  <!-- NOTES -->
  
  
  <xsl:template match="text[@type='ancillary-correspondence']//note | text[@type='ancillary']//note" priority="1">
    <a>
      <xsl:attribute name="href">
        <xsl:text>#</xsl:text>
        <xsl:value-of select="@xml:id"/>
      </xsl:attribute>
      <sup class="footnote_sup_link">
        <xsl:attribute name="id">
          <xsl:text>ref_</xsl:text>
          <xsl:value-of select="@xml:id"/>
        </xsl:attribute>
        <xsl:value-of select="count(preceding::note[ancestor::text]) +1"/>
      </sup>
    </a>
  </xsl:template>
  
  <xsl:template match="text[@type='ancillary-correspondence'] | text[@type='ancillary']">
    <xsl:apply-templates/>
    
    <xsl:if test="//note[@type='editorial'] or //note[@type='authorial']">
      <hr />
      <h3>Notes</h3>
      <xsl:for-each select="//text//note">
        <p>
          <xsl:attribute name="id">
            <xsl:value-of select="@xml:id"/>
          </xsl:attribute>
          <xsl:value-of select="count(preceding::note[ancestor::text]) +1"/>
          <xsl:text>. </xsl:text>
          <xsl:apply-templates/>
          <xsl:text> [</xsl:text>
          <a>
            <xsl:attribute name="href">
              <xsl:text>#ref_</xsl:text>
              <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <xsl:text>back</xsl:text>
          </a>
          <xsl:text>]</xsl:text>
        </p>
        <xsl:text>
          
        </xsl:text>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  
  
</xsl:stylesheet>
