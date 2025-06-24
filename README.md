## Introduction

The MediaNow project is a pricing management system for various packages, which currently tracks the price of packages over time. This assignment required the addition of two new features: 
1. **Municipalities**: Enabling package prices to vary depending on the municipality in which the package is sold.
2. **Pricing History**: Providing an easy way for the accounting department to access price changes for a package within a given year, optionally filtered by municipality.

### **Given Requirements**

The assignment specifies two main feature requests:

- **Feature 1: Municipalities**: Introduce a way to associate package prices with different municipalities, which would allow the company to have different prices for packages depending on the municipality. This would require structural changes in the data model, ensuring that historical pricing data remains intact.
  
- **Feature 2: Pricing History**: Create a simple and efficient way to retrieve the price history for a package, given a specific year, and optionally filtered by municipality. The goal was to implement a feature that could efficiently query pricing data, particularly for large datasets.

## **Approach Taken**

### **Feature 1: Municipalities**

#### **Objective:**
The task required associating package prices with different municipalities. This was done to ensure that the prices could vary by location while keeping track of all historical data. The implementation needed to be backward compatible with the existing price records.

#### **Design Decision:**
- **Column vs Model**: Initially, I considered adding a column to the `prices` table to store the `municipality_name`. However, this would have introduced inconsistencies and limitations, such as case-sensitivity issues and a lack of flexibility. I decided to use a **Municipality model** instead.
- **Municipality Model**: The **Municipality model** allows for clean data relationships and flexibility, as it can be extended to store additional information such as tax rules or regional data. It also ensures that all prices refer to a valid and consistent municipality by using a foreign key.
  
#### **Implementation:**
- I created a new **Municipality model** and added a foreign key reference to the `prices` table.
- To preserve old pricing data, I introduced a special municipality named **"global"** to assign to legacy price records that didn’t have a municipality associated with them. This ensures that no data is lost, and queries can still be made consistently.
  
#### **Updated Architecture**:
- **Packages** has a one-to-many relationship with **Prices**.
- **Municipalities** has a one-to-many relationship with **Prices**.
- **Prices** belongs to both **Packages** and **Municipalities**.

#### **Preserving Old Data**:
- A migration was added to assign the **global** municipality to existing price records without an associated municipality.
- Updated `seeds.rb` to handle both old and new data formats, ensuring consistent data.

### **Feature 2: Pricing History**

#### **Objective:**
The task was to allow easy querying of price history for a package, given a specific year, and optionally filtered by municipality. The solution aimed to be fast, especially when dealing with large datasets.

#### **Design Decision:**
- I initially considered using **ElasticSearch** or **GraphQL** to improve query performance and flexibility. However, as the assignment didn’t require HTTP requests and the complexity of these tools wasn’t necessary for the given requirements, I opted to implement a **clean, modular Ruby solution**.
  
- **Caching**: I decided to implement **caching** for frequently requested price history data, which would reduce repeated database queries and improve response times. This was done using **Rails.cache** for efficient querying and caching.

#### **Implementation**:
- A **PriceHistoryService** class was created to handle the querying and caching of price history.
- The `PriceHistory.call` method was implemented to retrieve pricing data for a given package and year, and optionally filter by municipality.
- The data is grouped by municipality, and price history is returned in the required format.

#### **Example Output**:

```ruby
# Example without municipality
PriceHistory.call(
  year: "2023",
  package: "premium",
)

# Expected Output:
# { "Stockholm" => [100_00, 125_00, 175_00], "Göteborg" => [50_00, 75_00] }

# Example with municipality
PriceHistory.call(
  year: "2023",
  package: "premium",
  municipality: "göteborg",
)

# Expected Output:
# { "Göteborg" => [50_00, 75_00] }
```

## **How to Set Up and Run the Application**

  ```bash
  bundle install
  rails db:create
  rails db:migrate
  rails db:seed
  rails server
  ```
  To run test cases
  ``` bash
  bundle exec rspec
  ```

### License
This code belongs to Saad Ishtiaq. All rights reserved.😊