{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}

    {%- if target.name == 'dev' -%}

        {{ default_schema }}

    {%- elif target.name == 'qa' -%}

        {{ custom_schema_name | trim }}

    {%- elif target.name == 'prd' -%}

        {{ custom_schema_name | trim }}

    {%- elif target.name == 'dev_pr' -%}

        dbt_cloud_pr_{{ default_schema }}

    {%- elif target.name == 'qa_pr' -%}

        dbt_cloud_pr_{{ default_schema }}



    {%- else -%}

        {{ default_schema }}

    {%- endif -%}

{%- endmacro %}