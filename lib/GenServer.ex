defmodule Child do
  def start_link(arg, arg2) do
    IO.inspect(arg)
    IO.inspect(arg2)

    pid = spawn fn() ->
      receive do
        _any -> arg
      end
    end

    {:ok, pid}
  end
end

defmodule Sup do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    children = [
      worker(Child, [:arg], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

  def start_child do
    Supervisor.start_child(__MODULE__, [:arg2])
  end
end

# Sup.start_link
# Suo.start_child
