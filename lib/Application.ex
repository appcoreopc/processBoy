defmodule Processboy.Supervisor do 
    use Application
    
    def start(_type, _args) do
    import Supervisor.Spec

    children = [
        worker(Task, [Processboy, :accept, [3001]])
    ]

    opts = [strategy: :one_for_one, name: Processboy.Supervisor]
    Supervisor.start_link(children, opts)
    end
end 