<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
								xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								xmlns:msxsl="urn:schemas-microsoft-com:xslt"
								xmlns:hi="urn:nfi:iot:hi:1.0"
								exclude-result-prefixes="msxsl hi xsl">

	<xsl:output method="text" indent="no"/>

	<xsl:template match="/hi:interface">
		<xsl:text>Title: </xsl:text>
		<xsl:value-of select="@id"/>
		<xsl:text>
Description: Page contains a description of the harmonized interface </xsl:text>
		<xsl:value-of select="@id"/>
		<xsl:text>.
Master: /Master.md

========================

# `</xsl:text>
		<xsl:value-of select="@id"/>
		<xsl:text>`

</xsl:text>
		<xsl:value-of select="hi:description"/>
		<xsl:text>

</xsl:text>

		<xsl:if test="hi:sensorData">
			<xsl:text>## Sensor Data Interface

| Sensor Data Fields                                   |||||
| Field Name | Use | Field Type | Value Type | Description |
|:-----------|:----|:-----------|:-----------|:------------|
</xsl:text>
			<xsl:for-each select="hi:sensorData/hi:field">
				<xsl:text>| `</xsl:text>
				<xsl:value-of select="@name"/>
				<xsl:text>` | </xsl:text>
				<xsl:value-of select="@use"/>
				<xsl:text> | </xsl:text>
				<xsl:choose>
					<xsl:when test="@type='q'">
						<xsl:text>Physical Quantity</xsl:text>
					</xsl:when>
					<xsl:when test="@type='s'">
						<xsl:text>String</xsl:text>
					</xsl:when>
					<xsl:when test="@type='b'">
						<xsl:text>Boolean</xsl:text>
					</xsl:when>
					<xsl:when test="@type='d'">
						<xsl:text>Date</xsl:text>
					</xsl:when>
					<xsl:when test="@type='dt'">
						<xsl:text>Date &amp; Time</xsl:text>
					</xsl:when>
					<xsl:when test="@type='dr'">
						<xsl:text>Duration</xsl:text>
					</xsl:when>
					<xsl:when test="@type='e'">
						<xsl:text>Enumeration</xsl:text>
					</xsl:when>
					<xsl:when test="@type='i'">
						<xsl:text>32-bit integer</xsl:text>
					</xsl:when>
					<xsl:when test="@type='l'">
						<xsl:text>64-bit integer</xsl:text>
					</xsl:when>
					<xsl:when test="@type='t'">
						<xsl:text>Time</xsl:text>
					</xsl:when>
					<xsl:when test="@type='numeric'">
						<xsl:text>Numeric</xsl:text>
					</xsl:when>
					<xsl:when test="@type='integer'">
						<xsl:text>Integer</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>`</xsl:text>
						<xsl:value-of select="@type"/>
						<xsl:text>`</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> |</xsl:text>
				<xsl:if test="@m">
					<xsl:text> Momentary</xsl:text>
				</xsl:if>
				<xsl:if test="@p">
					<xsl:text> Peak</xsl:text>
				</xsl:if>
				<xsl:if test="@s">
					<xsl:text> Status</xsl:text>
				</xsl:if>
				<xsl:if test="@c">
					<xsl:text> Computed</xsl:text>
				</xsl:if>
				<xsl:if test="@i">
					<xsl:text> Identity</xsl:text>
				</xsl:if>
				<xsl:if test="@h">
					<xsl:text> Historical</xsl:text>
				</xsl:if>
				<xsl:text> | </xsl:text>
				<xsl:value-of select="@description"/>
				<xsl:text> |
</xsl:text>
			</xsl:for-each>
			<xsl:text>
</xsl:text>
			<xsl:if test="hi:sensorData/hi:comment">
				<xsl:value-of select="hi:sensorData/hi:comment"/>
				<xsl:text>

</xsl:text>
			</xsl:if>
		</xsl:if>

		<xsl:if test="hi:controlParameters">
			<xsl:text>## Actuator Interface

| Actuator Control Parameters                             |||||
| Parameter Name | Use | Parameter Type | Range | Description |
|:---------------|:----|:---------------|:------|:------------|
</xsl:text>
			<xsl:for-each select="hi:controlParameters/hi:parameter">
				<xsl:text>| `</xsl:text>
				<xsl:value-of select="@name"/>
				<xsl:text>` | </xsl:text>
				<xsl:value-of select="@use"/>
				<xsl:text> | </xsl:text>
				<xsl:choose>
					<xsl:when test="@type='b'">
						<xsl:text>Boolean</xsl:text>
					</xsl:when>
					<xsl:when test="@type='cl'">
						<xsl:text>Color</xsl:text>
					</xsl:when>
					<xsl:when test="@type='d'">
						<xsl:text>Date</xsl:text>
					</xsl:when>
					<xsl:when test="@type='dt'">
						<xsl:text>Date &amp; Time</xsl:text>
					</xsl:when>
					<xsl:when test="@type='db'">
						<xsl:text>Double</xsl:text>
					</xsl:when>
					<xsl:when test="@type='dr'">
						<xsl:text>Duration</xsl:text>
					</xsl:when>
					<xsl:when test="@type='e'">
						<xsl:text>Enumeration</xsl:text>
					</xsl:when>
					<xsl:when test="@type='i'">
						<xsl:text>32-bit integer</xsl:text>
					</xsl:when>
					<xsl:when test="@type='l'">
						<xsl:text>64-bit integer</xsl:text>
					</xsl:when>
					<xsl:when test="@type='s'">
						<xsl:text>String</xsl:text>
					</xsl:when>
					<xsl:when test="@type='t'">
						<xsl:text>Time</xsl:text>
					</xsl:when>
					<xsl:when test="@type='numeric'">
						<xsl:text>Numeric</xsl:text>
					</xsl:when>
					<xsl:when test="@type='integer'">
						<xsl:text>Integer</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>`</xsl:text>
						<xsl:value-of select="@type"/>
						<xsl:text>`</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> | </xsl:text>
				<xsl:choose>
					<xsl:when test="@range='RangeElement'">
						<xsl:text disable-output-escaping="yes">`&lt;range&gt;` element.</xsl:text>
					</xsl:when>
				</xsl:choose>
				<xsl:text> | </xsl:text>
				<xsl:value-of select="@description"/>
				<xsl:text> |
</xsl:text>
			</xsl:for-each>
			<xsl:text>
</xsl:text>
			<xsl:if test="hi:controlParameters/hi:comment">
				<xsl:value-of select="hi:controlParameters/hi:comment"/>
				<xsl:text>

</xsl:text>
			</xsl:if>
		</xsl:if>

		<xsl:text>

## XML Interface Definition

Below you find the XML source that generated this page:

```xml
</xsl:text>
		<xsl:copy-of select="."/>
		<xsl:text>
```
</xsl:text>
		
	</xsl:template>

</xsl:stylesheet>
