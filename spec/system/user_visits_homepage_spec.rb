require 'rails_helper'

describe 'User visits homepage' do
  it 'and see warehouses' do
    warehouses = []
    warehouses << Warehouse.new(
      id: 1, name: 'Galpão Rio', code: 'SDU', description: 'Galpão do Rio de Janeiro',
      cep: '20100-000', address: 'Avenida do Museu do Amanhã, 1000', city: 'Rio de Janeiro',
      area: 60000
    )
    warehouses << Warehouse.new(
      id: 2, name: 'Galpão Maceio', code: 'MCZ', description: 'Galpão Maceio',
      cep: '80000-000', address: 'Avenida Atlantica, 50', city: 'Maceio',
      area: 50000
    )
    allow(Warehouse).to receive(:all).and_return(warehouses)

    visit root_path

    expect(page).to have_content 'E-Commerce App'
    expect(page).to have_content 'Galpão Rio'
    expect(page).to have_content 'Galpão Maceio'
  end

  it 'and there are no warehouses' do
    warehouses = []
    allow(Warehouse).to receive(:all).and_return(warehouses)

    visit root_path

    expect(page).to have_content 'Nenhum galpão encontrado.'
  end

  it 'and see a warehouse details' do
    warehouses = []
    warehouses << Warehouse.new(
      id: 1, name: 'Galpão Rio', code: 'SDU', description: 'Galpão do Rio de Janeiro',
      cep: '20100-000', address: 'Avenida do Museu do Amanhã, 1000', city: 'Rio de Janeiro',
      area: 60000
    )
    
    visit root_path
    click_on 'Galpão Rio'

    expect(page).to have_content 'Galpão Rio - SDU'
    expect(page).to have_content 'Galpão do Rio de Janeiro'
    expect(page).to have_content 'Área: 60.000 m²'
    expect(page).to have_content 'CEP: 20100-000'
    expect(page).to have_content 'Avenida do Museu do Amanhã, 1000, Rio de Janeiro'
  end

  it 'and fails to load a warehouse details' do
    json_data = File.read(Rails.root.join('spec/support/json/warehouses.json'))
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:3333/api/v1/warehouses').and_return(fake_response)
    error_response = double('faraday_response', status: 500, body: '{}')
    allow(Faraday).to receive(:get).with('http://localhost:3333/api/v1/warehouses/1').and_return(error_response)

    visit root_path
    click_on 'Galpão Rio'
    
    expect(current_path).to eq root_path
    expect(page).to have_content 'Não foi possível carregar o galpão.'
  end
end
