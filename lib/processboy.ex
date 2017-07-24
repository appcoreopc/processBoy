defmodule Processboy do
  require Logger

  @doc """
  Starts accepting connections on the given `port`.
   Processboy.Supervisor.start(nil, nil)
  """
  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port,
                      [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info "Accepting connections on port #{port}"
    loop_acceptor(socket)
  end

  def init() do 
    import Supervisor.Spec

    children = [
        worker(Task, [Processboy, :accept, [3001]])
    ]

    opts = [strategy: :one_for_one, name: Processboy]
    Supervisor.start_link(children, opts)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    Logger.info "getting connections from client"
    {:ok, pid} = serve(client) 

    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    socket
    |> read_line()
    |> write_line(socket)

    serve(socket)
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end

  def handle_all(:dequeue, _from, []), do: {:reply, nil, []}

  def handle_all(:queue, _from, state), do: {:reply, state, state}



end