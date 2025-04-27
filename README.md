# Airline Delays and Cancellations Analysis (Power BI + SQL)
# Project Overview
This project analyzes airline flight delays and cancellations from 2014 to 2018 using data sourced from Kaggle's Airline Delay and Cancellation Dataset.
The project involved cleaning and transforming the raw data using SQL Server, followed by developing an interactive Power BI dashboard to visualize key operational metrics and passenger feedback insights.

# Objectives
Analyze trends in total flights, delays, and cancellations over time.

Measure ground processing efficiency based on flight schedules.

Map source and destination airports to understand flight patterns.

Incorporate passenger feedback to assess satisfaction impact.

Enable dynamic filtering by year, airline, and airport.

# Tools and Technologies
SQL Server: Data cleaning, transformation, and preparation.

Power BI: Data modeling, dashboard creation, and visualization.

Power BI Service: Report publication and sharing.

# Dataset Information
Source: Kaggle Airline Dataset

Time Period: 2014–2018

# Key fields used:

CANCELLED, CANCELLATION_CODE

ARR_DELAY, DEP_DELAY

AIRLINE, ORIGIN_AIRPORT, DESTINATION_AIRPORT

Passenger feedback and satisfaction scores (synthesized for analysis)

# Power BI Dashboard
You can view the interactive Power BI dashboard here:
[🔗 View Live Dashboard](https://app.powerbi.com/groups/me/reports/d599e559-7198-45ce-9fcf-171b3fe2f03d/b5fac3ea61764abc2485?experience=power-bi)

Note: The dashboard is published via Power BI's "Publish to Web" feature and is accessible publicly.

# Project Structure
SQL
  └── Data_Cleaning_Scripts.sql    # SQL queries for cleaning and preparing the dataset

PowerBI
  └── Airline_Dashboard.pbix       # Power BI project file (link or reference only)

# Key Insights
Total Flights: Yearly and monthly trends showing operational peaks and slumps.

Flight Delays: Distribution and primary reasons for delays (Carrier, Weather, NAS, etc.).

Ground Processing Time: Analysis of scheduled vs actual turnaround times.

Passenger Feedback: Correlation between delays/cancellations and passenger satisfaction.

Flight Routes Map: Visualization of source and destination airport networks.

# Future Improvements
Integrate weather data for deeper cause analysis.

Add machine learning models to predict delays.

Build mobile-friendly dashboard views.

# Acknowledgements
Kaggle for the open-source dataset.

Microsoft Power BI Community for learning resources.

# License
This project is for educational and portfolio purposes only.

# Author
Neetika Upadhyay
Data Analyst
Ottawa, Canada
[neetusco26@gmail.com]
