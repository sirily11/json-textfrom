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
      "label": "Item Name",
      "readonly": false,
      "extra": {"help": "Please Enter your item name", "default": ""},
      "name": "name",
      "widget": "text",
      "required": true,
      "translated": false,
      "validations": {
        "length": {"maximum": 1024}
      }
    },
    {
      "label": "description",
      "readonly": false,
      "extra": {"help": "Please enter your item description"},
      "name": "description",
      "widget": "text",
      "required": true,
      "translated": false,
      "validations": {
        "length": {"maximum": 1024}
      }
    },
    {
      "label": "created time",
      "readonly": false,
      "extra": {"help": "Please enter your item description"},
      "name": "time",
      "widget": "datetime",
      "required": true,
      "translated": false,
      "validations": {}
    },
    {
      "label": "price",
      "readonly": false,
      "extra": {"default": 0.0},
      "name": "price",
      "widget": "number",
      "required": true,
      "translated": false,
      "validations": {}
    },
    {
      "label": "column",
      "readonly": false,
      "extra": {"default": 1},
      "name": "column",
      "widget": "number",
      "required": true,
      "translated": false,
      "validations": {}
    },
    {
      "label": "row",
      "readonly": false,
      "extra": {"default": 1},
      "name": "row",
      "widget": "number",
      "required": true,
      "translated": false,
      "validations": {}
    },
    {
      "label": "qr code",
      "readonly": false,
      "extra": {},
      "name": "qr_code",
      "widget": "text",
      "required": true,
      "translated": false,
      "validations": {
        "length": {"maximum": 10008}
      }
    },
    {
      "label": "unit",
      "readonly": false,
      "extra": {
        "choices": [
          {"label": "US Dollar", "value": "USD"},
          {"label": "Hong Kong Dollar", "value": "HDK"},
          {"label": "RMB", "value": "CNY"}
        ],
        "default": "USD"
      },
      "name": "unit",
      "widget": "select",
      "required": false,
      "translated": false,
      "validations": {}
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
      "extra": {"default": "2584ca7c-bab3-4231-a846-c2aecbd4ba00"},
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
};

Map<String, dynamic> itemJSONData2 = {
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
      "label": "name",
      "readonly": false,
      "extra": {},
      "name": "name",
      "widget": "text",
      "required": true,
      "translated": false,
      "validations": {
        "presence": true,
        "length": {"maximum": 128}
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
      "validations": {}
    },
    {
      "label": "show in folder",
      "readonly": false,
      "extra": {"default": true, "help": "Select your widget"},
      "name": "show_in_folder",
      "widget": "checkbox",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "unit",
      "readonly": false,
      "extra": {
        "choices": [
          {"label": "US Dollar", "value": "USD"},
          {"label": "Hong Kong Dollar", "value": "HDK"},
          {"label": "RMB", "value": "CNY"}
        ],
        "default": "USD"
      },
      "name": "unit",
      "widget": "select",
      "required": false,
      "translated": false,
      "validations": {}
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
    }
  ],
};

Map<String, dynamic> itemJSONData3 = {
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
      "label": "title",
      "readonly": false,
      "extra": {},
      "name": "title",
      "widget": "text",
      "required": true,
      "translated": false,
      "validations": {
        "presence": true,
        "length": {"maximum": 128}
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
      "validations": {}
    },
    {
      "label": "created at",
      "readonly": true,
      "extra": {},
      "name": "created_at",
      "widget": "datetime",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "cover",
      "readonly": false,
      "extra": {},
      "name": "cover",
      "widget": "file",
      "required": false,
      "translated": false,
      "validations": {
        "length": {"maximum": 100}
      }
    },
    {
      "label": "duration",
      "readonly": false,
      "extra": {},
      "name": "duration",
      "widget": "number",
      "required": true,
      "translated": false,
      "validations": {"presence": true}
    },
    {
      "label": "original text",
      "readonly": false,
      "extra": {},
      "name": "original_text",
      "widget": "text",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "videos",
      "readonly": true,
      "extra": {"related_model": "podcast/video"},
      "name": "video_list",
      "widget": "manytomany-lists",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "subtitle",
      "readonly": false,
      "extra": {"help": "Upload subtitle in vtt format"},
      "name": "subtitle",
      "widget": "file",
      "required": false,
      "translated": false,
      "validations": {
        "length": {"maximum": 100}
      }
    },
    {
      "label": "collections",
      "readonly": false,
      "extra": {"related_model": "podcast/collection"},
      "name": "asset_collections",
      "widget": "manytomany-lists",
      "required": true,
      "translated": false,
      "validations": {}
    }
  ],
};
