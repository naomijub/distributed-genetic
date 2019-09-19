defmodule DistributedGenetic.GeneTest do
  use ExUnit.Case
  import TestHelper
  alias DistributedGenetic.Gene

  @directions ["S", "N", "W", "E", "NE", "NW", "SE", "SW"]

  describe "Generate RNA" do
    test "RNA should have size between 4 and 12" do
      Enum.each(1..10, fn _ ->
        rna = Gene.generate_rna()
        assert length(rna) >= 4
        assert length(rna) <= 12
      end)
    end

    test "RNA should have only valid directions" do
      rna = Gene.generate_rna()

      assert Enum.all?(rna, fn n -> Enum.member?(@directions, n) end)
    end
  end

  describe "Calculate Fitness" do
    test "Gets 1 point for every 0 in its movement" do
      rna = ["E", "S", "W", "S", "E"]
      lab = [["E", "0", "1"], ["0", "0", "1"], ["0", "0", "1"]]

      assert Gene.calculate_fitness(rna, lab) == 5 - size_penalty(length(rna))
    end

    test "Gets a bonus when exit is found" do
      rna = ["E", "S", "W"]
      lab = [["E", "0", "1"], ["S", "0", "1"], ["1", "1", "1"]]

      assert Gene.calculate_fitness(rna, lab) == 102 - size_penalty(length(rna))
    end

    test "Gets points when moving diagonal" do
      rna = ["SE", "W"]
      lab = [["E", "0", "1"], ["S", "0", "1"], ["1", "1", "1"]]

      assert Gene.calculate_fitness(rna, lab) == 101 - size_penalty(length(rna))
    end

    test "Gets a low score if hits the edge of the labyrinth" do
      rna = ["E", "S", "W", "W"]
      lab = [["E", "0", "1"], ["0", "0", "1"], ["0", "0", "1"]]

      assert Gene.calculate_fitness(rna, lab) == -1000 + 3 - size_penalty(length(rna))
    end

    test "Gets a penalty if hits a wall" do
      rna = ["E", "S", "E"]
      lab = [["E", "0", "1"], ["0", "0", "1"], ["0", "0", "1"]]

      assert Gene.calculate_fitness(rna, lab) == -10 + 2 - size_penalty(length(rna))
    end

    test "Gets a low score if direction is not valid" do
      rna = ["E", "S", "W", "invalid"]
      lab = [["E", "0", "1"], ["0", "0", "1"], ["0", "0", "1"]]

      assert Gene.calculate_fitness(rna, lab) == -1000 + 3 - size_penalty(length(rna))
    end

    test "Smaller gene gets a higher score" do
      smaller_rna = ["SE", "N", "S", "W"]
      bigger_rna = ["SE", "N", "S", "N", "S", "N", "SW"]
      lab = [["E", "0", "1"], ["S", "0", "1"], ["1", "1", "1"]]
      IO.puts(Gene.calculate_fitness(smaller_rna, lab))
      IO.puts(Gene.calculate_fitness(bigger_rna, lab))
      assert Gene.calculate_fitness(smaller_rna, lab) > Gene.calculate_fitness(bigger_rna, lab)
    end
  end

  describe "Find Entrance" do
    test "Gets the entrance coordinates" do
      lab = [["0", "0", "1"], ["0", "0", "1"], ["E", "0", "1"]]

      assert Gene.find_entrance(lab) == {0, 2}
    end

    test "Points to upper left corner when no entrance is found" do
      lab = [["0", "1", "1"], ["S", "0", "1"], ["0", "0", "1"]]

      assert Gene.find_entrance(lab) == {0, 0}
    end

    test "Points to upper left corner when lab is empty" do
      lab = [[], []]

      assert Gene.find_entrance(lab) == {0, 0}
    end
  end
end
