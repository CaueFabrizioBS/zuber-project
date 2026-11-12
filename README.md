# Zuber: what moves taxi rides in Chicago?

Zuber is a new ride-sharing company getting ready to launch in Chicago. Before entering a market, it helps to know it: who the competitors are, where people are going, and whether something outside the company's control, like the weather, changes the rides.

This project answers those questions with real taxi data from November 2017. It goes from collecting the data to a tested conclusion, using web scraping, SQL and Python.

## What I found

- **Demand is concentrated downtown.** Four central neighborhoods (Loop, River North, Streeterville and West Loop) receive about 57% of all drop-offs. O'Hare airport is the main destination outside the center.
- **The competition is a small group.** There are 64 taxi companies, but the 10 biggest hold about 72% of the rides, with Flash Cab clearly in front.
- **There is no clear sign that rain reduces airport rides, but it makes them longer.** On rainy Saturdays, the number of rides per hour from the Loop to O'Hare stays about the same. The average ride, however, takes about 7 minutes more (40.5 against 33.3 minutes), and the difference is statistically significant. The weather results come from four Saturdays, so they are worth confirming with more data.

In short: Zuber can focus its launch on downtown and the airport route, keep an eye on a handful of large competitors, and prepare for bad weather by adjusting time estimates and having more cars available.

## How the project is organized

```
zuber-project/
├── 01_web_scraping/
│   └── weather_records.py
├── 02_sql/
│   ├── 01_trips_per_company.sql
│   ├── 02_yellow_and_blue_companies.sql
│   ├── 03_top_two_vs_others.sql
│   ├── 04_loop_and_ohare_ids.sql
│   ├── 05_weather_conditions_per_hour.sql
│   └── 06_loop_to_ohare_saturdays.sql
├── 03_analysis/
│   └── zuber_analysis.ipynb
├── data/
│   ├── weather_records.csv
│   ├── project_sql_result_01.csv
│   ├── project_sql_result_04.csv
│   └── project_sql_result_07.csv
└── requirements.txt
```

The folders are numbered in the order the work happened.

## Step 1. Web scraping

The weather for November 2017 was not in a file. It was in an HTML table on a web page.

The script `01_web_scraping/weather_records.py` downloads the page with `requests`, finds the table with `BeautifulSoup`, turns it into a pandas DataFrame and saves it as `data/weather_records.csv`. The result has 697 hourly records with date and time, temperature and a short description of the weather, such as "light rain" or "broken clouds".

## Step 2. SQL

The rides live in a database with four tables:

| Table | What it holds |
|---|---|
| `neighborhoods` | Name and id of each neighborhood |
| `cabs` | Each taxi and the company that owns it |
| `trips` | Each ride: taxi, start and end time, duration, distance, pickup and drop-off neighborhoods |
| `weather_records` | Hourly weather: time, temperature and description |

Each file in `02_sql` answers one question:

| Query | Question |
|---|---|
| `01_trips_per_company` | Which taxi companies got the most rides on November 15 and 16? |
| `02_yellow_and_blue_companies` | How many rides did the companies with "Yellow" or "Blue" in their name get in the first week of November? |
| `03_top_two_vs_others` | How do Flash Cab and Taxi Affiliation Services compare with all the other companies together? |
| `04_loop_and_ohare_ids` | What are the ids of the Loop and O'Hare neighborhoods? |
| `05_weather_conditions_per_hour` | Was the weather good or bad at each hour? |
| `06_loop_to_ohare_saturdays` | Which Saturday rides went from the Loop to O'Hare, how long did they take and what was the weather like? |

All six queries were written and run on a PostgreSQL database hosted by the TripleTen learning platform. Every file has comments explaining the reasoning, and the results of the main queries are saved in the `data` folder, so the analysis can be followed and reproduced from here.

One detail worth mentioning: `trips` and `weather_records` have no direct link. Since both timestamps are rounded to the hour, the last query joins them on the hour the ride started.

## Step 3. Analysis and hypothesis test

The notebook `03_analysis/zuber_analysis.ipynb` brings everything together:

1. **Import and web scraping**: loads the data.
2. **Data cleaning**: checks types, missing values and duplicates. The files arrive already aggregated by the SQL queries, so no cleaning was needed.
3. **Analysis**: the top 10 destinations, the biggest taxi companies and the number of rides with good and bad weather, each with a chart and a conclusion.
4. **Hypothesis test**: whether rainy Saturdays change the duration of the ride from the Loop to O'Hare. It uses a two-sample t-test with a 5% significance level, and the notebook explains how the hypotheses were formed and why that test was chosen.

## The data files

| File | Where it comes from | What it holds |
|---|---|---|
| `weather_records.csv` | Web scraping script | Hourly weather in Chicago, November 2017 |
| `project_sql_result_01.csv` | Query 01 | Taxi companies and their number of rides on November 15 and 16 |
| `project_sql_result_04.csv` | Provided by TripleTen | Neighborhoods and the average number of rides that ended in each one in November |
| `project_sql_result_07.csv` | Query 06 | Saturday rides from the Loop to O'Hare, with weather and duration |

## How to run it

```
pip install -r requirements.txt
python 01_web_scraping/weather_records.py
```

Run the script from the project folder. Then open `03_analysis/zuber_analysis.ipynb` and run all the cells.

## Tools

Python (pandas, requests, BeautifulSoup, matplotlib, SciPy), SQL (PostgreSQL) and Jupyter.

---

Project developed as part of the TripleTen Data Analyst program.
