# Code Standards

## Quick Review Checklist

This checklist is intended to be a short hand guide for when reviewing ones own
code or another's code.  It is by no means a comprehensive list of everything
to consider when reviewing code.  Nor is it intended to be a set of hard and
fast rules.  It is merely a list of guidelines, rules of thumb, and discussion
starters to keep in mind when performing a code review. 

- [ ] Except where dictated by libraries, code uses proper casing 
- [ ] Names are accurate, unambiguous, and descriptive
- [ ] Doc blocks are thorough and describe code intent
- [ ] Don't let anonymous hashes travel multiple scopes
- [ ] Options hashes should have defaults 

## Except Where Dictated by Libraries, Code Uses PMC Casing

We use a different casing style for each level of the code so that we can tell,
at a glance, what we're dealing with.

- Constants use ALL\_CAPS\_UNDERSCORE\_CASE
- Properties and variables use underscore\_case 
- Methods and function use camelCase
- Classes and Namespaces use StudlyCase

Sometimes libraries prevent us from using our preferred casing, but, otherwise,
we should stick to this casing schema.

## Names are Accurate, Unambiguous, and Descriptive

Names should be clear and concise.  If given the choice between an ambiguous
shorter name and a clearer longer name, always choose clarity. If you believe
Robert Martin, the ratio of time spent reading code to time spent writing it is
well over 10 to 1.  Which means it makes far more sense to prioritize ease of
reading over ease of writing.  You'll thank yourself later.

For some basic examples, given a choice between ``counter`` 
and ``widget_counter``, choose ``widget_counter``.  

When naming methods, consider how the method will read when being called.  For
instance, a ``render`` method on a view reads with perfect clarity
(``plant_view.render()``), but a ``parse`` method may leave a question in the
reader's head ("``plant_view.parse()``? What are we parsing?").  The assumption
is a template, but clarifying that saves the reader's brain a few cycles
(``plant_view.parseTemplate()``).

## Doc Blocks are Thorough and Describe Code Intent

All methods should have doc blocks that describe what parameters the method
takes, what it returns, what it throws, and include a short paragraph
describing what the method's intended task is as well as any side effects it
has.

When documenting the parameters a method takes, keep in mind that the doc
blocks should allow a coder reading them to treat the method as a black box.
It should describe exactly what parameters the method takes -- and all
permutations there in -- and exactly what the method will return.  That means
the structure of complex parameters like arrays or hashes should be thoroughly
documented.

So, for example, instead of doing this:

```javascript
/**
 * A method to clean up victims of the Black Plague.
 * 
 * @param   {Person}    body    The body to be picked up.
 * @param   {object}    options An options hash.
 * @return  {Number}    The number of bodies collected.
 */
 pickupDead: function(body, options) {}
```

Do this:

```javascript
/**
 * A method to clean up victims of the Black Plague.
 *
 * @param   {Person}    body    The body to be picked up. 
 * @param   {object}    options An options hash with the following structure:
 *      refuseLiving    - boolean, default: false, when true always refuse to
 *        accept anyone still living.
 *      call            - string, default: "Bring out your dead!", what to call
 *        out when collecting. 
 * @return  {Number}    The number of bodies collected.
 */
 pickupDead: function(body, options) {}
```

Where appropriate, objects should also have doc blocks that describe the
objects purpose and give usage examples.  Some objects -- such as basic models
and views building on the frameworks -- are self explanatory and do not need
doc blocks.  Their usage is described by the backing frameworks.  

For our own services, however, including a doc block with usage examples is a
good idea.  A good example comes from the ``PlantCsvParsingService``:

```ruby
##
# Author:: Daniel Bingham <dbingham@theroadgoeson.com>
# License:: MIT
#
# Service class that parses plant CSV data files and saves them to the
# database.  
#
# Usage:
#
# ```
# csvService = PlantCSVParsingService.new
# csvService.parseCSVFile(filename)
# ```
# Alternately, if the CSV file has already been parsed into individual lines,
# you can parse it a line at the time by passing each line to
# ``parsePlant``:
#
# ```
# csvService = PlantCSVParsingService.new;
# lines = csv_data_string.split("\n");
# lines.each do |line|
#      csvService.parsePlant(line)
# end 
# ```
#
class PlantCsvParsingService
```

## Don't Let Hashes Travel Multiple Scopes

Hashes are a handy tool, but they can become a double edged sword if they are
allowed to travel too far through multiple scopes.  They quickly become a
problem when they travel too far from their point of definition, because it
becomes difficult to tell exactly what their structure is.  That leaves someone
trying to understand the code in the position of needing to inspect it in a
debugger -- and even then, not sure whether the hash's current structure will
be consistent in each call and situation -- or else traveling back through the
call stack and potentially reading a lot of code trying to find the hash's
definition.

To avoid this situation, it is better to avoid anonymous hashes if they are
going to end up passed through more than one scope.  If a hash is being passed
into two or more scopes, then make it an object, give it a name, give its
properties defaults, and document them. 

## Options Hashes Should Have Defined Defaults 

When using options hashes, their structure should be documented by defining a
defaults hash.  A defaults hash should be defined at the top of any method
accepting an options hash.  It should contain each field the options hash
accepts.  It's fields should be commented to describe their purpose and use. 
