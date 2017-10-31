view: user_facts {
  derived_table: {
    sql: SELECT
         OI.user_id
        ,sum(OI.sale_price) as total_lifetime_sales
        ,count(*) as lifetime_item_count
        ,min(created_at) as first_order_date
        ,max(created_at) as latest_order_date
        ,avg(sale_price) as avg_sale_per_user
      FROM public.order_items OI
      WHERE
        1=1
      GROUP BY 1
       ;;
#     persist_for: "3 hours"
#     sql_trigger_value: select current_date  ;;
#   datagroup_trigger: nightly_etl
#     sortkeys: ["user_id"]
#     distribution: "user_id"
  }
#        AND {% condition created_date_filter %} OI.created_at {% endcondition %}

  filter: created_date_filter {
    type: date
  }


  dimension: avg_sale_per_user {
    type: number
    sql: ${TABLE}.avg_sale_per_user ;;
  }


  filter: trade_type {
    suggestions: ["Bond", "ETF", "Stock"]
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
    timeframes: [time, date, week, month, year]
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: latest_order_date {
    type: time
    timeframes: [time, date, week, month, year]
    sql: ${TABLE}.latest_order_date ;;
  }

  measure: average_lifetime_value {
    type: average
    sql: ${total_lifetime_sales} ;;
    value_format_name: usd
  }

  dimension: lifetime_item_count_tier {
    type: tier
    tiers: [5, 10, 15, 20, 25, 30]
    sql: ${lifetime_item_count} ;;
    style: integer
  }

  set: detail {
    fields: [user_id, total_lifetime_sales, lifetime_item_count, first_order_date_time, latest_order_date_time]
  }
}
