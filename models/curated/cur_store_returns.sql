{{
    config 
    (materialized='table',
    transient = true,
    tag = 'curated_layer')
}}

with stg_store_returns as 
(
    select * from {{ ref ('stg_store_returns') }}
),

date_dim as 
(
    select * from {{ ref ('r_date_dim') }}
),

time_dim as 
(
    select * from {{ ref ('r_time_dim') }}
),

final as 
(
    select dt.d_date, 
    store_ret.*
    from stg_store_returns store_ret
    left join date_dim dt on (dt.d_date_sk = store_ret.sr_returned_date_sk )
    left join time_dim tm on (tm.t_time_sk = store_ret.sr_return_time_sk )
)

select * from final
