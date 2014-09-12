require_relative '../lib/GeneticTest'
require_relative '../lib/CysticFibrosisModel'
require_relative '../lib/TaySachsModel'
require_relative '../lib/Person'
require_relative '../lib/FamilyTree'
require_relative '../lib/Phenotype'
require_relative '../lib/Gene'
require 'awesome_print'

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

## Cystic Fibrosis Testing
# gt = GeneticTest.new(family_tree, CysticFibrosisModel)
# gt[:Ira].observe_pheno(:present)
# gt["Rene"].observe_alleles([:F, :f])
# gt[:Eva].observe_pheno(:present)

## Tay Sachs Testing
gt = GeneticTest.new(family_tree, TaySachsModel)
gt[:Ira].observe_pheno(:present)
gt[:James].observe_alleles([:T, :t])
gt[:Rene].observe_alleles([:T, :T])



ap gt.probability_phenotype_for "Benito"

