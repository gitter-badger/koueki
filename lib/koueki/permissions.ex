defimpl Canada.Can, for: Koueki.User do
  # Defines user permissions

  # When user is admin, everything is possible! 
  def can?(%Koueki.User{role: %Koueki.Role{is_global_admin: true}}, _, _), do: true

  # When user is org admin, only assert that org id matches
  def can?(%Koueki.User{org_id: org_id, role: %Koueki.Role{is_org_admin: true}}, _, %{
        org_id: org_id
      }),
      do: true

  # When user can manage org events, again only assert that org matches
  def can?(
        %Koueki.User{org_id: org_id, role: %Koueki.Role{can_modify_org_events: true}},
        _,
        %Koueki.Event{org_id: org_id}
      ),
      do: true

  # When user can manage own events, only assert that user ID matches
  def can?(
        %Koueki.User{id: user_id, role: %Koueki.Role{can_modify_own_events: true}},
        _,
        %Koueki.Event{user_id: user_id}
      ),
      do: true

  # All or nothing on sync role
  def can?(%Koueki.User{role: %Koueki.Role{can_modify_sync: sync}}, _, %Koueki.Server{}),
    do: sync

  def can?(%Koueki.User{role: %Koueki.Role{can_tag: tag}}, :tag, _), do: tag

  # When the user is part of the org that created the event, they should
  # always be able to see it
  def can?(%Koueki.User{org_id: org_id}, :read, %Koueki.Event{org_id: org_id}), do: true

  # When distribution is set to 1 "This Community Only", if the org is local
  # they can see it
  def can?(%Koueki.User{org: %Koueki.Org{local: local}}, :read, %Koueki.Event{distribution: 1}),
    do: local

  # When distribution is 2, "Connected Communities", access to this instance implies
  # ability to read
  def can?(%Koueki.User{}, :read, %Koueki.Event{distribution: 2}), do: true

  # "All Communities" - unconditional read
  def can?(%Koueki.User{}, :read, %Koueki.Event{distribution: 3}), do: true

  # Sharing group access
  # If user org is a member of the sharing group in the event, allow
  def can?(%Koueki.User{org_id: org_id}, :read, %Koueki.Event{
        distribution: 4,
        sharing_group: %Koueki.SharingGroup{member_orgs: members}
      }) do
    members
    |> Enum.map(fn x -> x.id end)
    |> Enum.member?(org_id)
  end

  # Fallback - if nothing above matched, assume the user *cannot* do it
  def can?(_, _, _), do: false
end
