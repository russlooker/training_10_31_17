connection: "events_ecommerce"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

persist_for: "30 seconds"

datagroup: nightly_etl {
  sql_trigger: select curernt_date ;;
  max_cache_age: "3 hours"
}


explore: order_items {
#   persist_with: nightly_etl
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} =  ${users.id};;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
#     fields: [products.department]
#     view_label: "Department"
  }

}

explore: users {
  join: user_facts {
    fields: [user_facts.average_lifetime_value
      , user_facts.first_order_date_date
      , user_facts.latest_order_date_date
      , user_facts.created_date_filter
    ]
    view_label: "Users"
    type: left_outer
    relationship: one_to_one
    sql_on: ${users.id} = ${user_facts.user_id} ;;
  }

}

explore: products {
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}



explore: inventory_items {
  join: products {
    type: left_outer
    relationship: many_to_one
    sql_on: ${inventory_items.product_id}=${products.id} ;;
  }
}
