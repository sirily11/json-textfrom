Map<String, dynamic> itemJSONData = {
  "fields": [
    {
      "label": "ID",
      "readonly": true,
      "extra": {},
      "name": "id",
      "widget": "number",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "Book Name",
      "readonly": false,
      "extra": {"default": ""},
      "name": "name",
      "widget": "text",
      "required": false,
      "translated": false,
      "validations": {
        "length": {"maximum": 1024}
      }
    },
    {
      "label": "description",
      "readonly": false,
      "extra": {},
      "name": "description",
      "widget": "text",
      "required": false,
      "translated": false,
      "validations": {
        "length": {"maximum": 1024}
      }
    },
    {
      "label": "qr code",
      "readonly": false,
      "extra": {},
      "name": "qr_code",
      "widget": "text",
      "required": false,
      "translated": false,
      "validations": {
        "length": {"maximum": 10008}
      }
    },
    {
      "label": "column",
      "readonly": false,
      "extra": {"default": 1},
      "name": "column",
      "widget": "number",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "row",
      "readonly": false,
      "extra": {"default": 1},
      "name": "row",
      "widget": "number",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "price",
      "readonly": false,
      "extra": {"default": 0.0},
      "name": "price",
      "widget": "number",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "unit",
      "readonly": false,
      "extra": {"default": "USD"},
      "name": "unit",
      "widget": "text",
      "required": false,
      "translated": false,
      "validations": {
        "length": {"maximum": 10}
      }
    },
    {
      "label": "created time",
      "readonly": true,
      "extra": {},
      "name": "created_time",
      "widget": "datetime",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "author",
      "readonly": true,
      "extra": {"related_model": "storage-management/author"},
      "name": "author_name",
      "widget": "foreignkey",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "series",
      "readonly": true,
      "extra": {"related_model": "storage-management/series"},
      "name": "series_name",
      "widget": "foreignkey",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "category",
      "readonly": true,
      "extra": {"related_model": "storage-management/category"},
      "name": "category_name",
      "widget": "foreignkey",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "location",
      "readonly": true,
      "extra": {"related_model": "storage-management/location"},
      "name": "location_name",
      "widget": "foreignkey",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "detail position",
      "readonly": true,
      "extra": {"related_model": "storage-management/detailposition"},
      "name": "position_name",
      "widget": "foreignkey",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "images",
      "readonly": false,
      "extra": {"related_model": "storage-management/itemimage"},
      "name": "images",
      "widget": "tomany-table",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "files",
      "readonly": false,
      "extra": {"related_model": "storage-management/itemfile"},
      "name": "files",
      "widget": "tomany-table",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "author",
      "readonly": false,
      "extra": {"related_model": "storage-management/author"},
      "name": "author_id",
      "widget": "foreignkey",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "series",
      "readonly": false,
      "extra": {"related_model": "storage-management/series"},
      "name": "series_id",
      "widget": "foreignkey",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "category",
      "readonly": false,
      "extra": {"related_model": "storage-management/category"},
      "name": "category_id",
      "widget": "foreignkey",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "location",
      "readonly": false,
      "extra": {"related_model": "storage-management/location"},
      "name": "location_id",
      "widget": "foreignkey",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "detail position",
      "readonly": false,
      "extra": {"related_model": "storage-management/detailposition"},
      "name": "position_id",
      "widget": "foreignkey",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "uuid",
      "readonly": true,
      "extra": {"default": "54eed2cd-23fe-49e7-9359-1b411ba839f0"},
      "name": "uuid",
      "widget": "text",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "files",
      "readonly": true,
      "extra": {"related_model": "storage-management/itemfile"},
      "name": "files_objects",
      "widget": "tomany-table",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "images",
      "readonly": true,
      "extra": {"related_model": "storage-management/itemimage"},
      "name": "images_objects",
      "widget": "tomany-table",
      "required": false,
      "translated": false,
      "validations": {}
    }
  ],
  "fieldsets": [
    {
      "title": null,
      "fields": [
        {"name": "name"},
        {"name": "description"},
        {"name": "qr_code"},
        {"name": "column"},
        {"name": "row"},
        {"name": "price"},
        {"name": "unit"},
        {"name": "created_time"},
        {"name": "author_name"},
        {"name": "series_name"},
        {"name": "category_name"},
        {"name": "location_name"},
        {"name": "position_name"},
        {"name": "author_id"},
        {"name": "series_id"},
        {"name": "category_id"},
        {"name": "location_id"},
        {"name": "position_id"},
        {"name": "uuid"}
      ]
    }
  ]
};
