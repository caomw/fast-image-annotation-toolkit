{exec} = require 'child_process'
Rehab = require 'rehab'

COFFEE_PATH = './src/coffee'
TARGET_PATH = './static/assets/js'

BUILD_DESC = """
    Building project from #{COFFEE_PATH}/*.coffee to #{TARGET_PATH}/script.js
"""

CLEAN_DESC = """
    Remove #{TARGET_PATH}/*.js
"""

task 'build', BUILD_DESC, ->
    console.log BUILD_DESC

    files = new Rehab().process COFFEE_PATH

    to_single_file = "--join #{TARGET_PATH}/script.js"
    from_files = "--compile #{files.join ' '}"

    exec "coffee #{to_single_file} #{from_files}", (err, stdout, stderr) ->
        throw err if err

task 'clean', CLEAN_DESC, ->
    exec "rm #{TARGET_PATH}/*.js"
