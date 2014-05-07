# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#

#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
University.delete_all
Type.delete_all
Campus.delete_all

# Borramos la información previamente almacenada en la DB:
puts 'DELETING PREVIOUS RECORDS'
Role.all.each do |role|
	role.destroy
end

User.all.each do |user|
	user.destroy
end

University.all.each do |univ|
	univ.destroy
end

Type.all.each do |type|
	type.destroy
end

Building.all.each do |b|
	b.destroy
end

puts 'CREATING ROLES'
Role.create([
  { :name => 'super_admin' }, 
  { :name => 'university_admin' }, 
  { :name => 'campus_admin' },
  { :name => 'admin'}
], :without_protection => true)

puts 'SETTING UP DEFAULT USER LOGIN'

user1 = User.create! :name => 'First User', :email => 'user@example.com', :password => 'pleaseasdf', :password_confirmation => 'pleaseasdf'
puts 'New user created: ' << user1.name

user2 = User.create! :name => 'Second User', :email => 'user2@example.com', :password => 'pleaseasdf', :password_confirmation => 'pleaseasdf'
puts 'New user created: ' << user2.name

user3 = User.create! :name => 'Third User', :email => 'user3@example.com', :password => 'pleaseasdf', :password_confirmation => 'pleaseasdf'
puts 'New user created: ' << user3.name

user4 = User.create! :name => 'Fourth User', :email => 'user4@example.com', :password => 'pleaseasdf', :password_confirmation => 'pleaseasdf'
puts 'New user created: ' << user4.name

universities = University.create([	{name: 'Pontificia Universidad Catolica', acronym: 'PUC'}, 
									{name: 'Universidad de Chile', acronym: 'UCH'}, 
									{name: 'Univeridad Federico Santa Maria', acronym: 'UFST'}, 
									{name: 'Univeridad de Concepcion', acronym: 'UDEC'}])

user1.add_role :super_admin
user2.add_role :university_admin, University.first
user3.add_role :campus_admin
user4.add_role :admin

Type.create(name: 'Latas', university: universities.first)
Type.create(name: 'Papel', university: universities.first)
Type.create(name: 'Pilas', university: universities.first)
Type.create(name: 'Vidrios', university: universities.first)
