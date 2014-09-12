require_relative 'person'

class FamilyTree < Array

  def initialize(family_tree, genetic_model)
    extend genetic_model
    super(family_tree.keys.map {|x| Person.new(name:x, alleles:alleles)})
    assign_parents(family_tree)
  end

  def member(name)
    self.find{|p| p.name == name.to_sym}
  end

  def assign_parents(family_tree)
    family_tree.each do |kid, parents|
      kid = member(kid)
      unless parents.empty?
        parents = parents.map{|p| member(p)}
        kid.was_born_to(parents)
      end
      kid.initialize_factors(pheno_stats, geno_stats)
    end
  end


end
