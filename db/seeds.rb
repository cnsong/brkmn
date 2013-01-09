# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(username: 'berkman', email: 'berkman@berkman.edu', superadmin: true, created_at: '01-09-2013', updated_at: '01-09-2013')
User.create(username: 'test', email: 'test@berkman.edu', superadmin: false, created_at: '01-09-2013', updated_at: '01-09-2013')