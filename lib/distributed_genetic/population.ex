defmodule DistributedGenetic.Population do
  alias DistributedGenetic.Gene

  @pop_size 20

  def generate_pop do
    1..@pop_size |> Enum.map(fn _ -> Gene.generate_rna end)
  end
end
