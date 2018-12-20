REM Set up \Microsoft Visual Studio 2015, where <arch> is amd64, x86, etc.
@echo off

IF "%~1"=="" goto missing

SET SOURCE_PATH=%~dp0
SET PREFIX_PATH=%~1

IF "%~2"=="" (
  SET OUTPUT_PATH=%SOURCE_PATH%
) else (
  SET OUTPUT_PATH=%~2
)

CALL "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86

REM ********** Update include & lib to support xp win sdk 7.1A **********
SET PATH=C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin;D:\Qt\Qt5.6.3\Tools\QtCreator\bin;%PATH%
SET INCLUDE=C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\include;C:\Program Files (x86)\Windows Kits\8.1\Include;%INCLUDE%
SET LIB=C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\lib;%LIB%
REM SET CL=/D_USING_V110_SDK71_;%CL%
REM SET CL=/MP %CL%

REM ********** 3rd party build tools binaries: ruby, perl, python ********** 
REM SET PATH=D:\Ruby22\bin;D:\Perl\bin;D:\Python\Python27;%PATH%
SET PATH=C:\Ruby24\bin;C:\Perl\bin;C:\Python27;%PATH%

REM ********** Set up qt source env **********
SET PATH=%SOURCE_PATH%\qtbase\bin;%SOURCE_PATH%\gnuwin32\bin;%PATH%

REM Uncomment the below line when using a git checkout of the source repository
REM SET PATH=%_ROOT%\qtrepotools\bin;%PATH%
SET QMAKESPEC=win32-msvc2015
set _ROOT=
REM nmake module-qtwebengine-qmake_all
REM Generate makefile

if not exist %OUTPUT_PATH% mkdir %OUTPUT_PATH%
pushd %OUTPUT_PATH%
CALL %SOURCE_PATH%\configure.bat -mp -confirm-license -opensource -platform %QMAKESPEC% -release -opengl dynamic -prefix %PREFIX_PATH% -nomake tests -nomake examples
nmake > nmake_info_output.log
nmake install
popd
goto :eof
REM configure.bat -list-features
:missing
echo Usage: qt_build.bat <prefix_path> <output_path>
echo E.g    qt-build.bat C:\Qt\Qt5.6.3\5.6.3\msvc2015 H:\open_source_build_bin
echo        <prefix_path> must be set
echo        <output_path> is option
goto :eof