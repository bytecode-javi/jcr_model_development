# The name of this view in Looker is "Inventory Items"
# This view was enhanced from it's original form in order to perform a case study analysis as part of the Onboarding process at Bytecode IO

view: inventory_items {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `thelook.inventory_items`
    ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    description: "Unique identifier of inventory items"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Cost" in Explore.

  dimension: cost {
    description: "Cost of inventory items"
    type: number
    sql: ${TABLE}.cost ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: created {
    description: "Date in which item entered inventory"
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

  dimension: product_brand {
    description: "Product brand"
    type: string
    sql: ${TABLE}.product_brand ;;
  }

  dimension: product_category {
    description: "Product category"
    type: string
    sql: ${TABLE}.product_category ;;
  }

  dimension: product_department {
    description: "Product department"
    type: string
    sql: ${TABLE}.product_department ;;
  }

  dimension: product_distribution_center_id {
    description: "Unique identifier for distribution center product"
    type: number
    sql: ${TABLE}.product_distribution_center_id ;;
  }

  dimension: product_id {
    description: "Unique identifier for product"
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension: product_name {
    description: "Product name"
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_retail_price {
    description: "Product retail price"
    type: number
    sql: ${TABLE}.product_retail_price ;;
  }

  dimension: product_sku {
    description: "SKU"
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  dimension_group: sold {
    description: "Date item was sold"
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
    sql: ${TABLE}.sold_at ;;
  }
  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.



  measure: average_cost {
    description: "Average cost of items sold from inventory"
    type: average
    sql: ${cost} ;;
    filters: [sold_date: "NOT NULL"]
    value_format_name: usd
  }

  measure: count {
    type: count
    drill_fields: [id, product_name, products.name, products.id, order_items.count]
  }

  measure: total_cost {
    description: "Total cost of items sold from inventory"
    type: sum
    sql: ${cost} ;;
    filters: [sold_date: "NOT NULL"]
    value_format_name: usd
  }

}
