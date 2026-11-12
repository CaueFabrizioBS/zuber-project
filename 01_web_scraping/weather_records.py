"""
Step 1 - Web scraping: Chicago weather, November 2017

Zuber wants to know whether the weather changes how often people ride.
Before answering that, we need the weather itself. It lives in an HTML
table on a web page, so this script grabs that table and turns it into
a DataFrame we can work with later.
"""

import pandas as pd
import requests
from bs4 import BeautifulSoup

URL = "https://practicum-content.s3.us-west-1.amazonaws.com/data-analyst-eng/moved_chicago_weather_2017.html"

# Download the page. At this point all we have is one long string of raw HTML.
response = requests.get(URL)

# Stop here with a clear error if the page did not load.
response.raise_for_status()

# Let BeautifulSoup parse that string so we can search it by tag,
# then pick the one table we care about using its id.
soup = BeautifulSoup(response.text, "lxml")
table = soup.find("table", attrs={"id": "weather_records"})

# The header cells (<th>) give us the column names.
heading_table = [th.text for th in table.find_all("th")]

# Every <tr> is a row. The header row has no data, so we skip it
# and keep the text of each <td> cell from the others.
content = []
for row in table.find_all("tr"):
    if not row.find_all("th"):
        content.append([td.text for td in row.find_all("td")])

# Put names and rows together into the final DataFrame.
weather_records = pd.DataFrame(content, columns=heading_table)

# Everything that comes from .text is a string, so the date and the temperature are converted.
weather_records["Date and time"] = pd.to_datetime(weather_records["Date and time"])
weather_records["Temperature"] = pd.to_numeric(weather_records["Temperature"])

print(weather_records)

# Save the table next to the other datasets, so the analysis notebook
# can read it without visiting the site again.
# Run this script from the project folder so the path below works.
weather_records.to_csv("data/weather_records.csv", index=False)
