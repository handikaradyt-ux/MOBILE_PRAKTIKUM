import time
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

options = Options()
options.add_argument("--headless=new")
options.add_argument("--window-size=412,892") # Standard modern Android device resolution (Pixel 7 / generic phone)
options.add_argument("--disable-gpu")
options.add_argument("--no-sandbox")

driver = webdriver.Chrome(options=options)
driver.get("http://localhost:8080/")

print("Page title:", driver.title)
time.sleep(5) # Allow flutter web engine to render canvas
driver.save_screenshot("test_tasbih_initial.png")
print("Screenshot saved!")
driver.quit()
