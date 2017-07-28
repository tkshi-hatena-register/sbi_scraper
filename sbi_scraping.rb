Encoding.default_external = Encoding::UTF_8 # windows対応

require 'selenium-webdriver'

driver = Selenium::WebDriver.for :chrome

driver.navigate.to("https://site2.sbisec.co.jp/ETGate/?OutSide=on&_ControlID=WPLETmgR001Control&_PageID=WPLETmgR001Mdtl20&_DataStoreID=DSWPLETmgR001Control&_ActionID=DefaultAID&burl=iris_ranking&cat1=market&cat2=ranking&dir=tl1-rnk%7Ctl2-stock%7Ctl3-price%7Ctl4-uprate%7Ctl5-priceview%7Ctl7-T1&file=index.html&getFlg=on&int_pr1=150313_cmn_gnavi:5_dmenu_02")

user_id = ""
password = ""

driver.find_element(:name, 'user_id').send_keys(user_id)
driver.find_element(:name, 'user_password').send_keys(password)
driver.find_element(:name, 'ACT_login').click

loop do
  detail_page_url = []
  for i in 1..10
    detail_page_url << driver.find_element(:xpath, '//*[@id="MAINAREA01"]/table/tbody/tr[' + i.to_s + ']/td[2]/a').attribute("href")
  end

  window = []
  detail_page_url.each do |page|
    driver.execute_script( "window.open()" )
    driver.switch_to.window( driver.window_handles.last )
    window << driver.window_handles.last
    begin
      driver.get (page)

      # 銘柄名
      brand_name = driver.find_element(:xpath, '//*[@id="main"]/form[2]/div[1]/div/table/tbody/tr/td[1]/h3/span[1]').text

      # 証券コード
      code = driver.find_element(:xpath, '//*[@id="main"]/form[2]/div[1]/div/table/tbody/tr/td[1]/h3/span[2]/span').text.delete(" （").delete("）")

      # 時間
      time = Time.now.strftime('%H:%M')

      wait = Selenium::WebDriver::Wait.new(:timeout => 10000) # seconds
      wait.until {driver.find_element(:id, 'flash').displayed?}

      # 売気配株数
      if driver.find_element(:id, 'MTB0_8').text == "--"
        over = driver.find_element(:id, 'MTB0_11').text
      else
        over = driver.find_element(:id, 'MTB0_8').text
      end
      if over == "--" || over == " "
        raise
      end

      # 買気配株数
      element = "MTB0_76"
      for i in 1..20
        if driver.find_element(:id, element).text == "--" || driver.find_element(:id, element).text == " "
          element = "MTB0_" + (76 - i*3).to_s
        else
          under = driver.find_element(:id, element).text
          break
        end
      end
      if under == "--" || under == " "
        raise
      end
    rescue
      retry
    end
    p brand_name
    p code
    p time
    p over
    p under
  end
  10.times do
    driver.switch_to.window( driver.window_handles.last )
    driver.close
  end
  driver.switch_to.window( driver.window_handles.last )
  driver.navigate.refresh
end
