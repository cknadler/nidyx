# Nidyx [![Gem Version](https://badge.fury.io/rb/nidyx.svg)](http://badge.fury.io/rb/nidyx) [![Build Status](https://travis-ci.org/cknadler/nidyx.svg?branch=master)](https://travis-ci.org/cknadler/nidyx) [![Code Climate](https://codeclimate.com/github/cknadler/nidyx/badges/gpa.svg)](https://codeclimate.com/github/cknadler/nidyx) [![Documentation](https://inch-ci.org/github/cknadler/nidyx.svg?branch=master)](https://inch-ci.org/github/cknadler/nidyx)

[JSON Schema][JSONSchema] &#8658; Model

Nidyx generates Objective-C models from JSON Schema. It can also generate
models with [JSONModel](https://github.com/icanzilb/JSONModel) support.

## Install

```bash
$ gem install nidyx
```

## Usage

```
usage: nidyx [-h] [--version]
       nidyx <schema> [-n] [-a author] [-c company] [-p project]
             [-o directory] [-x prefix]
             [--json-model] # objc specific

    -a, --author AUTHOR              Author's name
    -c, --company COMPANY            Company's name
    -p, --project PROJECT            Project's name
    -o, --output DIRECTORY           Output models to a specific directory
    -x, --class-prefix PREFIX        Add a prefix to generated model names
    -n, --no-comments                Generate without header comments
        --json-model                 Generate with JSONModel support
    -h, --help                       Print usage information
        --version                    Print version

Nidyx generates plain Objective-C models from JSON Schema. It can also generate
models with JSONModel support.

Examples
========

Generate models for a given schema.

  $ nidyx example.json.schema

Specify an ouput directory and a class prefix:

  $ nidyx example.json.schema -x ClassPrefix -o /path/to/output/directory

Generate with JSONModel support and optional documentation:

  $ nidyx example.json.schema --json-model -a "Your Name" -p "Project Name"
```

## Features

__[JSON Schema draft 4][JSONSchemaDraft4] support:__

Nidyx exclusively supports JSON Schema draft 4. All previous drafts are not
supported intentionally.

## Examples

Examples are run with the following unless otherwise specified:

```bash
$ nidyx example.json.schema Example
```

#### Simple Properties

```json
{
  "properties": {
    "key": { "type": "string" },
    "value": { "type": "string" }
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

#### Refs and Nested Properties

```json
{
  "properties": {
    "id": {
      "type": "object",
      "properties": {
        "key": { "type": "string" },
        "hash": { "type": "string" }
      }
    },
    "value":  { "$ref": "#/definitions/obj" }
  },
  "definitions": {
    "obj": {
      "type": "object",
      "properties": {
        "banner": { "$ref": "#/definitions/banner" },
        "name": { "type": "string" },
        "count": { "type": "integer" }
      }
    },
    "banner": { "type": "string" }
  }
}
```

```objc
// ExampleModel.h
#import "ExampleIdModel.h"
#import "ExampleObjModel.h"
@interface ExampleModel
@property (strong, nonatomic) ExampleIdModel* id;
@property (strong, nonatomic) ExampleObjModel* value;
@end

// ExampleIdModel.h
@interface ExampleIdModel
@property (strong, nonatomic) NSString* key;
@property (strong, nonatomic) NSString* hash;
@end

// ExampleObjModel.h
@interface ExampleObjModel
@property (strong, nonatomic) NSString* banner;
@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) NSInteger count;
@end
```

#### Caveats

* The following is omitted from the beginning of all JSON examples:

```
"$schema": "http://json-schema.org/draft-04/schema#",
"type": "object",
```

* `.m` files are also omitted from all examples

## License

MIT.

[JSONSchema]: http://json-schema.org/
[JSONSchemaDraft4]: http://tools.ietf.org/html/draft-zyp-json-schema-04
