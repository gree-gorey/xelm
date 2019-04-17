<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xelm="https://github.com/gree-gorey/xelm">
  <xsl:template match="/">
    <root>
      <apiVersion>v1</apiVersion>
      <kind>Pod</kind>
      <metadata>
        <name><xsl:value-of select="values/name"/></name>
        <labels>
          <app>nginx</app>
        </labels>
      </metadata>
      <spec>
        <containers xelm:Array="true">
          <container>
            <name><xsl:value-of select="values/name"/></name>
            <image>
              <xsl:value-of select="values/image"/>:<xsl:value-of select="values/imageTag"/>
            </image>
            <ports xelm:Array="true">
              <port>
                <containerPort xelm:Integer="true">80</containerPort>
              </port>
            </ports>
          </container>
        </containers>
      </spec>
    </root>
  </xsl:template>
</xsl:stylesheet>
