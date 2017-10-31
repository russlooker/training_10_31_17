view: order_items {
  sql_table_name: public.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id;;
  }

#   dimension: pk {
#     type: string
#     primary_key: yes
#     sql: ${f1} || '-' || ${f2} ;;
#   }

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

  dimension: custom_time {
    group_label: "Created Date"
    type: string
    sql: ${created_week}  || '-' || ${created_quarter};;
  }

  dimension_group: delivered {
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

  dimension: inventory_item_id {
    type: number
    hidden: yes
    sql: ${TABLE}.inventory_item_id;;
  }

  dimension: order_id {
    type: number
    label: "Order Key"
    sql: ${TABLE}.order_id;;
#     description: "This is not to be confused with order id"
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      hour_of_day,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price / 100 ;;
  }

  dimension_group: shipped {
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

  dimension: status {
    type: string
    sql:
    ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]

  }

  measure: count_orders {
    description: "Count of distinct orders"
    type: count_distinct
    sql: ${order_id};;
  }

  measure: total_sale_price {
    value_format_name: usd
    type:  sum
    sql: ${sale_price};;
  }

  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
  }

  measure: running_total_sale_price {
    type: running_total
    sql: ${total_sale_price} ;;
  }

  measure: percent_of_total_sale_price {
    type: percent_of_total
    sql: ${total_sale_price} ;;
  }

  measure: order_items_per_user {
    type: number
    sql: ${count}*1.0 / nullif(${users.count},0) ;;
  }

  measure: two_measures_combined {
    type: number
    sql: ${total_sale_price_filtered} * 1.0/ nullif(${total_sale_price},0);;
    value_format_name: percent_1

  }

  measure: total_sale_price_filtered {
    value_format_name: usd
    type:  sum
    sql: ${sale_price} ;;
    filters: {
      field: users.age
      value: ">50"
    }
  }

  measure: total_sale_price_filtered_custom {
    value_format_name: usd
    type:  sum
    sql:
    CASE
      WHEN ${users.age} > ${users.id} THEN ${sale_price}
      ELSE NULL
    END
     ;;
  }




  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.id,
      users.first_name,
      users.last_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}
