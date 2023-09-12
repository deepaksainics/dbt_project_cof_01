{{
    config 
    (materialized='incremental',
    unique_key = ['sr_returned_date_sk','sr_return_time_sk','sr_item_sk','sr_customer_sk','sr_cdemo_sk','sr_hdemo_sk','sr_addr_sk','sr_store_sk','sr_reason_sk','sr_ticket_number'],
    transient = false,
    tag = 'mart_layer',
    merge_exclude_columns = ['created_at'])
}}

{%- set columns = get_columns_in_relation(ref('cur_store_returns')) -%}

{% set column_names = columns|map(attribute='name')|list %}

with store_returns as 
(
    select {{ dbt_utils.generate_surrogate_key( column_names )}} as store_returns_hashid,
    * 
    from {{ ref ('cur_store_returns')}}
    
    {% if is_incremental() %}

    where store_returns_hashid not in (select store_returns_hashid from {{ this }} )

    {% endif %}

), 

final as 
(
    select *, 
    current_time() as created_at, 
    current_time() as updated_at from store_returns
)

select * from final