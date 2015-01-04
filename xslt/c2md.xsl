<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ac="http://www.atlassian.com/schema/confluence/4/ac/"
  xmlns:ri="http://www.atlassian.com/schema/confluence/4/ri/"
  xmlns:acxhtml="http://www.atlassian.com/schema/confluence/4/"
  xmlns:lookup="http://www.fundi.com.au/">

  <xsl:output method="text"/>

  <!--xsl:strip-space elements="acxhtml:div acxhtml:table acxhtml:tbody acxhtml:tr acxhtml:ol acxhtml:ul ac:* ri:*"/-->

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="text()">
    <!--xsl:value-of select="normalize-space(.)"/-->
    <!--xsl:text>[</xsl:text-->
    <!--xsl:value-of select="."/-->
    <!--xsl:text>]</xsl:text-->
    <xsl:if test="normalize-space(.) != ''">
      <xsl:value-of select="."/>
    </xsl:if>
  </xsl:template>


  <xsl:template match="acxhtml:h1">
    <xsl:text># </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#xa;</xsl:text>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

  <xsl:template match="acxhtml:h2">
    <xsl:text>## </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#xa;</xsl:text>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

  <xsl:template match="acxhtml:h3">
    <xsl:text>### </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#xa;</xsl:text>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

  <xsl:template match="acxhtml:h4">
    <xsl:text>#### </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#xa;</xsl:text>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

  <xsl:template match="acxhtml:h5">
    <xsl:text>##### </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#xa;</xsl:text>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

  <xsl:template match="acxhtml:h6">
    <xsl:text>###### </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#xa;</xsl:text>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

  <xsl:template match="acxhtml:ul">
    <xsl:apply-templates/>
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="acxhtml:ul/acxhtml:li">
    <xsl:for-each select="../ancestor::*[local-name(.)='ol' or local-name(.)='ul']">
      <xsl:text>  </xsl:text>
    </xsl:for-each>
    <xsl:text>* </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

  <xsl:template match="acxhtml:p">
    <xsl:apply-templates/>
    <xsl:if test="not(ancestor::acxhtml:td or ancestor::acxhtml:th)">
      <xsl:text>&#xa;</xsl:text>
      <xsl:text>&#xa;</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="acxhtml:a">
    <xsl:text>[</xsl:text>
    <xsl:choose>
      <xsl:when test=".">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@href"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>]</xsl:text>
    <xsl:text>(</xsl:text>
    <xsl:value-of select="@href"/>
    <xsl:text>)</xsl:text>
  </xsl:template>


  <xsl:template match="acxhtml:strong | acxhtml:b">
    <xsl:text>**</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>**</xsl:text>
  </xsl:template>

  <xsl:template match="acxhtml:em">
    <xsl:text>*</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>*</xsl:text>
  </xsl:template>

  <xsl:template match="acxhtml:code">
    <xsl:text>`</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>`</xsl:text>
  </xsl:template>

  <xsl:template match="acxhtml:br">
    <xsl:text>  &#xa;</xsl:text>
  </xsl:template>


  <xsl:template match="ac:structured-macro[@ac:name='code']">
    <xsl:text>```</xsl:text>
    <xsl:variable name="contents">
      <xsl:apply-templates/>
    </xsl:variable>
    <xsl:if test="not(starts-with($contents, '&#xa;'))">
      <xsl:text>&#xa;</xsl:text>
    </xsl:if>
    <xsl:value-of select="$contents"/>
    <xsl:if test="not(ends-with($contents, '&#xa;'))">
      <xsl:text>&#xa;</xsl:text>
    </xsl:if>
    <xsl:text>```</xsl:text>
    <xsl:text>&#xa;</xsl:text>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

  <xsl:template match="ac:structured-macro/ac:parameter"/>

  <xsl:template match="ac:link[ri:*]">
    <xsl:text>[[</xsl:text>
    <xsl:if test="ac:link-body or ac:plain-text-link-body">
      <xsl:apply-templates select="ac:link-body | ac:plain-text-link-body"/>
      <xsl:text>|</xsl:text>
    </xsl:if>
    <xsl:apply-templates select="ri:*" mode="link-target"/>
    <xsl:if test="@ac:anchor">
      <xsl:text>#</xsl:text>
      <xsl:value-of select="translate(lower-case(@ac:anchor), ' ', '-')"/>
    </xsl:if>
    <xsl:text>]]</xsl:text>
  </xsl:template>

  <xsl:template match="ac:link[not(ri:*) and @ac:anchor]">
    <xsl:text>[</xsl:text>
    <xsl:choose>
      <xsl:when test="ac:link-body or ac:plain-text-link-body">
        <xsl:apply-templates select="ac:link-body | ac:plain-text-link-body"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@ac:anchor"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>]</xsl:text>
    <xsl:text>(</xsl:text>
    <xsl:text>#</xsl:text>
    <xsl:value-of select="translate(lower-case(@ac:anchor), ' ', '-')"/>
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="ri:page[@ri:content-title]" mode="link-target">
    <xsl:value-of select="@ri:content-title"/>
  </xsl:template>

  <xsl:template match="acxhtml:table">
    <xsl:apply-templates/>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

  <xsl:template match="acxhtml:tr[acxhtml:th]">
    <xsl:apply-templates/>
    <xsl:text>&#xa;</xsl:text>
    <xsl:apply-templates mode="header-dashes"/>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

  <xsl:template match="acxhtml:tr[acxhtml:td]">
    <xsl:apply-templates/>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

  <xsl:template match="acxhtml:th">
    <xsl:text>|</xsl:text>
    <xsl:apply-templates/>
    <xsl:if test="not(following-sibling::acxhtml:th)">
      <xsl:text>|</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="acxhtml:th" mode="header-dashes">
    <xsl:text>|</xsl:text>
    <xsl:variable name="text">
      <xsl:apply-templates/>
    </xsl:variable>
    <xsl:for-each select="1 to string-length($text)">
      <xsl:text>-</xsl:text>
    </xsl:for-each>
    <xsl:if test="not(following-sibling::acxhtml:th)">
      <xsl:text>|</xsl:text>
    </xsl:if>
  </xsl:template>


  <xsl:template match="acxhtml:td">
    <xsl:text>|</xsl:text>
    <xsl:apply-templates/>
    <xsl:if test="not(following-sibling::acxhtml:td)">
      <xsl:text>|</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="ac:image">
    <xsl:text>![]</xsl:text>
    <xsl:text>(</xsl:text>
    <xsl:apply-templates mode="link-target"/>
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="ri:attachment" mode="link-target">
    <xsl:value-of select="@ri:filename"/>
  </xsl:template>

  <xsl:template match="ac:emoticon[@ac:name='plus']">
    <xsl:text>+</xsl:text>
  </xsl:template>

  <xsl:template match="ac:emoticon[@ac:name='minus']">
    <xsl:text>-</xsl:text>
  </xsl:template>

</xsl:stylesheet>