# Coding Assignment

A company ‘MediaNow’ is selling packages - Basic, Plus, and Premium. The price for each package is updated regularly and a pricing log is kept for all packages. The company is doing well and the feature requests are pouring in! Help us by implementing the following two feature requests made by our coworkers.

## Feature request 1: Municipalities
The company pricing expert wants to start segmenting our package prices based on the municipality the package is sold in. In other words, a package should be able to have different prices depending on a municipality. The current code doesn't really support this well (on purpose) and some structural changes are needed. We still want to have our pricing log, but now with the added municipalities.

To add this feature, continue the work in the file `app/lib/update_package_price.rb`.

## Feature request 2: Pricing history
An accounting department needs information on price changes that happened for the package basic in 2020. This kind of request will happen frequently, so we need a simple way to fetch pricing history, given a package, a year and optionally a municipality.

To add a pricing history, continue the work in the file `app/lib/price_history.rb`.

As an example, assuming the following prices exist
| Package       | Municipality  | Price   | Date        |
| ------------- | ------------- | ------: | ----------: |
| Premium       | Stockholm     | 100 kr  | 2023-04-01  |
| Premium       | Stockholm     | 125 kr  | 2023-08-02  |
| Premium       | Stockholm     | 175 kr  | 2023-12-24  |
| Premium       | Göteborg      | 25 kr   | 2022-09-01  |
| Premium       | Göteborg      | 50 kr   | 2023-02-03  |
| Premium       | Göteborg      | 75 kr   | 2023-05-20  |
| Bas           | Göteborg      | 100 kr  | 2023-06-01  |

We expect something similar to the output below.
```ruby
# Example without municipality
PriceHistory.call(
  year: "2023",
  package: "premium",
)

=> { "Stockholm" => [100_00, 125_00, 175_00], "Göteborg" => [50_00, 75_00] }

# Example with municipality. Stockholm is filtered out.
PriceHistory.call(
  year: "2023",
  package: "premium",
  municipality: "göteborg",
)

=> { "Göteborg" => [50_00, 75_00] }
```

## Starting out
**NOTE: In this assignment we assume you are comfortable with developing Rails applications.**

We have set up a minimal Rails app with some models and tests added. Running rspec should result in all tests passing:

```sh
# Assuming the Rails app is set up and the database is created/migrated
media_now $ rspec
.......

Finished in 0.03535 seconds (files took 1.05 seconds to load)
7 examples, 0 failures
```

There is a seed that might be helpful in the beginning of the assignment. You probably want to update it after you finish the first feature request (though it is not required):

```
$ rails db:seed
Removing old packages and their price histories
Creating new packages
Creating a price history for the packages
```

## A few notes about the assignment

We would like you to model the product domain and update the application to enable the two features.
Think through your solution and implement it based on the instructions and your own thoughts. Spend at most 3 hours on the assignment. It's not worth more of your time (or ours).

- Complete the assignment, only having passing tests (old and new ones)
- Approach the assignment as if it was a real task at work.
- Write code as if it was to be delivered to production
- Don't be afraid to update old tests if needed.
- Use version control (Git preferably) and commit frequently
- Set your own scope and make your own prioritizations for the challenge
- You don't need to spend any time on deployment/ops solutions, e.g. using Docker
- No HTTP requests are needed anywhere

## If things go wrong
Let us know if something doesn't seem right. We might have missed something. Don't panic! 💚

## Follow-up
Send us the code when you are done, preferably hosted on a service such as GitHub, Bitbucket, or Gitlab. We will review your solution in a follow-up interview where we will go through and discuss the different aspects of the application, for example:
- Application structure
- Data integrity
- Testing
- Design choices and their advantages and disadvantages

To solve the assignment, clone this repo and push it with your solution to a new repository.
