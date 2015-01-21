# Envplate

[![Build Status](https://travis-ci.org/kreuzwerker/envplate.svg)](https://travis-ci.org/kreuzwerker/envplate)

Trivial templating for configuration files using environment keys. References to such keys are declared in arbitrary config files either as:

1. `${key}` or
* `${key:-default value}`

Envplate (`ep`) parses arbitrary configuration files (using glob patterns) and replaces all references with values from the environment or with default values (if given). These values replace the keys *inline* (= the files will be changed).

Failure to resolve the supplied glob pattern(s) to at least one file results in an error.

Optionally, `ep` can:

* backup (`-b` flag): create backups of the files it changes, appending a `.bak` extension to backup copies
* dry-run (`-d` flag): output to stdout instead of replacing values inline
* strict (`-s` flag): refuse to fallback to default values
* verbose (`-v` flag): be verbose about it's operations

`ep` can also `exec()` another command by passing

* `--` after all arguments to `ep`
* the path to the binary and it's arguments

Example: `/usr/local/bin/ep -v *.conf -- /usr/sbin/nginx -c /etc/nginx.conf`

This can be used to use `ep` to parse configs and execute the container process using Dockers `CMD`

## Why?

For apps running Docker which rely (fully or partially) on configuration files instead of being purely configured through environment variables.

You can directly download envplate binaries into your Dockerfile using Github releases like this:

```
RUN curl -sLo /usr/local/bin/ep https://github.com/kreuzwerker/envplate/releases/download/v0.0.4/ep-linux && chmod +x /usr/local/bin/ep

...

CMD [ "/usr/local/bin/ep", "-v", "/etc/nginx/nginx.conf", "--", "/usr/sbin/nginx", "-c", "/etc/nginx/nginx.conf" ]
```

## Full example

```
$ cat /etc/foo.conf
Database=${FOO_DATABASE}
DatabaseSlave=${BAR_DATABASE:-db2.example.com}
Mode=fancy

$ export FOO_DATABASE=db.example.com

$ ep /etc/f*.conf

$ cat /etc/foo.conf
Database=db.example.com
DatabaseSlave=db2.example.com
Mode=fancy
```
