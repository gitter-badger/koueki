# Koueki

*公益, for the public benefit*

Good security comes with transparency, not walled gardens and paywalls.

## What is it?

A lightweight, unrestricted threat intelligence sharing server,
using the MISP format. It will not consider sharing groups or
visibility restrictions as valid and hence will not implement them.
(However it will honour externally-created restrictions)

Koueki provides consistent RESTful API alongside a PyMISP-compatible
"legacy" API.

This project will implement what I view as the minimum viable
set of features from MISP, and slowly build from there.

## Installation

You can either set up Koueki as a docker service or as a bare process on a server

Both are listed in [BUILDING.md](./documentation/BUILDING.md)
