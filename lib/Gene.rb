require 'grimoire'

class Gen < RandomVar
  private
  attr_writer :parent_1_gen, :parent_2_gen
  public
  attr_reader :parent_1_gen, :parent_2_gen

  include Model

  def initialize(name)
    super({card:P_genes_in_population.keys.size, name:name, 
      ass:P_genes_in_population.keys})
  end

  def is_inherited_from(parental_genes)
    self.parent_1_gen, self.parent_2_gen = parental_genes
  end

  def factor
    if parent_1_gen && parent_2_gen
      f_inherited
    else
      f_non_inherited
    end
  end

  def f_inherited
    n = Gen_Expressions.size
    # na = NArray.float(3,3,3)
    na = NArray.float(n,n,n)
    parent_1_gen.ass.each_with_index do |dad_gen, i|
      parent_2_gen.ass.each_with_index do |mom_gen, j|
        d, m = dad_gen.to_s.split(''), mom_gen.to_s.split('')
        combinations = d.product(m).map{|e| e.sort.join}
        na[true,i,j] = ass.map{|k| combinations.count(k.to_s)/4.0}
      end
    end
    return Factor.new({vars:[self, parent_1_gen, parent_2_gen], vals:na})
  end

  # CPD of a person's genes given the probabilities of finding those genes in
  # the general population. Useful when we don't know the parent's genes.
  def f_non_inherited
    alleles = P_genes_in_population.keys
    possible_combinations = alleles.product(alleles).map{|e| e.sort.join('')}
    combinations = possible_combinations.group_by{|x| x.to_sym}
    values = ass.map do |genotype|
      probability = combinations[genotype].size
      my_alleles = genotype.to_s.split('')
      my_alleles.each{|a| probability *= P_genes_in_population[a.to_sym]}
      probability
    end
    return Factor.new({vars:[self], vals:values})
  end
end
