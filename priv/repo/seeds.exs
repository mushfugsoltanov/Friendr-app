alias Friendr.{Repo, Interest.Topic}

[%{name: "Politics"}, %{name: "Sports"}, %{name: "Science"}, %{name: "Culture"}]
|> Enum.map(fn topic_name -> Topic.changeset(%Topic{}, topic_name) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)
