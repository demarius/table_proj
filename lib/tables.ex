defmodule Tables do
  use Application
  require Logger

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Tables.Client, []),
      worker(Tables.Generator,  [
             Tables.Client,
             [:public, :named_table, :set, read_concurrency: true] ])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :rest_for_one, name: Tables.Supervisor]
    Supervisor.start_link(children, opts)
    case GenServer.start_link(__MODULE__, {}, name: :tablevisor) do
    {:ok, pid} ->
        #GenServer.cast(self, {:new_table, recipient, options})
      {:ok, pid}
    end
  end

  def start_session do
    res = Supervisor.start_child(Tables.Supervisor, [%{}])
  end

  def init(args) do
    Logger.debug 'server init'
    {:ok, args}
    #j{:error, reason} ->
      #Logger.error "start_link tables.generator, reason: "#{inspect reason}"
      #jend
      #{:ok, args}
  end
      #Receive an ETS table                                                                            
      #def handle_info({:"ETS-TRANSFER", table, _manager_pid, data}, state) do                          
      #@docp """
  def handle_info(msg, state) do
    Logger.debug "got a message #{inspect msg} containing #{inspect state}"
    {:noreply, state}
  end

  def handle_info({:"ETS-TRANSFER", table, _manager_pid, data}, state) do                          
    Logger.debug "got a table #{inspect table}"
    new_state = %{table: table}
    {:noreply, new_state}
  end
end
