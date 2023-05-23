require 'rails_helper'

describe Warehouse do
  context '.all' do
    it 'should return an array with all warehouses' do
      json_data = File.read(Rails.root.join('spec/support/json/warehouses.json'))
      fake_response = double('faraday_response', status: 200, body: json_data)
      allow(Faraday).to receive(:get).with('http://localhost:3333/api/v1/warehouses').and_return(fake_response)
      
      result = Warehouse.all

      expect(result.size).to eq 2

      expect(result[0].id).to eq 1
      expect(result[0].name).to eq 'Galpão Rio'
      expect(result[0].code).to eq 'SDU'
      expect(result[0].description).to eq 'Galpão do Rio de Janeiro'
      expect(result[0].cep).to eq '20100-000'
      expect(result[0].city).to eq 'Rio de Janeiro'
      expect(result[0].address).to eq 'Avenida do Museu do Amanhã, 1000'
      expect(result[0].area).to eq 60_000
      
      expect(result[1].id).to eq 2
      expect(result[1].name).to eq 'Galpão Maceio'
      expect(result[1].code).to eq 'MCZ'
      expect(result[1].description).to eq 'Galpão de Maceio'
      expect(result[1].cep).to eq '80000-000'
      expect(result[1].city).to eq 'Maceio'
      expect(result[1].address).to eq 'Avenida Atlantica, 50'
      expect(result[1].area).to eq 50_000
    end

    it 'should return an empty array when API is unavailable' do
      fake_response = double('faraday_response', status: 500, body: '{ "error": "API is unavailable" }')
      allow(Faraday).to receive(:get).with('http://localhost:3333/api/v1/warehouses').and_return(fake_response)
      
      result = Warehouse.all

      expect(result).to be_empty
    end
  end

  context '.find' do
    context 'receives an id' do
      it 'and should return a warehouses' do
        json_data = File.read(Rails.root.join('spec/support/json/warehouses.json'))
        fake_response = double('faraday_response', status: 200, body: json_data)
        allow(Faraday).to receive(:get).with('http://localhost:3333/api/v1/warehouses').and_return(fake_response)
        json_data = File.read(Rails.root.join('spec/support/json/warehouse.json'))
        fake_response = double('faraday_response', status: 200, body: json_data)
        allow(Faraday).to receive(:get).with('http://localhost:3333/api/v1/warehouses/1').and_return(fake_response)
        
        result = Warehouse.find(1)
  
        expect(result.id).to eq 1
        expect(result.name).to eq 'Galpão Rio'
        expect(result.code).to eq 'SDU'
        expect(result.description).to eq 'Galpão do Rio de Janeiro'
        expect(result.cep).to eq '20100-000'
        expect(result.city).to eq 'Rio de Janeiro'
        expect(result.address).to eq 'Avenida do Museu do Amanhã, 1000'
        expect(result.area).to eq 60_000
      end
  
      it 'and should return nil when no warehouse is found with this id' do
        json_data = File.read(Rails.root.join('spec/support/json/warehouses.json'))
        fake_response = double('faraday_response', status: 200, body: json_data)
        allow(Faraday).to receive(:get).with('http://localhost:3333/api/v1/warehouses').and_return(fake_response)
        error_response = double('faraday_response', status: 404, body: '{}')
        allow(Faraday).to receive(:get).with('http://localhost:3333/api/v1/warehouses/1').and_return(error_response)
        
        result = Warehouse.find(1)
  
        expect(result).to be_nil
      end
    end
  end
end
