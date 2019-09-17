defmodule DistributedGenetic.Gene do
  defstruct [:rna, :fitness]

  @directions ["S", "N", "W", "E", "NE", "NW", "SE", "SW"]

  def generate_rna do
    :rand.seed(:exsplus, {101, 102, 103})

    1..Enum.random(4..12) |> Enum.map(fn _ -> Enum.random(@directions) end)
  end

  def calculate_fitness(rna, lab) do
    {points, _} = Enum.reduce(rna, {0, {0, 0}}, fn x, {point, pos} ->
      next_pos = move(x, pos)
      next_pos_point = eval_position(next_pos, lab)
      {next_pos_point + point, next_pos}
    end)

    points
  end

  def move("S", {x, y}), do: {x, y + 1}
  def move("N", {x, y}), do: {x, y - 1}
  def move("W", {x, y}), do: {x - 1, y}
  def move("E", {x, y}), do: {x + 1, y} 
  def move("NE", {x, y}), do: {x + 1, y - 1}
  def move("NW", {x, y}), do: {x - 1, y - 1}
  def move("SE", {x, y}), do: {x + 1, y + 1}
  def move("SW", {x, y}), do: {x - 1, y + 1}

  def eval_position({x, y}, lab) do
    with {:ok, row} <- Enum.fetch(lab, y), 
         {:ok, col} <- Enum.fetch(row, x) 
    do
      case col do
        "0" -> 1
        "S" -> 10
        _ -> -1000
      end
    else
      _ -> -1
    end
  end
end