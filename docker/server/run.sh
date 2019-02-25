sh write_config_file.sh
mix ecto.create
mix ecto.migrate
mix Koueki.Org initial $ORG_NAME
echo "mix Koueki.User new $INITIAL_USERNAME $INITIAL_PASSWORD"
mix Koueki.User new $INITIAL_USERNAME $INITIAL_PASSWORD
mix phx.server
