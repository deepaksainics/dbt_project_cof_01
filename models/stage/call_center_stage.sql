{{
    config 
    (materialized='table',
    transient = false)
}}

Select * from {{ source ('call_center_raw','CALL_CENTER')}}