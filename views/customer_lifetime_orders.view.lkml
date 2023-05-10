view: customer_lifetime_orders {
 derived_table: {
  sql:
      SELECT
        user_id,
        SUM(sale_price) AS total_spent,
        COUNT(distinct order_id) as total_orders,
        MIN(created_at) as first_order,
        MAX(created_at) as last_order
      FROM
        order_items
      GROUP BY
        1;;
  }

## DIMENSIONS ##

  dimension: customer_id {
    type: number
    description: "Unique identifier for each customer"
    primary_key: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: days_since_last_order {
    type: duration_day
    description: "Identifies the number of days since the customer last made a purchase"
    sql_start: ${last_order} ;;
    sql_end: current_date();;
  }

  dimension: first_order {
    type: date
    description: "The date in which a customer placed his or her first order on the fashion.ly website"
    sql: ${TABLE}.first_order ;;
  }

  dimension: is_active {
    type: yesno
    description: "Identifies whether a customer is active or not (has purchased from the website within the last 90 days)"
    sql: ${days_since_last_order} <= 90;;
  }

  dimension: is_repeat_customer {
    type: yesno
    description: "Identifies whether a customer has previously made a purchase or not"
    sql: ${lifetime_orders} > 1 ;;
  }

  dimension: last_order {
    type: date
    description: "The date in which a customer placed his or her most recent order on the fashion.ly website"
    sql: ${TABLE}.last_order ;;
  }

  dimension: lifetime_orders {
    type: number
    description: "The total number of orders placed over the course of customers’ lifetimes"
    sql: ${TABLE}.total_orders  ;;
  }

  dimension: lifetime_orders_group {
    type: tier
    description: "Specific value groupings associated with total number of orders from an individual customer over the course of their patronage"
    style: relational
    tiers: [0,1,2,3,6,10]
    sql: ${lifetime_orders};;
  }

  dimension: lifetime_revenue {
    type: number
    description: "The total amount of revenue brought in over the course of customers’ lifetimes"
    value_format_name: usd
    sql: ${TABLE}.total_spent ;;
  }

  dimension: lifetime_revenue_group {
    type: tier
    description: "Specific value groupings associated with total amount of revenue from an individual customer over the course of their patronage"
    style: integer
    tiers: [5,20,50,100,500,1000]
    sql: ${lifetime_revenue} ;;
    value_format_name: usd
  }

## MEASURES ##

  measure: avg_days_since_last_order {
    type: average
    description: "Identifies the average number of days since the customer last made a purchase"
    sql: ${days_since_last_order} ;;
  }

  measure: average_lifetime_orders {
    type: average
    description: "The average number of orders that a customer places over the course of their lifetime as a customer"
    value_format_name: decimal_1
    sql: ${lifetime_orders} ;;
  }

  measure: average_lifetime_revenue {
    type: average
    description: "The average amount of revenue that a customer brings in over the course of their lifetime as a customer"
    value_format_name: usd
    sql: ${lifetime_revenue} ;;
  }

  measure: customer_count {
    type: count_distinct
    sql: ${customer_id} ;;
  }
}
