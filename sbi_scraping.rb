Encoding.default_external = Encoding::UTF_8 # windows対応

require 'selenium-webdriver'
require 'sinatra'
require 'sinatra/reloader'
require 'mongo'
require 'thread'

driver = Selenium::WebDriver.for :chrome

driver.navigate.to("https://site2.sbisec.co.jp/ETGate/?OutSide=on&_ControlID=WPLETmgR001Control&_PageID=WPLETmgR001Mdtl20&_DataStoreID=DSWPLETmgR001Control&_ActionID=DefaultAID&burl=iris_ranking&cat1=market&cat2=ranking&dir=tl1-rnk%7Ctl2-stock%7Ctl3-price%7Ctl4-uprate%7Ctl5-priceview%7Ctl7-T1&file=index.html&getFlg=on&int_pr1=150313_cmn_gnavi:5_dmenu_02")

account = []
File.foreach("account.txt") do |row|
  account << row
end
user_id = account[0].strip
password = account[1].strip

driver.find_element(:name, 'user_id').send_keys(user_id)
driver.find_element(:name, 'user_password').send_keys(password)
driver.find_element(:name, 'ACT_login').click

codes = []
File.foreach("code.txt") do |row|
  codes << row
end

i = 0
window = []
per = []
codes.each do |row|
  driver.switch_to.window( driver.window_handles.last )

  begin
    driver.get ("https://site2.sbisec.co.jp/ETGate/?_ControlID=WPLETsiR001Control&_DataStoreID=DSWPLETsiR001Control&_PageID=WPLETsiR001Idtl10&_ActionID=stockDetail&getFlg=on&OutSide=on&stock_sec_code_mul=#{row}")

    if driver.page_source.include?("対象銘柄はありません")
      next
    end

    window << driver.window_handles.last
    # # 銘柄名
    # # brand_name = driver.find_element(:xpath, '//*[@id="main"]/form[2]/div[1]/div/table/tbody/tr/td[1]/h3/span[1]').text
    # brand_name = driver.execute_script("var heading = document.evaluate(\"//*[@id='main']/form[2]/div[1]/div/table/tbody/tr/td[1]/h3/span[1]\", document, null, XPathResult.ANY_TYPE, null);
    # var thisheading = heading.iterateNext();return thisheading.textContent")
    #
    # # 証券コード
    # # code = driver.find_element(:xpath, '//*[@id="main"]/form[2]/div[1]/div/table/tbody/tr/td[1]/h3/span[2]/span').text.delete(" （").delete("）")
    # code = driver.execute_script("var heading = document.evaluate(\"//*[@id='main']/form[2]/div[1]/div/table/tbody/tr/td[1]/h3/span[2]/span\", document, null, XPathResult.ANY_TYPE, null);
    # var thisheading = heading.iterateNext();return thisheading.textContent.trim();")
    #
    # # 時間
    # time = Time.now.strftime('%H:%M')
    #
    # wait = Selenium::WebDriver::Wait.new(:timeout => 10000) # seconds
    # wait.until {driver.find_element(:id, 'flash').displayed?}
    #
    # # 現在値
    # # current_price = driver.find_element(:id, 'posElem_360').find_element(:id, 'flash').text.delete(",")
    # current_price = driver.execute_script("var heading = document.evaluate(\"//*[@id='flash']\", document, null, XPathResult.ANY_TYPE, null);
    # var thisheading = heading.iterateNext();return thisheading.textContent.trim();")
    #
    # # 売気配株数
    # # over = driver.find_element(:id, 'MTB0_11').text.delete(",")
    # over = driver.execute_script("var heading = document.evaluate(\"//*[@id='MTB0_11']\", document, null, XPathResult.ANY_TYPE, null);    var thisheading = heading.iterateNext();
    # return thisheading.textContent.trim();")
    # over = over.delete(",")
    # if over == "--"
    #   over = 0
    # end
    #
    # # 買気配株数
    # # under = driver.find_element(:xpath, '//*[@id="MTB0_76"]').text.delete(",")
    # under = driver.execute_script("var heading = document.evaluate(\"//*[@id='MTB0_76']\", document, null, XPathResult.ANY_TYPE, null);    var thisheading = heading.iterateNext();
    # return thisheading.textContent.trim();")
    # under = under.delete(",")
    # if under == "--"
    #   under == 0
    # end

    driver.find_element(:id, 'imgRefArea_MTB0_on').click
  rescue
    retry
  end

  # db =  Mongo::Client.new('mongodb://test:test0812@ds149613.mlab.com:49613/sbi_scraper')
  # collection = db[:securities]
  #
  # collection.insert_one({brand_name: brand_name, code: code, time: time, current_price: current_price, over: over, under: under})
  # p brand_name
  # p code
  # p time
  # p current_price
  # p over
  # p under

  # タブを開く数
  if i >= 99
    break
  end
  i += 1
  driver.execute_script( "window.open()" )
end

loop do
  window.each do |w|
    begin
      driver.switch_to.window(w)

      # 銘柄名
      # brand_name = driver.find_element(:xpath, '//*[@id="main"]/form[2]/div[1]/div/table/tbody/tr/td[1]/h3/span[1]').text
      brand_name = driver.execute_script("var heading = document.evaluate(\"//*[@id='main']/form[2]/div[1]/div/table/tbody/tr/td[1]/h3/span[1]\", document, null, XPathResult.ANY_TYPE, null);
      var thisheading = heading.iterateNext();return thisheading.textContent")

      # 証券コード
      # code = driver.find_element(:xpath, '//*[@id="main"]/form[2]/div[1]/div/table/tbody/tr/td[1]/h3/span[2]/span').text.delete(" （").delete("）")
      code = driver.execute_script("var heading = document.evaluate(\"//*[@id='main']/form[2]/div[1]/div/table/tbody/tr/td[1]/h3/span[2]/span\", document, null, XPathResult.ANY_TYPE, null);
      var thisheading = heading.iterateNext();return thisheading.textContent.trim();")
      code = code.delete(" （").delete("）")

      # 時間
      time = Time.now.strftime('%H:%M')

      wait = Selenium::WebDriver::Wait.new(:timeout => 10000) # seconds
      wait.until {driver.find_element(:id, 'flash').displayed?}

      # 現在値
      # current_price = driver.find_element(:id, 'posElem_360').find_element(:id, 'flash').text.delete(",")
      current_price = driver.execute_script("var heading = document.evaluate(\"//*[@id='flash']\", document, null, XPathResult.ANY_TYPE, null);
      var thisheading = heading.iterateNext();return thisheading.textContent.trim();")
      current_price = current_price.delete(',')

      # 売気配株数
      # over = driver.find_element(:id, 'MTB0_11').text.delete(",")
      over = driver.execute_script("var heading = document.evaluate(\"//*[@id='MTB0_11']\", document, null, XPathResult.ANY_TYPE, null);    var thisheading = heading.iterateNext();
      return thisheading.textContent.trim();")
      over = over.delete(",")
      if over == "--"
        over = 0
      end

      # 買気配株数
      # under = driver.find_element(:xpath, '//*[@id="MTB0_76"]').text.delete(",")
      under = driver.execute_script("var heading = document.evaluate(\"//*[@id='MTB0_76']\", document, null, XPathResult.ANY_TYPE, null);    var thisheading = heading.iterateNext();
      return thisheading.textContent.trim();")
      under = under.delete(",")
      if under == "--"
        under == 0
      end

    rescue
      retry
    end

    db =  Mongo::Client.new('mongodb://test:test0812@ds149613.mlab.com:49613/sbi_scraper')
    collection = db[:securities]

    collection.insert_one({brand_name: brand_name, code: code, time: time, current_price: current_price, over: over, under: under, under_divided_over:over.to_i/under.to_i.round(0) })
    # p brand_name
    # p code
    # p time
    # p current_price
    # p over
    # p under
  end
end
