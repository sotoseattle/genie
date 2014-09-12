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

require_relative './CysticFibrosisModel'
require_relative './TaySachsModel'
require_relative './Person'
require_relative './FamilyTree'
require_relative './Phenotype'
require_relative './Gene'
require 'awesome_print'


# gt = GeneticTest.new(family_tree, CysticFibrosisModel)
# gt[:Ira].observe_pheno(:present)
# gt["Rene"].observe_alleles([:F, :f])
# gt[:Eva].observe_pheno(:present)


gt = GeneticTest.new(family_tree, TaySachsModel)
gt[:Ira].observe_pheno(:present)
gt[:James].observe_alleles([:T, :t])
gt[:Rene].observe_alleles([:T, :T])



ap gt.probability_phenotype_for "Benito"

