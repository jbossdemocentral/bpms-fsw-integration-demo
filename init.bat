@ECHO OFF
setlocal enabledelayedexpansion

set PROJECT_HOME=%~dp0
set DEMO=JBoss BPM Suite & JBoss FSW Integration Demo
set AUTHORS=Kenny Peeples, Eric D. Schabell
set PROJECT=git@github.com:jbossdemocentral/bpms-fsw-integration-demo.git
set PRODUCT=JBoss BPM Suite & JBoss FSW Integration Demo
set JBOSS_HOME=%PROJECT_HOME%target\jboss-eap-6.1
set JBOSS_HOME_FSW=%PROJECT_HOME%target\jboss-eap-6.1.fsw
set SERVER_DIR=%JBOSS_HOME%\standalone\deployments\
set SERVER_CONF=%JBOSS_HOME%\standalone\configuration\
set SERVER_BIN=%JBOSS_HOME%\bin
set SERVER_BIN_FSW=%JBOSS_HOME_FSW%\bin
set SRC_DIR=%PROJECT_HOME%installs
set SUPPORT_DIR=%PROJECT_HOME%support
set PRJ_DIR=%PROJECT_HOME%projects
set TARGET_DIR=%PROJECT_HOME%target
set PRJ_DTGOVWF=%JBOSS_HOME_FSW%\dtgov-data
set FSW_CONFIG=%SUPPORT_DIR%\installation-fsw
set FSW_CONFIG_LOCAL=%SUPPORT_DIR%\installation-fsw.local
set BPMS=jboss-bpms-installer-6.0.3.GA-redhat-1.jar
set FSW=jboss-fsw-installer-6.0.0.GA-redhat-4.jar
set DTGOVWF=dtgov-workflows-1.0.2.Final-redhat-8.jar
set BPMS_VERSION=6.0.3
set FSW_VERSION=6.0.0

REM wipe screen.
cls 

echo.
echo ####################################################################
echo ##                                                                ##   
echo ##  Setting up %DEMO%                                   ##
echo ##                                                                ##   
echo ##                                                                ##   
echo ##     ####   ####    #   #    ###       ####   ####  #     #     ##
echo ##     #   #  #   #  # # # #  #      #   #     #      #     #     ##
echo ##     ####   ####   #  #  #   ##   ###  ###    ###   #  #  #     ##
echo ##     #   #  #      #     #     #   #   #         #  # # # #     ##
echo ##     ####   #      #     #  ###        #     ####    #   #      ##
echo ##                                                                ##   
echo ##                                                                ##   
echo ##  brought to you by,                                            ##   
echo ##             %AUTHORS%                    ##
echo ##                                                                ##   
echo ##  %PROJECT% ##
echo ##                                                                ##   
echo ####################################################################
echo.

call where mvn >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
	echo Maven Not Installed. Setup Cannot Continue
	GOTO :EOF
)

call where git >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
	echo Git Not Installed. Setup Cannot Continue
	GOTO :EOF
)

REM # make some checks first before proceeding. 
if exist %SRC_DIR%\%BPMS% (
	echo JBoss product sources, %BPMS% present...
	echo.
) else (
	echo Need to download %BPMS% package from the Customer Support Portal and place it in the %SRC_DIR% directory to proceed...
	echo.
	GOTO :EOF
)

if exist %SRC_DIR%\%FSW% (
	echo JBoss product sources, %FSW% present...
	echo.
) else (
	echo Need to download %FSW% package from the Customer Support Portal and place it in the %SRC_DIR% directory to proceed...
	echo.
	GOTO :EOF
)

REM Move the old JBoss instance, if it exists, to the OLD position.
if exist %JBOSS_HOME% (
	echo - existing JBoss product install detected and removed...
	echo.

	rmdir /s /q "%PROJECT_HOME%\target"
)

echo   - modify FSW installer script with full path.
echo.
if exist %FSW_CONFIG_LOCAL% del %FSW_CONFIG_LOCAL%
for /f "tokens=* delims= " %%a in (%FSW_CONFIG%) do (
	set str=%%a
	set str=!str:^>target=^>%TARGET_DIR%! 
	echo !str! >> %FSW_CONFIG_LOCAL%
) 

REM Run FSW installer.
call java -jar "%SRC_DIR%\%FSW%" "%SUPPORT_DIR%\installation-fsw.local" -variablefile "%SUPPORT_DIR%\installation-fsw.variables"

if not "%ERRORLEVEL%" == "0" (
	echo Error Occurred During %PRODUCT% Installation!
	echo.
	GOTO :EOF
)

del /F /Q %FSW_CONFIG_LOCAL%

echo Pausing 10 seconds prior to starting next installation...
timeout /t 10

move "%JBOSS_HOME%" "%JBOSS_HOME_FSW%"

echo   - copy in property for monitoring dtgov queries...
echo.
xcopy /Y /Q "%SUPPORT_DIR%\dtgov.properties" "%JBOSS_HOME_FSW%\standalone\configuration\"


REM Run BPM Suite installer.
echo Product installer running now...
echo.
call java -jar %SRC_DIR%\%BPMS% %SUPPORT_DIR%\installation-bpms -variablefile %SUPPORT_DIR%\installation-bpms.variables

if not "%ERRORLEVEL%" == "0" (
	echo Error Occurred During %PRODUCT% Installation!
	echo.
	GOTO :EOF
)

echo   - enabling demo accounts role setup in application-roles.properties file...
echo.
xcopy /Y /Q "%SUPPORT_DIR%\application-roles.properties" "%SERVER_CONF%"

echo   - setting up demo projects...
echo.
xcopy /Y /Q /S "%SUPPORT_DIR%\bpm-suite-demo-niogit" "%SERVER_BIN%\.niogit\" 

echo   - setting up standalone.xml configuration adjustments...
echo.
xcopy /Y /Q "%SUPPORT_DIR%\standalone.xml" "%SERVER_CONF%"

REM cp pom to dtgovwf, mvn package, cli upload + type
echo   - copy modified pom to dtgov workflow project and build...
echo.
xcopy /Y /Q "%SUPPORT_DIR%\dtgovwf-pom.xml" "%PRJ_DTGOVWF%\pom.xml"
xcopy /Y /Q "%SUPPORT_DIR%\overlord.demo.SimpleReleaseProcessBPMS.bpmn" "%PRJ_DTGOVWF%\src\main\resources\SRAMPPackage\"
xcopy /Y /Q "%SUPPORT_DIR%\overlord.demo.SimpleReleaseProcess.bpmn" "%PRJ_DTGOVWF%\src\main\resources\SRAMPPackage\"

call mvn -f "%PRJ_DTGOVWF%\pom.xml" package

if %ERRORLEVEL% NEQ 0 (
	echo.
	echo Maven Build Failed! Setup cannot continue.
	cd "%PROJECT_HOME%"
GOTO :EOF
)

xcopy /Y /Q "%PRJ_DTGOVWF%\target\%DTGOVWF%" "%SUPPORT_DIR%"

REM Final instructions to user to start and run demo.
echo.
echo =============================================================================
echo =                                                                           = 
echo =  Start JBoss BPM Suite server:                                            =
echo =                                                                           =
echo =    %SERVER_BIN%\standalone.bat -Djboss.socket.binding.port-offset=100    
echo =                                                                           =
echo =  In seperate terminal start JBoss FSW server:                             =
echo =                                                                           =
echo =    %SERVER_BIN_FSW%\standalone.bat                    
echo =                                                                           =
echo =                                                                           =
echo =  *************** BPM GOVERNANCE DEMO ***************                      =
echo =                                                                           = 
echo =  After starting server you need to upload the DTGOV workflows with        =
echo =  following command:                                                       =
echo =                                                                           = 
echo =    %SERVER_BIN_FSW%\s-ramp.bat -f support/sramp-dtgovwf-upload.txt       
echo =                                                                           = 
echo =  Now open Business Central to build ^& deploy BPM process in your browser  =
echo =  at:                                                                      =
echo =                                                                           =
echo =    http://localhost:8180/business-central     (u:erics/p:bpmsuite1!)      =
echo =                                                                           =
echo =  As a developer you have a modified project pom.xml                       =
echo =  (found in projects/customer) which includes an s-ramp wagon and s-ramp   =
echo =  repsitory locations for transporting any artifacts we build              =
echo =  with 'mvn deploy'.                                                       =
echo =                                                                           =
echo =    mvn deploy -f projects/customer/evaluation/pom.xml                     =
echo =                                                                           = 
echo =  The rewards project now has been deployed in s-ramp repository where you =
echo =  can view the artifacts and see that the governance process in the s-ramp =
echo =  was automatically started. Claim the approval task in dashboard          =
echo =  available in your browser and see the rewards artifact deployed in       =
echo =  /tmp/dev copied to /tmp/qa upon approval:                                =
echo =                                                                           = 
echo =    http://localhost:8080/s-ramp-ui            u:erics/p:jbossfsw1!        =
echo =                                                                           = 
echo =                                                                           = 
echo =  ************* FSW SERVICE WITH EXTERNAL BPM PROCESS DEMO *************   =
echo =                                                                           = 
echo =  Deploying the camel route in JBoss Fuse Serivce Works as follows:        =
echo =                                                                           =
echo =    - start the JBoss FSW with:                                            =
echo =                                                                           =
echo =    %SERVER_BIN_FSW%\standalone.bat                                    
echo =                                                                           =
echo =        (TODO: Kenny as discussed, here we need to have Switchyard app     =
echo =         build and leverage a camel route based on the on in               =
echo =         projects/fuse-integration.)                                       =
echo =                                                                           =
echo =   %DEMO% Setup Complete.                          
echo =                                                                           =
echo =============================================================================
echo.
