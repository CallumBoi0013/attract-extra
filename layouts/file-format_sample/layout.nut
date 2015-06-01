fe.load_module("file-format");
fe.add_text("[Title]", 0, 0, fe.layout.width, 30 );

local xmlSettings = xml.loadFile( fe.script_dir + "settings.xml");
fe.add_text("XML One: " + xmlSettings.getChild("one").text, 0, 50, fe.layout.width, 30 );
fe.add_text("XML Two: " + xmlSettings.getChild("two").attr["name"], 0, 100, fe.layout.width, 30 );

local iniSettings = ini.loadFile( fe.script_dir + "settings.ini");
fe.add_text("INI One: " + iniSettings.map["General"]["one"], 0, 150, fe.layout.width, 30 );
fe.add_text("INI Two: " + iniSettings.map["General"]["two"], 0, 200, fe.layout.width, 30 );

local txtSettings = txt.loadFile( fe.script_dir + "settings.txt");
fe.add_text("TXT Line 2: " + txtSettings.lines[1], 0, 250, fe.layout.width, 30 );

