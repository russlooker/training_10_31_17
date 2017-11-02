
include: "ecommerce_10_31.model.lkml"


explore: order_items_for_warehouse_managers {
  extends: [order_items]
  view_name: order_items
  access_filter: {
    field: products.brand
    user_attribute: allowed_brand

  }
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}
