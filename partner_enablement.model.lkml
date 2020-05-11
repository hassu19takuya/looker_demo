connection: "snowlooker"

include: "/views/*.view.lkml"                # include all views in the views/ folder in this project
# include: "/**/view.lkml"                   # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }

datagroup: default {
  sql_trigger: select max(created_at) from order_items ;;
  max_cache_age: "4 hours"
}

explore: users {
  ## 演習6-1
  persist_with: default

  ## 演習4-1
  join: order_items {
    relationship: one_to_many
    sql_on: ${users.id}=${order_items.user_id} ;;

  }
  ## 演習5-1,2
  ## sql_always_where: ${order_items.status} = "Complete" AND ${order_items.returned_date} IS NULL;;

  ## sql_always_having: ${order_items.count} > 5000 AND ${order_items.total_sales} > 200;;

  ## 演習5-3
  always_filter: {
    filters: [
      order_items.created_date: "before today"

    ]
    filters: {
      field: order_items.created_date
      value: "before today"
    }
  }

  conditionally_filter: {
    filters: [
      order_items.created_date: "last 2 years"
    ]
    unless: [users.id]
  }

}
