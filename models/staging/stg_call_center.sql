{{
    config (tag = 'staged_layer')
}}

Select * from {{ source ('call_center','CALL_CENTER')}}