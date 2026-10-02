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
    time.sleep(0.2)

# 1. Initial screenshot
driver.save_screenshot("like_initial_10.png")
print("Saved like_initial_10.png")

# 2. Click heart at (248, 387) to like
print("Clicking heart to like...")
click(248, 387)
time.sleep(0.5)
driver.save_screenshot("like_liked_11.png")
print("Saved like_liked_11.png")

# 3. Click heart at (248, 387) to unlike
print("Clicking heart to unlike...")
click(248, 387)
time.sleep(0.5)
driver.save_screenshot("like_unliked_10.png")
print("Saved like_unliked_10.png")

driver.quit()
