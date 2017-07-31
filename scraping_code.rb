Encoding.default_external = Encoding::UTF_8 # windows対応

require 'selenium-webdriver'

driver = Selenium::WebDriver.for :chrome

driver.get "http://kabu-data.info/all_code/all_code_code.htm"

element = driver.find_elements(:xpath, '/html/body/center/div/table/tbody/tr[*]/td[1]')

File.open("code.txt","w") do |file|
end

code = []
element.each do |row|
  File.open("code.txt","a") do |file|
    file << row.text + "\n"
  end
end
