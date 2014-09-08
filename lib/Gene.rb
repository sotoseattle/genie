require 'grimoire'

class Gene < RandomVar
  private
  attr_writer :ascendant
  public
  attr_reader :name, :alleles, :ascendant

  SPLIT_CONSTANT = 2.0

  def initialize(args)
    args.merge({name:''})
    @alleles = args[:alleles]
    @ascendant = nil
    super({name:args[:name], card:alleles.size, ass:alleles})
  end

  def inherits_from(parent)
    self.ascendant = parent
  end

  def factor_given(stats)
    ascendant ? f_inherited : f_non_inherited(stats)
  end

  def vectorize_assignments
    h = {}
    ass.each_with_index do |e,i|
      h[e] = NArray.float(card)
      h[e][i] = 1.0/SPLIT_CONSTANT
    end
    return h
  end

  def f_inherited
    grandad, granmom = ascendant.g1, ascendant.g2
    h = vectorize_assignments

    f = Factor.new({vars:[self, grandad, granmom]})
    grandad.ass.each_with_index do |a, i|
      granmom.ass.each_with_index do |b, j|
        f.vals[true,i,j] = h[a] + h[b]
      end
    end

    return f
  end
  
  def f_non_inherited(p_genes_in_population)
    values = ass.map{|genotype| p_genes_in_population[genotype.to_sym]}
    return Factor.new({vars:[self], vals:values})
  end
end






