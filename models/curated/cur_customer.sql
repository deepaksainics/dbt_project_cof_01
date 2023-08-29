{{
    config 
    (materialized='table',
    transient = true,
    tag = 'curated_layer')
}}

WITH customer_raw AS 
(
    SELECT * FROM {{ ref ('stg_customer') }}
),
customer_address AS 
(
    SELECT * FROM {{ ref ('stg_customer_address') }}
),
customer_demographics AS
(
    SELECT * FROM {{ ref ('stg_customer_demographics') }}
),

household_demographics AS
(
    SELECT * FROM {{ ref ('stg_customer_household_demographics') }}
),

income_band AS
(
    SELECT * FROM {{ ref ('stg_customer_income_band') }}
),

final AS 
(
    SELECT 
    cus.c_customer_id AS customer_id,
    cus.c_salutation ||' '||cus.c_first_name ||' '|| cus.c_last_name AS customer_name,
    cus_demo.cd_gender AS customer_gender,
    cus_demo.cd_marital_status AS customer_marital_status,
    cus.c_birth_country AS customer_birth_country,
    cus.c_birth_month AS customer_birth_month,
    cus.c_email_address AS customer_email_address,
    cus_add.ca_country AS customer_residence_country,
    cus_add.ca_city AS customer_city,
    cus_demo.cd_credit_rating AS customer_credit_rating,
    cus_demo.cd_purchase_estimate AS customer_purchase_estimate,
    ho_demo.hd_buy_potential AS customer_buy_potential,
    in_band.ib_lower_bound AS customer_income_lower_bound,
    in_band.ib_upper_bound AS customer_income_upper_bound
FROM customer_raw AS cus
LEFT JOIN customer_address AS cus_add 
On (cus.c_current_addr_sk = cus_add.ca_address_sk)
LEFT JOIN customer_demographics AS cus_demo
ON (cus.c_current_cdemo_sk = cus_demo.cd_demo_sk)
LEFT JOIN household_demographics AS ho_demo
ON (cus.c_current_hdemo_sk = ho_demo.hd_demo_sk)
LEFT JOIN income_band AS in_band
ON (ho_demo.hd_income_band_sk = in_band.ib_income_band_sk)
)

SELECT * FROM final