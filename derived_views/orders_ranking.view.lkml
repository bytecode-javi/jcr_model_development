# order items ranked which gives timeline of orders by user
# used to calculate return order metrics and customer order patterns
view: orders_ranking {
  derived_table: {
    sql: with order_dates as (
      select user_id, order_id, min(created_at) order_start_date, max(created_at) order_end_date
      from order_items
      group by 1,2
      ),
order_rank as (
      select user_id, order_id, order_start_date, order_end_date,
        row_number() over (partition by user_id order by order_start_date) as rn
      from order_dates
      )

      select *,lag(order_id) over (partition by user_id order by rn) as last_order_id,
      lag(order_start_date) over (partition by user_id order by rn) as last_order_date,
      lag(order_id) over (partition by user_id order by rn desc) as next_order_id,
      lag(order_start_date) over (partition by user_id order by rn desc) as next_order_date
      from order_rank
      ;;
    sql_trigger_value: max(order_start_date) ;;
  }

## IDs ##

  dimension: next_order_id {
    group_label: "IDs"
    type: number
    sql: ${TABLE}.next_order_id ;;
  }

  dimension: order_id {
    group_label: "IDs"
    type: number
    primary_key: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension: previous_order_id {
    group_label: "IDs"
    type: number
    sql: ${TABLE}.last_order_id ;;
  }

  dimension: user_id {
    group_label: "IDs"
    type: number
    sql: ${TABLE}.user_id ;;
  }


## DIMENSIONS ##

  dimension: days_between_orders {
    description: "The number of days between one order and the next order"
    type: number
    sql: date_diff(${order_start_date_date},${previous_order_date_date},day) ;;
  }

  dimension: has_subsequent_order {
    description: "Indicator for whether a purchase is a customer's first purchase or not"
    type: yesno
    sql: ${next_order_id} is not null ;;
  }

  dimension: has_order_last_30_days {
    description: "Indicator for whether a customer has ordered within the last 30 days"
    type: yesno
    sql: date_diff(current_date,${order_start_date_date},day)<=30 ;;
  }

  dimension: is_first_purchase {
    description: "Indicator for whether a purchase is a customer's first purchase or not"
    type: yesno
    sql: ${order_sequence}=1 ;;
  }

  dimension: is_one_time_customer {
    description: "Indicator for whether a customer has only made 1 purchase"
    type: yesno
    sql: ${is_first_purchase} and ${next_order_id} is null ;;
  }

  dimension: is_repeat_order {
    description: "Indicator for whether an order has been purchased before"
    type: yesno
    sql: ${order_sequence}>1;;
  }

  dimension_group: next_order_date {
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
    sql: ${TABLE}.next_order_date ;;
  }

  dimension_group: order_end_date {
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
    sql: ${TABLE}.order_end_date ;;
  }

  dimension: order_sequence {
    description: "The order in which a customer placed orders over their lifetime as customer"
    type: number
    sql: ${TABLE}.rn ;;
  }

  dimension_group: order_start_date {
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
    sql: ${TABLE}.order_start_date ;;
  }

  dimension_group: previous_order_date {
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
    sql: ${TABLE}.last_order_date ;;
  }

  dimension: repeat_purchase_60_days{
    description: "Indicator of whether a customer has made a purchase from the website again within 60 days of a prior purchase"
    type: yesno
    sql: ${days_between_orders}<=60 AND ${order_sequence}=2 ;;
  }

## MEASURES ##

  measure: average_days_between_first_and_second_orders {
    description: "The average number of days between the first and second order placed"
    type: average_distinct
    sql_distinct_key: ${user_id} ;;
    sql: ${days_between_orders} ;;
    filters: [order_sequence: "2"]
    value_format_name: decimal_0
  }

  measure: average_days_between_orders {
    description: "The average number of days between orders placed"
    type: average
    sql: ${days_between_orders} ;;
    value_format_name: decimal_0
  }

  measure: repeat_purchase_rate {
    type: number
    sql: 1.0*(${total_repeat_orders}/nullif(${total_orders},0)) ;;
    value_format_name: percent_2
  }

  measure: repeat_purchase_rate_60_days{
    description: "The percent of customers that have purchased from the website again within 60 days of a prior purchase"
    type: number
    sql:${total_60_day_repeat_customers}/nullif(${total_customers},0)  ;;
    value_format_name: percent_2
  }

  measure: total_60_day_repeat_customers {
    description: "Total number of customers who have purchased from the website again within 60 days of a prior purchase"
    type: count_distinct
    sql: ${user_id} ;;
    filters: [repeat_purchase_60_days: "yes"]
  }

  measure: total_customers {
    type: count_distinct
    sql:${user_id} ;;
  }

  measure: total_orders {
    type: count
  }

  measure: total_repeat_orders {
    type: count
    filters: [order_sequence:">1"]
  }

  # set: detail {
  #   fields: [
  #     user_id,
  #     order_id,
  #     order_start_date_date,
  #     order_end_date_date,
  #     order_sequence,
  #     previous_order_id,
  #     previous_order_date_date,
  #     next_order_id,
  #     next_order_date_date
  #   ]
  # }
}
