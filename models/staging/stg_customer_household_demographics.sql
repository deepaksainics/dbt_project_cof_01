{{
    config (tag = 'staged_layer')
}}

with 

source as (

    select * from {{ source('customer_raw', 'HOUSEHOLD_DEMOGRAPHICS') }}

),

renamed as (

    select
        hd_demo_sk,
        hd_income_band_sk,
        hd_buy_potential,
        hd_dep_count,
        hd_vehicle_count

    from source

)

select * from renamed
