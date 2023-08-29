{{
    config 
    (materialized='table',
    transient = true,
    tag = 'staged_layer')
}}

Select * from {{ source ('call_center','CALL_CENTER')}}