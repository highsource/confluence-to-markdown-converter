  <xsl:template match="text()[following-sibling::acxhtml:ol or following-sibling::acxhtml:ul]">
    <xsl:variable name="input" select="."/>
    <xsl:variable name="firstChar" select="substring($input, 1, 1)"/>
    <!-- If the text node begins with whitespace, then reinstate a single leading space -->
    <xsl:if test="translate($firstChar, '&#xa; ', '') = ''">
      <xsl:text> </xsl:text>
    </xsl:if>
    <!--xsl:value-of select="normalize-space(.)"/-->
    <xsl:text>[</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>]</xsl:text>

  </xsl:template>

