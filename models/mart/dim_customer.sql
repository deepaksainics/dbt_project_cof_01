{{
    config 
    (materialized='incremental',
    unique_key = 'customer_id',
    transient = false,
    tag = 'mart_layer',
    merge_exclude_columns = ['created_at'])
}}

{%- set columns = get_columns_in_relation(ref('cur_customer')) -%}

{% set column_names = columns|map(attribute='name')|list %}

WITH customer_stage AS 
(
    SELECT {{ dbt_utils.generate_surrogate_key( column_names )}} as customer_hashid,
    * 
    FROM {{ ref ('cur_customer')}}
    
    {% if is_incremental() %}

    WHERE customer_hashid NOT IN (SELECT customer_hashid from {{ this }} )

    {% endif %}

),

final AS 
(
    SELECT *, 
    current_time() AS created_at, 
    current_time() AS updated_at FROM customer_stage
)

SELECT * FROM final