local debug_mode = true -- Adds debug printing in the console. (Optional)
---
 
local wally = loadstring(game:HttpGet("https://pastebin.com/raw/nXukuxg3", true))()
local building = wally:CreateWindow('Building')
local units = wally:CreateWindow('Units')
local visuals = wally:CreateWindow("Visuals")
local diplomacy = wally:CreateWindow("Diplomacy")
local settings = wally:CreateWindow("Settings")
local players = game:GetService("Players")
local player = players.LocalPlayer
local gamemanager = workspace.GameManager
 
_G.testingdisabled2 = false
 
local function DebugMsg(msg)
   if debug_mode == true then
       if msg then
           if type(msg) == "string" then
               warn("DEBUG: "..msg)
           end
       end
   end
end
 
local suffixes = {"K", "M", "B", "T", "Q", "Qu", "S", "Se", "O", "N", "D"}
local function toSuffixString(n) -- Credit to woot3
for i = #suffixes, 1, -1 do
local v = math.pow(10, i * 3)
if n >= v then
return ("%.0f"):format(n / v) .. suffixes[i]
end
end
return tostring(n)
end
 
local function getcountry()
   return player:FindFirstChild("leaderstats").Country.Value
end
 
local mines_required_amount = 1;
 
building:Section("Mines")
local resourceamountreq_mines = building:Slider("Ore Count", {
  min = 1;
  max = 20;
  default = 10;
}, function(v)
  mines_required_amount = v;
end)
 
local minebuilding = building:Button('Build Mines', function()
   local country = getcountry()
   DebugMsg("Build Mines - Initiated")
   for i,v in pairs(workspace.Baseplate.Cities:FindFirstChild(country):GetChildren()) do
       if not v.Buildings:FindFirstChild("Mine") then
           local ores = false
           for a,b in pairs(v.Resources:GetChildren()) do
               if b.Name == "Oil" or b.Name == "Copper" or b.Name == "Diamond" or b.Name == "Gold" or b.Name == "Iron" or b.Name == "Phosphate" or b.Name == "Tungsten" or b.Name == "Uranium" or b.Name == "Steel" or b.Name == "Titanium" or b.Name == "Chromium" or b.Name == "Aluminum" then
                   if b.Value >= (mines_required_amount / (10/1)) then
                       ores = true
                   end
               end
           end
           wait()
           if ores == true then
               workspace.GameManager.CreateBuilding:FireServer({[1] = v},"Mines")
               DebugMsg("Build Mines - Created mines in "..v.Name)
           end
       end
   end
end)
 
units:Section("Unit Builder")
 
local unitbuilder_amount = 10
local unitbuilder_type = "Infantry"
 
local unitbuilderslider = units:Slider("Unit Count", {
  min = 1;
  max = 35;
  default = 10;
 
}, function(v)
  unitbuilder_amount = v;
end)
 
local unitbuilderselector = units:Dropdown("locations", {
  list = {
      "Infantry";
      "Tank";
      'Anti Aircraft';
      'Artillery';
      'Attacker';
      'Bomber';
      'Fighter';
      'Destroyer';
      'Frigate';
      'Battleship';
      'Aircraft Carrier';
      'Submarine';
  }
}, function(b)
  unitbuilder_type = b
end)
 
local unitbuilder = units:Button('Mass Build Units', function()
   local country = getcountry()
   DebugMsg("Unit Builder - Initiated")
   local cities = {}
   for i,v in pairs(workspace.Baseplate.Cities:FindFirstChild(country):GetChildren()) do
       if unitbuilder_type == "Bomber" or unitbuilder_type == "Fighter" or unitbuilder_type == "Attacker" then
           if v.Buildings:FindFirstChild("Airport") then
               table.insert(cities, v)
           end
       elseif unitbuilder_type == "Submarine" or unitbuilder_type == "Aircraft Carrier" or unitbuilder_type == "Battleship" or unitbuilder_type == "Frigate" then
           if v:FindFirstChild("Port") then
               table.insert(cities, v)
           end
       else
           table.insert(cities, v)
       end
   end
 
   for i = 1, unitbuilder_amount do
       if cities[i] ~= nil then
           gamemanager.CreateUnit:FireServer({[1] = cities[i]}, unitbuilder_type)
           DebugMsg("Unit Builder - Created a unit at "..cities[i].Name)
       else
           DebugMsg("Unit Builder - Ran out of cities to build this specific unit at")
       end
   end
end)
 
local updatetags = false
local tagupdate = 10
 
local alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
local tagname = ""
 
for i = 1, 7 do
local random = math.random(1, #alphabet)
tagname = tagname..string.sub(alphabet, random, random)
end
 
local faketag = Instance.new("BillboardGui")
faketag.Name = tagname
faketag.Size = UDim2.new(1,0,1,0)
faketag.Enabled = true
faketag.AlwaysOnTop = true
faketag.MaxDistance = 20
local faketaglabel = Instance.new("TextLabel")
faketaglabel.Parent = faketag
faketaglabel.BackgroundTransparency = 1
faketaglabel.TextColor3 = Color3.fromRGB(255, 0, 0)
faketaglabel.Text = "nil?"
faketaglabel.Font = Enum.Font.Code
faketaglabel.TextSize = 20
 
visuals:Section("Units")
local slider = visuals:Slider("Unit Update", {
  min = 1;
  max = 60;
  default = 10
  --flag = 'fov'
}, function(v)
  tagupdate = v;
end)
 
local unitvisuals = visuals:Button('Global Unit Visualization', function()
  if updatetags == false then
       updatetags = true
       DebugMsg("Global Unit Visualization - Enabled")
       for i,v in pairs(workspace.Units:GetChildren()) do
           if not v:FindFirstChild(tagname) then
               if v:FindFirstChild("Current") and v:FindFirstChild("Type") then
                   local tagbro = faketag:Clone()
                   tagbro.Parent = v
                   tagbro.Adornee = v
                   tagbro.TextLabel.Text = tostring(v.Type.Value).." - "..toSuffixString(v.Current.Value)
                   tagbro.TextLabel:TweenSize(UDim2.new(0,600,0,200))
                   if v.Owner.Value == player.Name then
                       tagbro.TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                   end
               end
           elseif v:FindFirstChild(tagname) then
               v:FindFirstChild(tagname).Enabled = true
           end
       end
  else
       updatetags = false
       DebugMsg("Global Unit Visualization - Disabled")
       for i,v in pairs(workspace.Units:GetChildren()) do
           if v:FindFirstChild(tagname) then
               v:FindFirstChild(tagname).Enabled = false
           end
       end
  end
end)
 
workspace.Units.ChildAdded:Connect(function(child)
   if updatetags == true then
       if child:IsA("Part") then
           if child ~= nil then
               if child:FindFirstChild("Current") and v:FindFirstChild("Type") then
                   local tagbro = faketag:Clone()
                   tagbro.Parent = v
                   tagbro.Adornee = v
                   tagbro.TextLabel.Text = tostring(v.Type.Value).." - "..toSuffixString(v.Current.Value)
                   tagbro.TextLabel:TweenSize(UDim2.new(0,600,0,200))
                   if v.Owner.Value == player.Name then
                       tagbro.TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                   end
               end
           end
       end
   end
end)
 
diplomacy:Section("Spam Alliance")
 
local function checkcountryexists(arg)
   for i,v in pairs(players:GetPlayers()) do
       if v:FindFirstChild("leaderstats") then
           if v.leaderstats.Country.Value ~= nil then
               return true
           end
       else
           return false
       end
   end
   wait()
   return false
end
 
local spamcountries = {}
local selected_spamcountry;
 
local box = diplomacy:Box('Country', {
  type = 'string';
}, function(new)
  selected_spamcountry = new
end)
 
local spamcountries_yes = diplomacy:Button('Enable', function()
   if selected_spamcountry ~= nil then
       local exists = checkcountryexists(selected_spamcountry)
       if exists == true then
           spamcountries[selected_spamcountry] = true
           DebugMsg("Spam Alliance - Added spam alliance on "..selected_spamcountry)
       end
   end
end)
 
local spamcountries_no = diplomacy:Button('Disable', function()
   if spamcountries[selected_spamcountry] ~= nil then
       spamcountries[selected_spamcountry] = nil
       DebugMsg("Spam Alliance - Removed spam alliance on "..selected_spamcountry)
   end
end)
 
gamemanager.AlertPopup.OnClientEvent:Connect(function(a, b)
   if a == "Alliance declined" then
       if string.gsub(b, " has refused to join our alliance!", "") ~= nil then
           if spamcountries[string.gsub(b, " has refused to join our alliance!", "")] ~= nil then
               delay(60, function()
                   gamemanager.ManageAlliance:FireServer(string.gsub(b, " has refused to join our alliance!", ""), "SendRequest")
                   DebugMsg("Spam Alliance - Sent ally request to "..string.gsub(b, " has refused to join our alliance!", ""))
               end)
           end
       else
           DebugMsg("Spam Alliance - Country value returned as nil, data: "..b)
       end
   elseif a == "Alliance Accepted" then
       if string.gsub(b, " has accepted our offer of an alliance.", "") ~= nil then
           if spamcountries[string.gsub(b, " has accepted our offer of an alliance.", "")] then
               spamcountries[string.gsub(b, " has accepted our offer of an alliance.", "")] = nil
           end
       else
           DebugMsg("Spam Alliance - Country value returned as nil, data: "..b)
       end
   end
end)
 
settings:Section("Debug Info")
 
local minebuilding = settings:Button('Toggle Debug Mode', function()
   debug_mode = not debug_mode
   DebugMsg("Debug Mode Settings - Toggled")
end)
 
spawn(function()
   while wait(tagupdate) do
       if _G.testingdisabled2 == true then
           break
       end
       if updatetags == true then
           DebugMsg("Global Unit Visualization - Updated")
           for i,v in pairs(workspace.Units:GetChildren()) do
               if v:FindFirstChild(tagname) and v:FindFirstChild("Current") and v:FindFirstChild("Type") then
                   v:FindFirstChild(tagname).TextLabel.Text = tostring(v.Type.Value).." - "..toSuffixString(v.Current.Value)
               end
           end
       end
   end
end)
 