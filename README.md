# Koueki

*公益, the public good*

Good security comes with transparency.

## What is it?

A lightweight, unrestricted threat intelligence sharing server,
using the MISP format.

This project will implement what I view as the minimum viable
set of features from MISP, and slowly build from there.

Notably, features I will *not* consider a part of that set are
those that restrict sharing or visibility. Other features,
such as the `analysis` attribute of events should be used
to inform others of if they should act on an attribute alone.


## Motivation

Having been an active contributor to MISP for the past 3 years,
I've watched the project increasingly be stifled by corporate
interests demanding features that only they would ever use,
and total backwards compatibility, at the expense of the
project's consistency. 

I believe the project is now too far gone to be recovered from
the spaghetti logic demanded by such a high set of restrictions.

The MISP format is currently the nicest threat sharing format
in active use - the only viable alternative is STIX, which
I've spent enough time with to believe is not worth pursuing.
Additionally the adoption of MISP is high enough to be the
de-facto indicator sharing system in Europe. Hence I want
to use that as a base to work from - by remaining compatible
with PyMISP pre-existing tools can be ported with nothing more
than a URL switch.

I also believe the sharing restrictions of MISP are primarily
used to create "paid feeds" - walling off some valuable
information behind extortionate fees. I believe the best
way to do security is for everyone to know everything. If
we hide potentially vital information for material gain,
what are we even working for? Do we want a more secure world,
or an insecure world that we can nickle and dime out of everything it
has with flashy press releases and scare tactics? 

## Installation

TODO
