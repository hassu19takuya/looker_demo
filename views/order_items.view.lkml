view: order_items {
  sql_table_name: "PUBLIC"."ORDER_ITEMS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
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
    sql: ${TABLE}."CREATED_AT" ;;
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
    sql: ${TABLE}."DELIVERED_AT" ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."INVENTORY_ITEM_ID" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  ## 演習2-1
  measure: order_num {
    type: count_distinct
    sql: ${order_id} ;;
  }

  dimension_group: returned {
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
    sql: ${TABLE}."RETURNED_AT" ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}."SALE_PRICE" ;;
  }

  ## 演習2-2
  measure: total_sales {
    type: sum
    sql: ${sale_price} ;;
  }

  ## 演習2-3
  measure: average_sales {
    type: average
    sql: ${sale_price} ;;
  }

  ## 演習3-1
  measure: email_sales {
    type: sum
    sql: ${sale_price} ;;

    #filters: [users.is_email_source: "Yes"]

  }

  ## 演習3-2
  measure: email_trafic_sales_ratio{
    type: number
    value_format_name: percent_2
    sql: 1.0*${email_sales}/NULLIF(${total_sales}, 0) ;;
  }

  ## 演習3-3
  measure: unit_sale_price_per_customer{
    type: number
    value_format_name: usd
    sql: 1.0*${total_sales}/${users.count} ;;
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
    sql: ${TABLE}."SHIPPED_AT" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."USER_ID" ;;
  }

  ## 演習1-2 ##
  dimension: shipping_Days {
    type: number
    sql: datediff('day',${shipped_date},${delivered_date})*1.0 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }


  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.first_name,
      users.last_name,
      users.id,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}
