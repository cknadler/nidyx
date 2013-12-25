# nidyx

JSON Schema -> Objective-C model generator.

Nidyx generates Objective-C models from JSON schema. It also supports
generating with [JSONModel](https://github.com/icanzilb/JSONModel) support.

## usage

```
usage: nidyx [-h] [--version]
       nidyx <schema> <class-prefix> [output-directory]
             [-j] [-a author] [-c company] [-p project]

    -j, --json-model                 Generate with JSONModel support
    -a, --author AUTHOR              Author's name
    -c, --company COMPANY            Company's name
    -p, --project PROJECT            Project's name
    -h, --help                       Print usage information
        --version                    Print version

Nidyx generates plain Objective-C models from JSON Schema. That's pretty much
it. Oh yeah, Nidyx can also generate models with JSONModel support!

Examples:

  Bare minimum. Given a schema and a class prefix, generate models in the
  current directory:

    $ nidyx example.json.schema ClassPrefix

  Specify an ouput directory:

    $ nidyx example.json.schema ClassPrefix /path/to/output/directory

  Generate models with JSONModel support and all optional documentation:

    $ nidyx example.json.schema ClassPrefix /path/to/output/directory \
      -j -a "Your Name" -c "Company Name" -p "Project Name"

```
