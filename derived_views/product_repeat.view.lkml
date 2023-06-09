## Product Repeat Derived View##
## Evaluate the population of repurchased products in order to identify instances where a customer has purchased the same item multiple times ##
## Leverage this dataset to understand if certain brands/categories have a lower repeat purchase than others (>1, <3) ##
view: product_repeat {
  derived_table: {
    sql: SELECT
          order_items.user_id  AS order_items_user_id,
          order_items.id  AS order_items_id,
          order_items.order_id  AS order_items_order_id,
          order_items.product_id  AS order_items_product_id,
          (DATE(order_items.created_at , 'America/Los_Angeles')) AS order_items_created_date,
          products.category  AS products_category,
          products.brand  AS products_brand,
          products.name  AS products_name,
          row_number() over (partition by user_id, brand order by created_at) as brand_counter,
          row_number() over (partition by user_id, category order by created_at) as category_counter
      FROM `thelook.order_items` AS order_items
      LEFT JOIN `thelook.products`
           AS products ON order_items.product_id = products.id;;
  }

## IDs ##

  dimension: id {
    group_label: "IDs"
    type: number
    primary_key: yes
    sql: ${TABLE}.order_items_id ;;
  }

  dimension: order_id {
    group_label: "IDs"
    type: number
    sql: ${TABLE}.order_items_order_id ;;
  }

  dimension: product_id {
    group_label: "IDs"
    type: number
    sql: ${TABLE}.order_items_product_id ;;
  }

  dimension: user_id {
    group_label: "IDs"
    type: number
    sql: ${TABLE}.order_items_user_id ;;
  }

## MEASURES ##

  dimension: brand {
    type: string
    sql: ${TABLE}.products_brand ;;
    link: {
      label: "Search Google"
      url: "http://www.google.com/search?q={{ value }}"
      icon_url: "http://google.com/favicon.ico"
    }
    link: {
      label: "Compare Brand"
      url: "https://looker.bytecode.io/dashboards/him8AFBPKX8q5mivsfYOkN?Select+Brand={{ value }}"
    }
  }

  dimension: brand_counter {
    type: number
    sql: ${TABLE}.brand_counter ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.products_category ;;
    link: {
      label: "Compare Category"
      url: "https://looker.bytecode.io/dashboards/him8AFBPKX8q5mivsfYOkN?Select+Category={{ value }}"
    }
  }

  dimension: category_counter {
    type: number
    sql: ${TABLE}.category_counter ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}.order_items_created_date ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.products_name ;;
  }


## MEASURES  ##

  measure: brand_total_repeat_orders {
    type: count
    filters: [brand_counter: ">1"]
    drill_fields: [detail*]
  }

  measure: category_total_repeat_orders {
    type: count
    filters: [category_counter: ">1"]
    drill_fields: [detail*]
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: repeat_rate_for_brand {
    type: number
    sql: ${brand_total_repeat_orders}/${count};;
    value_format_name: percent_2
  }

  measure: repeat_rate_for_category {
    type: number
    sql: ${category_total_repeat_orders}/${count} ;;
    value_format_name: percent_2
  }

## DRILL ##
  set: detail {
    fields: [category, brand, name]
  }
}
