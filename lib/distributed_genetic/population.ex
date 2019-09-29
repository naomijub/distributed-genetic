defmodule DistributedGenetic.Population do
  alias DistributedGenetic.Gene

  @pop_size 20

  def generate_pop do
    1..@pop_size |> Enum.map(fn _ -> Gene.generate_rna end)
  end

  def select_genes(pop) do
    first = :os.system_time(:seconds)
    second = :os.system_time(:micro_seconds)
    third = :os.system_time(:milli_seconds)
    :rand.seed(:exsplus, {first, second, third})

    1..3 |> Enum.map(fn _ -> 
      Enum.at(pop, Enum.random(0..19))
    end)
  end
end
