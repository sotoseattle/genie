require 'grimoire'
require "awesome_print"

#######################################################################
#
# P_ refers to "probability of"
# genotype: grouping of two genes
#   ie. genotype "Aa" has two genes with alleles "A" & "a"
# allele: each of the possible assigments or expressions of 1 gene (A or a)
# CPD: Conditional Probability Distribution (discrete, so in table form)
#
#######################################################################

module Model

  Gen_Expressions = [:FF, :Ff, :ff]
  P_pheno_given_genes = {FF:0.8, Ff:0.6, ff:0.1}
  P_genes_in_population = {F:0.1, f:0.9}

  # Gen_Expressions = [:FF, :Ff, :ff, :Fn, :fn, :nn]
  # P_pheno_given_genes = {FF:0.8, Ff:0.6, ff:0.1, Fn:0.5, fn:0.05, nn:0.01}
  # P_genes_in_population = {F:0.1, f:0.7, n:0.2}
end


class Genes < RandomVar
  # private
  # attr_writer :parent_1_genes, :parent_2_genes
  # public
  # attr_reader :parent_1_genes, :parent_2_genes

  include Model

  def initialize(name)
    @gen1 = Gen.new(name)
    @gen2 = Gen.new(name)
  end

  def are_inherited_from(parents)
    # self.parent_1_genes, self.parent_2_genes = parents.map{|p| p.genes}
    @gen1.is_inherited_from(parents.select{|p| p.genes.gen1})
    @gen2.is_inherited_from(parents.select{|p| p.genes.gen2})
  end

  def factor
    if parent_1_genes && parent_2_genes
      f_inherited
    else
      f_non_inherited
    end
  end

  def f_inherited
    n = Gen_Expressions.size
    # na = NArray.float(3,3,3)
    na = NArray.float(n,n,n)
    parent_1_genes.ass.each_with_index do |dad_gen, i|
      parent_2_genes.ass.each_with_index do |mom_gen, j|
        d, m = dad_gen.to_s.split(''), mom_gen.to_s.split('')
        combinations = d.product(m).map{|e| e.sort.join}
        na[true,i,j] = ass.map{|k| combinations.count(k.to_s)/4.0}
      end
    end
    return Factor.new({vars:[self, parent_1_genes, parent_2_genes], vals:na})
  end

  # CPD of a person's genes given the probabilities of finding those genes in
  # the general population. Useful when we don't know the parent's genes.
  def f_non_inherited
    alleles = P_genes_in_population.keys
    possible_combinations = alleles.product(alleles).map{|e| e.sort.join('')}
    combinations = possible_combinations.group_by{|x| x.to_sym}
    values = ass.map do |genotype|
      probability = combinations[genotype].size
      my_alleles = genotype.to_s.split('')
      my_alleles.each{|a| probability *= P_genes_in_population[a.to_sym]}
      probability
    end
    return Factor.new({vars:[self], vals:values})
  end
end


family_tree = {
  :Ira    => [],
  :Robin  => [],
  # :Aaron  => [],
  :Rene   => [],
  :James  => [:Ira, :Robin],
  # :Eva    => [:Ira, :Robin],
  # :Sandra => [:Aaron, :Eva],
  :Jason  => [:James, :Rene],
  :Benito => [:James, :Rene]
}


gt = GeneticTest.new(family_tree)

gt[:Ira].observe_pheno(:present)
gt[:James].observe_gen(:Ff)
gt[:Rene].observe_gen(:FF)

ap gt.probability_phenotype_for "Benito"

