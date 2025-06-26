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
"Unit Category" "1" *-- "*" Unit
"Unit Category" : name : string
"Unit Category" "1" *-- "1" "Reference Unit"

Unit : name : string
"Reference Unit" : name : string

Unit "0" *-- "*" "RPN Operation"
"Reference Unit" .. "RPN Operation"
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
used to represent the same physical quantity. Each Unit Category defines exactly one 
**Reference Unit**. This should be the SI unit, if applicable, or similar well-known unit if
SI units are not available for the corresponding physical quantity. The name of a unit category
should be a human-readable string that describes the physical quantity represented by the units.
It is not used in unit conversion or communication, and is available only for documentation 
purposes.

Each **Unit** is represented by a unique Unit object associated with its Unit Category. The
unit is defined by its name, which should correspond to the short-hand form used when expressing
physical quantities, for example `m` for meters, `g` for grams, `s` for seconds, etc.

Each Unit defines a set of [Reverse Polish Notation](https://en.wikipedia.org/wiki/Reverse_Polish_notation)
**Operations** that converts a value expressed using the unit, to the corresponding value
expressed using the reference unit associated with the unit category. The Reverse Polish 
Notation used in the conversion definition allows us to define the conversion without having
to implement a specific expression parser. It also permits easy-to-implement algorithms both for
converting a unit to the reference unit, but also the reverse, convert a reference unit to the
specific unit.

**Note**: Each category should include the reference unit as a unit definition. The reference
unit definition however, must not have any operations defined. And any unit definition without
operations defined, is assumed to be equivalent to the reference unit for that unit category.

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

Examples
-----------

TBD
