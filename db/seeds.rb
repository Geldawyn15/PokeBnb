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
    name = doc['name'].downcase
    if i == '29'
      name = "nidoran-female"
    elsif i == '32'
      name = "nidoran-male"
    end
    url_img = "https://www.pokemon.com/us/pokedex/#{name}"
    p url_img
    page = open(url_img).read
    noko = Nokogiri::HTML.parse(page)
    img =  noko.search(".profile-images img").attribute('src').value

    if i == '29'
      name = "nidoranf"
    elsif i == '32'
      name = "nidoranm"
    end
    pokemon = Pokemon.create!(
      name: doc['name'].downcase.capitalize,
      poke_type: doc['types'][0]['type']['name'].downcase.capitalize,
      level: rand(1..100),
      image_url: img,
      anime_url:"http://pokestadium.com/sprites/xy/#{name}.gif",
      professor_id: user.id
      )

  end
end

10.times do
  Transfer.create!(
    date: DateTime.now.next_day(rand(1..10)),
    pokemon: Pokemon.all.sample,
    trainer: User.all.sample
  )
end

10.times do
  j = rand(1..151).to_s
  html_content = open(url+j).read
  doc = JSON.parse(html_content)
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
  j = rand(1..151).to_s
  html_content = open(url+j).read
  doc = JSON.parse(html_content)
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
  j = rand(1..151).to_s
  html_content = open(url+j).read
  doc = JSON.parse(html_content)
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
