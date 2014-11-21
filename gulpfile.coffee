#
# # Gulpfile
#
path = require 'path'
gulp    = require 'gulp'
concat  = require 'gulp-concat'
replace = require 'gulp-replace'
tap = require 'gulp-tap'
util = require 'gulp-util'



# The handler for gulp-tap
tap_json = (file, t) ->
  filename = path.basename file.path
  if filename is 'README.template.md' then return

  try
    data = JSON.parse file.contents.toString()
  catch e
    util.log util.colors.red('Warning'), "Failed to parse json file.
      Invalid JSON syntax. File: #{file.path}"
    file.contents = new Buffer ''
    return

  str = format_json data, file.path
  if not str?
    util.log util.colors.red('Warning'), "The JSON data couldn't be formatted
      into the table for an unknown reason. File: #{file.path}"
    file.contents = new Buffer ''
    return

  # Everything is successful
  file.contents = new Buffer str



# Format a data object, and return a string to be
# appended to the readme
format_json = (data, filepath) ->
  teamPath = path.basename path.dirname filepath
  output = '|'

  # First column, #TeamName
  if data.teamName?
    output += " ##{data.teamName} |"
  else
    output += " |"

  # Second column, TeamLead
  # Faking for now.
  output += " |"

  # Third column, TeamMembers
  # Faking for now
  output += " |"

  # Fourth column, TeamPage
  if data.teamName? then teamName = data.teamName
  else teamName = teamPath
  output += " [#{teamName}](./Teams/#{teamPath}/ABOUT.md) |"

  # Fifth column, Approved
  # Faking for now
  output += " |"





gulp.task 'run', ->
  gulp.src [
    'README.template.md'
    './Teams/**/*.json'
  ]
    .pipe tap tap_json
    .pipe concat 'README.md', newLine: ''
    .pipe gulp.dest './'



gulp.task 'default', ['run']
