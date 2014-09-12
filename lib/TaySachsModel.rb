module TaySachsModel

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
