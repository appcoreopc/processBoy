
defmodule FakeProcess do 
  
  def run(n) when n <= 0 do
    IO.puts "serving as a final loop run" 
    :timer.sleep(1000)
  end

  def run(n) do    
    IO.puts n
    :timer.sleep(1000)
    run(n - 1)
  end
 
end 
