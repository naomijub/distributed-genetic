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
end
