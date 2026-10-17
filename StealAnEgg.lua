--[[
Steal An Egg - Final developer panel build
Base script: randomcamper707/stealanegg1/Main.lua

This file keeps the user's existing Main.lua as the base and adds a polished
inventory panel for the supplied Divine eggs, pets and Star.

IMPORTANT:
- Run THIS file directly. Do not overwrite Main.lua with this loader unless
you also change BASE_URL, otherwise Main.lua would load itself recursively.
- In a normal client loadstring environment, created Backpack tools and placed
pets are local to that client. If ReplicatedStorage contains a RemoteEvent or
RemoteFunction named "SAE_DeveloperBridge", this add-on will use it for
server-authoritative GiveItem / PlacePet requests instead.
--]]

local BASE_URL = "https://raw.githubusercontent.com/randomcamper707/stealanegg1/refs/heads/main/Main.lua"

-- Load the existing control panel first.
local baseOK, baseErr = pcall(function()
local source = game:HttpGet(BASE_URL)
local fn, compileErr = loadstring(source)
if not fn then
error(compileErr or "Could not compile base script")
end
fn()
end)

if not baseOK then
warn("[SAE] Base script error: " .. tostring(baseErr))
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local P = Players.LocalPlayer
if not P then return end

local PG = P:FindFirstChildOfClass("PlayerGui")
or P:WaitForChild("PlayerGui", 10)

if not PG then return end

local Backpack = P:FindFirstChildOfClass("Backpack")
or P:WaitForChild("Backpack", 10)

if not Backpack then return end

-- Clean up older copies.
for _, guiName in ipairs({
"SAE_ITEMS_V3",
"SAE_ITEMS_V2",
"SAE_ITEMS_V1"
}) do
local old = PG:FindFirstChild(guiName)
if old then
old:Destroy()
end
end

for _, folderName in ipairs({
"SAE_HeldItemVisuals",
"SAE_LocalPlacedPets"
}) do
local old = workspace:FindFirstChild(folderName)
if old then
old:Destroy()
end
end

for _, tool in ipairs(Backpack:GetChildren()) do
if tool:IsA("Tool")
and tool:GetAttribute("SAE_InventoryTool") then
tool:Destroy()
end
end

if P.Character then
for _, child in ipairs(P.Character:GetChildren()) do
if child:IsA("Tool")
and child:GetAttribute("SAE_InventoryTool") then
child:Destroy()
end
end
end

local HeldFolder = Instance.new("Folder")
HeldFolder.Name = "SAE_HeldItemVisuals"
HeldFolder.Parent = workspace

local PlacedFolder = Instance.new("Folder")
PlacedFolder.Name = "SAE_LocalPlacedPets"
PlacedFolder.Parent = workspace

local COLORS = {
bg = Color3.fromRGB(8, 8, 14),
header = Color3.fromRGB(15, 11, 23),
card = Color3.fromRGB(24, 18, 34),
card2 = Color3.fromRGB(37, 25, 50),
border = Color3.fromRGB(84, 57, 110),

purple = Color3.fromRGB(142, 51, 236),
purple2 = Color3.fromRGB(184, 83, 255),

white = Color3.fromRGB(255, 255, 255),
muted = Color3.fromRGB(168, 162, 181),

green = Color3.fromRGB(105, 245, 135),
orange = Color3.fromRGB(255, 188, 82),
red = Color3.fromRGB(255, 86, 86),

gold = Color3.fromRGB(255, 214, 52)
}

-- =========================================================
-- ITEMS
-- =========================================================

local ITEMS = {

Eggs = {

{
name = "Unicorn Egg",
aliases = {
"Unicorn Egg",
"UnicornEgg"
}
},

{
name = "Kitsune Egg",
aliases = {
"Kitsune Egg",
"KitsuneEgg"
}
},

{
name = "Night Flame Egg",
aliases = {
"Night Flame Egg",
"Nightflame Egg",
"NightFlameEgg",
"NightflameEgg"
}
},

{
name = "Archangel Egg",
aliases = {
"Archangel Egg",
"ArchAngel Egg",
"Arch Angel Egg",
"ArchAngelEgg"
}
},

{
name = "World Burner Egg",
aliases = {
"World Burner Egg",
"WorldBurner Egg",
"WorldBurnerEgg"
}
},

{
name = "Aetheron Egg",
aliases = {
"Aetheron Egg",
"AetheronEgg"
}
},

{
name = "Cthulhu Egg",
aliases = {
"Cthulhu Egg",
"CthulhuEgg"
}
},

{
name = "Luminous Cthulhu Egg",
aliases = {
"Luminous Cthulhu Egg",
"LuminousCthulhu Egg",
"LuminousCthulhuEgg"
}
},

{
name = "Sabertooth Egg",
aliases = {
"Sabertooth Egg",
"Saber Tooth Egg",
"SabertoothEgg"
}
},

{
name = "Skeletal Sabertooth Egg",
aliases = {
"Skeletal Sabertooth Egg",
"Skeletal Saber Tooth Egg",
"SkeletalSabertoothEgg"
}
},

{
name = "Octophant Egg",
aliases = {
"Octophant Egg",
"OctophantEgg"
}
},

{
name = "Mecha Scrambler Egg",
aliases = {
"Mecha Scrambler Egg",
"MechaScrambler Egg",
"MechaScramblerEgg"
}
}
},

Pets = {

{
name = "Unicorn",
aliases = {
"Unicorn"
}
},

{
name = "Kitsune",
aliases = {
"Kitsune"
}
},

{
name = "Night Flame",
aliases = {
"Night Flame",
"Nightflame",
"NightFlame"
}
},

{
name = "Archangel",
aliases = {
"Archangel",
"ArchAngel",
"Arch Angel"
}
},

{
name = "World Burner",
aliases = {
"World Burner",
"WorldBurner"
}
},

{
name = "Aetheron",
aliases = {
"Aetheron"
}
},

{
name = "Cthulhu",
aliases = {
"Cthulhu"
}
},

{
name = "Luminous Cthulhu",
aliases = {
"Luminous Cthulhu",
"LuminousCthulhu"
}
},

{
name = "Sabertooth",
aliases = {
"Sabertooth",
"Saber Tooth"
}
},

{
name = "Skeletal Sabertooth",
aliases = {
"Skeletal Sabertooth",
"Skeletal Saber Tooth",
"SkeletalSabertooth"
}
},

{
name = "Octophant",
aliases = {
"Octophant"
}
},

{
name = "Mecha Scrambler",
aliases = {
"Mecha Scrambler",
"MechaScrambler"
}
}
},

Star = {

{
name = "Star",
aliases = {
"Star",
"Golden Star",
"Gold Star",
"Divine Star"
}
}
}
}

-- =========================================================
-- OBJECT LOOKUP
-- =========================================================

local function norm(s)
return string.lower(
tostring(s or "")
):gsub("[^%w]", "")
end

local function aliasesToSet(item)

local set = {}

for _, alias in ipairs(
item.aliases or {item.name}
) do

set[norm(alias)] = true
end

return set
end

local function safeAttributeText(o, key)

local ok, value = pcall(function()
return o:GetAttribute(key)
end)

if not ok or value == nil then
return nil
end

return tostring(value)
end

local function nearestVisualContainer(o, searchRoot)

if not o then
return nil
end

if o:IsA("Tool") then
return o
end

local cur = o

while cur and cur ~= searchRoot do

if cur:IsA("Tool") then
return cur
end

cur = cur.Parent
end

if o:IsA("Model") then
return o
end

cur = o

while cur and cur ~= searchRoot do

if cur:IsA("Model") then
return cur
end

cur = cur.Parent
end

if o:IsA("BasePart") then
return o
end

if o:IsA("Folder") then

local m = o:FindFirstChildWhichIsA(
"Model",
true
)

if m then
return m
end

local p = o:FindFirstChildWhichIsA(
"BasePart",
true
)

if p then
return p
end
end

return nil
end

local function visualBounds(o)

if not o then
return nil, nil
end

if o:IsA("Model") then

local ok, cf, sz = pcall(function()

local c, s = o:GetBoundingBox()

return c, s
end)

if ok then
return cf, sz
end

elseif o:IsA("BasePart") then

return o.CFrame, o.Size

elseif o:IsA("Tool") then

local parts = {}

for _, d in ipairs(
o:GetDescendants()
) do

if d:IsA("BasePart") then
table.insert(parts, d)
end
end

if #parts > 0 then

local minV = Vector3.new(
math.huge,
math.huge,
math.huge
)

local maxV = Vector3.new(
-math.huge,
-math.huge,
-math.huge
)

for _, p in ipairs(parts) do

local half = p.Size * 0.5

minV = Vector3.new(

math.min(
minV.X,
p.Position.X - half.X
),

math.min(
minV.Y,
p.Position.Y - half.Y
),

math.min(
minV.Z,
p.Position.Z - half.Z
)
)

maxV = Vector3.new(

math.max(
maxV.X,
p.Position.X + half.X
),

math.max(
maxV.Y,
p.Position.Y + half.Y
),

math.max(
maxV.Z,
p.Position.Z + half.Z
)
)
end

local size = maxV - minV

return CFrame.new(
(minV + maxV) * 0.5
), size
end
end

return nil, nil
end

local sourceCache = {}

local function sourceCacheKey(category, item)

return tostring(category)
.. "::"
.. item.name
end

local function resolveSource(category, item)

local key = sourceCacheKey(
category,
item
)

local cached = sourceCache[key]

if cached and cached.Parent then
return cached
end

local wanted = aliasesToSet(item)

local best = nil
local bestScore = -math.huge

local roots = {
ReplicatedStorage,
workspace
}

for rootIndex, root in ipairs(roots) do

for _, o in ipairs(
root:GetDescendants()
) do

if o ~= HeldFolder
and o ~= PlacedFolder
and not o:IsDescendantOf(HeldFolder)
and not o:IsDescendantOf(PlacedFolder) then

if not (
P.Character
and o:IsDescendantOf(P.Character)
) then

local matched = false

local exactName =
wanted[norm(o.Name)] == true

if exactName then
matched = true
end

if not matched then

for _, attr in ipairs({
"ItemName",
"DisplayName",
"PetName",
"EggName",
"Type",
"Title",
"Name"
}) do

local value =
safeAttributeText(
o,
attr
)

if value
and wanted[norm(value)] then

matched = true
break
end
end
end

if not matched
and o:IsA("StringValue")
and wanted[norm(o.Value)] then

matched = true
end

if matched then

local container =
nearestVisualContainer(
o,
root
)

if container
and container ~= workspace
and container ~= ReplicatedStorage then

local n =
norm(container.Name)

local categoryOK = true

if category == "Pets"
and n:find(
"egg",
1,
true
) then

categoryOK = false
end

if category == "Eggs" then

local aliasEggMatch =
false

for aliasNorm
in pairs(wanted) do

if aliasNorm:find(
"egg",
1,
true
)
and (
n == aliasNorm
or norm(o.Name)
== aliasNorm
) then

aliasEggMatch =
true

break
end
end

if not aliasEggMatch
and not n:find(
"egg",
1,
true
)
and not exactName then

categoryOK =
false
end
end

if categoryOK then

local _, size =
visualBounds(
container
)

local sane = true

if size then

local largest =
math.max(
size.X,
size.Y,
size.Z
)

if largest > 220
or largest < 0.05 then

sane = false
end
end

if sane then

local score = 0

if exactName then
score =
score + 1200
else
score =
score + 850
end

if container:IsA(
"Tool"
) then

score =
score + 260
end

if container:IsA(
"Model"
) then

score =
score + 170
end

if rootIndex == 1 then

score =
score + 180
end

local parentName =
container.Parent
and norm(
container.Parent.Name
)
or ""

if category == "Pets"
and parentName:find(
"pet",
1,
true
) then

score =
score + 180
end

if category == "Eggs"
and parentName:find(
"egg",
1,
true
) then

score =
score + 180
end

if category == "Star"
and n == "star" then

score =
score + 300
end

if score > bestScore then

bestScore = score
best = container
end
end
end
end
end
end
end
end
end

if best then
sourceCache[key] = best
end

return best
end

-- =========================================================
-- VISUAL CLONING
-- =========================================================

local function stripVisualScripts(o)

local kill = {}

for _, d in ipairs(
o:GetDescendants()
) do

if d:IsA("Script")
or d:IsA("LocalScript")
or d:IsA("ModuleScript")
or d:IsA("ProximityPrompt")
or d:IsA("ClickDetector")
or d:IsA("Humanoid")
or d:IsA("Animator")
or d:IsA("BodyMover")
or d:IsA("BodyPosition")
or d:IsA("BodyVelocity")
or d:IsA("BodyGyro")
or d:IsA("VectorForce")
or d:IsA("LinearVelocity")
or d:IsA("AngularVelocity")
or d:IsA("AlignPosition")
or d:IsA("AlignOrientation") then

table.insert(
kill,
d
)
end
end

for _, d in ipairs(kill) do

pcall(function()
d:Destroy()
end)
end
end

local function cloneVisualFromSource(
source,
displayName
)

if not source then
return nil
end

local ok, raw = pcall(function()
return source:Clone()
end)

if not ok or not raw then
return nil
end

stripVisualScripts(raw)

local visual = raw

if raw:IsA("Tool")
or raw:IsA("Folder")
or raw:IsA("Accessory") then

local m = Instance.new("Model")

m.Name =
displayName
or raw.Name

for _, child in ipairs(
raw:GetChildren()
) do

child.Parent = m
end

raw:Destroy()

visual = m
end

visual.Name =
displayName
or visual.Name

if not visual:IsA("Model")
and not visual:IsA("BasePart") then

local m = Instance.new("Model")

m.Name =
displayName
or "Visual"

visual.Parent = m

visual = m
end

local hasPart =
visual:IsA("BasePart")
or visual:FindFirstChildWhichIsA(
"BasePart",
true
) ~= nil

if not hasPart then

visual:Destroy()

return nil
end

return visual
end

local function rootPartOf(o)

if not o then
return nil
end

if o:IsA("BasePart") then
return o
end

if o:IsA("Model") then

return o.PrimaryPart
or o:FindFirstChild(
"HumanoidRootPart",
true
)
or o:FindFirstChild(
"Handle",
true
)
or o:FindFirstChildWhichIsA(
"BasePart",
true
)
end

return o:FindFirstChildWhichIsA(
"BasePart",
true
)
end

local function allParts(o)

local list = {}

if o:IsA("BasePart") then

table.insert(
list,
o
)

else

for _, d in ipairs(
o:GetDescendants()
) do

if d:IsA("BasePart") then

table.insert(
list,
d
)
end
end
end

return list
end

local function setVisualPhysics(
o,
anchored
)

for _, p in ipairs(allParts(o)) do

p.Anchored =
anchored == true

p.CanCollide = false
p.CanTouch = false
p.CanQuery = false
p.Massless = true
end
end

local function getVisualSize(o)

if o:IsA("Model") then

local ok, size =
pcall(function()

return o:GetExtentsSize()
end)

if ok and size then
return size
end

elseif o:IsA("BasePart") then

return o.Size
end

return Vector3.new(
4,
4,
4
)
end

local function scaleVisualForHeld(
o,
category
)

local size =
getVisualSize(o)

local largest =
math.max(
size.X,
size.Y,
size.Z
)

if largest <= 0.01 then
return
end

local targetMax = 6.0

if category == "Pets" then
targetMax = 12.0
end

if category == "Star" then
targetMax = 4.2
end

local factor = 1

if largest > targetMax then

factor =
targetMax
/ largest

elseif largest
< targetMax * 0.22 then

factor =
math.min(
2.5,
(targetMax * 0.38)
/ largest
)
end

if math.abs(
factor - 1
) < 0.02 then

return
end

if o:IsA("Model") then

pcall(function()
o:ScaleTo(factor)
end)

elseif o:IsA("BasePart") then

o.Size =
o.Size * factor

local mesh =
o:FindFirstChildWhichIsA(
"SpecialMesh"
)

if mesh then

mesh.Scale =
mesh.Scale * factor
end
end
end

local function pivotVisual(
o,
cf
)

if o:IsA("Model") then

o:PivotTo(cf)

elseif o:IsA("BasePart") then

o.CFrame = cf
end
end

local function centerVisualAt(
o,
targetCF
)

pivotVisual(
o,
targetCF
)

if o:IsA("Model") then

local ok, boxCF =
pcall(function()

local cf =
o:GetBoundingBox()

return cf
end)

if ok and boxCF then

local delta =
targetCF.Position
- boxCF.Position

o:PivotTo(
o:GetPivot()
+ delta
)
end
end
end

local function weldVisualTogether(
o,
root
)

for _, p in ipairs(
allParts(o)
) do

if p ~= root then

local w =
Instance.new(
"WeldConstraint"
)

w.Name =
"SAE_VisualWeld"

w.Part0 = root
w.Part1 = p

w.Parent = root
end
end
end

-- =========================================================
-- STAR FALLBACK
-- =========================================================

local function makeFallbackStar()

local m =
Instance.new("Model")

m.Name = "Star"

local function part(
name,
size,
cf,
color
)

local p =
Instance.new("Part")

p.Name = name
p.Size = size
p.CFrame = cf

p.Color =
color
or COLORS.gold

p.Material =
Enum.Material.SmoothPlastic

p.TopSurface =
Enum.SurfaceType.Smooth

p.BottomSurface =
Enum.SurfaceType.Smooth

p.Parent = m

return p
end

local center =
part(
"Center",
Vector3.new(
2.25,
2.15,
0.55
),
CFrame.new(),
COLORS.gold
)

m.PrimaryPart = center

local points = {

{
Vector3.new(
0,
1.70,
0
),
Vector3.new(
1.15,
2.0,
0.55
),
0
},

{
Vector3.new(
1.62,
0.45,
0
),
Vector3.new(
2.0,
1.05,
0.55
),
-18
},

{
Vector3.new(
1.02,
-1.35,
0
),
Vector3.new(
1.25,
1.85,
0.55
),
-36
},

{
Vector3.new(
-1.02,
-1.35,
0
),
Vector3.new(
1.25,
1.85,
0.55
),
36
},

{
Vector3.new(
-1.62,
0.45,
0
),
Vector3.new(
2.0,
1.05,
0.55
),
18
}
}

for i, info in ipairs(points) do

part(
"Point" .. i,
info[2],

CFrame.new(
info[1]
)
* CFrame.Angles(
0,
0,
math.rad(
info[3]
)
),

COLORS.gold
)
end

for x = -1, 1 do

for y = -1, 1 do

if not (
x == 0
and y == 0
) then

part(
"Stud",

Vector3.new(
0.34,
0.34,
0.12
),

CFrame.new(
x * 0.58,
y * 0.50,
-0.34
),

Color3.fromRGB(
255,
226,
64
)
)
end
end
end

local eye1 =
part(
"Eye",

Vector3.new(
0.26,
0.42,
0.13
),

CFrame.new(
-0.48,
0.15,
-0.36
),

Color3.fromRGB(
20,
20,
20
)
)

local eye2 =
part(
"Eye",

Vector3.new(
0.26,
0.42,
0.13
),

CFrame.new(
0.48,
0.15,
-0.36
),

Color3.fromRGB(
20,
20,
20
)
)

eye1.Shape =
Enum.PartType.Ball

eye2.Shape =
Enum.PartType.Ball

part(
"MouthL",

Vector3.new(
0.12,
0.42,
0.13
),

CFrame.new(
-0.13,
-0.34,
-0.36
)
* CFrame.Angles(
0,
0,
math.rad(38)
),

Color3.fromRGB(
20,
20,
20
)
)

part(
"MouthR",

Vector3.new(
0.12,
0.42,
0.13
),

CFrame.new(
0.13,
-0.34,
-0.36
)
* CFrame.Angles(
0,
0,
math.rad(-38)
),

Color3.fromRGB(
20,
20,
20
)
)

setVisualPhysics(
m,
true
)

weldVisualTogether(
m,
center
)

return m
end

-- =========================================================
-- EQUIPPED ITEMS
-- =========================================================

local function createHeldVisual(
category,
item,
tool
)

if not tool
or not tool.Parent then

return
end

local char = P.Character

if not char then
return
end

for _, old in ipairs(
HeldFolder:GetChildren()
) do

if old:GetAttribute(
"SAE_ToolId"
) == tool:GetAttribute(
"SAE_ToolKey"
) then

old:Destroy()
end
end

local source =
resolveSource(
category,
item
)

local visual =
cloneVisualFromSource(
source,
item.name
)

if not visual
and category == "Star" then

visual =
makeFallbackStar()
end

if not visual then
return
end

visual:SetAttribute(
"SAE_ToolId",
tool:GetAttribute(
"SAE_ToolKey"
)
)

visual.Parent =
HeldFolder

setVisualPhysics(
visual,
true
)

scaleVisualForHeld(
visual,
category
)

local attachPart
local targetCF

if category == "Pets" then

attachPart =
char:FindFirstChild(
"HumanoidRootPart"
)
or char:FindFirstChild(
"UpperTorso"
)
or char:FindFirstChild(
"Torso"
)

if not attachPart then

visual:Destroy()

return
end

targetCF =
attachPart.CFrame

* CFrame.new(
1.55,
1.35,
-4.7
)

* CFrame.Angles(
0,
math.rad(180),
0
)

else

attachPart =
char:FindFirstChild(
"RightHand"
)
or char:FindFirstChild(
"Right Arm"
)
or char:FindFirstChild(
"HumanoidRootPart"
)

if not attachPart then

visual:Destroy()

return
end

if category == "Eggs" then

targetCF =
attachPart.CFrame

* CFrame.new(
0.0,
0.25,
-2.1
)

* CFrame.Angles(
0,
math.rad(180),
0
)

else

targetCF =
attachPart.CFrame

* CFrame.new(
0.0,
0.15,
-1.35
)

* CFrame.Angles(
0,
math.rad(180),
0
)
end
end

centerVisualAt(
visual,
targetCF
)

local root =
rootPartOf(visual)

if not root then

visual:Destroy()

return
end

weldVisualTogether(
visual,
root
)

local handWeld =
Instance.new(
"WeldConstraint"
)

handWeld.Name =
"SAE_HoldWeld"

handWeld.Part0 =
attachPart

handWeld.Part1 =
root

handWeld.Parent =
root

setVisualPhysics(
visual,
false
)
end

local function destroyHeldVisual(tool)

if not tool then
return
end

local id =
tool:GetAttribute(
"SAE_ToolKey"
)

for _, old in ipairs(
HeldFolder:GetChildren()
) do

if old:GetAttribute(
"SAE_ToolId"
) == id then

old:Destroy()
end
end
end

-- =========================================================
-- OPTIONAL SERVER BRIDGE
-- =========================================================

local function bridgeRemote()

return ReplicatedStorage:
FindFirstChild(
"SAE_DeveloperBridge",
true
)
end

local function invokeBridge(
action,
...
)

local bridge =
bridgeRemote()

if not bridge then

return nil,
"No developer bridge"
end

local args = {...}

local ok, result =
pcall(function()

if bridge:IsA(
"RemoteFunction"
) then

return bridge:
InvokeServer(
action,
table.unpack(args)
)

elseif bridge:IsA(
"RemoteEvent"
) then

bridge:
FireServer(
action,
table.unpack(args)
)

return true
end

return false
end)

if not ok then

return false,
tostring(result)
end

if result == false then

return false,
"Server rejected request"
end

return true,
result
end

-- =========================================================
-- PEN DETECTION
-- =========================================================

local function ownerMatches(o)

local ownerKeys = {

"Owner",
"OwnerName",

"Player",
"PlayerName",

"OwnerId",
"OwnerUserId",

"UserId"
}

for _, key in ipairs(
ownerKeys
) do

local v =
safeAttributeText(
o,
key
)

if v and (
v == P.Name
or v == P.DisplayName
or tonumber(v) == P.UserId
) then

return true
end
end

for _, child in ipairs(
o:GetChildren()
) do

if child:IsA(
"StringValue"
)
and (
norm(
child.Name
):find(
"owner",
1,
true
)
or norm(
child.Name
):find(
"player",
1,
true
)
) then

if child.Value == P.Name
or child.Value
== P.DisplayName then

return true
end

elseif child:IsA(
"IntValue"
)
and (
norm(
child.Name
):find(
"owner",
1,
true
)
or norm(
child.Name
):find(
"userid",
1,
true
)
) then

if child.Value
== P.UserId then

return true
end
end
end

local checked = 0

for _, d in ipairs(
o:GetDescendants()
) do

if d:IsA("TextLabel")
or d:IsA("TextButton") then

checked =
checked + 1

local text =
string.lower(
d.Text or ""
)

if text:find(
string.lower(P.Name),
1,
true
)
or text:find(
string.lower(
P.DisplayName
),
1,
true
) then

return true
end

if checked >= 20 then
break
end
end
end

return false
end

local function objectBounds(o)

if o:IsA("BasePart") then

return o.CFrame,
o.Size
end

if o:IsA("Model") then

local ok, cf, size =
pcall(function()

local c, s =
o:GetBoundingBox()

return c, s
end)

if ok then

return cf,
size
end
end

return nil,
nil
end

local function findPlayersPen()

local charRoot =
P.Character
and P.Character:
FindFirstChild(
"HumanoidRootPart"
)

local playerPos =
charRoot
and charRoot.Position
or Vector3.zero

local best = nil
local bestScore =
-math.huge

for _, o in ipairs(
workspace:GetDescendants()
) do

if (
o:IsA("Model")
or o:IsA("BasePart")
)
and o ~= PlacedFolder
and not o:IsDescendantOf(
PlacedFolder
) then

local n =
norm(o.Name)

local penWord =
n:find(
"pen",
1,
true
) ~= nil

local plotWord =
n:find(
"plot",
1,
true
) ~= nil

local enclosureWord =
n:find(
"enclosure",
1,
true
) ~= nil

local yardWord =
n:find(
"yard",
1,
true
) ~= nil

local baseWord =
n:find(
"base",
1,
true
) ~= nil

local owned = false

if penWord
or plotWord
or enclosureWord
or yardWord
or baseWord then

owned =
ownerMatches(o)
end

if penWord
or plotWord
or enclosureWord
or yardWord
or (
baseWord
and owned
) then

local cf, size =
objectBounds(o)

if cf and size then

local biggest =
math.max(
size.X,
size.Z
)

if biggest >= 5
and biggest <= 400 then

local score = 0

if penWord then
score =
score + 500
end

if plotWord then
score =
score + 350
end

if enclosureWord then
score =
score + 400
end

if yardWord then
score =
score + 300
end

if baseWord
and owned then

score =
score + 250
end

if owned then

score =
score + 5000
end

score =
score
- (
cf.Position
- playerPos
).Magnitude
* 0.35

if score
> bestScore then

bestScore =
score

best = o
end
end
end
end
end
end

return best
end

local function pointInsideXZ(
cf,
size,
point,
extra
)

local localPoint =
cf:PointToObjectSpace(
point
)

local pad =
extra or 0

return math.abs(
localPoint.X
) <= size.X * 0.5 + pad

and math.abs(
localPoint.Z
) <= size.Z * 0.5 + pad
end

local function groundPointAt(
pos,
ignoreList
)

local rp =
RaycastParams.new()

rp.FilterType =
Enum.RaycastFilterType.Exclude

local ex = {
HeldFolder,
PlacedFolder
}

if P.Character then

table.insert(
ex,
P.Character
)
end

if ignoreList then

for _, o in ipairs(
ignoreList
) do

table.insert(
ex,
o
)
end
end

rp.FilterDescendantsInstances =
ex

local hit =
workspace:Raycast(

pos
+ Vector3.new(
0,
80,
0
),

Vector3.new(
0,
-180,
0
),

rp
)

return hit
and hit.Position
or pos
end

local function anchorPlacedVisual(
visual
)

for _, p in ipairs(
allParts(visual)
) do

p.Anchored = true

p.CanCollide = false
p.CanTouch = false
p.CanQuery = true
p.Massless = true
end
end

local function placeVisualOnGround(
visual,
position
)

anchorPlacedVisual(
visual
)

local yaw = 0

local charRoot =
P.Character
and P.Character:
FindFirstChild(
"HumanoidRootPart"
)

if charRoot then

local _, y, _ =
charRoot.CFrame:
ToOrientation()

yaw =
y + math.pi
end

local targetCF =

CFrame.new(
position
+ Vector3.new(
0,
25,
0
)
)

* CFrame.Angles(
0,
yaw,
0
)

pivotVisual(
visual,
targetCF
)

if visual:IsA("Model") then

local ok,
boxCF,
size =
pcall(function()

local cf, sz =
visual:
GetBoundingBox()

return cf, sz
end)

if ok
and boxCF
and size then

local bottom =
boxCF.Position.Y
- size.Y * 0.5

local deltaY =
position.Y
- bottom
+ 0.05

visual:PivotTo(
visual:GetPivot()
+ Vector3.new(
0,
deltaY,
0
)
)
end

elseif visual:IsA(
"BasePart"
) then

visual.CFrame =
visual.CFrame
+ Vector3.new(

0,

position.Y
- (
visual.Position.Y
- visual.Size.Y
* 0.5
)
+ 0.05,

0
)
end
end

-- =========================================================
-- PET PLACEMENT
-- =========================================================

local statusCallback =
function() end

local function placePetFromTool(
tool,
item
)

if not tool
or not tool.Parent then

return
end

if tool:GetAttribute(
"SAE_Placing"
) then

return
end

tool:SetAttribute(
"SAE_Placing",
true
)

local source =
resolveSource(
"Pets",
item
)

if not source then

tool:SetAttribute(
"SAE_Placing",
false
)

statusCallback(
"Could not find the "
.. item.name
.. " model in ReplicatedStorage/workspace.",

COLORS.red
)

return
end

local pen =
findPlayersPen()

local targetPos

local mouse =
P:GetMouse()

local mousePos =
mouse
and mouse.Hit
and mouse.Hit.Position
or nil

if pen then

local penCF,
penSize =
objectBounds(pen)

if penCF
and penSize then

if mousePos
and pointInsideXZ(
penCF,
penSize,
mousePos,
1.5
) then

targetPos =
mousePos

else

targetPos =
penCF.Position
end
end
end

if not targetPos
and mousePos then

targetPos =
mousePos
end

if not targetPos then

local root =
P.Character
and P.Character:
FindFirstChild(
"HumanoidRootPart"
)

if root then

targetPos =
root.Position
+ root.CFrame.LookVector
* 7

else

tool:SetAttribute(
"SAE_Placing",
false
)

statusCallback(
"Character is not ready yet.",
COLORS.red
)

return
end
end

local ground =
groundPointAt(
targetPos,
nil
)

local serverOK,
serverInfo =
invokeBridge(

"PlacePet",

item.name,

CFrame.new(
ground
)
)

if serverOK == true then

destroyHeldVisual(tool)

tool:Destroy()

statusCallback(
item.name
.. " placed in your pen through the developer bridge.",

COLORS.green
)

return

elseif serverOK == false then

tool:SetAttribute(
"SAE_Placing",
false
)

statusCallback(
"Server placement failed: "
.. tostring(
serverInfo
),

COLORS.red
)

return
end

local visual =
cloneVisualFromSource(
source,
item.name
)

if not visual then

tool:SetAttribute(
"SAE_Placing",
false
)

statusCallback(
"Could not clone the "
.. item.name
.. " visual.",

COLORS.red
)

return
end

visual:SetAttribute(
"SAE_OwnerUserId",
P.UserId
)

visual:SetAttribute(
"SAE_ItemName",
item.name
)

visual.Parent =
PlacedFolder

placeVisualOnGround(
visual,
ground
)

destroyHeldVisual(tool)

tool:Destroy()

statusCallback(
item.name
.. " placed and left in the pen for this client session.",

COLORS.green
)
end

-- =========================================================
-- INVENTORY TOOLS
-- =========================================================

local function makeInventoryTool(
category,
item
)

local source =
resolveSource(
category,
item
)

if not source
and category ~= "Star" then

return nil,
"The exact model is not currently replicated in ReplicatedStorage/workspace."
end

local tool =
Instance.new("Tool")

tool.Name =
item.name

tool.ToolTip =
"DIVINE • "
.. item.name

tool.RequiresHandle =
false

tool.CanBeDropped =
false

tool:SetAttribute(
"SAE_InventoryTool",
true
)

tool:SetAttribute(
"SAE_Category",
category
)

tool:SetAttribute(
"SAE_ItemName",
item.name
)

tool:SetAttribute(
"SAE_ToolKey",
HttpService:
GenerateGUID(false)
)

if source
and source:IsA("Tool") then

pcall(function()

tool.TextureId =
source.TextureId
end)
end

tool.Equipped:
Connect(function()

createHeldVisual(
category,
item,
tool
)
end)

tool.Unequipped:
Connect(function()

destroyHeldVisual(
tool
)
end)

tool.AncestryChanged:
Connect(function(
_,
parent
)

if not parent then

destroyHeldVisual(
tool
)
end
end)

if category == "Pets" then

tool.Activated:
Connect(function()

placePetFromTool(
tool,
item
)
end)
end

tool.Parent =
Backpack

return tool
end

local function giveItem(
category,
item
)

local serverOK,
serverInfo =
invokeBridge(

"GiveItem",

category,
item.name
)

if serverOK == true then

return true,
item.name
.. " sent to your server inventory."

elseif serverOK == false then

return false,
"Server inventory request failed: "
.. tostring(
serverInfo
)
end

local tool,
err =
makeInventoryTool(
category,
item
)

if not tool then

return false,
err
end

if category == "Pets" then

return true,
item.name
.. " added to Backpack. Equip it to hold it then click to place it."
end

return true,
item.name
.. " added to Backpack. Equip it to hold it."
end

-- =========================================================
-- UI
-- =========================================================

local Gui =
Instance.new(
"ScreenGui"
)

Gui.Name =
"SAE_ITEMS_V3"

Gui.ResetOnSpawn =
false

Gui.IgnoreGuiInset =
false

Gui.DisplayOrder =
725

Gui.ZIndexBehavior =
Enum.ZIndexBehavior.Sibling

Gui.Parent =
PG

local function corner(
o,
radius
)

local c =
Instance.new(
"UICorner"
)

c.CornerRadius =
UDim.new(
0,
radius or 8
)

c.Parent = o

return c
end

local function stroke(
o,
transparency
)

local s =
Instance.new(
"UIStroke"
)

s.Color =
COLORS.border

s.Thickness =
1

s.Transparency =
transparency
or 0.25

s.Parent = o

return s
end

local function gradient(o)

local g =
Instance.new(
"UIGradient"
)

g.Color =
ColorSequence.new(
COLORS.purple,
COLORS.purple2
)

g.Rotation =
15

g.Parent = o

return g
end

local function textLabel(
parent,
text,
position,
size,
fontSize,
color
)

local l =
Instance.new(
"TextLabel"
)

l.BackgroundTransparency =
1

l.Position =
position

l.Size =
size

l.Text =
text or ""

l.TextColor3 =
color
or COLORS.white

l.Font =
Enum.Font.GothamMedium

l.TextSize =
fontSize
or 11

l.TextXAlignment =
Enum.TextXAlignment.Left

l.TextYAlignment =
Enum.TextYAlignment.Center

l.Parent =
parent

return l
end

local function textButton(
parent,
text,
position,
size,
primary
)

local b =
Instance.new(
"TextButton"
)

b.Position =
position

b.Size =
size

b.BackgroundColor3 =
primary
and COLORS.purple
or COLORS.card2

b.BorderSizePixel =
0

b.AutoButtonColor =
false

b.Text =
text

b.TextColor3 =
COLORS.white

b.Font =
Enum.Font.GothamBold

b.TextSize =
11

b.Parent =
parent

corner(
b,
8
)

stroke(
b,
0.55
)

if primary then
gradient(b)
end

local normal =
b.BackgroundColor3

b.MouseEnter:
Connect(function()

TweenService:
Create(

b,

TweenInfo.new(
0.12
),

{
BackgroundColor3 =
Color3.fromRGB(
100,
49,
160
)
}

):Play()
end)

b.MouseLeave:
Connect(function()

TweenService:
Create(

b,

TweenInfo.new(
0.12
),

{
BackgroundColor3 =
normal
}

):Play()
end)

return b
end

-- =========================================================
-- MAIN PANEL
-- =========================================================

local Panel =
Instance.new(
"Frame"
)

Panel.Name =
"InventoryPanel"

Panel.AnchorPoint =
Vector2.new(
0.5,
0.5
)

Panel.Position =
UDim2.new(
0.5,
0,
0.5,
0
)

Panel.Size =
UDim2.fromOffset(
540,
458
)

Panel.BackgroundColor3 =
COLORS.bg

Panel.BackgroundTransparency =
0.06

Panel.BorderSizePixel =
0

Panel.Parent =
Gui

corner(
Panel,
13
)

stroke(
Panel,
0.08
)

local Header =
Instance.new(
"Frame"
)

Header.Size =
UDim2.new(
1,
0,
0,
62
)

Header.BackgroundColor3 =
COLORS.header

Header.BorderSizePixel =
0

Header.Parent =
Panel

corner(
Header,
13
)

local accent =
Instance.new(
"Frame"
)

accent.Position =
UDim2.new(
0,
12,
1,
-3
)

accent.Size =
UDim2.new(
1,
-24,
0,
3
)

accent.BackgroundColor3 =
COLORS.purple

accent.BorderSizePixel =
0

accent.Parent =
Header

corner(
accent,
99
)

gradient(
accent
)

local title =
textLabel(

Header,

"DIVINE ITEM SPAWNER",

UDim2.fromOffset(
16,
7
),

UDim2.new(
1,
-62,
0,
25
),

15,

COLORS.white
)

title.Font =
Enum.Font.GothamBold

local subtitle =
textLabel(

Header,

"Eggs • Pets • Star • Backpack + pet placement",

UDim2.fromOffset(
16,
32
),

UDim2.new(
1,
-62,
0,
18
),

9,

COLORS.muted
)

local close =
textButton(

Header,

"X",

UDim2.new(
1,
-42,
0,
11
),

UDim2.fromOffset(
29,
29
),

false
)

close.TextSize =
12

close.MouseButton1Click:
Connect(function()

Panel.Visible =
false
end)

-- =========================================================
-- DRAGGING
-- =========================================================

do

local dragging =
false

local dragStart

local panelStart

Header.InputBegan:
Connect(function(input)

if input.UserInputType
== Enum.UserInputType.MouseButton1 then

dragging =
true

dragStart =
input.Position

panelStart =
Panel.Position
end
end)

UserInputService.InputChanged:
Connect(function(input)

if dragging
and input.UserInputType
== Enum.UserInputType.MouseMovement then

local delta =
input.Position
- dragStart

Panel.Position =
UDim2.new(

panelStart.X.Scale,

panelStart.X.Offset
+ delta.X,

panelStart.Y.Scale,

panelStart.Y.Offset
+ delta.Y
)
end
end)

UserInputService.InputEnded:
Connect(function(input)

if input.UserInputType
== Enum.UserInputType.MouseButton1 then

dragging =
false
end
end)
end

-- =========================================================
-- ITEMS LAUNCHER
-- =========================================================

local Launcher =
textButton(

Gui,

"ITEMS",

UDim2.new(
0,
12,
0.5,
14
),

UDim2.fromOffset(
102,
29
),

true
)

Launcher.AnchorPoint =
Vector2.new(
0,
0
)

Launcher.MouseButton1Click:
Connect(function()

Panel.Visible =
not Panel.Visible
end)

-- =========================================================
-- TABS
-- =========================================================

local TabBar =
Instance.new(
"Frame"
)

TabBar.Position =
UDim2.fromOffset(
12,
73
)

TabBar.Size =
UDim2.new(
1,
-24,
0,
34
)

TabBar.BackgroundTransparency =
1

TabBar.Parent =
Panel

local tabEggs =
textButton(

TabBar,

"EGGS",

UDim2.fromOffset(
0,
0
),

UDim2.new(
0.333,
-5,
1,
0
),

false
)

local tabPets =
textButton(

TabBar,

"PETS",

UDim2.new(
0.333,
3,
0,
0
),

UDim2.new(
0.333,
-5,
1,
0
),

false
)

local tabStar =
textButton(

TabBar,

"STAR",

UDim2.new(
0.666,
6,
0,
0
),

UDim2.new(
0.334,
-6,
1,
0
),

false
)

-- =========================================================
-- ITEM LIST
-- =========================================================

local listCard =
Instance.new(
"Frame"
)

listCard.Position =
UDim2.fromOffset(
12,
116
)

listCard.Size =
UDim2.new(
1,
-24,
0,
245
)

listCard.BackgroundColor3 =
COLORS.card

listCard.BorderSizePixel =
0

listCard.Parent =
Panel

corner(
listCard,
10
)

stroke(
listCard,
0.48
)

local listTitle =
textLabel(

listCard,

"SELECT AN ITEM",

UDim2.fromOffset(
12,
6
),

UDim2.new(
1,
-24,
0,
20
),

9,

COLORS.muted
)

listTitle.Font =
Enum.Font.GothamBold

local Scroll =
Instance.new(
"ScrollingFrame"
)

Scroll.Position =
UDim2.fromOffset(
8,
30
)

Scroll.Size =
UDim2.new(
1,
-16,
1,
-38
)

Scroll.BackgroundTransparency =
1

Scroll.BorderSizePixel =
0

Scroll.ScrollBarThickness =
4

Scroll.ScrollBarImageColor3 =
COLORS.purple2

Scroll.CanvasSize =
UDim2.fromOffset(
0,
0
)

Scroll.AutomaticCanvasSize =
Enum.AutomaticSize.Y

Scroll.Parent =
listCard

local Grid =
Instance.new(
"UIGridLayout"
)

Grid.CellPadding =
UDim2.fromOffset(
7,
7
)

Grid.CellSize =
UDim2.new(
0.5,
-4,
0,
43
)

Grid.SortOrder =
Enum.SortOrder.LayoutOrder

Grid.Parent =
Scroll

-- =========================================================
-- SELECTION CARD
-- =========================================================

local selectedCard =
Instance.new(
"Frame"
)

selectedCard.Position =
UDim2.fromOffset(
12,
371
)

selectedCard.Size =
UDim2.new(
1,
-24,
0,
75
)

selectedCard.BackgroundColor3 =
COLORS.card

selectedCard.BorderSizePixel =
0

selectedCard.Parent =
Panel

corner(
selectedCard,
10
)

stroke(
selectedCard,
0.48
)

local selectedLabel =
textLabel(

selectedCard,

"Nothing selected",

UDim2.fromOffset(
12,
7
),

UDim2.new(
1,
-184,
0,
22
),

12,

COLORS.white
)

selectedLabel.Font =
Enum.Font.GothamBold

local selectedMeta =
textLabel(

selectedCard,

"Choose an egg, pet or Star above.",

UDim2.fromOffset(
12,
29
),

UDim2.new(
1,
-184,
0,
18
),

9,

COLORS.muted
)

local status =
textLabel(

selectedCard,

"",

UDim2.fromOffset(
12,
48
),

UDim2.new(
1,
-184,
0,
18
),

9,

COLORS.muted
)

status.TextTruncate =
Enum.TextTruncate.AtEnd

local spawnButton =
textButton(

selectedCard,

"SPAWN",

UDim2.new(
1,
-160,
0,
13
),

UDim2.fromOffset(
146,
49
),

true
)

spawnButton.TextSize =
12

statusCallback =
function(
message,
color
)

status.Text =
tostring(
message or ""
)

status.TextColor3 =
color
or COLORS.muted
end

-- =========================================================
-- TAB LOGIC
-- =========================================================

local currentCategory =
"Eggs"

local currentItem =
nil

local itemButtons =
{}

local function setTabVisual(
active
)

for category, b in pairs({

Eggs = tabEggs,
Pets = tabPets,
Star = tabStar

}) do

local on =
category == active

b.BackgroundColor3 =
on
and COLORS.purple
or COLORS.card2

b:SetAttribute(
"SAE_SelectedTab",
on
)
end
end

local function clearItemButtons()

for _, b in ipairs(
itemButtons
) do

if b
and b.Parent then

b:Destroy()
end
end

itemButtons = {}
end

local function updateSelection(
category,
item
)

currentCategory =
category

currentItem =
item

selectedLabel.Text =
item.name

selectedMeta.Text =
"DIVINE • "
.. (
category == "Eggs"
and "EGG"

or category == "Pets"
and "PET"

or "STAR"
)

local source =
resolveSource(
category,
item
)

if source then

statusCallback(

"Exact replicated model found: "
.. source.Name,

COLORS.green
)

elseif category == "Star" then

statusCallback(

"Star model not found yet • blocky reference fallback will be used.",

COLORS.orange
)

else

statusCallback(

"Model not found yet • it may replicate after the game finishes loading.",

COLORS.orange
)
end
end

local function rebuildList(
category
)

currentCategory =
category

currentItem =
nil

clearItemButtons()

setTabVisual(
category
)

selectedLabel.Text =
"Nothing selected"

selectedMeta.Text =
category == "Pets"

and "Equip a pet then click to place it in your pen."

or "Choose an item above."

statusCallback(
"",
COLORS.muted
)

for index, item in ipairs(
ITEMS[category]
) do

local b =
textButton(

Scroll,

item.name,

UDim2.new(),

UDim2.new(),

false
)

b.LayoutOrder =
index

b.TextXAlignment =
Enum.TextXAlignment.Left

b.Text =
" "
.. item.name

b.TextSize =
10

table.insert(
itemButtons,
b
)

b.MouseButton1Click:
Connect(function()

updateSelection(
category,
item
)

for _, other in ipairs(
itemButtons
) do

other.BackgroundColor3 =
COLORS.card2
end

b.BackgroundColor3 =
Color3.fromRGB(
78,
45,
107
)
end)
end
end

tabEggs.MouseButton1Click:
Connect(function()

rebuildList(
"Eggs"
)
end)

tabPets.MouseButton1Click:
Connect(function()

rebuildList(
"Pets"
)
end)

tabStar.MouseButton1Click:
Connect(function()

rebuildList(
"Star"
)
end)

spawnButton.MouseButton1Click:
Connect(function()

if not currentItem then

statusCallback(
"Select an item first.",
COLORS.orange
)

return
end

statusCallback(

"Adding "
.. currentItem.name
.. "...",

COLORS.muted
)

local ok,
message =
giveItem(
currentCategory,
currentItem
)

statusCallback(

message,

ok
and COLORS.green
or COLORS.red
)
end)

rebuildList(
"Eggs"
)

P.CharacterAdded:
Connect(function()

for _, v in ipairs(
HeldFolder:GetChildren()
) do

v:Destroy()
end
end)

ReplicatedStorage.DescendantAdded:
Connect(function()

sourceCache = {}
end)

print(
"[SAE] Final inventory panel loaded: 12 eggs, 12 pets and Star."
)
