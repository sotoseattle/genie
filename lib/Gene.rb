require 'grimoire'

class Gene < RandomVar
  private
  attr_writer :parent_gen_dad, :parent_gen_mom
  public
  attr_reader :parent_gen_dad, :parent_gen_mom, :name, 
              :alleles, :ascendant

  SPLIT_CONSTANT = 2.0

  def initialize(args)
    args.merge({name:''})
    @alleles = args[:alleles]
    @ascendant = nil
    super({name:name, card:alleles.size, ass:alleles})
  end

  def inherits_from(parent)
    @ascendant = parent
  end

  def factor(stats)
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
    grandad, granmom = ascendant.gene_dad, ascendant.gene_mom
    h = vectorize_assignments

    f = Factor.new({vars:[self, grandad, granmom]})
    grandad.ass.each_with_index do |g1, i|
      granmom.ass.each_with_index do |g2, j|
        f.vals[true,i,j] = h[g1] + h[g2]
      end
    end

    return f
  end
  
  def f_non_inherited(p_genes_in_population)
    values = ass.map{|genotype| p_genes_in_population[genotype.to_sym]}
    return Factor.new({vars:[self], vals:values})
  end
end






