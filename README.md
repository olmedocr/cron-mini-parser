# CronMiniParser

A parser for simulating the time of the execution of a cron job based on a given time.

## Usage
### No stdin
`swift run CronMiniParser "<current-time>" "<cron-mins>" "<cron-hours>" <cron-command>`

e.g. `swift run CronMiniParser "23:59" "*" "*" /bin/run_me_every_minute`

**Please do take note of the extra enclosing** `"`

### Stdin
`cat <file> | swift run CronMiniParser -`

e.g. `cat input.txt | swift run CronMiniParser -`

**A file example is included in this repo in** `input.txt`

## Notes
The only external library used (`swift-argument-parser`) is an argument parser developed for Swift command-line apps.

Since `stdin` input was not supported by default in `swift-argument-parser`, I had to take a bit of extra time to modify it in order to work as expected in the provided document.