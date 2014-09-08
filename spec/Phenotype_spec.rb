require 'spec_helper'

describe Phenotype do
  
  context "#initialize" do 
    it "fails without a name" do 
      expect {Phenotype.new}.to raise_error
    end

    subject {Phenotype.new('pepe')}
    it {is_expected.to be_kind_of(RandomVar)}
    its(:name) {is_expected.to eq('pepe')}
    its(:card) {is_expected.to eq(2)}
    its(:ass) {is_expected.to include(:present,:absent)}
  end

  context "#factor_given" do
    let(:g1) {Gene.new("gene_1")}
    let(:g2) {Gene.new("gene_2")}
    subject {Phenotype.new('pepe')}

    it "works" do
      stats = {FF:0.8, Ff:0.6, ff:0.1}

    end

  end
end