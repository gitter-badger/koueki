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

For a quick setup, simply run `docker-compose up` from the `docker` directory.

to install on a bare system:

Requirements
- Elixir Runtime (see [the elixir install page](https://elixir-lang.org/install.html))
- Postgres (in nearly all distribution repositories)

Once you have these two, you'll want to set up a new postgres user

```
psql (11.1)

postgres=# create user koueki with password 'make_this_complex' createdb;
CREATE ROLE
```

Now please follow the instructions given in the [#configuration](configuration) section.

Once you've done that, we can install the actual application. 

**NOTE!!** When updating and running the application, *always* make sure
`MIX_ENV` is exported (or you'll use the wrong config files)

```bash
export MIX_ENV=prod

# Retrieve depencies
mix deps.get

# Create the database 
mix ecto.create
# Things will compile here - might take a bit

# Update the schema
mix ecto.migrate

# Add your first user
mix Koueki.User new my_user@example.com my_password

# It'll make you create an organisation - don't worry,
# this can be edited later

# start up the server to make sure everything is ok
mix phx.server
```

You can now check that everything is ok by visiting http://localhost:4000/

To run as a daemon, install the systemd file located in the `doc/` directory. You'll
probably want to route through nginx, so I've also provided a template for that.

## Configuration

All configuration is done in the `config/` directory.

Create the file `config/prod.secret.exs`

```elixir
use Mix.Config

config :koueki, Koueki.Repo,
  username: "koueki",
  password: "your_db_password",
  database: "koueki_prod",
  hostname: "localhost",
  pool_size: 10

config :koueki, :instance,
  name: "My Koueki",
  signup_enabled: true
```

All keys should be relatively self-explanatory.
