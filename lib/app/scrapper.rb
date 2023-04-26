class Scrapper
  attr_accessor :hash_names_emails

  def initialize
    @hash_names_emails = Hash.new
  end

  # Pour aller chercher l'adresse mail sur la page d'une commune
  def get_townhall_email(townhall_url)
    page = Nokogiri::HTML(URI.open(townhall_url))
    return page.xpath("//html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]").text
  end

  # Pour aller chercher les urls de toutes les communes du 9-5
  def get_townhall_urls
    page = Nokogiri::HTML(URI.open("http://annuaire-des-mairies.com/val-d-oise.html"))
    array_town_url = []
    array_town_name = page.xpath("//p/a")
    array_town_name.each do |town_url|
      array_town_url << "http://annuaire-des-mairies.com" + town_url["href"][1..-1].to_s
    end  
    return array_town_url
  end

  # Pour aller chercher les noms de toutes les communes du 9-5
  def get_townhall_names
    page = Nokogiri::HTML(URI.open("http://annuaire-des-mairies.com/val-d-oise.html"))
    array_town_names = []
    array_town_name = page.xpath("//p/a")
    array_town_name.each do |town_name|
      array_town_names<< town_name.text
    end  
    return array_town_names
  end

  # # Fait une petite boucle pour faire correspondre chaque url à l'adresse mail correspondante et mettre les noms et les emails de le même hash
  def perform
    array_town_email = []  
    get_townhall_urls.each do |town_url|
      array_town_email << get_townhall_email(town_url)
    end
    array_town_email
    return @hash_names_emails = Hash[get_townhall_names.zip(array_town_email)]
  end

  def save_as_json
    array_town_email = []  
    get_townhall_urls.each do |town_url|
      array_town_email << get_townhall_email(town_url)
    end
    array_town_email
    @hash_names_emails = Hash[get_townhall_names.zip(array_town_email)]
    return File.open("db/emails.json", "w") {|f| f.write(JSON.pretty_generate(@hash_names_emails))}
  end

  def save_as_spreadsheet
    array_town_email = []  
    get_townhall_urls.each do |town_url|
      array_town_email << get_townhall_email(town_url)
    end
    array_town_email
    @hash_names_emails = Hash[get_townhall_names.zip(array_town_email)]
    session = GoogleDrive::Session.from_service_account_key("config.json")
    spreadsheet = session.spreadsheet_by_title("testmairie")
    worksheet = spreadsheet.worksheets.first
    @hash_names_emails.to_a.each do |name, email|
      worksheet.insert_rows(worksheet.num_rows + 1, [[name, email]])
      sleep(1)
      worksheet.save
    end
    # session = GoogleDrive::Session.from_config("config.json")
  end

  def save_as_csv
    array_town_email = []  
    get_townhall_urls.each do |town_url|
      array_town_email << get_townhall_email(town_url)
    end
    array_town_email
    @hash_names_emails = Hash[get_townhall_names.zip(array_town_email)]
    CSV.open("db/emails.csv", "w") {|csv| @hash_names_emails.to_a.each{|pair| csv << pair}}
  end

end