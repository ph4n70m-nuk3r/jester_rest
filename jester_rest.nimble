# Package

version       = "0.1.0"
author        = "apl"
description   = "Minimal jester REST app"
license       = "MIT"
srcDir        = "src"
bin           = @["jester_rest"]

backend       = "c"

# Dependencies

requires "nim >= 1.4.0"
requires "jester >= 0.5.0"
