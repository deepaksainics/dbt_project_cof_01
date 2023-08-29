{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}

    {%- if target.name == 'dev' -%}

        {{ default_schema }}

    {%- elif target.name == 'qa' -%}

        {{ custom_schema_name | trim }}

    {%- elif target.name == 'dev_pr' -%}

        {{ default_schema }}_pr

    {%- else -%}

        {{ default_schema }}

    {%- endif -%}

{%- endmacro %}