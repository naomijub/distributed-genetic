defmodule DistributedGenetic.Gene do
  defstruct [:rna, :fitness]

  @directions ["S", "N", "W", "E", "NE", "NW", "SE", "SW"]
  @rna_size 4..12

  def generate_rna do
    first = :os.system_time(:seconds)
    second = :os.system_time(:micro_seconds)
    third = :os.system_time(:milli_seconds)
    :rand.seed(:exsplus, {first, second, third})

    1..Enum.random(@rna_size) |> Enum.map(fn _ -> Enum.random(@directions) end)
  end

  def calculate_fitness(rna, lab) do
    {points, _} =
      Enum.reduce(rna, {0, find_entrance(lab)}, fn x, {point, pos} ->
        with next_pos <- move(x, pos),
             next_pos_point <- eval_position(next_pos, lab) do
          {next_pos_point + point, next_pos}
        end
      end)

    points - 6 * :math.tan(length(rna) / 6 + 5)
  end

  def move("S", {x, y}), do: {x, y + 1}
  def move("N", {x, y}), do: {x, y - 1}
  def move("W", {x, y}), do: {x - 1, y}
  def move("E", {x, y}), do: {x + 1, y}
  def move("NE", {x, y}), do: {x + 1, y - 1}
  def move("NW", {x, y}), do: {x - 1, y - 1}
  def move("SE", {x, y}), do: {x + 1, y + 1}
  def move("SW", {x, y}), do: {x - 1, y + 1}
  def move(_direciton, _pos), do: {-10, -10}

  def find_entrance(lab) do
    width =
      lab
      |> List.first()
      |> length

    index =
      lab
      |> List.flatten()
      |> Enum.find_index(fn x -> x == "E" end) || 0

    if width > 0 do
      {rem(index, width), div(index, width)}
    else
      {0, 0}
    end
  end

  defp eval_position({x, y}, lab) do
    with true <- x >= 0,
         true <- y >= 0,
         {:ok, row} <- Enum.fetch(lab, y),
         {:ok, col} <- Enum.fetch(row, x) do
      case col do
        "0" -> 1
        "S" -> 100
        "1" -> -10
        _ -> -1000
      end
    else
      _ -> -1000
    end
  end
end
