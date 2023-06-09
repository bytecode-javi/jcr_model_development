# The name of this view in Looker is "Order Items"
# This view was enhanced from it's original form in order to perform a case study analysis as part of the Onboarding process at Bytecode IO

view: order_items {
  sql_table_name: `thelook.order_items`;;
  drill_fields: [id, product_details*]

  dimension: id {
    primary_key: yes
    description: "Unique identifier for item order"
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
      hour_of_day,
      date,
      day_of_week,
      day_of_week_index,
      day_of_month,
      day_of_year,
      week,
      week_of_year,
      month,
      month_name,
      month_num,
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
      hour_of_day,
      date,
      day_of_week,
      day_of_week_index,
      day_of_month,
      day_of_year,
      week,
      week_of_year,
      month,
      month_name,
      month_num,
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

  dimension: inventory_item_id {
    description: "Unique identifier for inventory items"
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: is_cancelled {
    description: "Identify order items that have been cancelled"
    type: yesno
    sql: ${status}= "Cancelled" ;;
  }

  dimension: is_complete {
    description: "Identify order items that have been completed"
    type: yesno
    sql: ${status}!="Cancelled" and ${returned_raw} is null ;;
  }

  dimension: is_returned {
    description: "Identify order items that have been returned"
    type: yesno
    sql: ${returned_raw} is not null ;;
  }

  dimension: mtd_only {
    group_label: "To-Date Filters"
    label: "MTD"
    view_label: "_orders_PoP"
    type: yesno
    sql:  EXTRACT(DAY FROM ${created_raw}) <= EXTRACT(DAY FROM current_date) ;;
  }

  dimension: qtd_only {
    group_label: "To-Date Filters"
    label: "QTD"
    view_label: "_orders_PoP"
    type: yesno
    sql:  EXTRACT(QUARTER FROM ${created_raw}) <= EXTRACT(QUARTER FROM current_date) ;;
  }

  dimension: pop_row {
    view_label: "_orders_PoP"
    label_from_parameter: pop_compare
    type: string
    sql:
    {% if pop_compare._parameter_value == 'Year' %} ${created_year}
    {% elsif pop_compare._parameter_value == 'Quarter' %} ${created_quarter}
    {% elsif pop_compare._parameter_value == 'Month' %} ${created_month}
    {% else %}NULL{% endif %};;
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
      hour_of_day,
      date,
      day_of_week,
      day_of_week_index,
      day_of_month,
      day_of_year,
      week,
      week_of_year,
      month,
      month_name,
      month_num,
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
      hour_of_day,
      date,
      day_of_week,
      day_of_week_index,
      day_of_month,
      day_of_year,
      week,
      week_of_year,
      month,
      month_name,
      month_num,
      quarter,
      year
    ]
    sql: ${TABLE}.shipped_at ;;
  }

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

  dimension: ytd_only {
    group_label: "To-Date Filters"
    label: "YTD"
    view_label: "_orders_PoP"
    type: yesno
    sql:  EXTRACT(DAYOFYEAR FROM ${created_raw}) <= EXTRACT(DAYOFYEAR FROM current_date) ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.

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

  measure: gross_margin_percent {
    description: "Total Gross Margin Amount / Total Gross Revenue"
    type: number
    sql: ${total_gross_margin_amount}/ NULLIF(${total_gross_revenue},0) ;;
    value_format_name: percent_2
  }

  measure: gross_revenue_mtd {
    type: sum
    filters: [is_complete: "yes", mtd_only: "yes"]
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: gross_revenue_qtd {
    type: sum
    filters: [is_complete: "yes", qtd_only: "yes"]
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: gross_revenue {
    type: number
    label: "Gross Revenue"
    sql:{% if pop_to_date._parameter_value == 'Yes' %}
            ${gross_revenue_ytd}
        {% elsif pop_to_date._parameter_value == 'Yes' %}
            ${gross_revenue_qtd}
        {% elsif pop_to_date._parameter_value == 'Yes' %}
            ${gross_revenue_mtd}
        {% else %}
            ${total_gross_revenue}
        {% endif %} ;;
    value_format_name: usd
  }

  measure: gross_revenue_pop {
    type: number
    label: "Gross Revenue"
    view_label: "_orders_PoP"
    sql:{% if pop_to_date._parameter_value == 'Yes' and pop_compare._parameter_value == 'Year' %}
            ${gross_revenue_ytd}
        {% elsif pop_to_date._parameter_value == 'Yes' and pop_compare._parameter_value=='Quarter' %}
            ${gross_revenue_qtd}
        {% elsif pop_to_date._parameter_value == 'Yes' and pop_compare._parameter_value=='Month' %}
            ${gross_revenue_mtd}
        {% else %}
            ${total_gross_revenue}
        {% endif %} ;;
    value_format_name: usd
  }

  measure: gross_revenue_ytd {
    type: sum
    filters: [is_complete: "yes", ytd_only: "yes"]
    sql: ${sale_price} ;;
    value_format_name: usd
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
    drill_fields: [product_details*]
  }

  measure: total_gross_revenue {
    description: "Total revenue from completed sales (cancelled and returned orders excluded)"
    type: sum
    sql:  ${sale_price} ;;
    filters: [status: "Complete"]
    value_format_name: usd
    drill_fields: [product_details*]
  }

  measure: total_sale_price {
    description: "Total sales from items sold"
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd_0
    drill_fields: [product_details*]
  }

  measure: total_orders {
    description: "Total orders"
    type: count_distinct
    sql: ${order_id} ;;
    filters: [status: "Complete"]
  }

## PARAMETERS ##
  parameter: pop_compare {
    label: "Select Period"
    view_label: "_orders_PoP"
    type: unquoted
    default_value: "Year"
    allowed_value: {value: "Year"}
    allowed_value: {value: "Quarter"}
    allowed_value: {value: "Month"}
  }

  parameter: pop_to_date {
    type: unquoted
    allowed_value: {value: "Yes"}
    allowed_value: {value:"No"}
  }

## DRILL ##
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
  set: product_details{
    fields: [products.category, products.brand, total_gross_revenue, total_gross_margin_amount]
  }
}
