/// 
/// Colors used to customize console output
class ConsoleColors {
    static const reset = '\x1b[0m';           // reset
    static const bright = '\x1b[1m';
    //
    static const dim = '\x1b[2m';
    static const underscore = '\x1b[4m';
    static const blink = '\x1b[5m';
    static const reverse = '\x1b[7m';
    static const hidden = '\x1b[8m';
    //
    // Regular foreground
    static const fgBlack = '\x1b[0;30m';        // Black
    static const fgRed = '\x1b[0;31m';          // Red
    static const fgGreen = '\x1b[0;32m';        // Green
    static const fgYellow = '\x1b[0;33m';       // Yellow
    static const fgBlue = '\x1b[0;34m';         // Blue
    static const fgPurple = '\x1b[0;35m';       // Purple
    static const fgCyan = '\x1b[0;36m';         // Cyan
    static const fgWhite = '\x1b[0;37m';        // White
    static const fgGray = '\x1b[90m';
    //
    // Bold
    static const fgBoldBlack = '\x1b[1;30m';    // Black
    static const fgBoldRed = '\x1b[1;31m';      // Red
    static const fgBoldGreen = '\x1b[1;32m';    // Green
    static const fgBoldYellow = '\x1b[1;33m';   // Yellow
    static const fgBoldBlue = '\x1b[1;34m';     // Blue
    static const fgBoldPurple = '\x1b[1;35m';   // Purple
    static const fgBoldCyan = '\x1b[1;36m';     // Cyan
    static const fgBoldWhite = '\x1b[1;37m';    // White
    //
    // Regular background
    static const bgBlack = '\x1b[40m';
    static const bgRed = '\x1b[41m';
    static const bgGreen = '\x1b[42m';
    static const bgYellow = '\x1b[43m';
    static const bgBlue = '\x1b[44m';
    static const bgMagenta = '\x1b[45m';
    static const bgCyan = '\x1b[46m';
    static const bgWhite = '\x1b[47m';
    static const bgGray = '\x1b[100m';
}
