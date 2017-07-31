view: users {
  sql_table_name: public.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

#   dimension: custom_pk {
#     type: string
#     primary_key: yes
#     sql:  ${last_name} || '-' || ${email} ;;
#   }

  dimension: address {
    type: string
    sql: ${city} || ', ' || ${state} || ', ' || ${zip} || ', ' || ${country} ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_groups {
    type: tier
    tiers: [0,20,30,50]
    sql: ${age} ;;
    style: interval
  }

  dimension: is_under_21 {
    type: yesno
    hidden: yes
    sql: ${age} <= 21 ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: days_since_signup {
    type: number
    sql: datediff('day', ${created_date}, getdate()) ;;
  }

  dimension: days_since_signup_tier {
    type: tier
    tiers: [30, 90, 180, 360, 720, 1000]
    sql: ${days_since_signup} ;;
    style: integer
  }

#   filter: comparison_group_filter {
#     type: string
#     suggest_dimension: email
#   }


#   dimension: comparison_group {
#     type: string
#     sql:
#         CASE
#           WHEN {% condition comparison_group_filter %} ${email} {% endcondition %} then 'Comparison Group'
#           ELSE 'Rest of Population'
#       END
#
#     ;;
#   }


  dimension: is_new_user {
    type: yesno
    sql: ${days_since_signup} <= 90 ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: full_name {
    type: string
    sql: ${first_name} || ' ' || ${last_name} ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: location {
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }

  dimension: state {
    type: string
    map_layer_name: us_states
    sql: ${TABLE}.state ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    type: zipcode
    map_layer_name: us_zipcode_tabulation_areas
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }

  measure: avg_age {
    type: average
    sql: ${age} ;;

  }

  measure: sum_age {
    type: sum
    sql: ${age} ;;
  }

  measure: count_new_users {
    type: count
    filters: {
      field: is_new_user
      value: "Yes"
    }
  }

  measure: percent_of_new_users {
    type: number
    value_format_name: percent_0
    sql: ${count_new_users}*1.0 / nullif(${count},0) ;;
  }

}
