require 'grimoire'

class GeneticTest

  attr_reader :subjects

  def initialize(family_tree, gen_model)
    @subjects = FamilyTree.new(family_tree, gen_model)
  end

  # probability of person having the phenotype analyzed present (in 100 %)
  def probability_phenotype_for(name)
    patient = subjects.member(name)
    cpd = compute_joint_cpd
    pheno_probs = cpd.marginalize_all_but(patient.phenotype)
    100 * pheno_probs[:present]
  end

  def [](name)
    subjects.member(name)
  end

  private
  def compute_joint_cpd
    all_factors = FactorArray.new(subjects.map(&:factor))
    return all_factors.product(true)
  end

end
