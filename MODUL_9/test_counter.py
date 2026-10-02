import time
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

options = Options()
options.add_argument("--headless=new")
options.add_argument("--window-size=420,860")
options.add_argument("--disable-gpu")
options.add_argument("--no-sandbox")

driver = webdriver.Chrome(options=options)
driver.get("http://localhost:8081/")

time.sleep(3)
driver.save_screenshot("counter_initial.png")
print("Saved counter_initial.png")

driver.quit()
