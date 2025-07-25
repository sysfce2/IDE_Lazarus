unit IdeDebuggerStringConstants;

{$mode objfpc}{$H+}

interface

{//$R images.rc}
{$R images.res}

resourcestring
  // Overlap with the IDE
  lisMenuHelp = '&Help';
  lisId = 'ID';
  lisName = 'Name';
  lisValue = 'Value';
  lisPEFilename = 'Filename:';
  lisCCOErrorCaption = 'Error';
  lisKMEvaluateModify = 'Evaluate/Modify';
  dlgEnvType = 'Type';
  lisBreak = 'Break';
  lisMenuBreak = '&Break';
  lisExport = 'Export';
  lisImport = 'Import';
  dlgFilterAll = 'All files';
  dlgFilterXML = 'XML files';
  lisLess = 'Less';
  lisMore = 'More';
  lisStop = 'Stop';
  lisClear = 'Clear';
  lisMenuViewDebugEvents = 'Event Log';
  lisMenuViewDebugOutput = 'Debug Output';
  lisMVSaveMessagesToFileTxt = 'Save messages to file (*.txt)';
  uemToggleBreakpoint = 'Toggle &Breakpoint';

  lisMenuStepInto = 'Step In&to';
  lisMenuStepOver = '&Step Over';
  lisMenuStepIntoInstr = 'Step Into Instruction';
  lisMenuStepIntoInstrHint = 'Step Into Instruction';
  lisMenuStepOverInstr = 'Step Over Instruction';
  lisMenuStepOverInstrHint = 'Step Over Instruction';
  lisMenuStepIntoContext = 'Step Into (Context)';
  lisMenuStepOverContext = 'Step Over (Context)';
  lisMenuStepOut = 'Step O&ut';
  lisMenuStepToCursor = 'Step over to &Cursor';

  //
  lisMenuViewCallStack = 'Call Stack';

  dlgSortUp = 'Up';
  dlgSortDown = 'Down';

  dlgInspectIndexOfFirstItemToShow = 'Index of first item to show';
  dlgInspectAmountOfItemsToShow = 'Amount of items to show';
  dlgInspectBoundsDD = 'Bounds: %d .. %d';
  dlgBackConvOptAddNew = 'Add';
  dlgBackConvOptRemove = 'Remove';
  dlgBackConvOptMatchTypesByName = 'Match types by name';
  dlgBackConvOptAction = 'Action';
  dlgDisplayFormatDebugOptions = 'Display Format';
  dlgVarFormatterDebugOptions = 'Value Formatter';
  dlgBackConvOptDebugOptions = 'Backend Converter';
  dlgIdeDbgDebugger = 'Debugger';
  dlgIdeDbgNewItem = 'New Item';
  dlgIdeDbgEnterName = 'Enter name';
  dlgBackConvOptName = 'Name';
  dlgBackConvOptNesting = 'Limit to (un)nested';
  dlgBackConvOptNestLvl = 'Min/Max level';

  drsUseInstanceClass = 'Instance';
  drsUseInstanceClassHint = 'Use Instance class type';
  drsUseFunctionCalls = 'Function';
  drsUseFunctionCallsHint = 'Allow function calls';
  drsEnterExpression = 'Enter Expression';
  drsAddWatch = 'Add watch';
  drsEvaluate = 'Evaluate';
  drsInspect = 'Inspect';
  drsHistory = 'History';
  drsDebugConverter = 'Converter';
  drsNoDebugConverter= 'No Converter';
  drsDebugValFormatter = 'Value formatter';
  drsNoValFormatter= 'No value formatter';
  drsDisableEnableUpdatesForTh = 'Disable/Enable updates for the entire window';
  drsNoHistoryKept = 'No history kept';
  drsInsertResultAtTopOfHistor = 'Insert result at top of history';
  drsAppendResultAtBottomOfHis = 'Append result at bottom of history';
  lisInspectShowColClass = 'Show class column';
  lisInspectShowColType = 'Show type column';
  lisInspectShowColVisibility = 'Show visibility column';
  lisWordWrapBtnHint = 'Word wrap';
  drsNewValue = 'New Value';
  drsNewValueToAssignToTheVari = 'New value to assign to the variable in the '
    +'debugged process (use Shift-Enter to confirm)';

  // Watch Property Dialog
  lisWatchPropert = 'Watch Properties';
  lisExpression = 'Expression:';
  lisRepeatCount = 'Repeat Count:';
  lisDigits = 'Digits:';
  lisAllowFunctio = 'Allow Function Calls';
  lisStyle = 'Style';

  drsUseInstanceClassType = 'Use Instance class type';
  dlgBackendConvOptDebugConverter = 'Backend Converter:';
  dlgBackendConvOptDefault = '- Default -';
  dlgBackendConvOptDisabled = '- Disabled -';
  drsRunAllThreadsWhileEvaluat = 'Run all threads while evaluating';
  dlgWatchPropertyUnknown = '>> Mixed/Keep <<';

  // Debugger Dialogs
  lisDbgWinPower = 'On/Off';
  lisDbgWinPowerHint = 'Disable/Enable updates for the entire window';

  lisDbgItemEnable          = 'Enable';
  lisDbgItemEnableHint      = 'Enable';
  lisDbgItemDisable         = 'Disable';
  lisDbgItemDisableHint     = 'Disable';
  lisDbgItemDeleteHint      = 'Delete';
  lisDbgAllItemEnable       = 'Enable all';
  lisDbgAllItemEnableHint   = 'Enable all';
  lisDbgAllItemDisable      = 'Disable all';
  lisDbgAllItemDisableHint  = 'Disable all';
  lisDbgAllItemDelete       = 'Delete all';
  lisDbgAllItemDeleteHint   = 'Delete all';
  lisDbgBreakpointPropertiesHint = 'Breakpoint Properties ...';
  lisDbgBreakpointGroupsHint = 'Show breakpoints by group';

  liswlProperties = '&Properties';
  liswlQuickFormat = '&Format';
  liswlDIsableAll = 'D&isable All';
  liswlENableAll = 'E&nable All';
  liswlDeLeteAll = 'De&lete All';
  liswlInspectPane = 'Inspect pane';

  // Watch Dialog
  liswlWatchList = 'Watches';
  liswlExpression = 'Expression';
  dlgValueColor = 'Value';
  dlgValueDataAddr = 'Data-Address';
  dlgWatchesDeleteAllConfirm = 'Delete all watches?';

  lisWatch = '&Watch';
  lisWatchData = 'Watch:';
  lisWatchScope = 'Watch scope';
  lisWatchScopeGlobal = 'Global';
  lisWatchScopeLocal = 'Declaration';
  lisWatchKind = 'Watch action';
  lisWatchKindRead = 'Read';
  lisWatchKindWrite = 'Write';
  lisWatchKindReadWrite = 'Read/Write';

  lisLocals = 'Local Variables';
  lisLocalsNotEvaluated = 'Locals not evaluated';
  lisLocalsDlgCopyName = '&Copy Name';
  lisLocalsDlgCopyValue = 'C&opy Value (quoted)';
  lisLocalsDlgCopyRAWValue = 'Copy &RAW Value';
  lisLocalsDlgCopyAddr = 'Copy &Data-Address';
  lisLocalsDlgCopyEntry = 'Copy entire entry';
  lisLocalsDlgCopyAll = 'Copy &all entries';

  lisLocalsDlgCopyNameValue = 'Co&py Name and Value'; // Registers

  lisWatchToWatchPoint = 'Create &Data/Watch Breakpoint ...';

  // Mem viewer
  liswlMemView = 'Memory';

  // Terminal Output
  lisDbgTerminal = 'Console In/Output';

  // Call Stack Dialog
  lisCurrent = 'Select as context';
  lisViewSource = 'View Source';
  lisViewSourceDisass = 'View Assembler';
  lisMaxS = 'Max %d';
  lisGotoSelected = 'Goto selected';
  lisCopyLine = 'Copy Line';
  lisCopyAll = 'Copy All';
  lisIndex = 'Index';
  lisFunction = 'Function';
  lisCSTop = 'Top';
  lisCSDown = 'Page down';
  lisCSUp = 'Page up';
  lisCSBottom = 'Bottom';
  lisCallStackNotEvaluated = 'Stack not evaluated';

  // Locals Dialog
  lisEvaluateModify = '&Evaluate/Modify';
  lisEvaluateAll = 'Evaluate all';

  // Registers Dialog
  lisRegisters = 'Registers';

  // ThreadDlg
  lisThreads = 'Threads';
  lisThreadId = 'Thread ID';
  lisThreadsState = 'State';
  lisThreadsSrc  = 'Source';
  lisThreadsLine = 'Line';
  lisThreadsFunc = 'Function';
  lisThreadsCurrent = 'Current';
  lisThreadsGoto = 'Goto';
  lisThreadsNotEvaluated = 'Threads not evaluated';

  // HistoryDlg
  histdlgFormName   = 'History';
  histdlgColumnCur  = '';
  histdlgColumnTime = 'Time';
  histdlgColumnLoc  = 'Location';
  histdlgBtnPowerHint = 'Switch on/off automatic snapshots';
  histdlgBtnEnableHint = 'Toggle view snapshot or current';
  histdlgBtnClearHint = 'Clear all snapshots';
  histdlgBtnShowHistHint = 'View history';
  histdlgBtnShowSnapHint = 'View Snapshots';
  histdlgBtnMakeSnapHint = 'Take Snapshot';
  histdlgBtnRemoveHint   = 'Remove selected entry';
  dlgHistoryDeleteAllConfirm = 'Delete complete History?';

  // Exception Dialog
  lisExceptionDialog = 'Debugger Exception Notification';
  lisIgnoreExceptionType = 'Ignore this exception type';

  // Inspect Dialog
  lisInspectDialog = 'Debug Inspector';
  lisInspectData = 'Data';
  lisInspectProperties = 'Properties';
  lisInspectMethods = 'Methods';
  lisInspectUseInstance = 'Instance';
  lisInspectUseInstanceHint = 'Use instance class';
  lisInspectClassInherit = '%s: class %s inherits from %s';
  lisInspectUnavailableError = '%s: unavailable (error: %s)';
  lisInspectPointerTo = 'Pointer to %s';
  lisInspectAddWatch = 'Add watch';
  lisColClass = 'Class';
  lisColVisibility = 'Visibility';
  lisColReturns = 'Returns';
  lisColAddress = 'Function Address';
  lisColInstance = 'Object Instance';

  // Breakpoint
  lisHitCount = 'Hitcount';
  lisDisableBreakPoint = 'Disable Breakpoint';
  lisEnableBreakPoint = 'Enable Breakpoint';
  lisDeleteBreakPoint = 'Delete Breakpoint';
  lisViewBreakPointProperties = 'Breakpoint Properties ...';
  lisEnableGroups = 'Enable Groups';
  lisDisableGroups = 'Disable Groups';
  lisLogMessage = 'Log Message';
  lisLogEvalExpression = 'Eval expression';
  lisLogCallStack = 'Log Call Stack';
  lisLogCallStackLimit = '(frames limit. 0 - no limits)';
  lisBPSEnabled = 'Enabled';
  lisBPSDisabled = 'Disabled';
  lisInvalidOff = 'Invalid (Off)';
  lisInvalidOn = 'Invalid (On)';
  lisPendingOn = 'Pending (On)';
  lisOff = '? (Off)';
  lisOn = '? (On)';
  lisTakeSnapshot = 'Take a Snapshot';
  lisSrcLine     = 'Line';


  // Breakpoint Properties Dialog
  dbgBreakPropertyGroupNotFound = 'Some groups in the Enable/Disable list do not exist.%0:s'
    +'Create them?%0:s%0:s%1:s';
  lisBreakPointProperties = 'Breakpoint Properties';
  lisLine = 'Line:';
  lisAddress = 'Address:';
  lisAutoContinueAfter = 'Auto continue after:';
  lisMS = '(ms)';
  lisActions = 'Actions:';
  lisEvalExpression = 'Eval expression';

  // Break Points Dialog
  lisFilenameAddress = 'Filename/Address';
  lisLineLength = 'Line/Length';
  lisCondition = 'Condition';
  lisPassCount = 'Pass Count';
  lisGroup = 'Group';
  lisSourceBreakpoint = '&Source Breakpoint ...';
  lisAddressBreakpoint = '&Address Breakpoint ...';
  lisWatchPoint = '&Data/Watch Breakpoint ...';
  lisWatchPointBreakpoint = '&Data/watch Breakpoint ...';
  lisEnableAll = '&Enable All';
  lisDeleteAll = '&Delete All';
  lisDisableAllInSameSource = 'Disable All in same source';
  lisEnableAllInSameSource = 'Enable All in same source';
  lisDeleteAllInSameSource = 'Delete All in same source';
  lisDeleteAllSelectedBreakpoints = 'Delete all selected breakpoints?';
  lisDeleteBreakpointAtLine = 'Delete breakpoint at%s"%s" line %d?';
  lisDeleteBreakpointForAddress = 'Delete breakpoint for address %s?';
  lisDeleteBreakpointForWatch = 'Delete watchpoint for "%s"?';
  lisDeleteAllBreakpoints = 'Delete all breakpoints?';
  lisDeleteAllBreakpoints2 = 'Delete all breakpoints in file "%s"?';
  lisGroupNameInput = 'Group name:';
  lisGroupNameInvalid = 'BreakpointGroup name must be a valid Pascal identifier name.';
  lisGroupNameEmptyClearInstead = 'The group name cannot be empty. Clear breakpoints'' group(s)?';
  lisGroupAssignExisting = 'Assign to existing "%s" group?';
  lisGroupSetNew = 'Set new group ...';
  lisGroupSetNone = 'Clear group(s)';
  lisGroupEmptyDelete = 'No more breakpoints are assigned to group "%s", delete it?';
  lisGroupEmptyDeleteMore = '%sThere are %d more empty groups, delete all?';
  lisMenuViewBreakPoints = 'BreakPoints';
  lisBrkPointState = 'State';
  lisBrkPointAction = 'Action';

  // Debug Output Dialog
  lisCopyAllOutputClipboard = 'Copy all output to clipboard';

  // breakpointgroups
  dbgBreakGroupDlgCaption = 'Select Groups';
  dbgBreakGroupDlgHeaderEnable = 'Select groups to enable when breakpoint is hit';
  dbgBreakGroupDlgHeaderDisable = 'Select groups to disable when breakpoint is hit';

  //Registers dialog
  regdlgDisplayTypeForSelectedRegisters = 'Display type for selected Registers';
  regdlgFormat = 'Format';
  regdlgDefault = 'Default';
  regdlgHex = 'Hex';
  regdlgDecimal = 'Decimal';
  regdlgOctal = 'Octal';
  regdlgBinary = 'Binary';
  regdlgRaw = 'Raw';

  //Debugger Attaching dialog
  lisDADRunningProcesses = 'Running Processes';
  lisDADImageName = 'Image Name';
  lisDADPID = 'PID';
  lisDADAttach = 'Attach';
  rsAttachTo = 'Attach to';
  rsEnterPID = 'Enter PID';
  dlgUnitDepRefresh      = 'Refresh';

  //Disassembler dialog
  lisDisAssAssembler = 'Assembler';
  lisMenuViewAssembler = 'Assembler';
  lisMenuViewMemViewer = 'Memory Viewer';
  lisDbgAsmCopyToClipboard = 'Copy to Clipboard';
  lisDbgAsmCopyAddressToClipboard = 'Copy address to Clipboard';
  lisDisAssGotoCurrentAddress = 'Goto Current Address';
  lisDisAssGotoCurrentAddressHint = 'Goto Current Address';
  lisDisAssGotoAddress = 'Goto Address';
  lisDisAssGotoAddressHint = 'Goto Address';
  lisDisAssGotoAddrEditTextHint = '($address)';

  // Feedback
  lisDebuggerFeedbackInformation = 'Debugger Information';
  lisDebuggerFeedbackWarning = 'Debugger Warning';
  lisDebuggerFeedbackError = 'Debugger Error';

  // Event log dialog
  lisEventLogOptions = 'Event Log Options ...';
  lisEventLogClear = 'Clear Events';
  lisEventLogSaveToFile = 'Save Events to File';
  lisEventsLogAddComment = 'Add Comment ...';
  lisEventsLogAddComment2 = 'Add Comment';


  lisInspect = '&Inspect';

  //
  lisDebugOptionsFrmResume = 'Resume';
  lisDebugOptionsFrmResumeHandled = 'Resume Handled';
  lisDebugOptionsFrmResumeUnhandled = 'Resume Unhandled';


  drsColWidthTId         = 'Thread ID column';
  drsColWidthName        = 'Name column';
  drsColWidthExpression  = 'Expression column';
  drsColWidthValue       = 'Value column';
  drsColWidthAddr        = 'Address column';
  drsColWidthState       = 'State column';
  drsColWidthIndex       = 'Index column';
  drsColWidthSource      = 'Source column';
  drsColWidthLine        = 'Line column';
  drsColWidthFunc        = 'Function name column';
  drsColWidthBrkPointImg = 'Break indication column';

  drsWatchSplitterInspect = 'Inspect pane';

  drsBreakPointColWidthFile      = 'File/address column';
  drsBreakPointColWidthLine      = 'Line column';
  drsBreakPointColWidthCondition = 'Condition column';
  drsBreakPointColWidthAction    = 'Action column';
  drsBreakPointColWidthPassCount = 'Pass-count column';
  drsBreakPointColWidthGroup     = 'Group column';

  drsHistoryColWidthCurrent  = 'Current column';
  drsHistoryColWidthTime     = 'Time column';
  drsHistoryColWidthLocation = 'Location column';

  drsInspectColWidthDataName = 'Data name column';
  drsInspectColWidthDataType = 'Data type column';
  drsInspectColWidthDataValue = 'Data value column';
  drsInspectColWidthDataClass = 'Data class column';
  drsInspectColWidthDataVisibility = 'Data visibility column';
  drsInspectColWidthMethName = 'Method name column';
  drsInspectColWidthMethType = 'Method type column';
  drsInspectColWidthMethReturns = 'Method returns column';
  drsInspectColWidthMethAddress = 'Method address column';
  dsrEvalUseDebugConverter = 'Use Backend Converter';

  drsLen = 'Len=%d: ';
  drsLen2 = 'Len=%s: ';
  synfNewValueIsEmpty = '"New value" is empty.';
  synfTheDebuggerWasNotAbleToModifyTheValue = 'The debugger was not able to modify the value.';
  drsSuspend = 'Suspend';
  BreakViewHeaderNoGroup = 'No group';
  BreakViewHeaderAddGroup = '- Add new group -';

  ValFormatterOrigValHide    = 'Replace/Hide original value';
  ValFormatterOrigValAtStart = 'Show original value at start';
  ValFormatterOrigValAtEnd   = 'Show original value at end';

  ValFormatterDateTimeName = 'DateTime';
  ValFormatterDateTimeFormatDT = 'Format for date-time';
  ValFormatterDateTimeFormatD = 'Format for date';
  ValFormatterDateTimeFormatT = 'Format for time';

  ValFormatterColorName = 'TColor';
  ValFormatterColorNameAlpha = 'TAlphaColor';
  ValFormatterColorShowName = 'Show name';
  ValFormatterColorShowRgb  = 'Show RGB';
  ValFormatterColorShowBoth = 'Show Both';
  ValFormatterColorRgbDec = 'RGB in decimal';

  ValFormatterCurrencyName = 'Currency';
  ValFormatterCharArrayToStringName = 'CharArray as String';

  ValFormatterCharArrayToStringStopNull = 'Stop at #0';

  DispFormatDlgBtnCurrent   = 'Current';
  DispFormatDlgBtnAll       = 'All';
  DispFormatDlgBtnNumber    = 'Number';
  DispFormatDlgBtnNumber2   = 'Number (2nd)';
  DispFormatDlgBtnEnum      = 'Enum';
  DispFormatDlgBtnEnumVal   = 'Enum (Identifier)';
  DispFormatDlgBtnBool      = 'Boolean';
  DispFormatDlgBtnChar      = 'Char';
  DispFormatDlgBtnFloat     = 'Float';
  DispFormatDlgBtnStruct    = 'Structure';
  DispFormatDlgBtnPointer   = 'Pointer';
  DispFormatDlgBtnArray     = 'Array';
  DispFormatDlgBtnAdrFormat = 'Address';
  DispFormatDlgBtnOptions   = 'Options';

  DispFormatDlgCaptionShowChar = '(Show Char)';
  DispFormatDlgCaptionAddress  = '(Address)';
  DispFormatDlgCaptionTyped    = '(Typed)';
  DispFormatDlgCaptionDeref    = '(Deref)';
  DispFormatDlgCaptionNumber   = '(Number)';
  DispFormatDlgCaptionSign     = '(Sign)';

  DispFormatGroupBase          = 'Number base';
  DispFormatGroupSign          = 'Number sign';
  DispFormatGroupEnum          = 'Enum';
  DispFormatGroupBool          = 'Bool';
  DispFormatGroupChar          = 'Char';
  DispFormatGroupFloat         = 'Float';
  DispFormatGroupStruct        = 'Structures';
  DispFormatGroupStructAddress = 'Structures (Addr)';
  DispFormatGroupPointerDeref  = 'Deref Pointer';
  DispFormatGroupAddress       = 'Pointer (Addr)';
  DispFormatGroupCategory      = 'Display type';

  DispFormatBaseDecimal          = 'Decimal';
  DispFormatBaseHex              = 'Hex';
  DispFormatBaseOct              = 'Oct';
  DispFormatBaseBin              = 'Binary';
  DispFormatBaseChar             = 'Char';
  DispFormatSignAuto             = 'Auto-sign';
  DispFormatSignSigned           = 'Signed';
  DispFormatSignUnsigned         = 'Unsigned';
  DispFormatNoLeadZero           = 'Hide leading zeros';
  DispFormatDlgBtnNum2Visible    = 'Show value in a second format';
  DispFormatNumDigits            = 'Digits';
  DispFormatNumDigitsFull        = 'Full';
  DispFormatNumSeperator         = 'Separator (1000)';
  DispFormatNumSepGroup          = 'Group';
  DispFormatNumSepGroupNone      = 'Off';
  DispFormatNumSepGroupByte      = 'Byte';
  DispFormatNumSepGroupWord      = 'Word';
  DispFormatNumSepGroupLong      = 'DWord';
  DispFormatEnumName             = 'Name';
  DispFormatEnumOrd              = 'Ordinal';
  DispFormatEnumNameAndOrd       = 'Both';
  DispFormatBoolName             = 'Name';
  DispFormatBoolOrd              = 'Ordinal';
  DispFormatBoolNameAndOrd       = 'Both';
  DispFormatCharLetter           = 'Letter';
  DispFormatCharOrd              = 'Ordinal';
  DispFormatCharLetterAndOrd     = 'Both';
  DispFormatFloatPoint           = 'Decimal';
  DispFormatFloatScientific      = 'Exponent';
  DispFormatStructValOnly        = 'Values only';
  DispFormatStructFields         = 'Field names';
  DispFormatStructFull           = 'Full';
  DispFormatStructAddressOff     = 'Hide pointer';
  DispFormatStructAddressOn      = 'Show pointer';
  DispFormatStructAddressOnly    = 'Only pointer';
  DispFormatPointerAddressPlain  = 'Plain address';
  DispFormatPointerAddressTyped  = 'Typed address';
  DispFormatPointerDerefOff      = 'No deref data';
  DispFormatPointerDerefOn       = 'Show deref data';
  DispFormatPointerDerefOnly     = 'Only deref data';
  DispFormatDlgIndent            = 'Multiline';
  DispFormatIndentMaxWrap        = 'Max multiline level';
  DispFormatForceSingleLineToggle    = 'Keep singleline, if ...';
  DispFormatForceSingleLineArrayLen  = 'Max len';
  DispFormatForceSingleLineStructFld = 'Max fields';
  DispFormatForceSingleLineDepth     = 'Max sub-levels';
  DispFormatForceSingleLineEach      = 'Max sub-values';
  DispFormatForceSingleLineLen       = 'Max text len';
  DispFormatForceSingleLineDigitsAny = 'Any';

  DispFormatDlgArrayLen          = 'Array len';
  DispFormatDlgArrayShowPrefix         = 'Show len';
  DispFormatDlgArrayShowPrefixEmbedded = 'Include embedded';
  DispFormatDlgArrayMaxNest            = 'Nested';
  DispFormatDlgArrayCombine            = 'Combine lengths';
  DispFormatDlgArrayCombineNone        = 'Never';
  DispFormatDlgArrayCombineAll         = 'Always';
  DispFormatDlgArrayCombineStat        = 'Static';
  DispFormatDlgArrayCombineDyn         = 'Dynamic';
  DispFormatArrayHideLenToggle         = 'Hide "Len", if ...';
  DispFormatArrayHideLenIfLess         = 'Max len';
  DispFormatArrayHideLenKeepDepth      = 'Min nested';
  DispFormatArrayHideLenThresEach      = 'Max sub-values';
  DispFormatArrayHideLenThresFullLen   = 'Max text len';

  DispFormatDlgArrayNav          = 'Array navigation';
  DispFormatArrayNavAutoHide     = 'Auto-hide';
  DispFormatArrayNavEnforceBounds= 'Enforce bounds';
  DispFormatArrayNavPageSize     = 'Page-size';
  DispFormatCategoryData         = 'Value';
  DispFormatCategoryMemDump      = 'Memory dump';

  DispFormatTargetGlobal   = 'General';
  DispFormatTargetHint     = 'Hints';
  DispFormatTargetWatches  = 'Watches';
  DispFormatTargetLocals   = 'Locals';
  DispFormatTargetInspect  = 'Inspect';
  DispFormatTargetEvalMod  = 'Eval/Modify';
  DispFormatOptChangingDescrAll  = 'Setting fallback options for all windows.';
  DispFormatOptChangingDescrSome = 'Setting fallback options for selected windows.';
  DispFormatOptChangingDescrPreset = 'Presets that can be applied to individual watches/locals.';
  DispFormatOptProjectText       = 'General and specific project settings will be used first. Only if none of them sets a default, then the IDE-wide settings will be used.';
  DispFormatTargetPreset = 'Presets';
  DispFormatPresetName   = 'Name';
  DispFormatPresetNew    = 'New';
  DispFormatPresetDel    = 'Delete';
  DispFormatPresetDefaults = 'Add Defaults';
  DispFormatPresetUp     = 'Up';
  DispFormatPresetDown   = 'Down';

  dbgDoNotShowThisMessageAgain = 'Do not ask again';
  optDispGutterCustomDisplayformat = 'Custom Display Format';
  dbgConvertOrdinalToName = 'Conversion of ordinal to name';
  arrnavEnforceBounds = 'Enforce bounds';
  arrnavAutoHide = 'Hide automatically';
  rsBaseAddress = 'Base-address';
  rsAddressOffset = 'Address-offset';
  rsLength = 'Length';
  MemViewGroupByte = 'Byte';
  MemViewGroupWordLittleEndian = 'Word (Little Endian)';
  MemViewGroupDWordLittleEndian = 'DWord (Little Endian)';
  MemViewGroupQWordLittleEndian = 'QWord (Little Endian)';
  MemViewGroupWordBigEndian = 'Word (Big Endian)';
  MemViewGroupDWordBigEndian = 'DWord (Big Endian)';
  MemViewGroupQWordBigEndian = 'QWord (Big Endian)';

implementation

end.

