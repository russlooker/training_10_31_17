view: user_facts_2 {
  derived_table: {
    sql: Select *,  CAST('hello' as text) as message FROM  ${user_facts.SQL_TABLE_NAME} limit 10
      ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: total_lifetime_sales {
    type: number
    sql: ${TABLE}.total_lifetime_sales ;;
  }

  dimension: lifetime_item_count {
    type: number
    sql: ${TABLE}.lifetime_item_count ;;
  }

  dimension_group: first_order_date {
    type: time
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: latest_order_date {
    type: time
    sql: ${TABLE}.latest_order_date ;;
  }

  dimension: avg_sale_per_user {
    type: number
    sql: ${TABLE}.avg_sale_per_user ;;
  }

  dimension: message {
    type: string
    sql: ${TABLE}.message ;;
  }

  set: detail {
    fields: [
      user_id,
      total_lifetime_sales,
      lifetime_item_count,
      first_order_date_time,
      latest_order_date_time,
      avg_sale_per_user,
      message
    ]
  }
}
