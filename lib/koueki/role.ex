defmodule Koueki.Role do
  use Ecto.Schema

  schema "roles" do
    field :name, :string
    # Org admins should be able to modify
    # any resource assigned to their org, including users!
    field :is_org_admin, :boolean, default: false
    # Global admins are just org admins that aren't restricted
    # to their own org's resources
    field :is_global_admin, :boolean, default: false
    # If this is true, users may edit events where event.user_id == user.id
    field :can_modify_own_events, :boolean, default: false
    # If this is true, users may edit any event belonging to their org
    field :can_modify_org_events, :boolean, default: false
    # If this is true, allow modification of the "published" flag
    field :can_publish_events, :boolean, default: false
    # Allow adding of existing tag resources to events/attrs
    field :can_tag, :boolean, default: false
    # Allow creation and modification of tag resources
    field :can_modify_tags, :boolean, default: false
    # Allow creation and modification of server resources
    field :can_modify_sync, :boolean, default: false
    field :default, :boolean, default: false

    has_many :users, Koueki.User
  end
end
