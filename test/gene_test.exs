defmodule DistributedGenetic.GeneTest do
  use ExUnit.Case
  alias DistributedGenetic.Gene
  
  @directions ["S", "N", "W", "E", "NE", "NW", "SE", "SW"]

  describe "Generate RNA" do
    test "RNA should have size between 4 and 12" do
      Enum.each(1..10 , fn _ ->
        rna = Gene.generate_rna
        assert length(rna) >= 4
        assert length(rna) <= 12
      end)
    end

    test "RNA should have only valid directions" do
      rna = Gene.generate_rna

      assert Enum.all?(rna, fn n -> Enum.member?(@directions, n) end)
    end
  end

  describe "Calculate Fitness" do
    test "Gets 1 point for every 0 in its movement" do
      rna = ["E", "S", "W", "S", "E"]
      lab = [["E", "0", "1"], 
            ["0", "0", "1"], 
            ["0", "0", "1"]]

      assert Gene.calculate_fitness(rna, lab) == 5
    end

    test "Gets a bonus when exit is found" do  
      rna = ["E", "S", "W"]
      lab = [["E", "0", "1"], 
            ["S", "0", "1"], 
            ["1", "1", "1"]]

      assert Gene.calculate_fitness(rna, lab) == 12
    end 
  end
end
