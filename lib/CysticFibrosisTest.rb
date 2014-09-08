require 'grimoire'
require './GeneticTest'


class CysticFibrosisTest < GeneticTest

  # possible alleles for the given gene
  def alleles
    [:F, :f, :n]
  end

  # probability of allele in general population
  def geno_stats
    {F:0.1, f:0.7, n:0.2}
  end

  # probability of showing pheno given pair of genes
  def pheno_stats
    {"FF"=>0.8, "Ff"=>0.6, "ff"=>0.5, "Fn"=>0.1, "fn"=>0.05, "nn"=>0.01}
  end

end

family_tree = {
  :Ira    => [],
  :Robin  => [],
  # :Aaron  => [],
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

gt = CysticFibrosisTest.new(family_tree)


gt[:Ira].observe_pheno(:present)
gt[:Rene].observe_alleles([:F, :f])
gt[:Eva].observe_pheno(:present)



ap gt.probability_phenotype_for "Benito"

