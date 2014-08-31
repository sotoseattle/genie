require 'grimoire'
require 'phenotype'
require 'gene'

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
