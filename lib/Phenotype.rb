require 'grimoire'

class Phenotype < RandomVar

  def initialize(name)
    super({card:2, name:name, ass:[:present, :absent]})
  end

  def factor_given(gene_1, gene_2, model_probabilities)
    f = Factor.new({vars:[self, gene_1, gene_2]})

    gene_1.ass.each_with_index do |g1, i|
      gene_2.ass.each_with_index do |g2, j|
        gg = [g1,g2].sort.join
        p = model_probabilities[gg]||model_probabilities[gg.reverse]
        f.vals[true,i,j] =  NArray[p, 1-p]
      end
    end

    return f
  end
end
