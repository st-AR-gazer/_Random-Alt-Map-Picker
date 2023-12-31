void NotifyWarn(const string &in msg) {
    UI::ShowNotification("Altered Random Map Picker", msg, vec4(1, .5, .1, .5), 6000);
}

void NotifyInfo(const string &in msg) {
    UI::ShowNotification("Altered Random Map Picker", msg, vec4(.2, .8, .5, .3), 6000);
}

enum LogLevel {
    Info,
    InfoG,
    Warn,
    Error
};

[Setting category="General" name="Show debug logs"]
bool doDevLogging = true;

void log(const string &in msg, LogLevel level = LogLevel::Info, int line = -1) {
    string lineInfo = line >= 0 ? "" + line : " ";
    if (doDevLogging) {
        switch(level) {
            case LogLevel::Info: 
                print("\\$0ff[INFO]" + " \\$fff" + "\\$0cc"+lineInfo+" \\$fff" + msg); 
                break;
            case LogLevel::InfoG: 
                print("\\$0f0[INFO-G]" + " \\$fff" + "\\$0c0"+lineInfo+" \\$fff" + msg); 
                break;
            case LogLevel::Warn: 
                print("\\$ff0[WARN]" + " \\$fff" + "\\$cc0"+lineInfo+" \\$fff" + msg); 
                break;
            case LogLevel::Error: 
                print("\\$f00[ERROR]" + " \\$fff" + "\\$c00"+lineInfo+" \\$fff" + msg); 
                break;
        }
    }
}