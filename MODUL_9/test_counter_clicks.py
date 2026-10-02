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

def click(x, y):
    driver.execute_cdp_cmd("Input.dispatchMouseEvent", {
        "type": "mouseMoved",
        "x": x,
        "y": y
    })
    time.sleep(0.05)
    driver.execute_cdp_cmd("Input.dispatchMouseEvent", {
        "type": "mousePressed",
        "x": x,
        "y": y,
        "button": "left",
        "buttons": 1,
        "clickCount": 1
    })
    time.sleep(0.05)
    driver.execute_cdp_cmd("Input.dispatchMouseEvent", {
        "type": "mouseReleased",
        "x": x,
        "y": y,
        "button": "left",
        "buttons": 0,
        "clickCount": 1
    })
    time.sleep(0.1)

# Tambah center is (319, 427)
print("Clicking Tambah 3 times...")
click(319, 427)
click(319, 427)
click(319, 427)
time.sleep(0.5)

driver.save_screenshot("counter_increment_3.png")
print("Saved counter_increment_3.png")

# Kurang center is (173, 427)
print("Clicking Kurang 4 times...")
click(173, 427)
click(173, 427)
click(173, 427)
click(173, 427)
time.sleep(0.5)

driver.save_screenshot("counter_decrement_neg1.png")
print("Saved counter_decrement_neg1.png")

driver.quit()
