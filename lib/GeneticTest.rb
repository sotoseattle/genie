require 'grimoire'
require 'person'

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
    a = all_factors.product(true)
    puts a.vars.size
    a
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