import time
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

options = Options()
options.add_argument("--headless=new")
options.add_argument("--window-size=412,892")
options.add_argument("--disable-gpu")
options.add_argument("--no-sandbox")

driver = webdriver.Chrome(options=options)
driver.get("http://localhost:8080/")

time.sleep(3)

def click_at(x, y):
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

# Check current view dimensions
size = driver.execute_script("return {w: window.innerWidth, h: window.innerHeight};")
print("Window inner size:", size)

# Test clicking at center horizontally (206) and vertical around fingerprint (700)
# Let's try 650, 700
click_at(206, 680)
time.sleep(0.5)
driver.save_screenshot("tasbih_cdp_test.png")
print("Saved tasbih_cdp_test.png")

driver.quit()
