Configs for https://github.com/realm/SwiftLint

## How to use
1) Install SwiftLint
2) Download and copy file "swiftlint.yml" to root directory of your project 
3) Rename file to ".swiftlint.yml"

## Configs
My configs of ".swiftlint.yml" file

```
excluded:
    - Pods
    - Scripts
disabled_rules:
    - trailing_whitespace
    - type_body_length
    - nesting
    - todo
    - notification_center_detachment
    - line_length
    - type_name

opt_in_rules:
    - private_outlet
    - empty_count
    - closing_brace
    - opening_brace
    - trailing_semicolon
    - explicit_init
    - overridden_super_call
    - redundant_nil_coalescing
    - operator_usage_whitespace
    - closure_end_indentation
    - prohibited_super_call
    - fatal_error_message
    - force_unwrapping

trailing_semicolon: error
colon: error
comma: error
opening_brace: error
closing_brace: error

cyclomatic_complexity:
    ignores_case_statements: true

variable_name:
  excluded:
    - id

file_length:
    warning: 800
    error: 1000

warning_threshold: 15
```

