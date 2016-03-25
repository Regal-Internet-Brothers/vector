vector
======

## Description
The standard vector module for most [Monkey code](https://github.com/blitz-research/monkey) publicly available from both the Regal Internet Brothers, and Sonickidnextgen/ImmutableOctet.

**Requirements:**
* ['util'](https://github.com/Regal-Internet-Brothers/util): The standard vector implementations utilize the 'util' module's container/array management code.

**Optional Dependencies:**
* ['ioelement'](https://github.com/Regal-Internet-Brothers/ioelement): All standard vector implementations can optionally support the 'SerializableElement' interface.
	* ['brl.stream'](https://github.com/blitz-research/monkey/blob/develop/modules/brl/stream.monkey): Used for standard serialization via the 'ioelement' module's 'SerializableElement' interface.

* 'supportlayer' (Local module): Can be partially toggled using the 'VECTOR_TYPEFIXES' and/or 'VECTOR_SUPPORTLAYER_TYPEFIXES' preprocessor variables.
	* ['boxutil'](https://github.com/Regal-Internet-Brothers/boxutil): Used for handling the standard "box" classes.

**References:**
* [V. Lehtinen's vector implementation](http://www.monkey-x.com/Community/posts.php?topic=8998).

##### Documentation notes (README)
* Any entries offset from the current entry by one 'TAB' character will act as a requirement for the entry one step above. If no sub-entries are present, then either there aren't extra requirements, or there isn't sufficient documentation.
* If a sub-entry is described as explicitly optional (Or required), that notation will take priority. This also goes for instances where entire sections are defined as optional or required.

## Installation
This module is officially distributed with the [Regal Modules](https://github.com/Regal-Internet-Brothers/regal-modules#regal-modules) project. To install this module, please follow the installation guide provided with that repository.
