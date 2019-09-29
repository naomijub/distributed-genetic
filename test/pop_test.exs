defmodule DistributedGenetic.PopTest do
  use ExUnit.Case
  alias DistributedGenetic.Population

  describe "Generate Population" do
    test "population should have 20 genes" do
        pop = Population.generate_pop()
        assert length(pop) == 20
    end

    test "genes should be different" do
      pop = Population.generate_pop()
      assert pop |> Enum.uniq |> length == length(pop)
    end
  end

  describe "Get random genes" do
    test "3 random genes are returned from pop" do
      pop = Population.generate_pop()
      selected_genes = Population.select_genes(pop)

      assert length(selected_genes) == 3
      assert selected_genes |> Enum.uniq |> length == length(selected_genes)
    end
  end
end
