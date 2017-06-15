view: sql_runner_query_pdt_test {
  derived_table: {
    persist_for: "2 hours"
    indexes: ["user_id"]
    sql: SELECT
        users.id  AS user_id,
        COUNT(*) AS order_count,
        MAX(orders.created_at) AS latest_order,
        MIN(orders.created_at) AS first_order,
        Datediff(CURDATE(),MIN(orders.created_at)) as days_since
      FROM demo_db.orders  AS orders
      LEFT JOIN demo_db.users  AS users ON orders.user_id = users.id

      GROUP BY 1
      ORDER BY COUNT(*) DESC
      LIMIT 500
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

  dimension: order_count {
    type: number
    sql: ${TABLE}.order_count ;;
  }

  dimension_group: latest_order {
    type: time
    sql: ${TABLE}.latest_order ;;
  }

  dimension_group: first_order {
    type: time
    sql: ${TABLE}.first_order ;;
  }

  dimension: days_since {
    type: number
    sql: ${TABLE}.days_since ;;
  }

  set: detail {
    fields: [user_id, order_count, latest_order_time, first_order_time, days_since]
  }
}


view: test_ref_pdt{
  derived_table: {
    sql: select * from ${sql_runner_query_pdt_test.SQL_TABLE_NAME} ;;
  }
}
