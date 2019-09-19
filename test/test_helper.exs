defmodule TestHelper do
  def size_penalty(size) do
    6 * :math.tan(size / 6 + 5)
  end
end

ExUnit.start()
