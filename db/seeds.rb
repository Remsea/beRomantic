
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'
require 'nokogiri'

puts 'Cleaning database...'
PartenaireInterest.destroy_all
Partenaire.destroy_all
KeyDate.destroy_all
Interest.destroy_all
Memo.destroy_all
UserEvent.destroy_all
User.destroy_all
Event.destroy_all

domain = "https://69.agendaculturel.fr"
url = "https://69.agendaculturel.fr/agenda-culturel/lyon/"
html_file = open(url).read
doc = Nokogiri::HTML(html_file)
links = []

doc.search('.block.subdep_ac_city_ a').each do |link|
  links << link.attribute('href').value
end

events = []
links.each do |path|
  url_complete = "#{domain}#{path}"
  html_file = open(url_complete).read
  doc = Nokogiri::HTML(html_file)

  doc.search('.title-list-event').each do |event|
    events << event.attribute('href').value
  end
end


url = "https://69.agendaculturel.fr"

events.each do |path|
  url_complete = "#{url}#{path}"
  html_file = open(url_complete).read
  doc = Nokogiri::HTML(html_file)

  # if url_complete.split("/").second = "theatre"
  #   i = Event.create! ({
  #     title: doc.search("ul.breadcrumb li").last.text,
  #     description: doc.search('div#left_content div').first.children.text
  #   })
  #   puts i.title
  #   puts i.description
  # else if
  # else
  #  puts "ça n'a pas marché"
  # end
francais_chiffre = {
  "janvier" => "1",
  "février" => "2",
  "mars" => "3",
  "avril" => "4",
  "mai" => "5",
  "juin" => "6",
  "juillet" => "7",
  "août" => "8",
  "septembre" => "9",
  "octobre" => "10",
  "novembre" => "11",
  "décembre" => "12"
}

  a = doc.search('.date-start .annee').text.empty? ? doc.search('.annee').text : doc.search('.date-start .annee').text
  m = doc.search('.date-start .mois').text.empty? ? francais_chiffre[doc.search('.mois').text] : francais_chiffre[doc.search('.date-start .mois').text]
  d = doc.search('.date-start .date').text.empty? ? doc.search('.date').text.first(2) : doc.search('.date-start .date').text.first(2)

  if a.present? && m.present? && d.present?
    date_start = Date.new(a.to_i, m.to_i, d.to_i)
  else
    date_start = "2020-02-19"
  end

  a_end = doc.search('.date-end .annee').text.empty? ? doc.search('.annee').text : doc.search('.date-end .annee').text
  m_end = doc.search('.date-end .mois').text.empty? ? francais_chiffre[doc.search('.mois').text] : francais_chiffre[doc.search('.date-end .mois').text]
  d_end = doc.search('.date-end .date').text.empty? ? doc.search('.date').text.first(2) : doc.search('.date-end .date').text.first(2)

  if a_end.present? && m_end.present? && d_end.present?
    date_end = Date.new(a_end.to_i, m_end.to_i, d_end.to_i)
  else
    date_end = "2020-02-19"
  end


  event_category_splited = path.split("/").second
  case event_category_splited
  when "theatre"

    i = Event.create! ({
      title: doc.search("ul.breadcrumb li").last.text,
      description: doc.search('section.section_summary div.description p').text,
      start_date: date_start,
      end_date: date_end,
      category: event_category_splited,
      address: doc.search('p.place').text,
      link_url: doc.search('.underline').attribute('href').nil? ? "no_url" : doc.search('.underline').attribute('href').value,
      photo_url: doc.search('img.img-polaroid').attribute('src').value,
    })

    puts i.title
    puts i.description
    puts i.category
    puts i.start_date
    puts i.end_date
    puts i.address
    puts i.photo_url

  when "festival"
    i = Event.create! ({
    title: doc.search("ul.breadcrumb li").last.text,
    description: doc.search('div#left_content div').first.children.text,
    start_date: date_start,
    end_date: date_end,
    category: event_category_splited,
    address: doc.search('p.place').text,
    photo_url: doc.search('img.img-polaroid').attribute('src').value,
    link_url: doc.search('.underline').attribute('href').nil? ? "no_url" : doc.search('.underline').attribute('href').value,

    })
    puts i.title
    puts i.description
    puts i.category
    puts i.start_date
    puts i.end_date
    puts i.address
    puts i.photo_url

  when "concert"
    i = Event.create! ({
    title: doc.search("ul.breadcrumb li").last.text,
    description: doc.search('section.section_summary div.description p').first.text,
    start_date: date_start,
    end_date: date_end,
    category: event_category_splited,
    address: doc.search('p.place').text,
    photo_url: doc.search('img.img-polaroid').attribute('src').value,
    link_url: doc.search('.btn btn-large btn-booking btn_category').attribute('href').nil? ? "no_url" : doc.search('.btn btn-large btn-booking btn_category').attribute('href').value,
    })
    puts i.title
    puts i.description
    puts i.category
    puts i.start_date
    puts i.end_date
    puts i.address
    puts i.photo_url

  when "danse"
    i = Event.create! ({
    title: doc.search("ul.breadcrumb li").last.text,
    description: doc.search('section.section_summary div.description p').text,
    start_date: date_start,
    end_date: date_end,
    category: event_category_splited,
    address: doc.search('p.place').text,
    photo_url: doc.search('img.img-polaroid').attribute('src').value,
    link_url: doc.search('.btn btn-large btn-booking btn_category').attribute('href').nil? ? "no_url" : doc.search('.btn btn-large btn-booking btn_category').attribute('href').value,
    })
    puts i.title
    puts i.description
    puts i.category
    puts i.start_date
    puts i.end_date
    puts i.address
    puts i.photo_url

  when "arts-du-spectacle"
    i = Event.create! ({
    title: doc.search("ul.breadcrumb li").last.text,
    description: doc.search('section.section_summary div.description p').first.text,
    start_date: date_start,
    end_date: date_end,
    category: event_category_splited,
    address: doc.search('p.place').text,
    photo_url: doc.search('img.img-polaroid').attribute('src').value,
    link_url: doc.search('.btn btn-large btn-booking btn_category').attribute('href').nil? ? "no_url" : doc.search('.btn btn-large btn-booking btn_category').attribute('href').value,
    })
    puts i.title
    puts i.description
    puts i.category
    puts i.start_date
    puts i.end_date
    puts i.address
    puts i.photo_url

  when "exposition"
    i = Event.create! ({
    title: doc.search("ul.breadcrumb li").last.text,
    description: doc.search('section.section_summary div.description p').first,
    start_date: date_start,
    end_date: date_end,
    category: event_category_splited,
    address: doc.search('p.place').text,
    photo_url: doc.search('img.img-polaroid').attribute('src').value,
    link_url: doc.search('.btn btn-large btn-booking btn_category').attribute('href').nil? ? "no_url" : doc.search('.underline').attribute('href').value,
    })
    puts i.title
    puts i.description
    puts i.category
    puts i.start_date
    puts i.end_date
    puts i.address
    puts i.photo_url

  else
    puts "ça a pas marché !"
  end
end
# doc.search(".breadcrumb span[itemprop='title']")

puts 'Creating user'
paul = User.create!(
  email: 'remi@gmail.com',
  password: "azertyuiop",
  first_name: "Remi",
  city: "Lyon",
  photo: "homme.jpg"
  )

adrien = User.create!(
  email: 'b@b.com',
  password: "azeqsd",
  first_name: "Adrien",
  city: "Lyon"
  )

puts 'Creating partenaire'
Partenaire.create!(
  firstname: "Sophie",
  lastname: "Durand",
  user: paul
  )

first_date = KeyDate.create!(
  date: "26/11/2012",
  description: "Premier rendez-vous",
  user: paul
  )

wedding = KeyDate.create!(
  date: "27/11/2016",
  description: "Anniversaire de mariage",
  user: paul
  )

presentation = KeyDate.create!(
  date: "29/11/2019",
  description: "Présentation Demo Day",
  user: paul
  )

dog_birthday = KeyDate.create!(
  date: "06/12/2017",
  description: "Anniversaire du chien",
  user: paul
  )
road_trip = KeyDate.create!(
  date: "11/01/1961",
  description: "Anniversaire belle-maman",
  user: paul
  )

puts 'Creating key date'
birthday = KeyDate.create!(
  date: "02/03/1987",
  description: "Anniversaire Susan",
  user: paul
  )

puts 'Creating interests'
Interest.create(
  title: "Concert",
  category: "Culturelle",
  genre: "Activité"
  )
Interest.create(
  title: "Théâtre",
  category: "Culturelle",
  genre: "Activité"
  )
Interest.create(
  title: "Festival",
  category: "Artistique",
  genre: "Activité"
  )
Interest.create(
  title: "Danse",
  category: "Artistique",
  genre: "Activité"
  )
Interest.create(
  title: "Spectacle",
  category: "Culturelle",
  genre: "Activité"
  )
Interest.create(
  title: "Exposition",
  category: "Artistique",
  genre: "Activité"
  )
Interest.create(
  title: "Running",
  category: "Sport",
  genre: "Centre d'intérêt"
  )
Interest.create(
  title: "Animaux",
  category: "Animaux",
  genre: "Centre d'intérêt"
  )
Interest.create(
  title: "Yoga",
  category: "Sport",
  genre: "Centre d'intérêt"
  )
Interest.create(
  title: "Salsa",
  category: "Sport",
  genre: "Centre d'intérêt"
  )
Interest.create(
  title: "Cross Fit",
  category: "Sport",
  genre: "Centre d'intérêt"
  )
Interest.create(
  title: "Rock",
  category: "Musique",
  genre: "Centre d'intérêt"
  )
Interest.create(
  title: "Pop",
  category: "Musique",
  genre: "Centre d'intérêt"
  )
Interest.create(
  title: "Classique",
  category: "Musique",
  genre: "Centre d'intérêt"
  )
Interest.create(
  title: "Bateau",
  category: "Sport",
  genre: "Centre d'intérêt"
  )
Interest.create(
  title: "Pilates",
  category: "Sport",
  genre: "Centre d'intérêt"
  )
Interest.create(
  title: "Hip Hop",
  category: "Sport",
  genre: "Centre d'intérêt"
  )
Interest.create(
  title: "Flamenco",
  category: "Sport",
  genre: "Centre d'intérêt"
  )
Interest.create(
  title: "Moto",
  category: "Sport",
  genre: "Centre d'intérêt"
  )
Interest.create(
  title: "Volley",
  category: "Sport",
  genre: "Centre d'intérêt"
  )
Interest.create(
  title: "Violon",
  category: "Sport",
  genre: "Centre d'intérêt"
  )
Interest.create(
  title: "Piano",
  category: "Sport",
  genre: "Centre d'intérêt"
  )
Interest.create(
  title: "Guitare",
  category: "Sport",
  genre: "Centre d'intérêt"
  )
