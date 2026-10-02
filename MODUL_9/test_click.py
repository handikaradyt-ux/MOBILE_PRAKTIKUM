import time
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.action_chains import ActionChains

options = Options()
options.add_argument("--headless=new")
options.add_argument("--window-size=412,892")
options.add_argument("--disable-gpu")
options.add_argument("--no-sandbox")

driver = webdriver.Chrome(options=options)
driver.get("http://localhost:8080/")

time.sleep(3) # Wait for flutter app to load

# Save initial screenshot
driver.save_screenshot("tasbih_0.png")
print("Saved tasbih_0.png")

# Click fingerprint at (206, 650)
actions = ActionChains(driver)

def click_fingerprint(times=1):
    for i in range(times):
        # Click at coordinate (206, 650)
        ActionChains(driver).move_by_offset(206, 650).click().move_by_offset(-206, -650).perform()
        time.sleep(0.05)

# Test 1 click
click_fingerprint(1)
time.sleep(0.5)
driver.save_screenshot("tasbih_test_1.png")
print("Saved tasbih_test_1.png")

driver.quit()
