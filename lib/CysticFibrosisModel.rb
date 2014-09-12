module CysticFibrosisModel

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
