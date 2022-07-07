defmodule PresenceDemoWeb.UserLive.Index do
  use PresenceDemoWeb, :live_view

  alias PresenceDemoWeb.Presence

  @impl true
  def mount(_params, _session, socket) do
    id = Base.encode32(:crypto.strong_rand_bytes(30))
    online_at = inspect(System.system_time(:second))
    topic = "channel"
    PresenceDemoWeb.Endpoint.subscribe(topic)
    Presence.track(self(), topic, id, %{online_at: online_at})

    socket =
      socket
      |> assign(:users, list_users())
      |> assign(:user, id)

    {:ok, socket}
  end

  @impl true
  def handle_info(%{event: "presence_diff"}, socket) do
    {:noreply, assign(socket, :users, list_users())}
  end

  @impl true
  def handle_params(_params, _url, socket), do: {:noreply, socket}

  defp list_users, do: Map.keys(Presence.list("channel"))
end
