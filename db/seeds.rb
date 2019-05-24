require 'open-uri'
require 'faker'
require 'nokogiri'

Transfer.destroy_all
Pokemon.destroy_all
User.destroy_all


URL = 'https://pokeapi.co/api/v2/pokemon/'

user_pic = ["https://res.cloudinary.com/dsl8lc89k/image/upload/v1558369860/lflhcyfjyv7jabnpvkc5.png",
  "https://res.cloudinary.com/dsl8lc89k/image/upload/v1558369852/pc6zjnesaanyyiummpq6.png",
  "https://res.cloudinary.com/dsl8lc89k/image/upload/v1558369844/ezaaihedpmmn2jiu7fpl.png",
  "https://res.cloudinary.com/dsl8lc89k/image/upload/v1558369799/lbarmrxj2a34ejub5nbd.png"]

user = User.create!(
    name: "Toto",
    email: "randomemail@hotmail.fr",
    password: "123456789"
    )
puts "Jonas account created"

user = User.create!(
    name: "Charlycade",
    email: "randomemail@gmail.com",
    password: "Carapuce29"
    )
puts "Charline's account created"



user = User.create!(
    name: "totoman",
    email: "fake@gmail.com",
    password: "totoman"
    )
puts "Alex's account created"

def rand_num
  rand(1..151).to_s
end
def get_api(i)
  html_content = open(URL+i).read
  return JSON.parse(html_content)
end

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
    i = rand_num
    doc = get_api(i)
    name = doc['name'].downcase
    if i == '29'
      name = "nidoran-female"
    elsif i == '32'
      name = "nidoran-male"
    end
    url_img = "https://www.pokemon.com/us/pokedex/#{name}"
    page = open(url_img).read
    noko = Nokogiri::HTML.parse(page)
    img =  noko.search(".profile-images img").attribute('src').value

    if i == '29'
      name = "nidoranf"
    elsif i == '32'
      name = "nidoranm"
    end
    if doc["abilities"][1]
      ability2 = doc["abilities"][1]["ability"]["name"]
    else
      ability2 = "none"
    end
    pokemon = Pokemon.create!(
      name: doc['name'].downcase.capitalize,
      poke_type: doc['types'][0]['type']['name'].downcase.capitalize,
      level: rand(1..100),
      image_url: img,
      anime_url:"http://pokestadium.com/sprites/xy/#{name}.gif",
      professor_id: user.id,
      ability1: doc["abilities"][0]["ability"]["name"],
      ability2: ability2,
      hp: doc["stats"][5]["base_stat"],
      defense: doc["stats"][3]["base_stat"],
      attack: doc["stats"][4]["base_stat"],
      height: doc["height"],
      weight: doc["weight"]
    )
  end
end

puts "12 random users created"
puts "72 Pokemons created.... hurray!"

10.times do
  Transfer.create!(
    date: DateTime.now.next_day(rand(1..10)),
    pokemon: Pokemon.all.sample,
    trainer: User.all.sample
  )
end

10.times do
  i = rand_num
  doc = get_api(i)
  Transfer.create!(
    date: DateTime.now.next_day(rand(1..10)),
    pokemon: Pokemon.all.sample,
    trainer: User.all.sample,
    enemy_name: doc['name'].downcase.capitalize,
    enemy_type: doc['types'][0]['type']['name'].downcase.capitalize,
    enemy_level: rand(1..100),
    outcome: "win",
    comment: ["It was a great battle", "Love xoxo", "Enjoyed it, let's do it another time", "Best time ever"].sample,
    rating: rand(4..5),
  )
end

10.times do
  i = rand_num
  doc = get_api(i)
  Transfer.create!(
    date: DateTime.now.next_day(rand(1..10)),
    pokemon: Pokemon.all.sample,
    trainer: User.all.sample,
    enemy_name: doc['name'].downcase.capitalize,
    enemy_type: doc['types'][0]['type']['name'].downcase.capitalize,
    enemy_level: rand(1..100),
    outcome: ["win", "lose"].sample,
    comment: ["It was not a great battle. Anyway, we'll be luckier the next time.", "Not sure we'll do it again", "Not that great. I had such an hard time."].sample,
    rating: rand(2..3),
  )
end

10.times do
  i = rand_num
  doc = get_api(i)
  Transfer.create!(
    date: DateTime.now.next_day(rand(1..10)),
    pokemon: Pokemon.all.sample,
    trainer: User.all.sample,
    enemy_name: doc['name'].downcase.capitalize,
    enemy_type: doc['types'][0]['type']['name'].downcase.capitalize,
    enemy_level: rand(1..100),
    outcome: "lose",
    comment: ["It sucked. Hate your pokemon, you're dead to me", "Not the best battle ever. Pokemon was not good", "We lose, that's the first time it ever happened too me. Your Pokemon is sooo bad"].sample,
    rating: rand(0..2),
  )
end

puts "40 transfers created"


user = User.create!(
    name: "Anna Maverick",
    email: "hatorianna13@gmail.com",
    password: "Pokepoke"
    )
puts "Anna Maverick's account created"

def anna_create(i, user)
  html_content = open(URL+i.to_s).read
  doc = JSON.parse(html_content)
  name = doc['name'].downcase
  url_img = "https://www.pokemon.com/us/pokedex/#{name}"
  page = open(url_img).read
  noko = Nokogiri::HTML.parse(page)
  img =  noko.search(".profile-images img").attribute('src').value

  if doc["abilities"][1]
    ability2 = doc["abilities"][1]["ability"]["name"]
  else
    ability2 = "none"
  end
  pokemon = Pokemon.create!(
    name: name.capitalize,
    poke_type: doc['types'][0]['type']['name'].downcase.capitalize,
    level: rand(55..100),
    image_url: img,
    anime_url:"http://pokestadium.com/sprites/xy/#{name}.gif",
    professor_id: user.id,
    ability1: doc["abilities"][0]["ability"]["name"],
    ability2: ability2,
    hp: doc["stats"][5]["base_stat"],
    defense: doc["stats"][3]["base_stat"],
    attack: doc["stats"][4]["base_stat"],
    height: doc["height"],
    weight: doc["weight"]
    )
end

anna_create(59, user)
anna_create(136, user)
anna_create(6, user)




