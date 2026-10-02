import time
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

options = Options()
options.add_argument("--headless=new")
options.add_argument("--window-size=500,741")
options.add_argument("--disable-gpu")
options.add_argument("--no-sandbox")

driver = webdriver.Chrome(options=options)
driver.get("http://localhost:8080/")

time.sleep(3)

def click_at(x, y):
    driver.execute_cdp_cmd("Input.dispatchMouseEvent", {
        "type": "mouseMoved",
        "x": x,
        "y": y
    })
    time.sleep(0.02)
    driver.execute_cdp_cmd("Input.dispatchMouseEvent", {
        "type": "mousePressed",
        "x": x,
        "y": y,
        "button": "left",
        "clickCount": 1
    })
    time.sleep(0.05)
    driver.execute_cdp_cmd("Input.dispatchMouseEvent", {
        "type": "mouseReleased",
        "x": x,
        "y": y,
        "button": "left",
        "clickCount": 1
    })

# Fingerprint center is (249, 581)
print("Clicking fingerprint button...")
click_at(249, 581)
time.sleep(0.5)

driver.save_screenshot("tasbih_cdp_clicked.png")
print("Saved tasbih_cdp_clicked.png")

driver.quit()
