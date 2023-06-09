view: compare_brands {
  derived_table: {
    explore_source: order_items {
      column: id {}
      column: created_date {}
      column: category { field: products.category }
      column: brand { field: products.brand }
      column: total_orders {}
      column: total_gross_revenue {}
    }
  }

  dimension: id {
    description: "Unique identifier for order items"
    primary_key: yes
    type: number
  }

  parameter: date_granularity {
    type: unquoted
    allowed_value: {
      label: "Break down by Year"
      value: "Year"
    }
    allowed_value: {
      label: "Break down by Month"
      value: "Month"
    }
    allowed_value: {
      label: "Break down by Quarter"
      value: "Quarter"
    }
  }

  dimension: date {
    sql:
    {% if date_granularity._parameter_value == "Year" %}
      ${created_date_year}
    {% elsif date_granularity._parameter_value == "Quarter" %}
      ${created_date_quarter}
    {% elsif date_granularity._parameter_value == "Month" %}
      ${created_date_month}
    {% else %}
      ${created_date_date}
      {% endif %}        ;;
  }

  dimension_group: created_date {
    label: "Created"
    description: "Date the item order was created"
    type: time
    timeframes: [
      raw,
      date,
      month,
      quarter,
      year
    ]
    convert_tz: no
  }

  dimension: category {
    description: "Product category"
  }

  dimension: brand {
    description: "Product brand"
  }

  dimension: total_orders {
    description: "Total orders"
    type: number
  }

  dimension: total_gross_revenue {
    description: "Total revenue from completed sales (cancelled and returned orders excluded)"
    value_format: "$#,##0.00"
    type: number
  }

  filter: brand_select {
    description: "Select brand of interest"
    label: "Select Brand"
    suggest_dimension: brand
  }

  filter: category_select {
    description: "Select category of interest"
    label: "Select Category"
    suggest_dimension: category
  }


  dimension: brand_and_product_comparitor {
    description: "Comparison brand and products"
    label: "Compare Brand and Product"
    type: string
    sql:
    case when   {% condition brand_select %} ${brand} {% endcondition %}
            and {% condition category_select %} ${category} {% endcondition %}
            then ${brand}
         when {% condition category_select %} ${category} {% endcondition %}
                then 'Competing Brands in Same Category'
         when  {% condition brand_select %} ${brand} {% endcondition %}
                then 'Other Products within Brand'
      else 'All Other Brands'
      end;;
  }

  dimension: brand_comparitor {
    description: "Compare a selected brand to All Other Brands"
    label: "Compare Brand"
    type: string
    sql: case when {% condition brand_select %} ${brand} {% endcondition %}
          then ${brand}
          else 'All Other Brands'
          end;;
  }

  dimension: category_comparitor {
    description: "Compare a selected category to All Other Categories"
    label: "Compare Category"
    type: string
    sql: case when {% condition category_select %} ${category} {% endcondition %}
          then ${category}
          else 'All Other Categories'
          end;;
  }

## MEASURES ##

  measure: total_aggregate_orders {
    description: "Total aggregate orders"
    type: sum
    sql: ${total_orders} ;;
    value_format_name: decimal_0
  }

  measure: total_aggregate_revenue {
    description: "Total aggregate revenue"
    type: sum
    sql: ${total_gross_revenue} ;;
    value_format_name: usd
  }

## PARAMETERS ##
  # parameter: select_period  {
  #   label: "Select Period"
  #   type: unquoted
  #   default_value: "Year"
  #   allowed_value: {value: "Year"}
  #   allowed_value: {value: "Quarter"}
  #   allowed_value: {value: "Month"}
  # }

}
