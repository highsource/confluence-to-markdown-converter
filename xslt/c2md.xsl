<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ac="http://www.atlassian.com/schema/confluence/4/ac/"
  xmlns:ri="http://www.atlassian.com/schema/confluence/4/ri/"
  xmlns:acxhtml="http://www.atlassian.com/schema/confluence/4/"
  xmlns:lookup="http://www.fundi.com.au/">

  <xsl:output method="text"/>

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="acxhtml:h1">
    <xsl:text># </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

  <xsl:template match="acxhtml:ul">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="acxhtml:ul/acxhtml:li">
    <xsl:if test="preceding-sibling::acxhtml:li">
      <xsl:text>&#xa;</xsl:text>
    </xsl:if>
    <xsl:for-each select="../ancestor::*[local-name(.)='ol' or local-name(.)='ul']">
      <xsl:text>  </xsl:text>
    </xsl:for-each>
      <xsl:text>* </xsl:text>
    <xsl:apply-templates/>
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

</xsl:stylesheet>