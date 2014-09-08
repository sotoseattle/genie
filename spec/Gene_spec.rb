require 'spec_helper'

describe Gene do
  context "initialize" do
    it "fails without gene expressions" do
      expect {Gene.new}.to raise_error
    end

    subject {Gene.new(:alleles => ['A', 'a'])}
    it {is_expected.to be_kind_of(RandomVar)}
    its(:name) {is_expected.to be_empty}
    its(:card) {is_expected.to eq(2)}
    its(:ass) {is_expected.to include("A", "a")}
    its("ass.first") {is_expected.to be_kind_of(String)}
  end
  
end