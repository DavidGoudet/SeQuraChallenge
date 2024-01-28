# SeQura backend coding challenge

This app calculates and persist the disbursements that need to be paid to merchants on a given day.

### Technologies
- Rails 7.1.3
- Ruby 3.3.0
- SQLite 3.39.5
- RSpec > 5.0

### Installation instructions
The app uses the Ruby on Rails framework to work. To test it in a local environment you need to:

- Install Ruby and Ruby on Rails on your local machine: [Ruby on Rails Installation Instructions](https://web.stanford.edu/~ouster/cgi-bin/cs142-fall10/railsInstall.php)
- Run ```bundle install``` to install the gems defined in the Gemfile
- Run the migrations with ```rails db:migrate```

### Features

- Import CSV files with merchants and orders
- Calculate and store the disbursements needed on a given day
- Calculate and store the monthly fees if the minimum was not reached
- Calculate Disbursements and Fees for a given year

### Use instructions

- Save on ```app/data``` the csv files that are going to be calculated:

-- ```merchants.csv``` and ```orders.csv```
- Load the data to the database with the rakes:

-- ```rake csv_import:merchants```

-- ```rake csv_import:orders```
- Calculate and store the disbursements with the rake (2023 is a variable for the year):

-- ```rake 'year_calculator:run_year_disbursements[2023]'```
- Run and print the calculations for the stats of a year:

-- ```rake 'year_calculator:calculate[2023]'```

### Disbursement calculations
The following table includes the results of calculating the stats for 2 years with the rake included in this app:

| Year  | Number of Disbursements   |  Amount disbursed to merchants | Amount of order fees  | Number of monthly fees charged (From minimum monthly fee)  | Amount of monthly fee charged (From minimum monthly fee) |
|---|---|---|---|---| --- |
|  2022 | 2167  |  38,439,158.23€ |  347,319.4€ | 379 | 9,272.03€ |
| 2023   | 13329   |  187,054,761.6€ | 1,695,618.73€  | 108  | 2,108.9€ |

### Notes

- To calculate a daily merchant's disbursements, I calculated the orders generated from the previous day after 8:00 UTC to those generated on the current day before that same hour.
- Rails was used to take advantage of the ORM, but all tasks are inside Rakes. In a real scenario, I would move the logic to APIs to ingest the new information, services to make the calculations, and a visual UI to make it easier for the client to use the tool.
- There are two sets of tests, made for the critical methods in the models, one for Disbursement and other for MinimumExtraFee, they can be run with ```rspec```.
- The calculations could be faster if we add a field ```year``` to the disbursements and minimum extra fees. I would add an index to that field because that query is recurrent.