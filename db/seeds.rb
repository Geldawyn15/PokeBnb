require 'open-uri'
require 'faker'
require 'nokogiri'

Transfer.destroy_all
Pokemon.destroy_all
User.destroy_all


url = 'https://pokeapi.co/api/v2/pokemon/'

user_pic = ["https://res.cloudinary.com/dsl8lc89k/image/upload/v1558369860/lflhcyfjyv7jabnpvkc5.png",
  "https://res.cloudinary.com/dsl8lc89k/image/upload/v1558369852/pc6zjnesaanyyiummpq6.png",
  "https://res.cloudinary.com/dsl8lc89k/image/upload/v1558369844/ezaaihedpmmn2jiu7fpl.png",
  "https://res.cloudinary.com/dsl8lc89k/image/upload/v1558369799/lbarmrxj2a34ejub5nbd.png"]

e = 0
12.times do
  user = User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: Faker::Internet.password,
    image_url: user_pic[e]
    )
  e += 1
  6.times do
    i = rand(1..151).to_s
    html_content = open(url+i).read
    doc = JSON.parse(html_content)
    url_img = "https://www.pokemon.com/us/pokedex/#{doc['name'].downcase}"
    p url_img
    page = open(url_img).read
    noko = Nokogiri::HTML.parse(page)
    img =  noko.search(".profile-images img").attribute('src').value

    pokemon = Pokemon.create!(
      name: doc['name'],
      poke_type: doc['types'][0]['type']['name'].downcase.capitalize,
      level: rand(1..100),
      image_url: img,
      anime_url:"http://pokestadium.com/sprites/xy/#{doc['name'].downcase}.gif",
      professor_id: user.id
      )

  end
end

60.times do
  Transfer.create!(
    date: DateTime.now.next_day(rand(1..10)),
    pokemon: Pokemon.all.sample,
    trainer: User.all.sample
    )
end

