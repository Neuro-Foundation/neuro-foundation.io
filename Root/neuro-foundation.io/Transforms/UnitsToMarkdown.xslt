<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
								xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								xmlns:msxsl="urn:schemas-microsoft-com:xslt"
								xmlns:units="urn:nf:iot:u:1.0"
								exclude-result-prefixes="msxsl units xsl">

	<xsl:output method="text" indent="no"/>

	<xsl:template match="/units:Units">
		<xsl:for-each select="units:Category">
			<xsl:text>### </xsl:text>
			<xsl:value-of select="@name"/>
			<xsl:text>

</xsl:text>
			<xsl:if test="units:ReferenceUnit">
				<xsl:text>Reference Unit: **</xsl:text>
				<xsl:value-of select="units:ReferenceUnit/@name"/>
				<xsl:text>**</xsl:text>
				<xsl:if test="units:ReferenceUnit/units:Derivation">
					<xsl:text>  
Derivation: </xsl:text>
					<xsl:if test="units:ReferenceUnit/units:Derivation/@factor">
						<xsl:value-of select="units:ReferenceUnit/units:Derivation/@factor"/>
						<xsl:text>⋅</xsl:text>
					</xsl:if>
					<xsl:for-each select="units:ReferenceUnit/units:Derivation/units:UnitFactor">
						<xsl:if test="position()&gt;1">
							<xsl:text>⋅</xsl:text>
						</xsl:if>
						<xsl:text>*</xsl:text>
						<xsl:value-of select="@unit"/>
						<xsl:text>*</xsl:text>
						<xsl:if test="@exponent">
							<xsl:text>^(</xsl:text>
							<xsl:value-of select="@exponent"/>
							<xsl:text>)</xsl:text>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
				<xsl:text>

</xsl:text>
				<xsl:if test="units:Unit">
					<xsl:text>| Unit | Conversion to reference |
|:-----|:-------------------------|</xsl:text>
					<xsl:for-each select="units:Unit">
						<xsl:text>
| `</xsl:text>
						<xsl:value-of select="@name"/>
						<xsl:text>` |</xsl:text>
						<xsl:for-each select="./*">
							<xsl:text> `</xsl:text>
							<xsl:apply-templates select="."/>
							<xsl:text>`</xsl:text>
						</xsl:for-each>
						<xsl:text> |</xsl:text>
					</xsl:for-each>
					<xsl:text>

</xsl:text>
				</xsl:if>
				<xsl:if test="units:CompoundUnit">
					<xsl:text>| Unit | Composition |
|:-----|:-------------|</xsl:text>
					<xsl:for-each select="units:CompoundUnit">
						<xsl:text>
| `</xsl:text>
						<xsl:value-of select="@name"/>
						<xsl:text>` | </xsl:text>
						<xsl:for-each select="units:UnitFactor">
							<xsl:if test="position()&gt;1">
								<xsl:text>⋅</xsl:text>
							</xsl:if>
							<xsl:text>*</xsl:text>
							<xsl:value-of select="@unit"/>
							<xsl:text>*</xsl:text>
							<xsl:if test="@exponent">
								<xsl:text>^(</xsl:text>
								<xsl:value-of select="@exponent"/>
								<xsl:text>)</xsl:text>
							</xsl:if>
						</xsl:for-each>
						<xsl:text> |</xsl:text>
					</xsl:for-each>
					<xsl:text>

</xsl:text>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="units:Number">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="units:Pi">
		<xsl:text>π</xsl:text>
	</xsl:template>

	<xsl:template match="units:Add">
		<xsl:text>Add</xsl:text>
	</xsl:template>
	
	<xsl:template match="units:Sub">
		<xsl:text>Sub</xsl:text>
	</xsl:template>
		
	<xsl:template match="units:Mul">
		<xsl:text>Mul</xsl:text>
	</xsl:template>
		
	<xsl:template match="units:Div">
		<xsl:text>Div</xsl:text>
	</xsl:template>
		
	<xsl:template match="units:Pow">
		<xsl:text>Pow</xsl:text>
	</xsl:template>
		
	<xsl:template match="units:Log">
		<xsl:text>Log</xsl:text>
	</xsl:template>
	
	<xsl:template match="units:Neg">
		<xsl:text>Neg</xsl:text>
	</xsl:template>
	
	<xsl:template match="units:Inv">
		<xsl:text>Inv</xsl:text>
	</xsl:template>
		
	<xsl:template match="units:Lg2">
		<xsl:text>Lg2</xsl:text>
	</xsl:template>
	
	<xsl:template match="units:Pow2">
		<xsl:text>Pow2</xsl:text>
	</xsl:template>
	
	<xsl:template match="units:Sqr">
		<xsl:text>Sqr</xsl:text>
	</xsl:template>
	
	<xsl:template match="units:Sqrt">
		<xsl:text>Sqrt</xsl:text>
	</xsl:template>
	
	<xsl:template match="units:Lg">
		<xsl:text>Lg</xsl:text>
	</xsl:template>
	
	<xsl:template match="units:Pow10">
		<xsl:text>Pow10</xsl:text>
	</xsl:template>
	
	<xsl:template match="units:Ln">
		<xsl:text>Ln</xsl:text>
	</xsl:template>
		
	<xsl:template match="units:Exp">
		<xsl:text>Exp</xsl:text>
	</xsl:template>
	
	<xsl:template match="units:LgB">
		<xsl:text>LgB</xsl:text>
	</xsl:template>
	
	<xsl:template match="units:PowB">
		<xsl:text>PowB</xsl:text>
	</xsl:template>

</xsl:stylesheet>
