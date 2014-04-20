{exec} = require 'child_process'
path = require 'path'
Rehab = require 'rehab'

APP_NAME = 'app'

COFFEE_PATH = './src/coffee'
TARGET_PATH = './static/assets/js'

outputFile = path.join TARGET_PATH, "#{APP_NAME}.js"

BUILD_DESC = "Building project from #{COFFEE_PATH}/*.coffee to #{outputFile}"
CLEAN_DESC = "Remove #{TARGET_PATH}/*.js"

build = (callback) ->
    files = new Rehab().process COFFEE_PATH
    to_single_file = "--join #{outputFile}"
    from_files = "--compile #{files.join ' '}"
    exec "coffee #{to_single_file} #{from_files}", (err, stdout, stderr) ->
        if err then throw err else callback()

task 'build', BUILD_DESC, ->
    console.log BUILD_DESC
    build ->
        exec "uglifyjs #{outputFile} -o #{outputFile}", (err, stdout, stderr) ->
            if err then throw err

task 'build-dev', BUILD_DESC, ->
    build ->

task 'clean', CLEAN_DESC, ->
    exec "rm #{TARGET_PATH}/*.js"
