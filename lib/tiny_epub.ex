
defmodule TinyEpub do
  def init() do
    path = System.argv()
    TinyEpub.Handler.handle(path)
  end
end

IO.puts("Program Initiated")
