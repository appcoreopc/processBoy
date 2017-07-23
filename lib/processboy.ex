defmodule Processboy do
  use Supervisor

  @moduledoc """
  Documentation for Processboy.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Processboy.hello
      :world

  """


  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do 
     children = [
      worker(Processboy.Registry, [Processboy.Registry])
    ]
     supervise(children, strategy: :one_for_all)

  end   
end
