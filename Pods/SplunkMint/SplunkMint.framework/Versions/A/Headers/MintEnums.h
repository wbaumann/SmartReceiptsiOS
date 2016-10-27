//
//  SplunkEnums.h
//  SplunkMint
//
//  Copyright (c) 2016 Splunk. All rights reserved.
//


/**
 *  Enumeration values that indicate the log level of the log event.
 */
typedef enum {
    /**
     *  The lowest priority, and normally not logged except for messages from the kernel.
     */
    DebugLogLevel = 20,
    
    /**
     *  The lowest priority that you would normally log, and purely informational in nature.
     */
    InfoLogLevel = 30,
    
    /**
     *  Things of moderate interest to the user or administrator.
     */
    NoticeLogLevel = 40,
    
    /**
     *  Something is amiss and might fail if not corrected.
     */
    WarningLogLevel = 50,
    
    /**
     *  Something has failed.
     */
    ErrorLogLevel = 60,
    
    /**
     *  A failure in a key system.
     */
    CriticalLogLevel = 70,
    
    /**
     *  A serious failure in a key system.
     */
    AlertLogLevel = 80,
    
    /**
     *  The highest priority, usually reserved for catastrophic failures and reboot notices.
     */
    EmergencyLogLevel = 90
} MintLogLevel;

