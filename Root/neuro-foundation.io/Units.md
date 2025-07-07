Title: Units
Description: Units page of neuro-foundation.io
Date: 2025-06-26
Author: Peter Waher
Master: Master.md

=============================================

Units
========

This document outlines the XML representation of unit definitions, and describes the
algorithms necessary to perform unit conversions in an interoperable manner.
The XML representation is modelled using an annotated XML Schema:

| Sensor Data                                      ||
| -------------|------------------------------------|
| Namespace:   | `urn:nf:iot:u:1.0`                 |
| Schema:      | [Units.xsd](Schemas/Units.xsd)     |
| Definitions: | [Units.xml](Definitions/Units.xml) |

![Table of Contents](toc)

Motivation and design goal
----------------------------

The representation of units described in this document, is designed with the following goals in mind:

* Most known physical units must be representable using the model.

* Unit presentations must be compact and easy to read, both for humans and machines.

* Machines must be able to perform unit conversions between compatible units based on the
definitions made.

* The representation must be **extensible**. New units and unit systems must be able to be 
added.

* It must be possible to communicate using units outside of the scope of the set of units
defined. In such cases, unit conversion will not be possble.

* Unit conversions must support linear and non-linear conversions.

* The unit conversion must be easily reversible.

Conceptual model
-------------------

The XML representation of Units and conversion rules used by the Neuro-Foundation IoT interfaces 
is based on the following abstraction:

```uml:Conceptual model
@startuml
left to right direction
"Unit Category" "1" *-- "1" "Reference Unit"
"Unit Category" "1" *-- "*" Unit
"Unit Category" "1" *-- "*" "Compound Unit"
"Unit Category" : name : string

Unit : name : string
"Reference Unit" : name : string
"Reference Unit" "1" *-- "0..1" "Derivation"
note on link
	Derivation shows how
	the reference unit is
	derived from base (SI)
	units.
end note


"Derivation" "1" *-- "*" "Unit Factor"

"Unit Factor" : factor : double
"Unit Factor" : unit : string
"Unit Factor" : exponent : double

"Compound Unit" "1" *-- "*" "Unit Factor"
note on link
	Defines the the compund
	unit as a product of a
	factor, and a set of
	units with corresponding
	exponents.
end note

Unit "0" *-- "*" "RPN Operation"
note on link
	Operations performed 
	sequentially, top-down,
	to convert unit to the
	reference unit. Inverse
	operations performed 
	bottom-up, converts the
	reference unit to the
	specified unit.
end note

"RPN Operation" <|-- Number
Number : value : double
"RPN Operation" <|-- Constant
Constant <|-- Pi

"RPN Operation" <|-- "RPN Operand"
"RPN Operand" <|-- "Binary Operand"
"RPN Operand" <|-- "Unary Operand"

"Unary Operand" <|-- Neg
"Unary Operand" <|-- Inv
"Unary Operand" <|-- Lg2
"Unary Operand" <|-- Pow2
"Unary Operand" <|-- Sqrt
"Unary Operand" <|-- Lg
"Unary Operand" <|-- Pow10
"Unary Operand" <|-- Ln
"Unary Operand" <|-- Exp
"Unary Operand" <|-- "Unary Operand Base"
"Unary Operand Base" <|-- LgB
"Unary Operand Base" <|-- PowB
"Unary Operand Base" : base : positiveInteger

"Binary Operand" <|-- Add
"Binary Operand" <|-- Sub
"Binary Operand" <|-- Mul
"Binary Operand" <|-- Div
"Binary Operand" <|-- Pow
@enduml
```

A **Unit Category** represents a set of units that are *compatible* in the sense they can be
used to represent the same physical quantity and can be converted between each other. Each Unit 
Category defines exactly one **Reference Unit**. This should be the SI unit, if applicable, or 
contain a **derivation** from SI units, or similar well-known unit if SI units are not available 
for the corresponding physical quantity. If a derivation does not exist, it is assumed that the
reference unit is a **base unit**. The name of a unit category should be a human-readable string 
that describes the physical quantity represented by the units. It is not used in unit conversion, 
communication, or user interfaces. It is available only for documentation purposes.

After the reference unit, the Unit Category can define any number of additional Units. There are 
two types: The regular **Unit** and the **Compound Unit**. Each unit is referenced to by its 
name, which should correspond to the short-hand form used when expressing physical quantities, 
for example `m` for meters, `g` for grams, `s` for seconds, etc.

Normal Unit objects define a set of [Reverse Polish Notation](https://en.wikipedia.org/wiki/Reverse_Polish_notation)
**Operations** that converts a value expressed using the unit, to the corresponding value
expressed using the reference unit associated with the unit category. The Reverse Polish 
Notation used in the conversion definition allows us to define the conversion without having
to implement a specific expression parser. It also permits easy-to-implement algorithms both for
converting a unit to the reference unit, but also the reverse, convert a reference unit to the
specific unit.

**Note**: Any unit definition lacking operations defined, is assumed to be equivalent to the 
reference unit for that unit category.

Compund units on the other hand, define only a set of implicit **Unit Factors**. Each unit 
factor defines a unit, an exponent, and a factor. The compound unit is the product of the
factor and the referenced units raised to the corresponding exponent. Unit conversion is 
performed by converting the individual factors. By looking up each of the unit factors, each
compound unit can be reduced to a product of a factor and a set of base units, raised to a
corresponding exponent.

Conversion Operation
-----------------------

Evaluating the RPN operations top-down converts a floating-point number expressed using the unit,
to a floating-point number expressed using the reference unit. The operations are listed using
*Reverse Polish Notation*, where numbers are pushed onto a stack, and operations pop the required
number of operands from the stack, perform the operation, and push the result back onto the stack.
Before the operation, the value being converted from is pushed as the first and only number on
the stack. After the operations, the top-most value on the stack (which should be the only value
on the stack) is the conversion result.

Evaluating the RPN operations bottom-up converts a floating-point number expressed using the
reference unit, to a floating-point number expressed using the specific unit. But instead of
pushing numbers to the stack, binary operations are pushed on the stack, and number values pop
operations from the stack and execute the inverse operation. Unary operations are executed in
its inverse form directly on the top-most value on the stack, replacing the top-most value with
the result.

**Note**: Unit conversion defined by the operations are based on the values without prefixes.
If values are expressed using prefixes, such as `k` for kilo, `M` for mega, etc., the prefix
needs to be applied before conversion, and a suitable prefix selected after conversion. A
similar consideration needs to be taken into account for the number of significant digits in
the value, if expressed as a human-readable string.

Operations
-------------

The following operations are defined in the XML schema, and can be used in the unit conversions.
The description describes the operator when executed from top to bottom. The elements on the 
stack are referred to as S[-1] as the topmost element (before the execution of an operator),
and S[-2] as the element below the topmost element (before the execution of an operator).


| Operation | Type                | Description |
|:----------|:--------------------|:------------|
| `Number`  | `xs:double`         | Pushes a number onto the stack. |
| `Pi`      | `Constant`          | Pushes *π* onto the stack. |
| `Add`     | `BinaryOperator`    | Pops the two topmost elements from the stack, adds them *S*[-2] + *S*[-1], and pushes the result onto the stack. |
| `Sub`     | `BinaryOperator`    | Pops the two topmost elements from the stack, subtracts them *S*[-2] - *S*[-1], and pushes the result onto the stack. |
| `Mul`     | `BinaryOperator`    | Pops the two topmost elements from the stack, multiplies them *S*[-2] * *S*[-1], and pushes the result onto the stack. |
| `Div`     | `BinaryOperator`    | Pops the two topmost elements from the stack, divides them  *S*[-2] / *S*[-1], and pushes the result onto the stack. |
| `Pow`     | `BinaryOperator`    | Pops the two topmost elements from the stack, Raises one to the other *S*[-2]^(*S*[-1]), and pushes the result onto the stack. |
| `Log`     | `BinaryOperator`    | Pops the two topmost elements from the stack, computes the logarithm *log*[*S*[-2]]\(*S*[-1]), and pushes the result onto the stack. |
| `Neg`     | `UnaryOperator`     | Pops the topmost element from the stack, negates it, and pushes the result onto the stack. |
| `Inv`     | `UnaryOperator`     | Pops the topmost element from the stack, inverts it, and pushes the result onto the stack. |
| `Lg2`     | `UnaryOperator`     | Pops the topmost element from the stack, calculates the base-2 logarithm of it *log*[2]\(*S*[-1]), and pushes the result onto the stack. |
| `Pow2`    | `UnaryOperator`     | Pops the topmost element from the stack, raises 2 to the power of it 2^(*S*[-1]), and pushes the result onto the stack. |
| `Sqrt`    | `UnaryOperator`     | Pops the topmost element from the stack, computes the square root of it *sqrt*(*S*[-1]), and pushes the result onto the stack. |
| `Lg`      | `UnaryOperator`     | Pops the topmost element from the stack, calculates the base-10 logarithm of it *log*[10]\(*S*[-1]), and pushes the result onto the stack. |
| `Pow10`   | `UnaryOperator`     | Pops the topmost element from the stack, raises 10 to the power of it 10^(*S*[-1]) it, and pushes the result onto the stack. |
| `Ln`      | `UnaryOperator`     | Pops the topmost element from the stack, calculates the natural logarithm of it *ln*(*S*[-1]), and pushes the result onto the stack. |
| `Exp`     | `UnaryOperator`     | Pops the topmost element from the stack, calculates the natural exponent of it *exp*(*S*[-1]), and pushes the result onto the stack. |
| `LgB`     | `UnaryOperatorBase` | Pops the topmost element from the stack, calculates the base-B logarithm of it *log*[B]\(*S*[-1]), and pushes the result onto the stack, where *B*s is a positive integer. |
| `PowB`    | `UnaryOperatorBase` | Pops the topmost element from the stack, raises *B* to the power of it *B*^(*S*[-1]) it, and pushes the result onto the stack, where *B* is a positive integer. |


Inverted Operations
----------------------

The inverted operations are the inverse of the above operations, and are used to convert a value
from the reference unit to the specific unit. The inverted operations are evaluated bottom-up,
and are evaluated as follows. Note that binary operations push their inverted operation on the
stack. A number checks the topmost element on the stack. If it is a binary operator is on the
stack, that operator is popped and executed on 
are pushed on the stack, while numbers
pop the operations from the stack and execute them. Unary operations are executed directly.

| Operation | Inversion |
|:----------|:----------|
| `Number`  | `Number`  |
| `Pi`      | `Pi`      |
| `Add`     | `Sub`     |
| `Sub`     | `Add`     |
| `Mul`     | `Div`     |
| `Div`     | `Mul`     |
| `Pow`     | `Log`     |
| `Log`     | `Pow`     |
| `Neg`     | `Neg`     |
| `Inv`     | `Inv`     |
| `Lg2`     | `Pow2`    |
| `Pow2`    | `Lg2`     |
| `Sqr`     | `Sqrt`    |
| `Sqrt`    | `Sqr`     |
| `Lg`      | `Pow10`   |
| `Pow10`   | `Lg`      |
| `Ln`      | `Exp`     |
| `Exp`     | `Ln`      |
| `LgB`     | `PowB`    |
| `PowB`    | `LgB`     |

Example
-----------

Consider the unit category definition for `Temperature`:

```xml
<Category name="Temperature">
	<ReferenceUnit name="K"/>
	<Unit name="°C">
		<Number>273.15</Number>
		<Add/>
	</Unit>
	<Unit name="°F">
		<Number>32</Number>
		<Sub/>
		<Number>5</Number>
		<Mul/>
		<Number>9</Number>
		<Div/>
		<Number>273.15</Number>
		<Add/>
	</Unit>
</Category>
```

We want to convert 50° F to °C. We follow the operations defined for the °F unit to convert the
value to the reference unit, which is K:

| Operation                 | *S*[-1] | *S*[-2] |
|:--------------------------|--------:|--------:|
| Converting from           |      50 |         |
| `<Number>32</Number>`     |      32 |      50 |
| `<Sub/>`                  |      18 |         |
| `<Number>5</Number>`      |       5 |      18 |
| `<Mul/>`                  |      90 |         |
| `<Number>9</Number>`      |       9 |      90 |
| `<Div/>`                  |      10 |         |
| `<Number>273.15</Number>` |  273.15 |      10 |
| `<Add/>`                  |  283.15 |         |

So, we have calculated that 50° F = 283.15 K. Now we need to do the reverse operation to convert
the Kelvin value to °C, remembering that binary operations have their inverted operation pushed 
to the stack and numbers pop the
operations.

| Operation                 | *S*[-1]  | *S*[-2] |
|:--------------------------|---------:|--------:|
| Converting from           |  283.15  |         |
| `<Add/>`                  | `<Sub/>` |  283.15 |
| `<Number>273.15</Number>` |      10  |         |

The result is 10° C. If we attempt to convert 10° C back to °F, we use the operations defined
for the Celcius unit:

| Operation                 | *S*[-1] | *S*[-2] |
|:--------------------------|--------:|--------:|
| Converting from           |      10 |         |
| `<Number>32</Number>`     |  273.15 |      10 |
| `<Add/>`                  |  283.15 |         |

So, 10° C = 283.15 K. We do the inverse calculation defined for the Fahrenheit unit, to convert
this value to Fahrenheit:

| Operation                 | *S*[-1]  | *S*[-2] |
|:--------------------------|---------:|--------:|
| Converting from           |  283.15  |         |
| `<Add/>`                  | `<Sub/>` |  283.15 |
| `<Number>273.15</Number>` |      10  |         |
| `<Div/>`                  | `<Mul/>` |      10 |
| `<Number>9</Number>`      |      90  |         |
| `<Mul/>`                  | `<Div/>` |      90 |
| `<Number>5</Number>`      |      18  |         |
| `<Sub/>`                  | `<Add/>` |      18 |
| `<Number>32</Number>`     |      50  |         |

And the result is 50° F.
