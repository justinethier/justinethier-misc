# Overview

Initial algorithm is to break the view up into a series of expressions. Raw contents of the view will be strings, probably part of a `display` expression so we write it to an output port.

Contents of a scheme expression will be taken verbatim and optionally wrapped in a `display`.


# Template Syntax

Loosely based off of Jinja (Django?) templates:
https://jinja.palletsprojects.com/en/2.11.x/templates/#variables


{% ... %} for Statements (no output)

{{ ... }} for Expressions to print to the template output

{# ... #} for Comments not included in the template output

# Pseudocode

higher-level subsystem
read next char from buf
terminate current expr if
- read start of scheme expression
- read eof

Buffer subsystem
read x chars from stream
read more if necessary

