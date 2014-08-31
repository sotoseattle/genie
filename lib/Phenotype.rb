require 'grimoire'

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
