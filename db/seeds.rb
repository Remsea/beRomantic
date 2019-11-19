puts 'Cleaning database...'
Partenaire.destroy_all
KeyDate.destroy_all
Interest.destroy_all
User.destroy_all

puts 'Creating user'
paul = User.create!(
  email: 'a@a.com',
  password: "azertyuiop",
  first_name: "Paul",
  city: "Lyon"
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

puts 'Creating key date'
birthday = KeyDate.create!(
  date: "21/11/1990",
  description: "Anniversaire Elodie",
  user: paul
  )

first_date = KeyDate.create!(
  date: "02/03/2012",
  description: "Premier rendez-vous",
  user: paul
  )

wedding = KeyDate.create!(
  date: "14/07/2016",
  description: "Anniversaire de mariage",
  user: paul
  )

dog_birthday = KeyDate.create!(
  date: "08/08/2017",
  description: "Anniversaire Titi (son chien)",
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
  title: "Loutres",
  category: "Animaux",
  genre: "Centre d'intérêt"
  )
Interest.create(
  title: "Chiens",
  category: "Animaux",
  genre: "Centre d'intérêt"
  )
Interest.create(
  title: "Yoga",
  category: "Sport",
  genre: "Centre d'intérêt"
  )
Interest.create(
  title: "Cross fit",
  category: "Sport",
  genre: "Centre d'intérêt"
  )
Interest.create(
  title: "Ping Pong",
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



