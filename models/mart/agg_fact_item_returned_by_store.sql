{{
    config 
    (
    materialized='table',
    transient = false,
    tag = 'mart_layer'
    )
}}

with fact_store_returns as 
(
    select sr_store_sk,
    sr_item_sk, 
    sum(sr_return_quantity) as total_returned_items, 
    sum(sr_return_amt) as total_returned_amount,
    sum(sr_net_loss) as total_net_loss 
    from {{ ref ('fact_store_returns') }}
    group by sr_store_sk, sr_item_sk
),

item as 
(
    select * from {{ ref ('stg_store_item') }}
),

store as 
(
    select * from {{ ref ('stg_store') }}
),


final as 
(
    select  i.i_product_name||'_'||i.i_category||'_'||i.i_brand as item_details,
    st.s_store_name||'_'||st.s_city||'_'||st.s_state||'_'||st.s_country as store_details,
    sr.total_returned_items, 
    sr.total_returned_amount,
    sr.total_net_loss,
    current_timestamp() as loaded_at
    from fact_store_returns as sr
    left join item as i on (i.i_item_sk = sr.sr_item_sk)
    left join store as st on (st.s_store_sk = sr.sr_store_sk)
)

select * from final