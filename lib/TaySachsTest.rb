require 'grimoire'
require './GeneticTest'


class TaySachsTest < GeneticTest

  # possible alleles for the given gene
  def alleles
    [:T, :t]
  end

  # probability of allele in general population
  def geno_stats
    {T:0.1, t:0.9}
  end

  # probability of showing pheno given pair of genes
  def pheno_stats
    {"TT"=>0.8, "Tt"=>0.6, "tt"=>0.1}
  end

end

family_tree = {
  :Ira    => [],
  :Robin  => [],
  :Aaron  => [],
  :Rene   => [],
  :James  => [:Ira, :Robin],
  :Eva    => [:Ira, :Robin],
  # :Sandra => [:Aaron, :Eva],
  # :Jason  => [:James, :Rene],
  :Benito => [:James, :Rene]
}
require_relative './Person'
require_relative './Phenotype'
require_relative './Gene'
require 'awesome_print'

gt = TaySachsTest.new(family_tree)

gt[:Ira].observe_pheno(:present)
gt[:Rene].observe_alleles([:T, :T])
gt[:James].observe_alleles([:t, :T])


ap gt.probability_phenotype_for "Benito"

