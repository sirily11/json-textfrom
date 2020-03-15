## Basic usage

Suppose you have following schema, then you can define the choices by using choices field. Label represents the display label, and value represents the actual value will be returned when user select any of the choice.

```json
{
  "label": "unit",
  "readonly": false,
  "extra": {
    "choices": [
      { "label": "US Dollar", "value": "USD" },
      { "label": "Hong Kong Dollar", "value": "HDK" },
      { "label": "RMB", "value": "CNY" }
    ],
    "default": "USD"
  },
  "name": "unit",
  "widget": "select",
  "required": false,
  "translated": false,
  "validations": {}
}
```
