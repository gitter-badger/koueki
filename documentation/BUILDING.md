# Building Koueki

## For docker

Requirements:
- [docker-compose](https://docs.docker.com/compose/install/)

First make sure you've set up `config/prod.secret.exs` as per
[the configuration section](./CONFIG.md) - make sure the database
credentials in `docker-compose.yml` match those in your config file!

Then simply run 

```bash
docker-compose up
```

And your containers will build and start. This will use a dockerised postgres
container which will store its data in `/data/koueki/db`. You can alternatively
point koueki at any other postgres database available over the network.

Your organisation and an administrative user will be created at startup with a random 
password - this will be saved in a file called `ADMIN_USER`, in the 
volume mounted to "/logs" - by default `/data/koueki/logs/`

Once docker-compose has finished doing its thing, koueki will be available at
http://localhost:4000

## For a bare server

Requirements
- Elixir Runtime (see [the elixir install page](https://elixir-lang.org/install.html))
- Postgres (in nearly all distribution repositories)
- NPM (in most repos, if not [see npmjs.com](https://www.npmjs.com/get-npm))

### Setting up the database

Please refer to [the database section](./DATABASE.md) for instructions on
how to set up your user.

Once this is done, make sure you configure your `.exs` file as per [the configuration section](./CONFIG.md).

### A note on environment variables

If you're running Koueki as an end-user, you'll want `MIX_ENV=prod` exported
at all times.

If you're a developer, not exporting the variable is fine and will launch
a development environment to help you do your thing.

The config files used by the application are based on your ENV variables -
`config/{ENV}.secret.exs` will be used (with dev being the fallback)


### Building the frontend

Koueki's frontend is a react.js application, to build it you'll need to
have npm.

```bash
# Install yarn, a better-than-npm package mangager (imo)
sudo npm i -g yarn

cd frontend
yarn && npx webpack -p 
# May take a while. Get a coffee.
cd ..
```

Now you'll have the frontend compiled.

### Building the backend

**Make sure you've configured your prod.secret.exs before doing this!**

```bash
export MIX_ENV=prod

# Retrieve depencies
mix deps.get
# Set up our database
mix ecto.create
mix ecto.migrate
```

### Adding your first user

```bash
mix Koueki.Org new "my organisation"
# Look at the ID of the org it created
mix Koueki.User new myusers@email.com --orgid the_id
```

This will generate a new user and organisation, and give you a temporary password
to log in.

### Running

```bash
mix phx.server
```

## Updating

If Koueki is updated, simply run a `git pull` on the repository and run

```bash
# For docker
git pull
docker build -t koueki .
docker-compose down
docker-compose up

# For a bare server
export MIX_ENV=prod
cd frontend && yarn && npx webpack -p && cd ..
mix deps.get
mix ecto.migrate
mix clean
mix compile
# And then restart your service.
```
