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

class Phenotype < RandomVar
  include Model

  def initialize(name)
    super({card:2, name:name, ass:[:present, :absent]})
  end

  # CPD of a person's phenotapy given his genes
  def factor_given(genes_var)
    values = genes_var.ass.map do |g| 
      [P_pheno_given_genes[g], 1-P_pheno_given_genes[g]]
    end
    return Factor.new({vars:[self, genes_var], vals:values})
  end

end
  
class Genes < RandomVar
  private
  attr_writer :parent_1_genes, :parent_2_genes
  public
  attr_reader :parent_1_genes, :parent_2_genes

  include Model

  def initialize(name)
    super({card:Gen_Expressions.size, name:name, ass:Gen_Expressions})
  end

  def are_inherited_from(parents)
    self.parent_1_genes, self.parent_2_genes = parents.map{|p| p.genes}
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

class Person

  private
  attr_accessor :factor
  public
  attr_reader :name, :genes, :phenotype, :factor

  def initialize(name)
    @name = name
    @phenotype = Phenotype.new(name)
    @genes = Genes.new(name)
    @factor = nil
  end

  def is_son_of(parents)
    genes.are_inherited_from(parents)
  end

  def factorize
    self.factor = FactorArray.new([phenotype.factor_given(genes), 
      genes.factor]).product(false)
  end

  def observe_pheno(ass)
    factor.reduce({phenotype => ass}).norm
  end

  def observe_gen(ass)
    factor.reduce({genes => ass}).norm
  end

end

class GeneticTest
  attr_accessor :subjects

  def initialize(family_tree)
    @subjects = {}
    family_tree.each_key{|name| @subjects[name] = Person.new(name)}
    family_tree.each do |name, parents|
      unless parents.empty?
        people = parents.map{|p| @subjects[p]}
        @subjects[name].is_son_of(people)
      end
      @subjects[name].factorize
    end    
  end

  def compute_joint_cpd
    ff = subjects.map{|name, person| person.factor}
    all_factors = FactorArray.new(ff)
    all_factors.product(true)
  end

  # probability of person having the phenotype analyzed present (in 100 %)
  def probability_phenotype_for(name)
    patient = subjects[name.to_sym]
    cpd = compute_joint_cpd
    pheno_probs = cpd.marginalize_all_but(patient.phenotype)
    100 * pheno_probs[:present]
  end

  def [](name)
    @subjects[name.to_sym]
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

