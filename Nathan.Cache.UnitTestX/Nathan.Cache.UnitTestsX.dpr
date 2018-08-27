program Nathan.Cache.UnitTestsX;

{$IFNDEF TESTINSIGHT}
  {$APPTYPE CONSOLE}
{$ENDIF}

uses
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ENDIF }
  DUnitX.TestFramework,
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  Cache.Provider.First.UnitTests in 'Cache.Provider.First.UnitTests.pas',
  Cache.Provider.Second.UnitTests in 'Cache.Provider.Second.UnitTests.pas',
  Cache.Manager.UnitTests in 'Cache.Manager.UnitTests.pas',
  Cache.Provider.Thrid.UnitTests in 'Cache.Provider.Thrid.UnitTests.pas',
  Nathan.Cache.Manager.Impl in '..\Nathan.Cache.Manager.Impl.pas',
  Nathan.Cache.Manager.Intf in '..\Nathan.Cache.Manager.Intf.pas',
  Nathan.Cache.Manager.T.Impl in '..\Nathan.Cache.Manager.T.Impl.pas',
  Nathan.Cache.Provider.Impl2 in '..\Nathan.Cache.Provider.Impl2.pas',
  Nathan.Cache.Provider.Intf in '..\Nathan.Cache.Provider.Intf.pas',
  Nathan.Cache.Provider.T.Impl in '..\Nathan.Cache.Provider.T.Impl.pas',
  Nathan.Cache.Provider.Impl1 in '..\Nathan.Cache.Provider.Impl1.pas',
  System.SysUtils,
  System.IOUtils,
  Nathan.Cache.InChunk.Provider.Intf in '..\Nathan.Cache.InChunk.Provider.Intf.pas',
  Nathan.Cache.InChunk.Manager.Intf in '..\Nathan.Cache.InChunk.Manager.Intf.pas',
  Nathan.Cache.InChunk.Manager.Impl in '..\Nathan.Cache.InChunk.Manager.Impl.pas',
  Nathan.Cache.InChunk.Provider.Impl in '..\Nathan.Cache.InChunk.Provider.Impl.pas',
  Cache.Provider.InChunk.UnitTests in 'Cache.Provider.InChunk.UnitTests.pas',
  Cache.Provider.InChunk.DummyObject in 'Cache.Provider.InChunk.DummyObject.pas',
  Cache.Manager.InChunk.UnitTests in 'Cache.Manager.InChunk.UnitTests.pas';

var
  Runner: ITestRunner;
  Results: IRunResults;
  Logger: ITestLogger;
  NUnitLogger: ITestLogger;

begin
  ReportMemoryLeaksOnShutdown := (DebugHook > 0);

  {$IFDEF TESTINSIGHT}
    //  With TestInsight PlugIn...
    if (DebugHook > 0) then
    begin
      TestInsight.DUnitX.RunRegisteredTests;
      Exit;
    end;
  {$ENDIF}

  try
    //  Check command line options, will exit if invalid. With option -O=... it was invalid.
    //  TDUnitX.CheckCommandLine;

    //  Create the test runner.
    Runner := TDUnitX.CreateRunner;

    //  Tell the runner to use RTTI to find Fixtures.
    Runner.UseRTTI := True;

    //  TDUnitXIoC.DefaultContainer.RegisterType<IStackTraceProvider,TYourProvider>;

    //  Tell the runner how we will log things Log to the console window.
    //  Add a console logger, pass in true to specify quiet mode as we don't need detailed console output.
    Logger := TDUnitXConsoleLogger.Create(True);
    Runner.AddLogger(Logger);

    //  Logger := TGUIXTestRunner.Create(True);
    //  Runner.AddLogger(Logger);

    //  Add an nunit xml loggeer. Generate an NUnit compatible XML File.
    TDUnitX.Options.XMLOutputFile := ChangeFileExt(ParamStr(0), '_Result.xml');
    if TFile.Exists(TDUnitX.Options.XMLOutputFile) then
      TFile.Delete(TDUnitX.Options.XMLOutputFile);

    NUnitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    Runner.AddLogger(NUnitLogger);
    Runner.FailsOnNoAsserts := False; //  When true, Assertions must be made during tests;

    //  Run tests...
    Results := Runner.Execute;

    //  Let the CI Server know that something failed...
    if (not Results.AllPassed) then
      System.ExitCode := EXIT_ERRORS;

    //  ExitCode := FTestResult.ErrorCount + FTestResult.FailureCount;

    //  We don't want this happening when running under CI.
    if ((DebugHook > 0)
    and (TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause)) then
    begin
      System.WriteLn('Done.. press <Enter> key to quit.');
      System.WriteLn('');
      System.WriteLn('HomePath: ' + TPath.GetHomePath);
      System.WriteLn('Running '
        + IntToStr(Results.PassCount)
        + ' of '
        + IntToStr(Results.TestCount)
        + ' test cases');  // + IntToStr(Results.MemoryLeakCount)
      System.Readln;
    end;
  except
    on E: Exception do
    begin
      System.Writeln(E.ClassName, ': ', E.Message);
      System.ExitCode := 2; //  System.ExitCode := 1; Old style like EXIT_ERRORS...
    end;
  end;
end.
