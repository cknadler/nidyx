# Nidyx

[JSON Schema][JSONSchema] &#8658; Objective-C model generator.

Nidyx generates Objective-C models from JSON Schema. It also supports
generating with [JSONModel](https://github.com/icanzilb/JSONModel) support.

## Usage

```
$ nidyx
usage: nidyx [-h] [--version]
       nidyx <schema> <class-prefix> [output-directory]
             [-j] [-a author] [-c company] [-p project]

    -j, --json-model                 Generate with JSONModel support
    -a, --author AUTHOR              Author's name
    -c, --company COMPANY            Company's name
    -p, --project PROJECT            Project's name
    -h, --help                       Print usage information
        --version                    Print version

Nidyx generates plain Objective-C models from JSON Schema. It can also generate
models with JSONModel support.

Examples
========

Bare minimum. Given a schema and a class prefix, generate models in the
current directory:

  $ nidyx example.json.schema ClassPrefix

Specify an ouput directory:

  $ nidyx example.json.schema ClassPrefix /path/to/output/directory

Generate models with JSONModel support and all optional documentation:

  $ nidyx example.json.schema ClassPrefix /path/to/output/directory \
    -j -a "Your Name" -c "Company Name" -p "Project Name"

```

## Features

__[JSON Schema draft 4][JSONSchemaDraft4] support:__

Nidyx exclusively supports JSON Schema draft 4. All previous drafts are not
supported intentionally.

__Automatic minification:__

Nidyx will automatically minify (strip out comments, etc) the schema passed to
it before generation.

## Examples

#### Simple Properties

```json
{
  "properties": {
    "key": {
      "type": "string"
    },
    "value": {
      "type": "string"
    }
  }
}
```

```objc
// ExampleModel.h
@interface ExampleModel
@property (strong, nonatomic) NSString* key;
@property (strong, nonatomic) NSString* value;
@end
```

#### Nested Properties

```json
{
  "properties": {
    "key": {
      "type": "string"
    },
    "value":  { "$ref": "#/definitions/obj" },
    "banner": { "$ref": "#/definitions/banner" }
  },
  "definitions": {
    "obj": {
      "type": "object",
      "properties": {
        "name": {
          "type": "string"
        },
        "count": {
          "type": "integer"
        }
      }
    },
    "banner": {
      "type": "string"
    }
  }
}
```

```objc
// ExampleModel.h
#import "ExampleObjModel.h"
@interface ExampleModel
@property (strong, nonatomic) NSString* key;
@property (strong, nonatomic) ExampleObjModel* value;
@property (strong, nonatomic) NSString* banner;
@end
```

```objc
// ExampleObjModel.h
@interface ExampleObjModel
@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) NSInteger count;
@end
```

#### Caveats

* The following is ommited from the beginning of all JSON examples:

```
"$schema": "http://json-schema.org/draft-04/schema#",
"type": "object",
```

* `.m` files are also ommited from all examples

* Assume that each example is run with the following command:

```bash
$ nidyx example.json.schema Example
```

[JSONSchema]: http://json-schema.org/
[JSONSchemaDraft4]: http://tools.ietf.org/html/draft-zyp-json-schema-04
