# winsw
---

Winsw is a windows service wrapper suggested by Spring Boot.

This cookbook contains a resource to interact with winsw services.

## Syntax
---
```ruby
winsw 'name' do
  service_name               String # defaults to 'name' if not specified
  basedir                    String
  description                String # defaults to 'service_name' if not specified
  executable                 String # required
  args                       Array
  env_variables              Hash
  options                    Hash
  supported_runtimes         Array # defaults ( v2.0.50727, v4.0 )
end
```

## Actions
---
`:install`

  Default. Install the service.  If the service was previously installed, updates the service and restarts it.

`:uninstall`

  Uninstall the service


## Properties
---
This resource has the following properties:

`service_name`

  **Ruby Type:** String

    Name for the service to be installed

`basedir`

  **Ruby Type:** String

    The path for the service to be installed to.

`description`

  **Ruby Type:** String

    The description for the windows service.

`executable`

  **Ruby Type:** String

    The fully qualified path to the executable.  This property is required by the resource.

`args`

  **Ruby Type:** Array

    List of arguments to be passed with the executable being ran.

`env_variables`

  **Ruby Type:** Hash

    A hash of environment variables to be defined for running the executable.

`options`

  **Ruby Type:** Hash

    Additional options to add to the winsw xml config file in the format of <key>Value</key>.

`supported_runtimes`

  **Ruby Type:** Array

    Define the supported runtimes by winsw. Optional, defaults should be updated with changes.  
    Default values: ( v2.0.50727, v4.0 )


## Example
---
```ruby
winsw 'application' do
  executable 'java'
  description 'Application Description'
  args [ '-jar', 'C:\path\to\your\application-1.0.28-SNAPSHOT.jar' ]
end
```
## Winsw Executable
---
Winsw resource has several built in wrapper commands as actions:
* install* (default action)
* status
* restart
* restart!
* stop
* start
* uninstall*

\*The command has been implemented with this cookbook.
Not all of the winsw commands are implemented, refer to the [winsw documentation](https://github.com/kohsuke/winsw/) for commands.
