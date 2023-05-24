# The name of this view in Looker is "Products"
# This view was enhanced from it's original form in order to perform a case study analysis as part of the Onboarding process at Bytecode IO

view: products {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `thelook.products`
    ;;
  drill_fields: [id, category, brand, name]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    description: "Unique identifier for products"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    description: "Product brand"
    type: string
    sql: ${TABLE}.brand ;;
    drill_fields: [category, name]
    suggest_explore: products
    link: {
      label: "Search Google"
      url: "http://www.google.com/search?q={{ value }}"
      icon_url: "http://google.com/favicon.ico"
    }

  }

  dimension: category {
    description: "Product category"
    type: string
    sql: ${TABLE}.category ;;
    drill_fields: [brand, name]
  }

  dimension: cost {
    description: "Product cost"
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension: department {
    description: "Product department"
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: distribution_center_id {
    description: "Unique identifier for distribution centers"
    type: number
    sql: ${TABLE}.distribution_center_id ;;
  }

  dimension: name {
    description: "Product name"
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: retail_price {
    description: "Retail price of product"
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    description: "SKU"
    type: string
    sql: ${TABLE}.sku ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: average_cost {
    description: "Average cost of products"
    type: average
    sql: ${cost} ;;
    value_format_name: usd
  }

  measure: count {
    type: count_distinct
    drill_fields: [detail*]
  }

  measure: total_cost {
    description: "Total cost of products"
    type: sum
    sql: ${cost} ;;
    value_format_name: usd
  }

##--PARAMETERS--##
  parameter: selected_brand {
    type: string
    suggest_dimension: brand
    default_value: "The North Face"
  }

  parameter: select_category {
    type: string
    suggest_dimension: category
    default_value: "Active"
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      name,
      distribution_centers.name,
      distribution_centers.id,
      inventory_items.count,
      order_items.count
    ]
  }

}
