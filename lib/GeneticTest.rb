require 'grimoire'

class GeneticTest
  attr_accessor :subjects

  def initialize(family_tree)
    @subjects = {}
    instantiate_individuals(family_tree.keys)
    assign_parents(family_tree)

    subjects.each_value do |guy|
      guy.initialize_factors(pheno_stats, geno_stats)
    end
  end

  def instantiate_individuals(family_members)
    family_members.each do |name| 
      subjects[name] = Person.new(name:name, alleles:alleles)
    end
  end

  def assign_parents(family_tree)
    family_tree.each do |name, parents|
      unless parents.empty?
        people = parents.map{|p| subjects[p]}
        subjects[name].was_born_to(people)
      end
    end
  end

  def alleles
    raise NotImplementedError.new("You must implement for genetic model")
  end

  def geno_stats
    raise NotImplementedError.new("You must implement for genetic model")
  end

  def pheno_stats
    raise NotImplementedError.new("You must implement for genetic model")
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

  private
  def compute_joint_cpd
    ff = subjects.map{|name, person| person.factor}
    all_factors = FactorArray.new(ff)
    puts "all_factors.size: #{all_factors.size}"
    b = all_factors.product(true)
    return b
  end

end
