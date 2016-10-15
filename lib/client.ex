defmodule Tables.Client do
  require Logger

  def start_link do
    {:ok, pid} = GenServer.start_link(__MODULE__, {}, name: :client)
    {:ok, pid}
  end

  def init(args) do
    Logger.debug "client init"
    {:ok, args}
  end

  def handle_info({:"ETS-TRANSFER", table, _manager_pid, data}, state) do                          
    Logger.debug "got a table #{inspect table}"
    new_state = %{table: table}
    {:noreply, new_state}
  end
end
