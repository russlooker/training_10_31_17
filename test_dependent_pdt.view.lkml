# view: test_dependent_pdt {
#   derived_table: {
#     sql: SELECT
#         AVG(user_facts.total_lifetime_sales ) AS "user_facts.average_lifetime_value",
#         'PDT 2' as which_pdt
#       FROM public.users  AS users
#       LEFT JOIN ${user_facts.SQL_TABLE_NAME} AS user_facts ON users.id = user_facts.user_id
#
#        ;;
#       sql_trigger_value: select current_date ;;
#   }
#
#
#   measure: count {
#     type: count
#     drill_fields: [detail*]
#   }
#
#   dimension: user_facts_average_lifetime_value {
#     type: string
#     sql: ${TABLE}."user_facts.average_lifetime_value" ;;
#   }
#
#   dimension: which_pdt {
#     type: string
#     sql: ${TABLE}.which_pdt ;;
#   }
#
#   set: detail {
#     fields: [user_facts_average_lifetime_value, which_pdt]
#   }
# }
