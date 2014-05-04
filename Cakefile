{exec} = require 'child_process'
path = require 'path'
Rehab = require 'rehab'

APP_NAME = 'app'

LESS_PATH = './src/less'
LESS_TARGET_PATH = './static/assets/css'
COFFEE_PATH = './src/coffee'
COFFEE_TARGET_PATH = './static/assets/js'

outputFile = path.join COFFEE_TARGET_PATH, "#{APP_NAME}.js"

BUILD_DESC = "Building project from #{COFFEE_PATH}/*.coffee to #{outputFile}"
CLEAN_DESC = "Remove #{COFFEE_TARGET_PATH}/*.js"

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

task 'build-css', ->
    fs = require 'fs'
    fs.readdir LESS_PATH, (err, files) ->
        for file in files
            continue if file[0] == '_'
            less_file = path.join LESS_PATH, file
            less_target_file = path.join LESS_TARGET_PATH,
                file.replace('less', 'css')
            exec "lessc #{less_file} > #{less_target_file}"

task 'clean', CLEAN_DESC, ->
    exec "rm #{COFFEE_TARGET_PATH}/*.js"
