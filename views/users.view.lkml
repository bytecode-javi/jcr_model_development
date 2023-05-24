# The name of this view in Looker is "Users"
# This view was enhanced from it's original form in order to perform a case study analysis as part of the Onboarding process at Bytecode IO

view: users {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `thelook.users`
    ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    description: "Unique identifier of users"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Age" in Explore.

  dimension: age {
    description: "Age of user"
    type: number
    #value_format_name: "decimal_2"
    sql: ${TABLE}.age ;;
    #drill_fields: [gender]
  }

  dimension: age_tier {
    description: "Tiered user ages [0, 15, 26, 36, 51, 66]"
    type: tier
    tiers: [0,15,26,36,51,66]
    sql: ${age} ;;
    style: integer
    drill_fields: [gender]
  }

  dimension: city {
    description: "User city"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    description: "User country"
    type: string
    map_layer_name: countries
    drill_fields: [state, city]
    sql: ${TABLE}.country ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: created {
    description: "Date which user created account"
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

  dimension: created_last_month {
    type: yesno
    sql: ${created_date}>=date_trunc(date_sub(current_date(), interval 1 month),month)
      and ${created_date}<date_trunc(current_date(),month);;
  }

  dimension: created_last_year {
    type: yesno
    sql: ${created_date}>=date_trunc(date_sub(current_date(), interval 1 year),year)
      and ${created_date}<date_trunc(current_date(),year);;
  }

  dimension: days_since_signup {
    type: number
    sql: date_diff(current_date,${created_date},day) ;;
  }

  dimension: email {
    description: "User email"
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    description: "User first name"
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    description: "User gender"
    type: string
    case: {
      when: {
        sql: ${TABLE}.gender = "M" ;;
        label: "Male"
      }
      when: {
        sql: ${TABLE}.gender = "F" ;;
        label: "Female"
      }
      else: "Undefined"
    }
    drill_fields: [age_tier]
  }

  dimension: is_long_term_customer {
    description: "Customer signed up longer that 90 days ago"
    type: string
      case: {
        when: {
          sql: ${days_since_signup} >90 ;;
          label: "Long-Term"
        }
        else: "New"
      }
  }

  dimension: last_name {
    description: "User last name"
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: latitude {
    description: "User latitude"
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    description: "User longitude"
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: months_since_signup {
    type: number
    sql: date_diff(current_date,${created_date},month) ;;
  }

  dimension: months_since_signup_tier {
    description: "The number of months since a customer has signed up on the website in tiered bins"
    type: tier
    tiers: [0,1,2,3,4,5,6,7,8,9,10,11,12,24,36,48,60]
    sql: ${months_since_signup} ;;
    style: integer
    drill_fields: [user_details*]
  }

  dimension: postal_code {
    description: "User postal code"
    type: zipcode
    sql: ${TABLE}.postal_code ;;
  }

  dimension: state {
    description: "User state"
    map_layer_name: us_states
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: street_address {
    description: "User street address"
    type: string
    sql: ${TABLE}.street_address ;;
  }

  dimension: traffic_source {
    description: "Traffic source"
    type: string
    sql: ${TABLE}.traffic_source ;;
    drill_fields: [user_details*]
  }

  dimension: years_since_signup {
    type: number
    sql: date_diff(current_date,${created_date},year) ;;
  }

  dimension: years_since_signup_tier {
    description: "The number of years since a customer has signed up on the website in tiered bins"
    type: tier
    tiers: [0,1,2,3,4,5,6]
    sql: ${years_since_signup};;
    style: integer
    drill_fields: [user_details*]

  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: average_number_of_days_since_signup {
    description: "Average number of days between a customer initially registering on the website and now"
    type: average
    sql: ${days_since_signup} ;;
    value_format_name: decimal_2
  }

  measure: average_age {
    description: "Average age of users"
    type: average
    sql: ${age} ;;
    value_format_name: "decimal_2"
  }

  measure: average_number_of_months_since_signup {
    description: "Average number of months between a customer initially registering on the website and now"
    type: average
    sql: ${months_since_signup} ;;
    value_format_name: decimal_2
  }

  measure: average_number_of_years_since_signup {
    description: "Average number of years between a customer initially registering on the website and now"
    type: average
    sql: ${years_since_signup} ;;
    value_format_name: decimal_2
  }

  measure: user_count {
    description: "Count of distinct users"
    type: count_distinct
    sql: ${id} ;;
    drill_fields: [id, last_name, first_name, events.count, order_items.count]
  }

  measure: total_age {
    description: "Total age"
    type: sum
    sql: ${age} ;;
  }

## DRILL FIELDS ##
  set: location_details {
    fields: [state,city]
  }

  set: user_details {
    fields: [gender, age_tier]
  }

}
