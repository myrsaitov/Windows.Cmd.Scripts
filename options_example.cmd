@echo off
setlocal enableDelayedExpansion

:: https://stackoverflow.com/questions/3973824/windows-bat-file-optional-argument-parsing

:: Define the option names along with default values, using a <space>
:: delimiter between options. I'm using some generic option names, but 
:: normally each option would have a meaningful name.
::
:: Each option has the format -name:[default]
::
:: The option names are NOT case sensitive.
::
:: Options that have a default value expect the subsequent command line
:: argument to contain the value. If the option is not provided then the
:: option is set to the default. If the default contains spaces, contains
:: special characters, or starts with a colon, then it should be enclosed
:: within double quotes. The default can be undefined by specifying the
:: default as empty quotes "".
:: NOTE - defaults cannot contain * or ? with this solution.
::
:: Options that are specified without any default value are simply flags
:: that are either defined or undefined. All flags start out undefined by
:: default and become defined if the option is supplied.
::
:: The order of the definitions is not important.
::
set "options=-username:/ -option2:"" -option3:"three word default" -flag1: -flag2:"

:: Set the default option values
for %%O in (%options%) do for /f "tokens=1,* delims=:" %%A in ("%%O") do set "%%A=%%~B"

:loop
:: Validate and store the options, one at a time, using a loop.
:: Options start at arg 3 in this example. Each SHIFT is done starting at
:: the first option so required args are preserved.
::
if not "%~3"=="" (
  set "test=!options:*%~3:=! "
  if "!test!"=="!options! " (
    rem No substitution was made so this is an invalid option.
    rem Error handling goes here.
    rem I will simply echo an error message.
    echo Error: Invalid option %~3
  ) else if "!test:~0,1!"==" " (
    rem Set the flag option using the option name.
    rem The value doesn't matter, it just needs to be defined.
    set "%~3=1"
  ) else (
    rem Set the option value using the option as the name.
    rem and the next arg as the value
    set "%~3=%~4"
    shift /3
  )
  shift /3
  goto :loop
)

:: Now all supplied options are stored in variables whose names are the
:: option names. Missing options have the default value, or are undefined if
:: there is no default.
:: The required args are still available in %1 and %2 (and %0 is also preserved)
:: For this example I will simply echo all the option values,
:: assuming any variable starting with - is an option.
::
set -

:: To get the value of a single parameter, just remember to include the `-`
echo The value of -username is: !-username!