echo start /wait dotnetfx45_full_x86_x64.exe /norestart /passive /showrmui
echo if not %ERRORLEVEL%==0 goto e
echo start /wait NDP451-KB2858728-x86-x64-AllOS-ENU.exe /norestart /passive /showrmui
echo if not %ERRORLEVEL%==0 goto e
echo start /wait NDP452-KB2901907-x86-x64-AllOS-ENU.exe /norestart /passive /showrmui
echo if not %ERRORLEVEL%==0 goto e
echo start /wait NDP46-KB3045557-x86-x64-AllOS-ENU.exe /norestart /passive /showrmui
echo if not %ERRORLEVEL%==0 goto e
start /wait NDP461-KB3102436-x86-x64-AllOS-ENU.exe /norestart /passive /showrmui
if not %ERRORLEVEL%==0 goto e
start /wait NDP462-KB3151800-x86-x64-AllOS-ENU.exe /norestart /passive /showrmui
if not %ERRORLEVEL%==0 goto e
start /wait NDP47-KB3186497-x86-x64-AllOS-ENU.exe /norestart /passive /showrmui
if not %ERRORLEVEL%==0 goto e
:e
EXIT /B %ERRORLEVEL%
