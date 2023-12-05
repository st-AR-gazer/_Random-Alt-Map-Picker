string currentVersionFile = "CDN/currentInstalledVersion.json";
string manifestUrl = "http://maniacdn.net/ar_/Alt-Map-Picker/manifest/latestInstalledVersion.json";
string url = "http://maniacdn.net/ar_/Alt-Map-Picker/data.csv";
// string currentVersionFileNEWTEST = "CDN/currentInstalledVersionNEW.json";
string latestVersion;
string currentInstalledVersion;

void GetLatestFileInfo() {
    Net::HttpRequest req;
    req.Method = Net::HttpMethod::Get;
    req.Url = manifestUrl;
    
    req.Start();

    while (!req.Finished()) yield();

    if (req != null) {
        log("Feching manifest successfull: \n" + req.String(), LogLevel::Info);
        ParseManifest(req.String());
    } else {
        log("Error fetching manifest: " + req.String(), LogLevel::Error);
    }
}

void ParseManifest(const string &in reqBody) {
    Json::Value manifest = Json::Parse(reqBody);
    if (manifest.GetType() != Json::Type::Object) {
        log("Failed to parse JSON.", LogLevel::Error);
        return;
    }

    string latestVersion = manifest["latestVersion"];
    log("Updating the url, the local url is: " + url, LogLevel::Info);
    string url = manifest["url"];
    log("The url has been updated, the new url is: " + url, LogLevel::Info);

    UpdateCurrentVersionIfDifferent(latestVersion);
}

void UpdateCurrentVersionIfDifferent(const string &in latestVersion) {
    string currentInstalledVersion = GetCurrentInstalledVersion();

    if (currentInstalledVersion != latestVersion) {
        log("Updating the current version: " + currentInstalledVersion + " to the most up-to-date version: " + latestVersion, LogLevel::Info);
        DownloadLatestData();
    } else {
        log("Current version is up-to-date.", LogLevel::Info);
    }
}

string GetCurrentInstalledVersion() {
    IO::FileSource file(currentVersionFile);

    string fileContents = file.ReadToEnd();

    Json::Value currentVersionJson = Json::Parse(fileContents);

    if (currentVersionJson.GetType() == Json::Type::Object) {
        return currentVersionJson["latestVersion"];
    }

    return "";
}

void DownloadLatestData() {
    Net::HttpRequest req;
    req.Method = Net::HttpMethod::Get;
    req.Url = url;
    
    req.Start();

    while (!req.Finished()) yield();

    if (req != null) {
        auto data = req.String();
        log("Feching new data successfull: \n" + "[the data would be here, but there's a lot of it and I'm lazy...]", LogLevel::Info);
        StoreDatafile(data);
    } else {
        log("Error fetching datafile: " + req.String(), LogLevel::Error);
    }
}

void StoreDatafile(const string &in data) {
    Json::Value json = Json::FromFile(currentVersionFile); 

    if (json.GetType() == Json::Type::Object && json.HasKey("latestVersion")) {
        log("Current Version " + currentInstalledVersion + "Latest version " + latestVersion, LogLevel::Info);
        json["latestVersion"] = latestVersion;
    } else {
        log("JSON file does not have the expected structure or the 'latestVersion' key.", LogLevel::Error);
        return;
    }

    Json::ToFile(currentVersionFile, json);

    log("Should have updated the version, probably...", LogLevel::Info);
}



/*
void StoreDatafile(const string &in data) {

}
*/