Encoding.default_external = Encoding::UTF_8 # windows対応

require 'selenium-webdriver'

driver = Selenium::WebDriver.for :chrome

# とりあえずJASDAQ全銘柄を取得
driver.get "https://hesonogoma.com/stocks/tosho-jasdaq-stock-prices.html"

File.open("code.txt","w") do |file|
end

loop do
  element = driver.find_element(:class, 'dataTables_scrollBody').find_elements(:tag_name, 'a')

  code = []
  element.each do |row|
    code << row.text
  end

  code.each do |row|
    File.open("code.txt","a") do |file|
      file << row + "\n"
    end
  end

  if driver.find_elements(:xpath, '//*[@class="next fg-button ui-button ui-state-default"]').size > 0
    driver.find_element(:xpath, '//*[@class="next fg-button ui-button ui-state-default"]').click
  else
    break
  end
end
