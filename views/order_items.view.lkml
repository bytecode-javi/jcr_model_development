# The name of this view in Looker is "Order Items"
# This view was enhanced from it's original form in order to perform a case study analysis as part of the Onboarding process at Bytecode IO

view: order_items {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `thelook.order_items`;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: created {
    description: "Date the item order was created"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    description: "Date the item was delivered"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: gross_margin_amount {
    description: "Difference between the total revenue from completed sales and the cost of the good that were sold"
    type: number
    sql: ${sale_price} - ${inventory_items.cost} ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Inventory Item ID" in Explore.

  dimension: inventory_item_id {
    description: "Unique identifier for inventory items"
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    description: "Unique identifier for orders"
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: product_id {
    description: "Unique identifier for products"
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension_group: returned {
    description: "Date the item was returned"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    description: "Sales price of the item"
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension_group: shipped {
    description: "Date the item was shipped"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.shipped_at ;;
  }

# Dimension added to define status of item order (e.g. "Complete", "Cancelled")
  dimension: status {
    description: "Status of item order"
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    description: "Unique identifier of users"
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: average_gross_margin {
    description: "Average difference between the total revenue from completed sales and the cost of the goods that were sold"
    type: average
    sql: ${gross_margin_amount} ;;
    filters: [status: "Complete"]
    value_format_name: usd
  }

  measure: average_order_count {
    description: "The average amount of orders"
    type: average
    sql: ${order_id} ;;
    filters: [status: "Complete"]
    value_format_name: decimal_2
    html: {{average_order_count._rendered_value }} ;;
  }

  measure: average_sale_price {
    description: "Average sale price of items sold"
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: average_spend_per_customer {
    description: "Total Sale Price / total number of customers"
    type: number
    sql: ${total_sale_price} / NULLIF(${number_of_customers},0);;
    value_format_name: usd
  }

  measure: cumulative_total_sales {
    description: "Cumulative total sales from items sold (also known as a running total)"
    type: running_total
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: first_order_date {
    description: "Date in which customer's first order was created"
    type: date
    sql: min(${created_raw}) ;;
    convert_tz: no
  }

  measure: gross_margin_pcnt {
    description: "Total Gross Margin Amount / Total Gross Revenue"
    type: number
    sql: ${total_gross_margin_amount}/ NULLIF(${total_gross_revenue},0) ;;
    value_format_name: percent_2
  }

  measure: item_return_rate {
    description: "Number of Items Returned / total number of items sold"
    type: number
    sql: ${number_of_items_returned} / NULLIF(${number_of_items_sold},0);;
    value_format_name: percent_2
  }

  measure: latest_order_date {
    description: "Date in which customer's latest order was created"
    type: date
    sql: max(${created_raw}) ;;
    convert_tz: no
  }

  measure: number_of_customers {
    description: "Count of distinct customers"
    type: count_distinct
    sql: ${user_id}  ;;
  }

  measure: number_of_customers_returning_items {
    description: "Number of users who have returned an item at some point"
    type: count_distinct
    sql: ${user_id}  ;;
    filters: [status: "Returned"]
  }

  measure: number_of_items_returned{
    description: "Number of items that were returned by dissatisfied customers"
    type: count_distinct
    sql: ${id} ;;
    filters: [status: "Returned"]
  }

  measure: number_of_items_sold{
    description: "Count of items sold"
    type: count_distinct
    sql: ${id} ;;
    filters: [status: "Complete"]
  }

  measure: percent_of_users_with_returns {
    description: "Number of Customer Returning Items / total number of customers"
    type: number
    sql: ${number_of_customers_returning_items} / NULLIF(${number_of_customers},0);;
    value_format_name: percent_2
  }

  measure: total_gross_margin_amount {
    description: "Total difference between the total revenue from completed sales and the cost of the goods that were sold"
    type: sum
    sql: ${gross_margin_amount} ;;
    filters: [status: "Complete"]
    value_format_name: usd
  }

  measure: total_gross_revenue {
    description: "Total revenue from completed sales (cancelled and returned orders excluded)"
    type: sum
    sql:  ${sale_price} ;;
    filters: [status: "Complete"]
    value_format_name: usd
  }

  measure: total_sale_price {
    description: "Total sales from items sold"
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd_0
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.last_name,
      users.id,
      users.first_name,
      inventory_items.id,
      inventory_items.product_name,
      products.name,
      products.id
    ]
  }
}
