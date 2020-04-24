require 'ostruct'
require "f1sales_custom/hooks"

RSpec.describe F1SalesCustom::Hooks::Lead do

  context 'when is from another source' do
    let(:source) do
      source = OpenStruct.new
      source.name = 'Website'
      source
    end

    let(:product) do
      product = OpenStruct.new
      product.name = 'Peugeot 307 GFH3652'

      product
    end

    let(:lead) do
      lead = OpenStruct.new
      lead.source = source
      lead.product = product

      lead
    end

    # it 'returns same source' do
    #   expect(described_class.switch_source(lead)).to eq(source.name)
    # end
  end

  context 'when is from webmotors' do

    let(:source) do
      source = OpenStruct.new
      source.name = 'Webmotors'
      source
    end

    context 'when is peugeot' do

      let(:product) do
        product = OpenStruct.new
        product.name = 'Peugeot 307 GFH3652'

        product
      end

      let(:lead) do
        lead = OpenStruct.new
        lead.source = source
        lead.product = product

        lead
      end

      # it 'sets web peugeot as source' do
      #   expect(described_class.switch_source(lead)).to eq(source.name + described_class.source[:webmotors_peugeot])
      # end
    end

    context 'when is another brand' do
      let(:product) do
        product = OpenStruct.new
        product.name = 'Audi Q7 GFH3652'

        product
      end

      let(:lead) do
        lead = OpenStruct.new
        lead.source = source
        lead.product = product

        lead
      end

      # it 'sets web as source' do
      #   expect(described_class.switch_source(lead)).to eq(source.name)
      # end
    end


    context 'when is citroen' do

      let(:product) do
        product = OpenStruct.new
        product.name = 'Citroën C4 GFH3652'

        product
      end

      let(:lead) do
        lead = OpenStruct.new
        lead.source = source
        lead.product = product

        lead
      end

      # it 'sets web citroen as source' do
      #   expect(described_class.switch_source(lead)).to eq(source.name + described_class.source[:webmotors_citroen])
      # end
    end
  end

end
