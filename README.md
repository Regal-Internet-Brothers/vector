vector
======

The standard vector module for most Monkey X code publicly available from both the Regal Internet Brothers, and Sonickidnextgen/ImmutableOctet.

**Requirements:**
* ['util'](https://github.com/Regal-Internet-Brothers/util): The standard vector implementations utilize the 'util' module's container/array management code.

**Optional Dependencies:**
* ['ioelement'](https://github.com/Regal-Internet-Brothers/ioelement): All standard vector implementations can optionally support the 'SerializableElement' interface.
{
	* ['brl.stream'](https://github.com/blitz-research/monkey/blob/develop/modules/brl/stream.monkey): Used for standard serialization via the 'ioelement' module's 'SerializableElement' interface.
}

**References:**
* [V. Lehtinen's vector implementation](http://www.monkey-x.com/Community/posts.php?topic=8998)

**Documentation notes:**
* Anything within brackets acts as a requirement for the associated entry. If no sub-entries are present, then either there aren't extra requirements, or there isn't sufficient documentation.
* If a sub-entry (Entry within brackets) is described as explicitly optional (Or required), that notation will take priority. This also goes for instances where sections are defined as optional or required.
