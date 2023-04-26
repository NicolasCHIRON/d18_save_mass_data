require 'bundler'
Bundler.require

$:.unshift File.expand_path('./../lib', __FILE__)
# reste à indiquer les require sans précision du chemin
require 'app/scrapper'

#=================== CREATION DU SCRAPPER NEW ==========================

scrapper_hash = Scrapper.new

#============================ MENU =====================================

puts "Bienvenue dans l'office de récupération des mails du Val d'Oise (appelé sobrement l'ORMVO pour les intimes)"
puts "------------------ Merci d'indiquer sous quel format vous voulez obtenir les documents : ------------------"
puts "                     [1] => Format JSON - [2] => Format Spreadsheet - [3] Format CSV"
print "> "
input = gets.chomp.to_i

while input != 1 && input != 2 && input != 3
  puts "Merci de choisir un format valide."
  puts "[1] => Format JSON - [2] => Format Spreadsheet - [3] Format CSV"
  print "> "
  input = gets.chomp.to_i
end

case input

  when 1

    #================================== METHODE JSON ===============================================

    scrapper_hash.save_as_json
    puts "Les fichiers demandés ont été transférés. Nous vous remercions d'avoir utilisé nos services."

  when 2

    # #============================== METHODE GOOGLE DRIVE ===========================================

    scrapper_hash.save_as_spreadsheet
    puts "Les fichiers demandés ont été transférés. Nous vous remercions d'avoir utilisé nos services."
    puts "Par contre, la limite de requête par minute fait que le transfert risque de prendre du temps, n'hésitez pas à prendre un café..."
    
  when 3

    # #================================== METHODE CSV ================================================

    scrapper_hash.save_as_csv
    puts "Les fichiers demandés ont été transférés. Nous vous remercions d'avoir utilisé nos services."

end

