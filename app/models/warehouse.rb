class Warehouse
  attr_accessor :name, :code, :description, :cep, :address, :city, :area
  attr_reader :id

  def initialize(id:, name:, code:, description:, cep:, address:, city:, area:)
    @id = id
    @name = name
    @code = code
    @description = description
    @cep = cep
    @address = address
    @city = city
    @area = area
  end

  def self.all
    warehouses = []
    response = Faraday.get('http://localhost:3333/api/v1/warehouses')

    if response.status == 200
      data = JSON.parse(response.body)
      data.each do |d|
        warehouses << Warehouse.new(
          id: d['id'], name: d['name'], code: d['code'], description: d['description'],
          cep: d['cep'], address: d['address'], city: d['city'], area: d['area']
        )
      end
    end

    warehouses
  end

  def self.find(id)
    response = Faraday.get("http://localhost:3333/api/v1/warehouses/#{id}")

    return nil unless response.status == 200
      
    data = JSON.parse(response.body)
    Warehouse.new(
      id: data['id'], name: data['name'], code: data['code'], description: data['description'],
      cep: data['cep'], address: data['address'], city: data['city'], area: data['area']
    )
  end
end
