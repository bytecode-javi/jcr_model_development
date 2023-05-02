- dashboard: fashion_ly__summary_dashboard
  title: Fashion.ly - Summary Dashboard
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  preferred_slug: mg2X2R1BCqaqdnXOsUIHlS
  elements:
  - title: Total Revenue Yesterday
    name: Total Revenue Yesterday
    model: jcr_model_development
    explore: order_items
    type: single_value
    fields: [order_items.total_gross_revenue, order_items.created_date]
    fill_fields: [order_items.created_date]
    filters:
      order_items.created_date: 2 days
    sorts: [order_items.created_date]
    limit: 5
    column_limit: 50
    query_timezone: America/Los_Angeles
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: fashionly
      palette_id: fashionly-categorical-0
    custom_color: "#b82c95"
    single_value_title: Total Revenue Yesterday
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    series_types: {}
    listen: {}
    row: 0
    col: 0
    width: 5
    height: 6
  - title: Total Number of New Users Yesterday
    name: Total Number of New Users Yesterday
    model: jcr_model_development
    explore: users
    type: single_value
    fields: [users.created_date, users.user_count]
    fill_fields: [users.created_date]
    filters:
      users.created_date: 2 days
    sorts: [users.created_date]
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: fashionly
      palette_id: fashionly-categorical-0
    custom_color: "#b82c95"
    single_value_title: Total Number of New Users Yesterday
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    series_types: {}
    listen: {}
    row: 0
    col: 5
    width: 5
    height: 6
  - title: Gross Margin % over the Past 30 Days
    name: Gross Margin % over the Past 30 Days
    model: jcr_model_development
    explore: order_items
    type: single_value
    fields: [order_items.gross_margin_percent]
    filters:
      order_items.created_date: 30 days
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: fashionly
      palette_id: fashionly-categorical-0
    custom_color: "#b82c95"
    single_value_title: Gross Margin % over the Past 30 Days
    defaults_version: 1
    listen: {}
    row: 0
    col: 15
    width: 5
    height: 6
  - title: Average Spend per Customer over the Past 30 Days
    name: Average Spend per Customer over the Past 30 Days
    model: jcr_model_development
    explore: order_items
    type: single_value
    fields: [order_items.average_spend_per_customer]
    filters:
      order_items.created_date: 30 days
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: fashionly
      palette_id: fashionly-categorical-0
    custom_color: "#b82c95"
    single_value_title: Average Spend per Customer over the Past 30 Days
    series_types: {}
    defaults_version: 1
    listen: {}
    row: 0
    col: 10
    width: 5
    height: 6
