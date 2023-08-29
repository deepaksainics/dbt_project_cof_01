--This is time dimension model common to all data sources

{{ 
    config (tag = 'master_tables')
}}

Select * from {{ source ('master_tables','TIME_DIM')}}