require 'spec_helper'

describe FamilyTree do
  let(:beavers) {{
    :Ira    => [],
    :Robin  => [],
    :Aaron  => [],
    :Rene   => [],
    :James  => [:Ira, :Robin],
    :Eva    => [:Ira, :Robin],
    :Sandra => [:Aaron, :Eva],
    :Jason  => [:James, :Rene],
    :Benito => [:James, :Rene]}}
  let(:family) {FamilyTree.new(beavers, CysticFibrosisModel)}

  context "initialize" do
    specify { expect(family).to be_an(Array) }
    specify { expect(family).to all(be_a(Person)) }
    specify { expect(family.size).to eq(beavers.keys.size) }
  end

  context "find by name as a member of the family" do
    specify { expect(family.member(:Ira)).to be_a(Person) }
  end

  context "parental links" do
    let(:ira_beaver) { family.member(:Ira) }
    let(:robin_beaver) { family.member(:Robin) }
    let(:eva_beaver) { family.member(:Eva) }

    specify { expect(ira_beaver.parents).to all(be_nil) }
    specify { expect(eva_beaver.parents).to eq([ira_beaver, robin_beaver]) }
  end
end
