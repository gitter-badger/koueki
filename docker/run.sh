rm /koueki/config/prod.secret.exs
ln -s /var/run/secrets/config /koueki/config/prod.secret.exs

/usr/bin/wait-for postgres:5432

mix ecto.create
mix ecto.migrate

mix koueki.User exists $ADMIN_USERNAME
if [ $? -eq 1 ]; then
    mix Koueki.Org new "$ORG_NAME"
    mix Koueki.User new $ADMIN_USERNAME --orgname "$ORG_NAME" > logs/ADMIN_USER
fi

mix phx.server
