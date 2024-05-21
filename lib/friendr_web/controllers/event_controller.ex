defmodule FriendrWeb.EventController do
  use FriendrWeb, :controller

  alias Friendr.Meets
  alias Friendr.Meets.Event
  alias Friendr.Meets.EventTopic
  alias Friendr.Repo
  alias Friendr.Interest
  alias Friendr.Interest.Topic
  alias Friendr.Accounts.UserEvent
  alias Friendr.Accounts.User


  import Ecto.Query


  def index(conn, %{"search_text" => search_text} = _params) do
    current_user = conn.assigns.current_user
    current_user_id = current_user.id
    topics = Repo.all(Topic)
    changeset = User.changeset(current_user, %{})

    public_events = from e in Friendr.Meets.Event,
                    where: e.is_public == true and ilike(e.name, ^"#{search_text}%")

    private_events = from e in Friendr.Meets.Event,
                     join: ue in Friendr.Accounts.UserEvent,
                     on: e.id == ue.event_id and ue.user_id == ^current_user_id,
                     where: e.is_public == false and ue.status == 0 and ilike(e.name, ^"#{search_text}%")


    public_events = Repo.all(public_events)
    private_events = Repo.all(private_events)

    combined_events = public_events ++ private_events

    events_with_distance =
      combined_events
      |> Repo.preload(:topics)
      |> Enum.map(fn event ->
        event_location = event.location
        distance = Friendr.Geolocation.distance(current_user.location, event_location)
        Map.put(event, :distance, distance)
      end)
      |> Enum.filter(fn event ->
        event.distance <= 10
      end)
      |> Enum.sort_by(fn event ->
        event.distance
      end)

    render(conn, :index, events: events_with_distance, user: current_user, changeset: changeset, topics: topics)
  end

  def update_location_event(conn, %{"user" => user_params}) do
    user = conn.assigns.current_user
    changeset = User.changeset(user, user_params)
    Repo.update(changeset)
    topics = Repo.all(Topic)

    case Repo.update(changeset) do
      {:ok, _user} ->
        conn
       |> put_flash(:info, "Your location updated successfully")
       |> redirect(to: ~p"/events")

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Failed to update the user location.")
        |> render("index.html", changeset: changeset, search_text: nil, topics: topics)
      end
  end


  def index(conn, _params) do
    current_user = conn.assigns.current_user
    current_user_id = current_user.id
    changeset = User.changeset(current_user, %{})
    topics = Repo.all(Topic)

    public_events = from e in Friendr.Meets.Event,
                    where: e.is_public == true

    private_events = from e in Friendr.Meets.Event,
                     join: ue in Friendr.Accounts.UserEvent,
                     on: e.id == ue.event_id and ue.user_id == ^current_user_id,
                     where: e.is_public == false


    public_events = Repo.all(public_events)
    private_events = Repo.all(private_events)

    combined_events = public_events ++ private_events

    events_with_distance =
      combined_events
      |> Repo.preload(:topics)
      |> Enum.map(fn event ->
        event_location = event.location
        distance = Friendr.Geolocation.distance(current_user.location, event_location)
        Map.put(event, :distance, distance)
      end)
      |> Enum.filter(fn event ->
        event.distance <= 10
      end)
      |> Enum.sort_by(fn event ->
        event.distance
      end)

    render(conn, :index, events: events_with_distance, user: current_user, changeset: changeset, topics: topics)
  end

  def new(conn, _params) do
    changeset = Meets.change_event(%Event{})
    topics = Repo.all(Topic)

    render(conn, :new, topics: topics, changeset: changeset)
  end

  def create(conn, %{"event" => event_params, "topics" => topics, "event_list" => event_list}) do
    user = conn.assigns.current_user
    current_user=conn.assigns.current_user

    emails = String.split(event_list, " ")

    topics_as_numbers = Enum.map(topics, &String.to_integer/1)

    case Meets.create_event(Map.put(event_params, "user_id", user.id)) do
      {:ok, event} ->
        event_id = event.id

        if emails != [""] do
          emails = case Enum.member?(emails, user.email) do
            true -> emails
            false -> [user.email | emails]
          end

          Enum.map(emails, fn email ->
            user = Repo.get_by(Friendr.Accounts.User, email: email)
            case user do
              nil ->
                conn
                |> put_flash(:error, "User #{email} does not exist.")
                |> redirect(to: ~p"/events/new")
              _ ->
                Repo.insert(%UserEvent{
                  status: if user.id == current_user.id do
                    2
                  else
                    0
                  end,
                  user_id: user.id,
                  event_id: event.id
                })
            end
          end)

        else
          Repo.insert(%UserEvent{
            status: 2,
            user_id: user.id,
            event_id: event.id
          })
        end

        Enum.map(topics_as_numbers, fn topic_id ->
          Repo.insert(%EventTopic{
            topic_id: topic_id,
            event_id: event_id
          })
        end)

        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: ~p"/events/#{event}")

      {:error, %Ecto.Changeset{} = changeset} ->
        topics = Repo.all(Topic)
        render(conn, :new, topics: topics, changeset: changeset)
    end
  end


  def show(conn, %{"id" => id}) do
    user = conn.assigns.current_user

    event = Meets.get_event!(id)
            |> Repo.preload([:topics, comments: :author])
            |> Repo.preload(:comments)



    event_creator = Friendr.Accounts.User |> Repo.get(event.user_id)

    engagement_status_query = from ue in Friendr.Accounts.UserEvent,
                              where: ue.user_id == ^user.id and ue.event_id == ^event.id,
                              select: ue.status

    engagement_status = Repo.one(engagement_status_query)



    render(conn, :show, event: event, user: user, engagement_status: engagement_status, event_creator: event_creator.name)
  end




  def edit(conn, %{"id" => id}) do
    event = Meets.get_event!(id) |> Repo.preload(:topics)
    topics = Repo.all(Topic)

    changeset = Meets.change_event(event)

    event_id = event.id
        query = from ue in Friendr.Accounts.UserEvent,
        join: e in Friendr.Meets.Event,
        on: e.id == ue.event_id,
        join: u in Friendr.Accounts.User,
        on: u.id == ue.user_id,
        where: e.id == ^event_id and e.is_public == false,
        select: u.email

    user_emails = Repo.all(query)

    user_emails_string = Enum.join(user_emails, " ")

    render(conn, :edit, event: event, topics: topics, changeset: changeset, user_emails: user_emails_string)
  end

  def update(conn, %{"id" => id, "event" => event_params, "topics" => topics, "event_list" => event_list}) do
    user = conn.assigns.current_user
    current_user=conn.assigns.current_user
    event = Meets.get_event!(id)

    emails = String.split(event_list, " ")

    topics_as_numbers = Enum.map(topics, &String.to_integer/1)

    case Meets.update_event(event, event_params) do
      {:ok, event} ->
        event_id = event.id

        query = from ue in Friendr.Accounts.UserEvent,
                join: e in Friendr.Meets.Event,
                on: e.id == ue.event_id,
                where: e.id == ^event_id and e.is_public == false

        events_to_delete = Repo.delete_all(query)

        if emails != [""] do
          emails = case Enum.member?(emails, user.email) do
            true -> emails
            false -> [user.email | emails]
          end

          Enum.map(emails, fn email ->
            user = Repo.get_by(Friendr.Accounts.User, email: email)
            case user do
              nil ->
                conn
                |> put_flash(:error, "User #{email} does not exist.")
                |> redirect(to: ~p"/events/new")
              _ ->
                Repo.insert(%UserEvent{
                  status: if user.id == current_user.id do
                    2
                  else
                    0
                  end,
                  user_id: user.id,
                  event_id: event.id
                })
            end
          end)

        else
          Repo.insert(%UserEvent{
            status: 2,
            user_id: user.id,
            event_id: event.id
          })
        end

        from(et in EventTopic, where: et.event_id == ^event_id)
        |> Repo.delete_all()

        Enum.map(topics_as_numbers, fn topic_id ->
          Repo.insert(%EventTopic{
            topic_id: topic_id,
            event_id: event_id
          })
        end)

        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: ~p"/events/#{event}")

      {:error, %Ecto.Changeset{} = changeset} ->
        topics = Repo.all(Topic)
        render(conn, :edit, event: event |> Repo.preload(event_topic: [:topic]), topics: topics, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Meets.get_event!(id)
    {:ok, _event} = Meets.delete_event(event)

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: ~p"/events")
  end

  def events_location(conn, _params) do
    user = conn.assigns.current_user
    current_user_id = user.id
    topics = Repo.all(Topic)
    public_events = from e in Friendr.Meets.Event,
                     where: e.is_public == true

    private_events = from e in Friendr.Meets.Event,
                      join: ue in Friendr.Accounts.UserEvent,
                      on: e.id == ue.event_id and ue.user_id == ^current_user_id,
                      where: e.is_public == false and ue.status == 0

    public_events = Repo.all(public_events)
    private_events = Repo.all(private_events)

    combined_events = public_events ++ private_events

    combined_events = combined_events |> Repo.preload(:topics)

    events = Enum.map(combined_events, fn event ->
      eventTopics = event.topics |> Enum.map(&(&1.name))
      %{
        location: Friendr.Geolocation.find_coordinates(event.location),
        name: event.name,
        price: event.price,
        location_txt: event.location,
        event_id: event.id,
        event_date: event.date,
        event_topics: eventTopics,
        is_public: event.is_public
      }
    end)

    user = conn.assigns.current_user
    user_location = %{
      location: Friendr.Geolocation.find_coordinates(user.location),
      name: user.name,
    }

    json_events = Jason.encode!(events)
    json_user_location = Jason.encode!(user_location)

    render(conn, :events_location, json_events_locations: json_events, json_user_location: json_user_location, topics: topics)
  end

  def my_events(conn, _params) do
    user = conn.assigns.current_user
    current_user_id = user.id

    user_events_query =
      from e in Friendr.Meets.Event,
      where: e.user_id == ^current_user_id


    user_events = Repo.all(user_events_query)

    case user_events do
      [] ->
        conn
        |> render(:my_events, user: user, user_events: [])

      _ ->
        render(conn, :my_events, user: user, user_events: user_events)
    end
  end

  def my_events_delete(conn, %{"id" => id}) do
    event = Meets.get_event!(id)
    {:ok, _event} = Meets.delete_event(event)

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: ~p"/my_events")
  end



end
