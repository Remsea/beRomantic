# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'
require 'nokogiri'

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
  a = a.to_i
  m = m.to_i
  d = d.to_i

  a_end = doc.search('.date-end .annee').text.empty? ? doc.search('.annee').text : doc.search('.date-end .annee').text
  m_end = doc.search('.date-end .mois').text.empty? ? francais_chiffre[doc.search('.mois').text] : francais_chiffre[doc.search('.date-end .mois').text]
  d_end = doc.search('.date-end .date').text.empty? ? doc.search('.date').text.first(2) : doc.search('.date-end .date').text.first(2)
  a_end = a_end.to_i
  m_end = m_end.to_i
  d_end = d_end.to_i


  event_category_splited = path.split("/").second
  case event_category_splited
  when "theatre"
    i = Event.create! ({
      title: doc.search("ul.breadcrumb li").last.text,
      description: doc.search('section.section_summary div.description p').text,
      start_date: Date.new(a, m, d),
      end_date: Date.new(a_end, m_end, d_end),
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
    start_date: Date.new(a, m, d),
    end_date: Date.new(a_end, m_end, d_end),
    category: event_category_splited,
    address: doc.search('p.place').text,
    photo_url: doc.search('img.img-polaroid').attribute('src').value,
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
    start_date: Date.new(a, m, d),
    end_date: Date.new(a_end, m_end, d_end),
    category: event_category_splited,
    address: doc.search('p.place').text,
    photo_url: doc.search('img.img-polaroid').attribute('src').value,
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
    start_date: Date.new(a, m, d),
    end_date: Date.new(a_end, m_end, d_end),
    category: event_category_splited,
    address: doc.search('p.place').text,
    photo_url: doc.search('img.img-polaroid').attribute('src').value,
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
    start_date: Date.new(a, m, d),
    end_date: Date.new(a_end, m_end, d_end),
    category: event_category_splited,
    address: doc.search('p.place').text,
    photo_url: doc.search('img.img-polaroid').attribute('src').value,
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
    description: doc.search('section.section_summary div.description p').first.text,
    start_date: Date.new(a, m, d),
    end_date: Date.new(a_end, m_end, d_end),
    category: event_category_splited,
    address: doc.search('p.place').text,
    photo_url: doc.search('img.img-polaroid').attribute('src').value,
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
Binding.pry
p Event


# doc.search(".breadcrumb span[itemprop='title']")
