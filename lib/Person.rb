require 'grimoire'

class Person

  private
  attr_accessor :factor
  public
  attr_reader :name, :g1, :g2, :phenotype, :factor

  def initialize(args)
    raise ArgumentError unless @name = args[:name]
    @phenotype = Phenotype.new("#{name}_ph")
    @g1 = Gene.new({name:"#{name}_g1", alleles:args[:alleles]})
    @g2 = Gene.new({name:"#{name}_g2", alleles:args[:alleles]})

    @factor = nil
  end

  def was_born_to(parents)
    g1.inherits_from(parents[0])
    g2.inherits_from(parents[1])
  end

  def initialize_factors(pheno_stats, geno_stats)
    self.factor = FactorArray.new([
      phenotype.factor_given(g1, g2, pheno_stats),
      g1.factor_given(geno_stats),
      g2.factor_given(geno_stats)])
    .product(false)
  end
 
  def observe_pheno(ass)
    factor.reduce({phenotype => ass}).norm
  end
 
  def observe_alleles(ass)
    # factor.reduce({genes => ass}).norm
    factor.reduce({g1 => ass[0], g2 => ass[1]}).norm
  end

end
