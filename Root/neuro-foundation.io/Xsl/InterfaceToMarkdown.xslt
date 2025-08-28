<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
								xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								xmlns:msxsl="urn:schemas-microsoft-com:xslt"
								xmlns:hi="urn:nfi:iot:hi:1.0"
								exclude-result-prefixes="msxsl hi xsl">

	<xsl:output method="html" indent="no"/>

	<xsl:template match="/hi:interface">
		<xsl:text>Title: </xsl:text>
		<xsl:value-of select="@id"/>
		<xsl:text>
Description: Page contains a description of the harmonized interface </xsl:text>
		<xsl:value-of select="@id"/>
		<xsl:text>.
Master: /Master.md

========================

![Table of Contents](toc)

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
				<xsl:call-template name="SensorFieldRow"/>
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
				<xsl:call-template name="ControlParameterRow"/>
			</xsl:for-each>
			<xsl:text>
</xsl:text>
			<xsl:if test="hi:controlParameters/hi:comment">
				<xsl:value-of select="hi:controlParameters/hi:comment"/>
				<xsl:text>

</xsl:text>
			</xsl:if>
		</xsl:if>

		<xsl:if test="hi:commands">
			<xsl:text>## Command Interface

The following commands are defined for this interface.

| Commands                                     ||||
| Command Name | Use | Command Type | Description |
|:-------------|:----|:-------------|:------------|
</xsl:text>

			<xsl:for-each select="hi:commands/*">
				<xsl:text>| `</xsl:text>
				<xsl:value-of select="@name"/>
				<xsl:text>` | </xsl:text>
				<xsl:value-of select="@use"/>
				<xsl:text> | </xsl:text>
				<xsl:choose>
					<xsl:when test="name()='simpleCommand'">
						<xsl:text>Simple Command</xsl:text>
					</xsl:when>
					<xsl:when test="name()='parametrizedCommand'">
						<xsl:text>Parametrized Command</xsl:text>
					</xsl:when>
					<xsl:when test="name()='parametrizedQuery'">
						<xsl:text>Parametrized Query</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>`</xsl:text>
						<xsl:value-of select="name()"/>
						<xsl:text>`</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> | </xsl:text>
				<xsl:value-of select="@description"/>
				<xsl:text> |
</xsl:text>
			</xsl:for-each>
			<xsl:text>
</xsl:text>

			<xsl:for-each select="hi:commands/*">
				<xsl:if test="name()='parametrizedCommand' or name()='parametrizedQuery' or hi:comment">
					<xsl:text>### `</xsl:text>
					<xsl:value-of select="@name"/>
					<xsl:text>`

</xsl:text>
					<xsl:value-of select="@description"/>
					<xsl:text>

</xsl:text>
					<xsl:if test="name()='parametrizedCommand' or name()='parametrizedQuery'">
						<xsl:text>
| Command Parameters                                      |||||
| Parameter Name | Use | Parameter Type | Range | Description |
|:---------------|:----|:---------------|:------|:------------|
</xsl:text>
						<xsl:for-each select="hi:parameter">
							<xsl:call-template name="ControlParameterRow"/>
						</xsl:for-each>
						<xsl:text>
</xsl:text>
					</xsl:if>
				</xsl:if>
			<xsl:if test="hi:comment">
				<xsl:value-of select="hi:comment"/>
				<xsl:text>

</xsl:text>
			</xsl:if>
			</xsl:for-each>

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

	<xsl:template name="SensorFieldRow">
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
	</xsl:template>

	<xsl:template name="ControlParameterRow">
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
			<xsl:when test="@regex">
				<xsl:text>`</xsl:text>
				<xsl:value-of select="@regex"/>
				<xsl:text>`</xsl:text>
			</xsl:when>
			<xsl:when test="@min and @max">
				<xsl:value-of select="@min"/>
				<xsl:text>-</xsl:text>
				<xsl:value-of select="@max"/>
			</xsl:when>
			<xsl:when test="@min">
				<xsl:value-of select="@min"/>
				<xsl:text>-</xsl:text>
			</xsl:when>
			<xsl:when test="@max">
				<xsl:text>-</xsl:text>
				<xsl:value-of select="@max"/>
			</xsl:when>
		</xsl:choose>
		<xsl:if test="@range">
			<xsl:text> </xsl:text>
			<xsl:choose>
				<xsl:when test="@range='RangeElement'">
					<xsl:text disable-output-escaping="yes">`&lt;range&gt;` element.</xsl:text>
				</xsl:when>
				<xsl:when test="@range='ListElement'">
					<xsl:text disable-output-escaping="yes">`&lt;list-single&gt;` element.</xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<xsl:text> | </xsl:text>
		<xsl:value-of select="@description"/>
		<xsl:text> |
</xsl:text>
	</xsl:template>

</xsl:stylesheet>
