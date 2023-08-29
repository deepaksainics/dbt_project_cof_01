{{
    config (tag = 'staged_layer')
}}

with 

source as (

    select * from {{ source('customer_raw', 'INCOME_BAND') }}

),

renamed as (

    select
        ib_income_band_sk,
        ib_lower_bound,
        ib_upper_bound

    from source

)

select * from renamed
