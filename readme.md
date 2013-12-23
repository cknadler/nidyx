# nidyx

JSON Schema -> Objective-C model generator.

nidyx generates Objective-C models from JSON schema. It also supports
generating with [JSONModel](https://github.com/icanzilb/JSONModel) support.

## usage

```
usage: nidyx [-h | --help] [--version]
       nidyx <schema> <class-prefix> [output-directory] [-j | --json-model]
             [-a | --author] [-c | --company] [-p | --project]

    -j, --json-model                 Generate with JSONModel support
    -a, --author=                    Author's name
    -c, --company=                   Company's name
    -p, --project=                   Project's name
        --version                    Show version

nidyx generates plain Objective-C models from JSON Schema. That's pretty much
it. Oh yeah, it also supports generating with JSONModel support! Pretty rad.

example:

  $ nidyx example.json.schema ClassPrefix /path/to/output/directory

```
