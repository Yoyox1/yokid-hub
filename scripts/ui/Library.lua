local RunService = game:GetService("RunService")
local StatsService = game:GetService("Stats")

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local Library = {Version = "1.0", Windows = {}}
Library.__index = Library

local IsMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

local Profiles = {
	Mobile = {
		HeaderH = 58, SideWide = 156, SideNarrow = 68, FootH = 30, RH = 2,
		BaseW = 680, BaseH = 380, CompactW = 520, MinW = 380, MinH = 300, Margin = 12,
		SwitchW = 50, SwitchH = 28, Knob = 22,
		Thumb = 20, ThumbHover = 20, ThumbDown = 26, HitPad = 4, HitY = 38, HitH = 36,
		KeyW = 168, KeyH = 38, BtnH = 48, HintSize = 24,
		Dot = 18, DotsW = 70, DotsX = -14,
		TitleSize = 16, TitleY = 8, TitleH = 24, DescY = 32,
		FindX = -92, FindSize = 36,
		NarrowW = 620, TitleGap = -320, TitleGapNarrow = -146,
		ScaleMin = 70, ScaleMax = 130,
	},
	PC = {
		HeaderH = 66, SideWide = 204, SideNarrow = 70, FootH = 32, RH = 0,
		BaseW = 940, BaseH = 560, CompactW = 580, MinW = 440, MinH = 340, Margin = 16,
		SwitchW = 46, SwitchH = 26, Knob = 20,
		Thumb = 14, ThumbHover = 17, ThumbDown = 18, HitPad = 6, HitY = 42, HitH = 30,
		KeyW = 164, KeyH = 36, BtnH = 46, HintSize = 20,
		Dot = 12, DotsW = 52, DotsX = -18,
		TitleSize = 18, TitleY = 12, TitleH = 26, DescY = 40,
		FindX = -80, FindSize = 34,
		NarrowW = 760, TitleGap = -280, TitleGapNarrow = -140,
		ScaleMin = 50, ScaleMax = 150,
	},
}

local Profile = IsMobile and Profiles.Mobile or Profiles.PC
Library.IsMobile = IsMobile
Library.Device = IsMobile and "Mobile" or "PC"

local HeaderH, SideWide, SideNarrow, FootH = Profile.HeaderH, Profile.SideWide, Profile.SideNarrow, Profile.FootH
local RH = Profile.RH
local BaseW, BaseH, CompactW = Profile.BaseW, Profile.BaseH, Profile.CompactW
local MinW, MinH = Profile.MinW, Profile.MinH
local TipW = 230

local Tone = {
	White = Color3.new(1, 1, 1),
	Black = Color3.new(0, 0, 0),
	Gray = Color3.fromRGB(148, 155, 170),
	Light = Color3.fromRGB(214, 218, 226),
	Muted = Color3.fromRGB(107, 114, 128),
	Emerald = Color3.fromRGB(16, 185, 129),
	Off = Color3.fromRGB(55, 60, 72),
}

local function PickFont(Name, Fallback)
	local Ok, Value = pcall(function() return Enum.Font[Name] end)
	return Ok and Value or Fallback
end

local Fonts = {
	Regular = Enum.Font.GothamMedium,
	Medium = Enum.Font.GothamBold,
	Bold = Enum.Font.GothamBlack,
	Black = Enum.Font.GothamBlack,
	Tech = PickFont("Michroma", Enum.Font.GothamBlack),
	Mono = PickFont("RobotoMono", Enum.Font.Code),
}

local Themes = {
	Halloween = {Accent = Color3.fromRGB(249, 115, 22), Accent2 = Color3.fromRGB(168, 85, 247), Bg = Color3.fromRGB(12, 10, 18), Card = Color3.fromRGB(23, 20, 33), Panel = Color3.fromRGB(32, 27, 46), Emoji = "🎃"},
	Christmas = {Accent = Color3.fromRGB(74, 222, 128), Accent2 = Color3.fromRGB(248, 113, 113), Bg = Color3.fromRGB(6, 16, 12), Card = Color3.fromRGB(13, 28, 22), Panel = Color3.fromRGB(19, 40, 31), Emoji = "🎄"},
	Hacker = {Accent = Color3.fromRGB(16, 230, 130), Accent2 = Color3.fromRGB(6, 182, 212), Bg = Color3.fromRGB(3, 12, 9), Card = Color3.fromRGB(9, 24, 19), Panel = Color3.fromRGB(14, 34, 27), Emoji = "👾"},
	Classic = {Accent = Color3.fromRGB(59, 130, 246), Accent2 = Color3.fromRGB(34, 211, 238), Bg = Color3.fromRGB(11, 17, 32), Card = Color3.fromRGB(18, 26, 43), Panel = Color3.fromRGB(25, 36, 60), Emoji = "✨"},
	Purple = {Accent = Color3.fromRGB(168, 85, 247), Accent2 = Color3.fromRGB(236, 72, 153), Bg = Color3.fromRGB(14, 9, 24), Card = Color3.fromRGB(26, 18, 42), Panel = Color3.fromRGB(36, 26, 58), Emoji = "🔮"},
	Crimson = {Accent = Color3.fromRGB(239, 68, 68), Accent2 = Color3.fromRGB(249, 115, 22), Bg = Color3.fromRGB(16, 8, 9), Card = Color3.fromRGB(30, 16, 18), Panel = Color3.fromRGB(42, 22, 25), Emoji = "🔥"},
}
local ThemeOrder = {"Halloween", "Christmas", "Hacker", "Classic", "Purple", "Crimson"}
local Backgrounds = {"Theme Default (Glass)", "Ultra Dark Minimal", "Cyber Grid Overlay"}

Library.Themes = Themes
Library.ThemeOrder = ThemeOrder

Library.LangOrder = {"English", "ไทย"}

Library.Locales = {
	English = {},
	["ไทย"] = {
		["Home"] = "หน้าหลัก",
		["Settings"] = "ตั้งค่า",
		["Home Dashboard"] = "แดชบอร์ดหลัก",
		["Overview of system performance and active modules"] = "ภาพรวมประสิทธิภาพและโมดูลที่ทำงานอยู่",
		["Customize your layout, color themes, performance, and overlay preferences"] = "ปรับแต่งเลย์เอาต์ ธีมสี ประสิทธิภาพ และการแสดงผล",
		["Appearance"] = "หน้าตา",
		["Change how the hub looks"] = "เปลี่ยนรูปลักษณ์ของฮับ",
		["Theme"] = "ธีม",
		["Pick a color theme for the whole hub"] = "เลือกธีมสีให้ทั้งฮับ",
		["Background Style"] = "สไตล์พื้นหลัง",
		["Glass, ultra dark or cyber grid backdrop"] = "พื้นหลังกระจก มืดสนิท หรือกริดไซเบอร์",
		["Theme Default (Glass)"] = "ตามธีม (กระจก)",
		["Ultra Dark Minimal"] = "มืดสนิทเรียบๆ",
		["Cyber Grid Overlay"] = "กริดไซเบอร์",
		["Language"] = "ภาษา",
		["Pick the language of the whole hub"] = "เลือกภาษาของทั้งฮับ",
		["Controls"] = "การควบคุม",
		["Shortcuts for the hub"] = "ปุ่มลัดของฮับ",
		["Toggle UI Key"] = "ปุ่มเปิด/ปิด UI",
		["Tap the box, then press any key to open or close the hub"] = "แตะช่อง แล้วกดปุ่มที่ต้องการเพื่อเปิด/ปิดฮับ",
		["Reset Toggle Key"] = "รีเซ็ตปุ่มลัด",
		["Set the toggle key back to Right Ctrl"] = "ตั้งปุ่มลัดกลับเป็น Right Ctrl",
		["Hub"] = "ฮับ",
		["Community and unloading"] = "คอมมูนิตี้และการถอนฮับ",
		["Copy Discord Invite"] = "คัดลอกลิงก์ Discord",
		["Copy the Discord invite link to your clipboard"] = "คัดลอกลิงก์เชิญ Discord ไปยังคลิปบอร์ด",
		["Discord link copied"] = "คัดลอกลิงก์ Discord แล้ว",
		["Clipboard not supported"] = "ตัวรันนี้ไม่รองรับคลิปบอร์ด",
		["No Discord link set"] = "ยังไม่ได้ตั้งลิงก์ Discord",
		["Unload UI"] = "ถอน UI",
		["Remove the hub from the game completely"] = "ลบฮับออกจากเกมทั้งหมด",
		["PRESS KEY"] = "กดปุ่มเลย",
		["System Options"] = "ตัวเลือกระบบ",
		["Performance and behavior"] = "ประสิทธิภาพและการทำงาน",
		["Notifications Enabled"] = "เปิดการแจ้งเตือน",
		["Show small popups when something changes"] = "แสดงป๊อปอัปเล็กๆ เมื่อมีการเปลี่ยนแปลง",
		["Smooth Scrolling"] = "เลื่อนแบบนุ่มนวล",
		["Soft bounce when you scroll to the edge"] = "เด้งนิ่มๆ เมื่อเลื่อนสุดขอบ",
		["FPS Limit"] = "จำกัด FPS",
		["Cap the frame rate of the game"] = "จำกัดเฟรมเรตของเกม",
		["UI Scale"] = "ขนาด UI",
		["Make the whole hub bigger or smaller"] = "ขยายหรือย่อฮับทั้งหมด",
		["Config"] = "คอนฟิก",
		["Save and load your settings for this map"] = "บันทึกและโหลดการตั้งค่าของแมพนี้",
		["Map Config"] = "คอนฟิกแมพ",
		["Auto Save"] = "บันทึกอัตโนมัติ",
		["Save changes automatically a moment after you change them"] = "บันทึกให้เองหลังเปลี่ยนค่าเล็กน้อย",
		["Save Config"] = "บันทึกคอนฟิก",
		["Load Config"] = "โหลดคอนฟิก",
		["Config saved"] = "บันทึกคอนฟิกแล้ว",
		["Config loaded"] = "โหลดคอนฟิกแล้ว",
		["No config found"] = "ไม่พบคอนฟิก",
		["File system not supported"] = "ตัวรันนี้ไม่รองรับไฟล์",
		["Fps"] = "FPS",
		["Ping"] = "ปิง",
		["Session"] = "เวลาเล่น",
		["Active"] = "ทำงานอยู่",
		["Search features..."] = "ค้นหาฟีเจอร์...",
		["Enter to open  ·  Esc to close"] = "Enter เพื่อเปิด  ·  Esc เพื่อปิด",
		["No results"] = "ไม่พบผลลัพธ์",
		["Page"] = "หน้า",
		["No matches"] = "ไม่พบรายการ",
		["Select option"] = "เลือกตัวเลือก",
		["Select options"] = "เลือกหลายตัวเลือก",
		["Search options"] = "ค้นหาตัวเลือก",
		["Type here..."] = "พิมพ์ที่นี่...",
		["ON"] = "เปิด",
		["OFF"] = "ปิด",
		["Theme switched to"] = "เปลี่ยนธีมเป็น",
		["UI Hidden"] = "ซ่อน UI แล้ว",
		["Toggle key"] = "ปุ่มลัด",
		["Fullscreen"] = "เต็มจอ",
		["Windowed"] = "แบบหน้าต่าง",
		["Yokid loaded"] = "โหลด Yokid แล้ว",
		["Tap to Toggle UI"] = "แตะเพื่อเปิด/ปิด UI",
		["Tap the top button to reopen"] = "แตะปุ่มด้านบนเพื่อเปิดใหม่",
		["{key} to Toggle UI"] = "กด {key} เพื่อเปิด/ปิด UI",
		["Yokid - New UI"] = "Yokid - UI ใหม่",
		["Main"] = "หลัก",
		["Main Features"] = "ฟีเจอร์หลัก",
		["Player tools, automation and visual options"] = "เครื่องมือผู้เล่น ระบบออโต้ และตัวเลือกภาพ",
		["Welcome"] = "ยินดีต้อนรับ",
		["Your settings save automatically for each player and map."] = "การตั้งค่าบันทึกให้อัตโนมัติแยกตามผู้เล่นและแมพ",
		["Player"] = "ผู้เล่น",
		["Movement and character options"] = "ตัวเลือกการเคลื่อนไหวและตัวละคร",
		["Custom Movement"] = "ปรับการเคลื่อนไหว",
		["Apply your own walk speed and jump power"] = "ใช้ความเร็วเดินและแรงกระโดดที่ตั้งเอง",
		["Walk Speed"] = "ความเร็วเดิน",
		["How fast your character walks"] = "ตัวละครเดินเร็วแค่ไหน",
		["Jump Power"] = "แรงกระโดด",
		["How high your character jumps"] = "ตัวละครกระโดดสูงแค่ไหน",
		["Infinite Jump"] = "กระโดดไม่จำกัด",
		["Jump again while in the air"] = "กระโดดซ้ำได้ตอนอยู่กลางอากาศ",
		["Noclip"] = "ทะลุกำแพง",
		["Walk through walls and objects"] = "เดินทะลุกำแพงและวัตถุ",
		["Anti AFK"] = "กันหลุด AFK",
		["Stay in the game without being kicked"] = "อยู่ในเกมได้โดยไม่โดนเตะ",
		["Rejoin"] = "เข้าเซิร์ฟใหม่",
		["Rejoin this server"] = "กลับเข้าเซิร์ฟเวอร์นี้ใหม่",
		["Automation"] = "ระบบออโต้",
		["Run your own code in a loop"] = "รันโค้ดของคุณเองวนซ้ำ",
		["Auto Farm"] = "ฟาร์มอัตโนมัติ",
		["Runs your farm code again and again"] = "รันโค้ดฟาร์มของคุณซ้ำๆ",
		["Farm Delay"] = "หน่วงเวลาฟาร์ม",
		["Seconds to wait between each loop"] = "จำนวนวินาทีที่รอระหว่างแต่ละรอบ",
		["Target Name"] = "ชื่อเป้าหมาย",
		["Name of the thing you want to farm"] = "ชื่อสิ่งที่ต้องการฟาร์ม",
		["Farm Mode"] = "โหมดฟาร์ม",
		["Pick how targets are chosen"] = "เลือกวิธีเลือกเป้าหมาย",
		["Nearest"] = "ใกล้สุด",
		["Strongest"] = "แข็งแกร่งสุด",
		["Random"] = "สุ่ม",
		["Visual"] = "ภาพ",
		["Lighting and color options"] = "ตัวเลือกแสงและสี",
		["Fullbright"] = "สว่างสุด",
		["Light up dark places"] = "ทำให้ที่มืดสว่างขึ้น",
		["Ambient Color"] = "สีแสงโดยรอบ",
		["Color used while Fullbright is on"] = "สีที่ใช้ตอนเปิดสว่างสุด",
		["Walk speed or jump power changed"] = "ปรับการเคลื่อนไหวแล้ว",
		["s"] = "วิ",
		["Section"] = "หมวด",
		["A group of controls"] = "กลุ่มของตัวควบคุม",
		["Toggle"] = "สวิตช์",
		["Simple on and off switch"] = "สวิตช์เปิดปิดง่ายๆ",
		["Slider"] = "แถบเลื่อน",
		["Drag to pick a number"] = "ลากเพื่อเลือกตัวเลข",
		["Dropdown"] = "ดรอปดาวน์",
		["Pick one option from the list"] = "เลือกหนึ่งตัวเลือกจากรายการ",
		["Dropdown Mutil"] = "ดรอปดาวน์หลายตัวเลือก",
		["Button"] = "ปุ่ม",
		["Runs an action when pressed"] = "ทำงานเมื่อกดปุ่ม",
		["Button pressed"] = "กดปุ่มแล้ว",
		["Keybind"] = "ปุ่มลัด",
		["Pick any key you like"] = "เลือกปุ่มที่ชอบได้เลย",
		["Colorpicker"] = "เลือกสี",
		["Tap the swatch to pick a color"] = "แตะช่องสีเพื่อเลือกสี",
		["Input"] = "ช่องกรอก",
		["Type something and press Enter"] = "พิมพ์อะไรสักอย่างแล้วกด Enter",
		["Paragraph"] = "ย่อหน้า",
		["Paragraphs show a title and text, and they follow the selected language too."] = "ย่อหน้าแสดงหัวข้อและข้อความ และเปลี่ยนตามภาษาที่เลือกด้วย",
	},
}

local function Clean(Name)
	return (tostring(Name):gsub('[\\/:*?"<>|]', "_"))
end

local function HasFiles()
	return type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
end

local function Encode(Value)
	local Kind = typeof(Value)
	if Kind == "Color3" then
		return {__t = "c", r = math.floor(Value.R * 255 + 0.5), g = math.floor(Value.G * 255 + 0.5), b = math.floor(Value.B * 255 + 0.5)}
	elseif Kind == "EnumItem" then
		return {__t = "k", n = Value.Name}
	elseif Kind == "table" then
		local Out = {}
		for Index, Item in ipairs(Value) do Out[Index] = Encode(Item) end
		return Out
	end
	return Value
end

local function Decode(Value)
	if type(Value) == "table" then
		if Value.__t == "c" then
			return Color3.fromRGB(Value.r or 0, Value.g or 0, Value.b or 0)
		elseif Value.__t == "k" then
			local Ok, Key = pcall(function() return Enum.KeyCode[Value.n] end)
			return Ok and Key or nil
		end
		local Out = {}
		for Index, Item in ipairs(Value) do Out[Index] = Decode(Item) end
		return Out
	end
	return Value
end

local function HexToColor(Text)
	local Hex = tostring(Text):gsub("[#%s]", "")
	if #Hex == 3 then Hex = Hex:gsub(".", "%0%0") end
	if #Hex == 6 and not Hex:find("%X") then
		return Color3.fromRGB(tonumber(Hex:sub(1, 2), 16), tonumber(Hex:sub(3, 4), 16), tonumber(Hex:sub(5, 6), 16))
	end
	return nil
end

local function ColorToHex(Color)
	return string.format("#%02X%02X%02X", math.floor(Color.R * 255 + 0.5), math.floor(Color.G * 255 + 0.5), math.floor(Color.B * 255 + 0.5))
end

local function Class(Base)
	local Cls = {}
	Cls.__index = Cls
	return Base and setmetatable(Cls, {__index = Base}) or Cls
end

local Util = {}
local OrderCount = setmetatable({}, {__mode = "k"})

function Util.New(ClassName, Props, Parent)
	local Inst = Instance.new(ClassName)
	for Key, Value in pairs(Props) do Inst[Key] = Value end
	Inst.Parent = Parent
	return Inst
end

function Util.Next(Parent)
	OrderCount[Parent] = (OrderCount[Parent] or 0) + 1
	return OrderCount[Parent]
end

function Util.Corner(Parent, Radius)
	return Util.New("UICorner", {CornerRadius = UDim.new(0, Radius)}, Parent)
end

function Util.Stroke(Parent, Color, Transparency, Thickness)
	return Util.New("UIStroke", {Color = Color, Transparency = Transparency, Thickness = Thickness or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, Parent)
end

function Util.Pad(Parent, Left, Top, Right, Bottom)
	return Util.New("UIPadding", {PaddingLeft = UDim.new(0, Left), PaddingTop = UDim.new(0, Top), PaddingRight = UDim.new(0, Right), PaddingBottom = UDim.new(0, Bottom)}, Parent)
end

function Util.List(Parent, Gap)
	return Util.New("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, Gap or 0)}, Parent)
end

function Util.Flow(Parent, Gap, Align)
	return Util.New("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Align or Enum.VerticalAlignment.Center, Padding = UDim.new(0, Gap or 0),
	}, Parent)
end

function Util.Label(Parent, Text, Size, Font, Color, Extra)
	if IsMobile then Size = math.max(Size, 11) end
	local Obj = Util.New("TextLabel", {
		BackgroundTransparency = 1, BorderSizePixel = 0, Text = Text, TextSize = Size, Font = Font, TextColor3 = Color,
		TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, Size = UDim2.new(1, 0, 0, Size + 4),
	}, nil)
	for Key, Value in pairs(Extra or {}) do Obj[Key] = Value end
	Obj.Parent = Parent
	return Obj
end

function Util.Tween(Inst, Props, Instant, Time, Style, Dir)
	if Instant then
		for Key, Value in pairs(Props) do Inst[Key] = Value end
	else
		TS:Create(Inst, TweenInfo.new(Time or 0.25, Style or Enum.EasingStyle.Quad, Dir or Enum.EasingDirection.Out), Props):Play()
	end
end

function Util.Pop(Inst, Props, Time)
	Util.Tween(Inst, Props, false, Time or 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

function Util.ScaleOf(Inst)
	local Obj = Inst:FindFirstChildOfClass("UIScale")
	return Obj and Obj.Scale or 1
end

function Util.IsPress(Input)
	return Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch
end

function Util.Matches(Held, Input)
	local Mouse = Held.UserInputType == Enum.UserInputType.MouseButton1
	return Input == Held or (Mouse and Input.UserInputType == Enum.UserInputType.MouseMovement)
end

function Util.Released(Held, Input)
	local Mouse = Held.UserInputType == Enum.UserInputType.MouseButton1 and Input.UserInputType == Enum.UserInputType.MouseButton1
	return Input == Held or Mouse
end

local Rng = Random.new()

local Maid = Class()

function Maid.new()
	return setmetatable({Items = {}}, Maid)
end

function Maid:Add(Conn)
	table.insert(self.Items, Conn)
	return Conn
end

function Maid:Clean()
	for _, Conn in ipairs(self.Items) do
		pcall(function() Conn:Disconnect() end)
	end
	table.clear(self.Items)
end

local Builder = Class()

function Builder.new(Root, Scale)
	return setmetatable({Root = Root, K = Scale, Fills = {}, Strokes = {}}, Builder)
end

function Builder:Props(Cx, Cy, W, H, Rot)
	local K = self.K
	return {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(Cx * K, Cy * K),
		Size = UDim2.fromOffset(W * K, H * K), Rotation = Rot or 0, BorderSizePixel = 0,
	}
end

function Builder:Bar(Cx, Cy, Len, Th, Rot)
	local Obj = Util.New("Frame", self:Props(Cx, Cy, Len, Th, Rot), self.Root)
	Util.Corner(Obj, Th * self.K / 2)
	table.insert(self.Fills, Obj)
end

function Builder:Dot(Cx, Cy, D)
	local Obj = Util.New("Frame", self:Props(Cx, Cy, D, D, 0), self.Root)
	Util.Corner(Obj, D * self.K / 2)
	table.insert(self.Fills, Obj)
end

function Builder:Block(Cx, Cy, W, H, R, Rot)
	local Obj = Util.New("Frame", self:Props(Cx, Cy, W, H, Rot), self.Root)
	Util.Corner(Obj, R * self.K)
	table.insert(self.Fills, Obj)
end

function Builder:Ring(Cx, Cy, W, H, R, Th, Rot)
	local Props = self:Props(Cx, Cy, W, H, Rot)
	Props.BackgroundTransparency = 1
	local Obj = Util.New("Frame", Props, self.Root)
	Util.Corner(Obj, R * self.K)
	table.insert(self.Strokes, Util.Stroke(Obj, Tone.White, 0, Th * self.K))
end

local Icon = Class()

Icon.Shapes = {
	Search = function(B)
		B:Ring(6.75, 6.75, 9.5, 9.5, 4.75, 1.7)
		B:Bar(12.4, 12.4, 5, 1.8, 45)
	end,
	Chevron = function(B)
		B:Bar(5.7, 8, 6.4, 1.8, 45)
		B:Bar(10.3, 8, 6.4, 1.8, -45)
	end,
	Check = function(B)
		B:Bar(5.4, 9.6, 4.4, 1.9, 45)
		B:Bar(9.6, 8.4, 8.6, 1.9, -45)
	end,
	Home = function(B)
		B:Ring(8, 10.5, 9, 6, 1.5, 1.6)
		B:Bar(5.4, 5.8, 6.4, 1.7, -45)
		B:Bar(10.6, 5.8, 6.4, 1.7, 45)
	end,
	Bot = function(B)
		B:Ring(8, 9.5, 11, 8, 3, 1.6)
		B:Bar(8, 3.6, 3, 1.6, 90)
		B:Dot(5.9, 9.4, 2)
		B:Dot(10.1, 9.4, 2)
	end,
	Castle = function(B)
		B:Ring(8, 10, 10, 7, 1.5, 1.6)
		B:Block(4, 5, 2, 3, 0.5, 0)
		B:Block(8, 5, 2, 3, 0.5, 0)
		B:Block(12, 5, 2, 3, 0.5, 0)
		B:Block(8, 11.7, 2.2, 3.4, 1, 0)
	end,
	Target = function(B)
		B:Ring(8, 8, 12, 12, 6, 1.6)
		B:Ring(8, 8, 6, 6, 3, 1.5)
		B:Dot(8, 8, 1.8)
	end,
	Gear = function(B)
		B:Ring(8, 8, 8, 8, 4, 1.8)
		B:Bar(8, 2.6, 3, 2, 90)
		B:Bar(8, 13.4, 3, 2, 90)
		B:Bar(2.6, 8, 3, 2, 0)
		B:Bar(13.4, 8, 3, 2, 0)
		B:Bar(4, 4, 3, 2, 45)
		B:Bar(12, 4, 3, 2, -45)
		B:Bar(4, 12, 3, 2, -45)
		B:Bar(12, 12, 3, 2, 45)
	end,
	Palette = function(B)
		B:Ring(8, 8, 12, 12, 6, 1.6)
		B:Dot(6, 6.8, 2)
		B:Dot(9.6, 5.4, 2)
		B:Dot(11.2, 9, 2)
	end,
	Grid = function(B)
		B:Ring(4.75, 4.75, 4.5, 4.5, 1.2, 1.5)
		B:Ring(11.25, 4.75, 4.5, 4.5, 1.2, 1.5)
		B:Ring(4.75, 11.25, 4.5, 4.5, 1.2, 1.5)
		B:Ring(11.25, 11.25, 4.5, 4.5, 1.2, 1.5)
	end,
	Sparkle = function(B)
		B:Bar(8, 8, 12, 1.5, 0)
		B:Bar(8, 8, 12, 1.5, 90)
		B:Bar(8, 8, 7, 1.3, 45)
		B:Bar(8, 8, 7, 1.3, -45)
	end,
	Grip = function(B)
		B:Block(12, 4, 2.4, 2.4, 0.7, 0)
		B:Block(12, 8, 2.4, 2.4, 0.7, 0)
		B:Block(12, 12, 2.4, 2.4, 0.7, 0)
		B:Block(8, 8, 2.4, 2.4, 0.7, 0)
		B:Block(8, 12, 2.4, 2.4, 0.7, 0)
		B:Block(4, 12, 2.4, 2.4, 0.7, 0)
	end,
	Yokid = function(B)
		B:Bar(5.6, 5.4, 7.4, 2.4, 52)
		B:Bar(10.4, 5.4, 7.4, 2.4, -52)
		B:Bar(8, 11.4, 2.4, 6, 0)
		B:Dot(8, 14.6, 2.2)
	end,
	Mark = function(B)
		B:Ring(8, 8, 10, 10, 2.2, 2, 45)
		B:Block(8, 8, 3.6, 3.6, 0.8, 45)
	end,
	Section = function(B)
		B:Block(8, 8, 13, 11, 1.5, 0)
		B:Bar(8, 6, 10, 1.2, 0)
	end,
	Slider = function(B)
		B:Bar(8, 8, 12, 1.6, 0)
		B:Dot(10.5, 8, 2.8)
	end,
	Toggle = function(B)
		B:Block(8, 8, 13, 7.5, 3.75, 0)
		B:Dot(5.5, 8, 2.3)
	end,
	Dropdown = function(B)
		B:Block(8, 8, 13, 10, 1.5, 0)
		B:Bar(11, 8, 4, 1.5, 45)
		B:Bar(12.5, 8, 4, 1.5, -45)
	end,
	Keyboard = function(B)
		B:Block(8, 8, 13, 9, 1.5, 0)
		B:Bar(8, 5.8, 10, 1.1, 0)
		B:Bar(8, 8.3, 10, 1.1, 0)
		B:Bar(8, 10.8, 7, 1.1, 0)
	end,
	Globe = function(B)
		B:Ring(8, 8, 12, 12, 6, 1.5)
		B:Ring(8, 8, 5, 12, 2.5, 1.3)
		B:Bar(8, 8, 12, 1.3, 0)
	end,
	Save = function(B)
		B:Ring(8, 8, 12, 12, 2.5, 1.6)
		B:Bar(8, 5, 6, 1.5, 0)
		B:Block(8, 11, 6, 3.5, 0.8, 0)
	end,
	Play = function(B)
		B:Bar(7.5, 8, 7.5, 1.8, 60)
		B:Bar(7.5, 8, 7.5, 1.8, -60)
		B:Bar(6.5, 8, 5, 1.8, 0)
	end,
	Pause = function(B)
		B:Bar(6.2, 8, 8, 1.8, 90)
		B:Bar(9.8, 8, 8, 1.8, 90)
	end,
	Close = function(B)
		B:Bar(8, 8, 9.5, 1.8, 45)
		B:Bar(8, 8, 9.5, 1.8, -45)
	end,
	User = function(B)
		B:Dot(8, 6.2, 2.5)
		B:Ring(8, 13, 10, 6, 3, 1.6)
	end,
	Info = function(B)
		B:Ring(8, 8, 12, 12, 6, 1.6)
		B:Dot(8, 5.2, 1.2)
		B:Bar(8, 10, 4.5, 1.6, 90)
	end,
	Plus = function(B)
		B:Bar(8, 8, 10, 1.8, 0)
		B:Bar(8, 8, 10, 1.8, 90)
	end,
	Trash = function(B)
		B:Bar(8, 4.5, 8, 1.5, 0)
		B:Block(8, 9.5, 9, 7.5, 1.5, 0)
		B:Bar(6.5, 9.5, 4, 1.2, 90)
		B:Bar(9.5, 9.5, 4, 1.2, 90)
	end
}

function Icon.new(Name, Parent, Px)
	local Size = Px or 16
	local Root = Util.New("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromOffset(Size, Size)}, nil)
	local Build = Builder.new(Root, Size / 16)
	local Draw = Icon.Shapes[Name] or Icon.Shapes.Mark
	Draw(Build)
	local Self = setmetatable({Root = Root, Fills = Build.Fills, Strokes = Build.Strokes}, Icon)
	Self:Tint(Tone.Gray, true)
	Root.Parent = Parent
	return Self
end

function Icon:Place(Anchor, Position)
	self.Root.AnchorPoint = Anchor
	self.Root.Position = Position
	return self
end

function Icon:Tint(Color, Instant)
	for _, Obj in ipairs(self.Fills) do Util.Tween(Obj, {BackgroundColor3 = Color}, Instant) end
	for _, Obj in ipairs(self.Strokes) do Util.Tween(Obj, {Color = Color}, Instant) end
end

local Draggable = Class()

function Draggable.new(Bag, Handle, Target, OnClick, Clamp)
	local Self = setmetatable({Handle = Handle, Target = Target, OnClick = OnClick, Clamp = Clamp}, Draggable)
	Bag:Add(Handle.InputBegan:Connect(function(Input) Self:Begin(Input) end))
	Bag:Add(UIS.InputChanged:Connect(function(Input) Self:Update(Input) end))
	Bag:Add(UIS.InputEnded:Connect(function(Input) Self:Finish(Input) end))
	return Self
end

function Draggable:Begin(Input)
	if Util.IsPress(Input) and not self.Input then
		self.Input, self.Moved, self.Start, self.Origin = Input, false, Input.Position, self.Target.Position
	end
end

function Draggable:Update(Input)
	if self.Input and Util.Matches(self.Input, Input) then
		local Delta = Input.Position - self.Start
		self.Moved = self.Moved or Delta.Magnitude > 4
		if self.Moved then
			local Scale = Util.ScaleOf(self.Target)
			self.Target.Position = UDim2.new(self.Origin.X.Scale, self.Origin.X.Offset + Delta.X / Scale, self.Origin.Y.Scale, self.Origin.Y.Offset + Delta.Y / Scale)
			if self.Clamp then self.Clamp() end
		end
	end
end

function Draggable:Finish(Input)
	if self.Input and Util.Released(self.Input, Input) then
		local Clicked = not self.Moved
		self.Input = nil
		if Clicked and self.OnClick then self.OnClick() end
	end
end

local Resizer = Class()

function Resizer.new(Window, Handle)
	local Self = setmetatable({Window = Window}, Resizer)
	Window.Maid:Add(Handle.InputBegan:Connect(function(Input) Self:Begin(Input) end))
	Window.Maid:Add(UIS.InputChanged:Connect(function(Input) Self:Update(Input) end))
	Window.Maid:Add(UIS.InputEnded:Connect(function(Input) Self:Finish(Input) end))
	return Self
end

function Resizer:Begin(Input)
	local Window = self.Window
	if Util.IsPress(Input) and not self.Input and not Window.Minimized and not Window.Maximized then
		Window:CloseOverlays()
		self.Input, self.Start, self.Origin = Input, Input.Position, Window.Root.Position
		self.StartW, self.StartH = Window.SizeW, Window.SizeH
	end
end

function Resizer:Update(Input)
	if self.Input and Util.Matches(self.Input, Input) then
		local Delta = Input.Position - self.Start
		local Scale = self.Window.BaseScale
		self.Window:ResizeTo(self.StartW + Delta.X / Scale, self.StartH + Delta.Y / Scale, self.Origin, self.StartW, self.StartH)
	end
end

function Resizer:Finish(Input)
	if self.Input and Util.Released(self.Input, Input) then
		self.Input = nil
	end
end

local Notifier = Class()

function Notifier.new(Window)
	local Self = setmetatable({Window = Window, Id = 0}, Notifier)
	Self.Frame = Util.New("Frame", {
		AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -20, 0, -70), Size = UDim2.fromOffset(240, 42),
		BorderSizePixel = 0, ZIndex = 200,
	}, Window.Gui)
	Util.Corner(Self.Frame, 12)
	Self.Stroke = Util.Stroke(Self.Frame, Window.Theme.Accent, 0.8)
	Self.Bar = Util.New("Frame", {BorderSizePixel = 0, Size = UDim2.new(0, 3, 1, -16), Position = UDim2.fromOffset(10, 8)}, Self.Frame)
	Util.Corner(Self.Bar, 2)
	Self.Text = Util.Label(Self.Frame, "", 12, Fonts.Medium, Tone.White, {Position = UDim2.fromOffset(24, 0), Size = UDim2.new(1, -32, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd})
	Window:Bind(function(Theme, Instant)
		Util.Tween(Self.Frame, {BackgroundColor3 = Theme.Card:Lerp(Tone.Black, 0.3)}, Instant)
		Util.Tween(Self.Stroke, {Color = Theme.Accent}, Instant)
		Util.Tween(Self.Bar, {BackgroundColor3 = Theme.Accent}, Instant)
	end)
	return Self
end

function Notifier:Show(Message)
	self.Id = self.Id + 1
	local Id = self.Id
	self.Text.Text = Message
	Util.Pop(self.Frame, {Position = UDim2.new(1, -20, 0, 20)}, 0.5)
	task.delay(2.2, function()
		if Id == self.Id then
			Util.Tween(self.Frame, {Position = UDim2.new(1, -20, 0, -70)}, false, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
		end
	end)
end

local Element = Class()

function Element:Init(Section, Options, Valued)
	self.Section = Section
	self.Window = Section.Window
	self.Name = Options.Name or "Element"
	self.Callback = Options.Callback
	self.Desc = Options.Desc
	self.Scope = Options.Scope or Section.Scope or "map"
	self.Persist = Options.Persist ~= false
	self.Flag = Options.Flag or (Valued and self.Name or nil)
	self.Window:Register(self.Name, Section.Tab)
	if self.Flag then self.Window.Elements[self.Flag] = self end
end

function Element:Commit(Value, Silent)
	if self.Flag then self.Window.Flags[self.Flag] = Value end
	if not Silent then
		if self.Callback then
			task.spawn(function()
				local Ok, Err = pcall(self.Callback, Value)
				if not Ok then warn("[Yokid] " .. tostring(self.Name) .. ": " .. tostring(Err)) end
			end)
		end
		if self.Flag then self.Window:QueueSave(self.Scope) end
	end
end

local Toggle = Class(Element)

function Toggle.new(Section, Options)
	local Self = setmetatable({}, Toggle)
	Self:Init(Section, Options, true)
	Self.State = Options.Default == true
	Self:Build()
	Self:Commit(Self.State, true)
	return Self
end

function Toggle:Build()
	local Row = self.Section:Card(52, true)
	self.Window:NameTag(Row, self.Name, self.Desc, UDim2.new(0, 16, 0.5, 0), 260, nil, nil, nil, 76)
	self.Switch = Util.New("Frame", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0), Size = UDim2.fromOffset(Profile.SwitchW, Profile.SwitchH), BorderSizePixel = 0}, Row)
	Util.Corner(self.Switch, Profile.SwitchH / 2)
	self.Knob = Util.New("Frame", {AnchorPoint = Vector2.new(0, 0.5), Size = UDim2.fromOffset(Profile.Knob, Profile.Knob), BackgroundColor3 = Tone.White, BorderSizePixel = 0}, self.Switch)
	Util.Corner(self.Knob, Profile.Knob / 2)
	self.Window:Bind(function(_, Instant) self:Paint(Instant) end)
	Row.MouseEnter:Connect(function() Util.Tween(Row, {BackgroundTransparency = 0.3}, false, 0.15) end)
	Row.MouseLeave:Connect(function() Util.Tween(Row, {BackgroundTransparency = 0.45}, false, 0.15) end)
	Row.MouseButton1Click:Connect(function()
		self:Set(not self.State)
		self.Window:Notify(self.Window:T(self.Name) .. ": " .. self.Window:T(self.State and "ON" or "OFF"))
	end)
end

function Toggle:Paint(Instant)
	Util.Tween(self.Switch, {BackgroundColor3 = self.State and self.Window.Theme.Accent or Tone.Off}, Instant)
	Util.Tween(self.Knob, {Position = UDim2.new(0, self.State and (Profile.SwitchW - Profile.Knob - 3) or 3, 0.5, 0)}, Instant, 0.36, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

function Toggle:Set(Value, Silent)
	self.State = Value == true
	self:Paint(false)
	self:Commit(self.State, Silent)
end

function Toggle:Get()
	return self.State
end

local Slider = Class(Element)

function Slider.new(Section, Options)
	local Self = setmetatable({}, Slider)
	Self:Init(Section, Options, true)
	Self.Min = Options.Min or 0
	Self.Max = Options.Max or 100
	Self.Step = Options.Step or 1
	Self.Suffix = Options.Suffix or ""
	Self.Value = nil
	Self.Goal, Self.Shown = 0, 0
	Self:Build()
	table.insert(Self.Window.Sliders, Self)
	Self:Set(Options.Default or Self.Min, true, nil, true)
	return Self
end

function Slider:Build()
	local Window = self.Window
	local Row = self.Section:Card(74, false)
	Window:NameTag(Row, self.Name, self.Desc, UDim2.new(0, 16, 0, 26), 260, nil, nil, nil, 170)
	local Group = Util.New("Frame", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0, 26), Size = UDim2.new(0, 0, 0, 28), AutomaticSize = Enum.AutomaticSize.X}, Row)
	local Flow = Util.Flow(Group, 8)
	Flow.HorizontalAlignment = Enum.HorizontalAlignment.Right
	self.Box = Util.New("TextBox", {
		LayoutOrder = 1, Size = UDim2.fromOffset(62, 28), BackgroundColor3 = Window.Theme.Accent, BackgroundTransparency = 0.86, BorderSizePixel = 0,
		Font = Fonts.Tech, TextSize = 12, TextColor3 = Window.Theme.Accent, Text = "", ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Center,
	}, Group)
	Util.Corner(self.Box, 9)
	self.BoxStroke = Util.Stroke(self.Box, Window.Theme.Accent, 0.8)
	Window:Loc(Util.Label(Group, self.Suffix, 11, Fonts.Medium, Tone.Gray, {LayoutOrder = 2, Size = UDim2.new(0, 0, 0, 28), AutomaticSize = Enum.AutomaticSize.X}), self.Suffix)
	self.Rail = Util.New("Frame", {BackgroundColor3 = Tone.White, BackgroundTransparency = 0.88, BorderSizePixel = 0, Position = UDim2.fromOffset(16, 54), Size = UDim2.new(1, -32, 0, 6)}, Row)
	Util.Corner(self.Rail, 3)
	self.Fill = Util.New("Frame", {BackgroundColor3 = Tone.White, BorderSizePixel = 0, Size = UDim2.new(0, 0, 1, 0)}, self.Rail)
	Util.Corner(self.Fill, 3)
	self.FillGrad = Util.New("UIGradient", {}, self.Fill)
	self.Thumb = Util.New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(Profile.Thumb, Profile.Thumb), Position = UDim2.fromScale(0, 0.5), BackgroundColor3 = Tone.White, BorderSizePixel = 0, ZIndex = 2}, self.Rail)
	Util.Corner(self.Thumb, Profile.Thumb / 2)
	self.ThumbLine = Util.Stroke(self.Thumb, Window.Theme.Accent, 0, 2.5)
	local Hit = Util.New("TextButton", {BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Position = UDim2.fromOffset(Profile.HitPad, Profile.HitY), Size = UDim2.new(1, -Profile.HitPad * 2, 0, Profile.HitH), ZIndex = 3}, Row)
	Window:Bind(function(Theme, Instant)
		self.FillGrad.Color = ColorSequence.new(Theme.Accent, Theme.Accent2)
		Util.Tween(self.ThumbLine, {Color = Theme.Accent}, Instant)
		Util.Tween(self.Box, {TextColor3 = Theme.Accent, BackgroundColor3 = Theme.Accent}, Instant)
		Util.Tween(self.BoxStroke, {Color = Theme.Accent}, Instant)
	end)
	Hit.InputBegan:Connect(function(Input)
		if Util.IsPress(Input) then self:Grab(Input) end
	end)
	Hit.MouseEnter:Connect(function()
		if not self.Held then Util.Tween(self.Thumb, {Size = UDim2.fromOffset(Profile.ThumbHover, Profile.ThumbHover)}, false, 0.14) end
	end)
	Hit.MouseLeave:Connect(function()
		if not self.Held then Util.Tween(self.Thumb, {Size = UDim2.fromOffset(Profile.Thumb, Profile.Thumb)}, false, 0.14) end
	end)
	self.Box.Focused:Connect(function() self.BoxStroke.Transparency = 0.2 end)
	self.Box.FocusLost:Connect(function()
		self.BoxStroke.Transparency = 0.8
		local Number = tonumber(self.Box.Text:match("-?%d+%.?%d*"))
		if Number and (Number < self.Min or Number > self.Max) then
			Window:Notify(Window:T(self.Name) .. ": " .. self.Min .. " - " .. self.Max)
		end
		self:Set(Number or self.Value)
		self.Box.Text = self:Format(self.Value)
	end)
end

function Slider:Format(Value)
	return self.Step < 1 and string.format("%.1f", Value) or tostring(math.floor(Value + 0.5))
end

function Slider:Apply()
	self.Thumb.Position = UDim2.fromScale(self.Shown, 0.5)
	self.Fill.Size = UDim2.fromScale(self.Shown, 1)
end

function Slider:Step_(Dt)
	local Gap = self.Goal - self.Shown
	if Gap ~= 0 then
		if math.abs(Gap) < 0.0005 then
			self.Shown = self.Goal
		else
			self.Shown = self.Shown + Gap * math.min(Dt * 24, 1)
		end
		self:Apply()
	end
end

function Slider:Set(Input, Silent, Soft, Instant)
	local Value = math.clamp(math.floor(Input / self.Step + 0.5) * self.Step, self.Min, self.Max)
	local Changed = Value ~= self.Value
	self.Value = Value
	self.Box.Text = self:Format(Value)
	self.Goal = Soft or (Value - self.Min) / math.max(self.Max - self.Min, 1e-6)
	if Instant then
		self.Shown = self.Goal
		self:Apply()
	end
	self:Commit(Value, Silent or not Changed)
end

function Slider:Get()
	return self.Value
end

function Slider:FromX(X)
	local Width = self.Rail.AbsoluteSize.X
	if Width > 0 then
		local Ratio = math.clamp((X - self.Rail.AbsolutePosition.X) / Width, 0, 1)
		self:Set(self.Min + (self.Max - self.Min) * Ratio, nil, Ratio)
	end
end

function Slider:Grab(Input)
	local Window = self.Window
	if Window.ActiveSlider == nil then
		Window.ActiveSlider = self
		self.Held = Input
		Window.Content.ScrollingEnabled = false
		Util.Tween(self.Thumb, {Size = UDim2.fromOffset(Profile.ThumbDown, Profile.ThumbDown)}, false, 0.12)
		self:FromX(Input.Position.X)
	end
end

function Slider:Drag(Input)
	if self.Held and Util.Matches(self.Held, Input) then
		self:FromX(Input.Position.X)
	end
end

function Slider:Release(Input)
	if self.Held and Util.Released(self.Held, Input) then
		self.Held = nil
		self.Goal = (self.Value - self.Min) / math.max(self.Max - self.Min, 1e-6)
		self.Window.ActiveSlider = nil
		self.Window.Content.ScrollingEnabled = true
		Util.Tween(self.Thumb, {Size = UDim2.fromOffset(Profile.Thumb, Profile.Thumb)}, false, 0.18)
	end
end

local Dropdown = Class(Element)

local function Normalize(Option)
	if type(Option) == "table" then
		return {Name = tostring(Option.Name), Color = Option.Color}
	end
	return {Name = tostring(Option)}
end

function Dropdown.new(Section, Options)
	local Self = setmetatable({}, Dropdown)
	Self:Init(Section, Options, true)
	Self.Multi = Options.Multi == true
	Self.Searchable = Options.Search ~= false
	Self.Items = {}
	Self.Entries = {}
	Self.Selected = {}
	Self.Opened = false
	Self.SearchHint = Options.SearchHint or "Search options"
	Self.Placeholder = Options.Placeholder or (Self.Multi and "Select options" or "Select option")
	Self:Build()
	Self:SetOptions(Options.Options or {}, true)
	Self:Set(Options.Default, true)
	return Self
end

function Dropdown:Build()
	local Window = self.Window
	local BoxWidth = Profile.KeyW
	local Row = self.Section:Card(58, false)
	Window:NameTag(Row, self.Name, self.Desc, UDim2.new(0, 16, 0.5, 0), 220, nil, nil, nil, BoxWidth + 16)
	self.Box = Util.New("TextButton", {
		AutoButtonColor = false, Text = "", BackgroundColor3 = Tone.Black, BackgroundTransparency = 0.35, BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(BoxWidth, Profile.KeyH),
	}, Row)
	Util.Corner(self.Box, 10)
	self.BoxStroke = Util.Stroke(self.Box, Tone.White, 0.88)
	self.ValueLabel = Util.Label(self.Box, "", 13, Fonts.Medium, Tone.Gray, {
		Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, self.Multi and -68 or -42, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd,
	})
	if self.Multi then
		self.Chip = Util.New("Frame", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -32, 0.5, 0), Size = UDim2.fromOffset(24, 18), BorderSizePixel = 0}, self.Box)
		Util.Corner(self.Chip, 6)
		self.ChipLabel = Util.Label(self.Chip, "0", 10, Fonts.Tech, Window.Theme.Accent, {Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center})
	end
	self.Chevron = Icon.new("Chevron", self.Box, 14):Place(Vector2.new(1, 0.5), UDim2.new(1, -10, 0.5, 0))
	self.Box.MouseButton1Click:Connect(function() self:Switch() end)
	self:BuildPopup()
	Window:Bind(function(Theme, Instant)
		Util.Tween(self.Popup, {BackgroundColor3 = Theme.Panel:Lerp(Tone.Black, 0.25)}, Instant)
		if self.Chip then
			Util.Tween(self.Chip, {BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.85}, Instant)
			Util.Tween(self.ChipLabel, {TextColor3 = Theme.Accent}, Instant)
		end
		self.Chevron:Tint(Tone.Gray, true)
		self:Refresh()
	end)
end

function Dropdown:BuildPopup()
	local Window = self.Window
	self.PopupWidth = 236
	self.SearchHeight = self.Searchable and 46 or 6
	self.Shell = Util.New("Frame", {Visible = false, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 100, Size = UDim2.fromOffset(self.PopupWidth, 200)}, Window.Gui)
	self.Popup = Util.New("Frame", {BorderSizePixel = 0, Size = UDim2.fromOffset(self.PopupWidth, 200), Active = true}, self.Shell)
	Util.Corner(self.Popup, 12)
	Window:Decorate(self.Popup, 1.2, false)
	self.PopupScale = Util.New("UIScale", {}, self.Popup)
	if self.Searchable then
		local Bar = Util.New("Frame", {BackgroundColor3 = Tone.Black, BackgroundTransparency = 0.45, BorderSizePixel = 0, Position = UDim2.fromOffset(8, 8), Size = UDim2.new(1, -16, 0, 30)}, self.Popup)
		Util.Corner(Bar, 8)
		Icon.new("Search", Bar, 14):Place(Vector2.new(0, 0.5), UDim2.new(0, 10, 0.5, 0))
		self.Search = Util.New("TextBox", {
			BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(32, 0), Size = UDim2.new(1, -40, 1, 0),
			Font = Fonts.Medium, TextSize = 12, TextColor3 = Tone.White, PlaceholderText = self.SearchHint, PlaceholderColor3 = Tone.Muted,
			Text = "", ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left,
		}, Bar)
		self.Search:GetPropertyChangedSignal("Text"):Connect(function() self:Filter() end)
		self.Window:Loc(self.Search, self.SearchHint, "PlaceholderText")
	end
	self.Scroller = Util.New("ScrollingFrame", {
		BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(0, self.SearchHeight), Size = UDim2.new(1, 0, 1, -(self.SearchHeight + 4)),
		CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3, ScrollingDirection = Enum.ScrollingDirection.Y,
		ElasticBehavior = Enum.ElasticBehavior.Never, VerticalScrollBarInset = Enum.ScrollBarInset.Always,
	}, self.Popup)
	self.Holder = Util.New("Frame", {BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 0)}, self.Scroller)
	Util.Pad(self.Holder, 6, 0, 6, 4)
	Util.List(self.Holder, 2)
	self.Empty = Util.Label(self.Holder, "No matches", 12, Fonts.Regular, Tone.Gray, {LayoutOrder = 100000, Size = UDim2.new(1, 0, 0, 32), TextXAlignment = Enum.TextXAlignment.Center, Visible = false})
	self.Window:Loc(self.Empty, "No matches")
end

function Dropdown:SetOptions(List, Silent)
	for _, Entry in pairs(self.Entries) do Entry.Button:Destroy() end
	table.clear(self.Entries)
	table.clear(self.Items)
	for Index, Raw in ipairs(List) do
		local Item = Normalize(Raw)
		self.Items[Index] = Item
		self.Entries[Item.Name] = self:BuildItem(Item, Index)
	end
	for Name in pairs(self.Selected) do
		if not self.Entries[Name] then self.Selected[Name] = nil end
	end
	self.ListHeight = math.min(#self.Items * 34 + 10, 190)
	self:Refresh()
	self:Commit(self:Get(), Silent)
end

function Dropdown:BuildItem(Item, Index)
	local Button = Util.New("TextButton", {
		AutoButtonColor = false, Text = "", BackgroundColor3 = Tone.White, BackgroundTransparency = 1, BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 32), LayoutOrder = Index,
	}, self.Holder)
	Util.Corner(Button, 8)
	local Dot = Util.New("Frame", {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 12, 0.5, 0), Size = UDim2.fromOffset(8, 8), BorderSizePixel = 0, Visible = false}, Button)
	Util.Corner(Dot, 4)
	local Text = Util.Label(Button, Item.Name, 13, Fonts.Medium, Tone.Light, {Position = UDim2.fromOffset(30, 0), Size = UDim2.new(1, -58, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd})
	self.Window:Loc(Text, Item.Name)
	local Check = Icon.new("Check", Button, 14):Place(Vector2.new(1, 0.5), UDim2.new(1, -12, 0.5, 0))
	Check.Root.Visible = false
	Button.MouseEnter:Connect(function()
		Util.Tween(Button, {BackgroundTransparency = self.Selected[Item.Name] and 0.8 or 0.94}, false, 0.12)
	end)
	Button.MouseLeave:Connect(function()
		Util.Tween(Button, {BackgroundTransparency = self.Selected[Item.Name] and 0.88 or 1}, false, 0.12)
	end)
	Button.MouseButton1Click:Connect(function() self:Pick(Item.Name) end)
	return {Button = Button, Dot = Dot, Text = Text, Check = Check, Item = Item}
end

function Dropdown:Names()
	local Out = {}
	for _, Item in ipairs(self.Items) do
		if self.Selected[Item.Name] then table.insert(Out, Item.Name) end
	end
	return Out
end

function Dropdown:Get()
	local Names = self:Names()
	return self.Multi and Names or Names[1]
end

function Dropdown:Refresh()
	local Accent = self.Window.Theme.Accent
	local Names = self:Names()
	local Shown = {}
	for Index, Name in ipairs(Names) do Shown[Index] = self.Window:T(Name) end
	if self.Multi then
		self.ChipLabel.Text = tostring(#Names)
		self.ValueLabel.Text = #Names > 0 and table.concat(Shown, ", ") or self.Window:T(self.Placeholder)
	else
		self.ValueLabel.Text = Shown[1] or self.Window:T(self.Placeholder)
	end
	self.ValueLabel.TextColor3 = #Names > 0 and Tone.Light or Tone.Gray
	for _, Entry in pairs(self.Entries) do
		local On = self.Selected[Entry.Item.Name] == true
		Entry.Button.BackgroundColor3 = On and Accent or Tone.White
		Entry.Button.BackgroundTransparency = On and 0.88 or 1
		Entry.Dot.Visible = On
		Entry.Dot.BackgroundColor3 = Entry.Item.Color or Accent
		Entry.Check.Root.Visible = On
		Entry.Check:Tint(Accent, true)
		Entry.Text.TextColor3 = On and Tone.White or Tone.Light
	end
end

function Dropdown:Set(Value, Silent)
	self.Selected = {}
	local List = type(Value) == "table" and Value or {Value}
	for _, Entry in ipairs(List) do
		local Name = Entry ~= nil and tostring(Entry) or nil
		if Name and self.Entries[Name] and (self.Multi or next(self.Selected) == nil) then
			self.Selected[Name] = true
		end
	end
	self:Refresh()
	self:Commit(self:Get(), Silent)
end

function Dropdown:Pick(Name)
	if self.Multi then
		self.Selected[Name] = (not self.Selected[Name]) or nil
	else
		self.Selected = {[Name] = true}
		self:Close()
	end
	self:Refresh()
	self:Commit(self:Get())
end

function Dropdown:Filter()
	local Query = self.Search and self.Search.Text:lower() or ""
	local Shown = 0
	for _, Item in ipairs(self.Items) do
		local Visible = Query == "" or Item.Name:lower():find(Query, 1, true) ~= nil or self.Window:T(Item.Name):lower():find(Query, 1, true) ~= nil
		self.Entries[Item.Name].Button.Visible = Visible
		Shown = Shown + (Visible and 1 or 0)
	end
	self.Empty.Visible = Shown == 0
end

function Dropdown:Reposition()
	local Window = self.Window
	local Scale = Window.BaseScale
	local Left, Top, Right, Bottom = Window:Bounds()
	local BoxPos, BoxSize = self.Box.AbsolutePosition, self.Box.AbsoluteSize
	local Width = math.min(self.PopupWidth, (Right - Left - 16) / Scale)
	local Wanted = self.SearchHeight + self.ListHeight + 4
	local Below = (Bottom - 8 - (BoxPos.Y + BoxSize.Y + 4 * Scale)) / Scale
	local Above = (BoxPos.Y - 4 * Scale - (Top + 8)) / Scale
	local Up = Below < math.min(Wanted, 200) and Above > Below
	local Height = math.max(math.min(Wanted, Up and Above or Below), self.SearchHeight + 70)
	local EdgeX = math.clamp(BoxPos.X + BoxSize.X, Left + 8 * Scale + Width * Scale, Right - 8 * Scale)
	local Anchor = Vector2.new(1, Up and 1 or 0)
	self.Shell.Size = UDim2.fromOffset(Width * Scale, Height * Scale)
	self.Shell.AnchorPoint = Anchor
	self.Shell.Position = UDim2.fromOffset(EdgeX, Up and BoxPos.Y - 4 * Scale or BoxPos.Y + BoxSize.Y + 4 * Scale)
	self.Popup.Size = UDim2.fromOffset(Width, Height)
	self.Popup.AnchorPoint = Anchor
	self.Popup.Position = UDim2.fromScale(Anchor.X, Anchor.Y)
end

function Dropdown:Open()
	local Window = self.Window
	Window:CloseDropdown()
	Window.OpenDropdown = self
	self.Opened = true
	if self.Search then self.Search.Text = "" end
	self:Filter()
	self:Reposition()
	Window.Catcher.Visible = true
	self.Shell.Visible = true
	local Scale = Window.BaseScale
	self.PopupScale.Scale = Scale * 0.9
	Util.Pop(self.PopupScale, {Scale = Scale}, 0.32)
	Util.Pop(self.Chevron.Root, {Rotation = 180}, 0.4)
	Util.Tween(self.BoxStroke, {Color = Window.Theme.Accent, Transparency = 0.3}, false)
end

function Dropdown:Close()
	if self.Opened then
		self.Opened = false
		self.Window.OpenDropdown = nil
		self.Window.Catcher.Visible = false
		Util.Tween(self.PopupScale, {Scale = self.Window.BaseScale * 0.94}, false, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		task.delay(0.12, function() self.Shell.Visible = self.Opened end)
		Util.Pop(self.Chevron.Root, {Rotation = 0}, 0.4)
		Util.Tween(self.BoxStroke, {Color = Tone.White, Transparency = 0.9}, false)
	end
end

function Dropdown:Switch()
	if self.Opened then self:Close() else self:Open() end
end

local Button = Class(Element)

function Button.new(Section, Options)
	local Self = setmetatable({}, Button)
	Self:Init(Section, Options, false)
	Self:Build()
	return Self
end

function Button:Build()
	local Window = self.Window
	local Btn = Util.New("TextButton", {
		AutoButtonColor = false, Text = self.Name, Font = Fonts.Bold, TextSize = 14, TextColor3 = Tone.White,
		BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, Profile.BtnH), LayoutOrder = self.Section:Order(),
	}, self.Section.Frame)
	Window:Loc(Btn, self.Name)
	Util.Corner(Btn, 12)
	Window:Decorate(Btn, 1, false)
	Window:Bind(function(Theme, Instant)
		Util.Tween(Btn, {BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.82}, Instant)
	end)
	Btn.MouseEnter:Connect(function() Util.Tween(Btn, {BackgroundTransparency = 0.68}, false, 0.12) end)
	Btn.MouseLeave:Connect(function() Util.Tween(Btn, {BackgroundTransparency = 0.82}, false, 0.12) end)
	Btn.MouseButton1Click:Connect(function() self:Commit(true) end)
	if self.Desc then
		local Tip = Window:Hint(Btn, self.Desc, 1)
		Tip.AnchorPoint = Vector2.new(1, 0.5)
		Tip.Position = UDim2.new(1, -12, 0.5, 0)
	end
end

local KeyNames = {
	LeftControl = "L-Ctrl", RightControl = "R-Ctrl", LeftShift = "L-Shift", RightShift = "R-Shift",
	LeftAlt = "L-Alt", RightAlt = "R-Alt", Return = "Enter", Backspace = "Bksp", Space = "Space",
	PageUp = "PgUp", PageDown = "PgDn", Insert = "Insert", Delete = "Del", Backquote = "`",
	One = "1", Two = "2", Three = "3", Four = "4", Five = "5", Six = "6", Seven = "7", Eight = "8", Nine = "9", Zero = "0",
}

local function KeyLabel(Key)
	return KeyNames[Key.Name] or Key.Name
end

local Keybind = Class(Element)

function Keybind.new(Section, Options)
	local Self = setmetatable({}, Keybind)
	Self:Init(Section, Options, true)
	Self.Key = Options.Default or Enum.KeyCode.RightControl
	Self.Waiting = false
	Self:Build()
	Self:Commit(Self.Key, true)
	return Self
end

function Keybind:Build()
	local Window = self.Window
	local Row = self.Section:Card(56, false)
	Window:NameTag(Row, self.Name, self.Desc, UDim2.new(0, 16, 0.5, 0), 220, nil, nil, nil, 172)
	self.Box = Util.New("TextButton", {
		AutoButtonColor = false, Text = "", BackgroundColor3 = Tone.Black, BackgroundTransparency = 0.35, BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(148, 36),
	}, Row)
	Util.Corner(self.Box, 10)
	self.BoxStroke = Util.Stroke(self.Box, Tone.White, 0.85)
	self.Mark = Icon.new("Keyboard", self.Box, 18):Place(Vector2.new(0, 0.5), UDim2.new(0, 10, 0.5, 0))
	self.Value = Util.Label(self.Box, "", 10, Fonts.Tech, Tone.Light, {Position = UDim2.fromOffset(34, 0), Size = UDim2.new(1, -42, 1, 0), TextXAlignment = Enum.TextXAlignment.Center, TextTruncate = Enum.TextTruncate.AtEnd})
	Window:Bind(function(_, Instant) self:Paint(Instant) end)
	self.Box.MouseButton1Click:Connect(function()
		if self.Waiting then Window:StopBinding() else Window:Listen(self) end
	end)
end

function Keybind:Paint(Instant)
	local Accent = self.Window.Theme.Accent
	self.Mark:Tint(self.Waiting and Accent or Tone.Gray, Instant)
	Util.Tween(self.BoxStroke, {Color = self.Waiting and Accent or Tone.White, Transparency = self.Waiting and 0.15 or 0.85}, Instant)
	self.Value.TextColor3 = self.Waiting and Accent or Tone.Light
	self.Value.Text = self.Waiting and self.Window:T("PRESS KEY") or string.upper(KeyLabel(self.Key))
end

function Keybind:Set(Key, Silent)
	self.Key = Key
	self:Paint(false)
	self:Commit(Key, Silent)
end

function Keybind:Get()
	return self.Key
end

local Paragraph = Class()

function Paragraph.new(Section, Options)
	local Self = setmetatable({}, Paragraph)
	local Window = Section.Window
	Self.Window, Self.Section = Window, Section
	Self.Name = Options.Title or Options.Name or "Paragraph"
	Window:Register(Self.Name, Section.Tab)
	local Card = Section:Card(0, false)
	Card.AutomaticSize = Enum.AutomaticSize.Y
	Card.Size = UDim2.new(1, 0, 0, 0)
	Util.Pad(Card, 16, 12, 16, 14)
	Util.List(Card, 6)
	Self.TitleLabel = Util.Label(Card, "", 14, Fonts.Bold, Window.Theme.Accent, {LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 20), TextTruncate = Enum.TextTruncate.AtEnd})
	Self.Body = Util.Label(Card, "", 12, Fonts.Medium, Tone.Gray, {LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top})
	Window:Loc(Self.TitleLabel, Self.Name)
	Window:Loc(Self.Body, Options.Content or Options.Desc or Options.Text or "")
	Self.TitleLabel.Visible = Options.Title ~= nil or Options.Name ~= nil
	Window:Bind(function(Theme, Instant) Util.Tween(Self.TitleLabel, {TextColor3 = Theme.Accent}, Instant) end)
	return Self
end

function Paragraph:SetTitle(Text)
	self.TitleLabel.Visible = true
	self.Window:Retext(self.TitleLabel, Text)
end

function Paragraph:SetContent(Text)
	self.Window:Retext(self.Body, Text)
end

local TextField = Class(Element)

function TextField.new(Section, Options)
	local Self = setmetatable({}, TextField)
	Self:Init(Section, Options, true)
	Self.Numeric = Options.Numeric == true
	Self.Live = Options.Live == true
	Self.Wide = Options.Wide == true
	Self.Placeholder = Options.Placeholder or "Type here..."
	Self.Text = ""
	Self:Build()
	Self:Set(Options.Default or "", true)
	return Self
end

function TextField:Build()
	local Window = self.Window
	local Row = self.Section:Card(self.Wide and 90 or 56, false)
	Window:NameTag(Row, self.Name, self.Desc, self.Wide and UDim2.new(0, 16, 0, 26) or UDim2.new(0, 16, 0.5, 0), self.Wide and 260 or 220, nil, nil, nil, self.Wide and 20 or 196)
	local Holder = Util.New("Frame", {
		BackgroundColor3 = Tone.Black, BackgroundTransparency = 0.35, BorderSizePixel = 0,
		AnchorPoint = self.Wide and Vector2.new(0, 0) or Vector2.new(1, 0.5),
		Position = self.Wide and UDim2.fromOffset(14, 48) or UDim2.new(1, -12, 0.5, 0),
		Size = self.Wide and UDim2.new(1, -28, 0, 34) or UDim2.fromOffset(176, 36),
	}, Row)
	Util.Corner(Holder, 10)
	self.Line = Util.Stroke(Holder, Tone.White, 0.88)
	self.Box = Util.New("TextBox", {
		BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(12, 0), Size = UDim2.new(1, -24, 1, 0),
		Font = Fonts.Medium, TextSize = 13, TextColor3 = Tone.White, PlaceholderColor3 = Tone.Muted, Text = "", ClearTextOnFocus = false,
		TextXAlignment = Enum.TextXAlignment.Left, ClipsDescendants = true,
	}, Holder)
	Window:Loc(self.Box, self.Placeholder, "PlaceholderText")
	self.Box.Focused:Connect(function()
		Util.Tween(self.Line, {Color = Window.Theme.Accent, Transparency = 0.2}, false)
	end)
	self.Box:GetPropertyChangedSignal("Text"):Connect(function()
		if self.Numeric then
			local Cleaned = (self.Box.Text:gsub("[^%d%.%-]", ""))
			if Cleaned ~= self.Box.Text then self.Box.Text = Cleaned end
		end
		if self.Live then self:Take(self.Box.Text) end
	end)
	self.Box.FocusLost:Connect(function()
		Util.Tween(self.Line, {Color = Tone.White, Transparency = 0.88}, false)
		self:Take(self.Box.Text)
	end)
end

function TextField:Value()
	return self.Numeric and (tonumber(self.Text) or 0) or self.Text
end

function TextField:Take(Text)
	if Text ~= self.Text then
		self.Text = Text
		self:Commit(self:Value())
	end
end

function TextField:Set(Value, Silent)
	self.Text = tostring(Value)
	self.Box.Text = self.Text
	self:Commit(self:Value(), Silent)
end

function TextField:Get()
	return self:Value()
end

local ColorPicker = Class(Element)

local PopW, PopH = 252, 286

local function Rainbow()
	local Keys = {}
	for Index = 0, 6 do
		table.insert(Keys, ColorSequenceKeypoint.new(Index / 6, Color3.fromHSV(Index / 6, 1, 1)))
	end
	return ColorSequence.new(Keys)
end

local Presets = {
	Color3.fromRGB(255, 82, 82), Color3.fromRGB(255, 159, 67), Color3.fromRGB(254, 211, 48), Color3.fromRGB(46, 213, 115),
	Color3.fromRGB(0, 210, 211), Color3.fromRGB(84, 160, 255), Color3.fromRGB(155, 89, 255), Color3.fromRGB(255, 107, 194),
}

function ColorPicker.new(Section, Options)
	local Self = setmetatable({}, ColorPicker)
	Self:Init(Section, Options, true)
	Self.Opened = false
	Self.H, Self.S, Self.V = 0, 1, 1
	Self.Color = Options.Default or Color3.fromRGB(255, 255, 255)
	Self.Last = 0
	Self:Build()
	Self:Set(Self.Color, true)
	return Self
end

function ColorPicker:Build()
	local Window = self.Window
	local Row = self.Section:Card(56, false)
	Window:NameTag(Row, self.Name, self.Desc, UDim2.new(0, 16, 0.5, 0), 220, nil, nil, nil, 152)
	self.Swatch = Util.New("TextButton", {
		AutoButtonColor = false, Text = "", BackgroundColor3 = Tone.Black, BackgroundTransparency = 0.35, BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(128, 36),
	}, Row)
	Util.Corner(self.Swatch, 10)
	self.SwatchLine = Util.Stroke(self.Swatch, Tone.White, 0.88)
	self.Dot = Util.New("Frame", {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 8, 0.5, 0), Size = UDim2.fromOffset(22, 22), BorderSizePixel = 0}, self.Swatch)
	Util.Corner(self.Dot, 11)
	Util.Stroke(self.Dot, Tone.White, 0.5, 1.5)
	self.HexLabel = Util.Label(self.Swatch, "", 11, Fonts.Tech, Tone.Light, {Position = UDim2.fromOffset(38, 0), Size = UDim2.new(1, -44, 1, 0), TextXAlignment = Enum.TextXAlignment.Center})
	self.Swatch.MouseButton1Click:Connect(function() self:Switch() end)
	self:BuildPopup()
end

function ColorPicker:Knob(Parent, Size)
	local Outer = Util.New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(Size, Size), BackgroundColor3 = Tone.White, BorderSizePixel = 0, ZIndex = 4}, Parent)
	Util.Corner(Outer, Size / 2)
	Util.Stroke(Outer, Tone.Black, 0.55, 1.5)
	local Inner = Util.New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(Size - 6, Size - 6), BorderSizePixel = 0, ZIndex = 5}, Outer)
	Util.Corner(Inner, (Size - 6) / 2)
	return Outer, Inner
end

function ColorPicker:BuildPopup()
	local Window = self.Window
	self.Shell = Util.New("Frame", {Visible = false, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 100, Size = UDim2.fromOffset(PopW, PopH)}, Window.Gui)
	self.Popup = Util.New("Frame", {BorderSizePixel = 0, Size = UDim2.fromOffset(PopW, PopH), Active = true}, self.Shell)
	Util.Corner(self.Popup, 14)
	Window:Decorate(self.Popup, 1, false)
	self.PopupScale = Util.New("UIScale", {}, self.Popup)
	self.SV = Util.New("Frame", {BackgroundColor3 = Tone.White, BorderSizePixel = 0, Position = UDim2.fromOffset(12, 12), Size = UDim2.fromOffset(228, 140)}, self.Popup)
	Util.Corner(self.SV, 10)
	local Light = Util.New("Frame", {BackgroundColor3 = Tone.White, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1)}, self.SV)
	Util.Corner(Light, 10)
	Util.New("UIGradient", {Transparency = NumberSequence.new(0, 1)}, Light)
	local Shadow = Util.New("Frame", {BackgroundColor3 = Tone.Black, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1)}, self.SV)
	Util.Corner(Shadow, 10)
	Util.New("UIGradient", {Rotation = 90, Transparency = NumberSequence.new(1, 0)}, Shadow)
	Util.Stroke(self.SV, Tone.White, 0.85)
	self.SVCursor, self.SVFill = self:Knob(self.SV, 26)
	local SVHit = Util.New("TextButton", {BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Position = UDim2.fromOffset(-8, -8), Size = UDim2.new(1, 16, 1, 16), ZIndex = 6}, self.SV)
	SVHit.InputBegan:Connect(function(Input)
		if Util.IsPress(Input) then self:Grab(Input, "sv") end
	end)
	self.Hue = Util.New("Frame", {BackgroundColor3 = Tone.White, BorderSizePixel = 0, Position = UDim2.fromOffset(12, 168), Size = UDim2.fromOffset(228, 20)}, self.Popup)
	Util.Corner(self.Hue, 10)
	Util.New("UIGradient", {Color = Rainbow()}, self.Hue)
	self.HueCursor, self.HueFill = self:Knob(self.Hue, 26)
	local HueHit = Util.New("TextButton", {BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Position = UDim2.fromOffset(-8, -8), Size = UDim2.new(1, 16, 1, 16), ZIndex = 6}, self.Hue)
	HueHit.InputBegan:Connect(function(Input)
		if Util.IsPress(Input) then self:Grab(Input, "hue") end
	end)
	local HexHolder = Util.New("Frame", {BackgroundColor3 = Tone.Black, BackgroundTransparency = 0.35, BorderSizePixel = 0, Position = UDim2.fromOffset(12, 204), Size = UDim2.fromOffset(136, 36)}, self.Popup)
	Util.Corner(HexHolder, 10)
	Util.Stroke(HexHolder, Tone.White, 0.88)
	self.HexBox = Util.New("TextBox", {
		BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), Font = Fonts.Tech, TextSize = 12, TextColor3 = Tone.White,
		PlaceholderText = "#RRGGBB", PlaceholderColor3 = Tone.Muted, Text = "", ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Center,
	}, HexHolder)
	self.HexBox.FocusLost:Connect(function()
		local Color = HexToColor(self.HexBox.Text)
		if Color then self:Set(Color) else self:Refresh() end
	end)
	self.Preview = Util.New("Frame", {BorderSizePixel = 0, Position = UDim2.fromOffset(156, 204), Size = UDim2.fromOffset(84, 36)}, self.Popup)
	Util.Corner(self.Preview, 10)
	Util.Stroke(self.Preview, Tone.White, 0.7, 1.5)
	for Index, Color in ipairs(Presets) do
		local Btn = Util.New("TextButton", {
			AutoButtonColor = false, Text = "", BackgroundColor3 = Color, BorderSizePixel = 0,
			Position = UDim2.fromOffset(12 + (Index - 1) * 28.86, 250), Size = UDim2.fromOffset(26, 26),
		}, self.Popup)
		Util.Corner(Btn, 13)
		Util.Stroke(Btn, Tone.White, 0.6, 1.5)
		Btn.MouseEnter:Connect(function() Util.Tween(Btn, {Size = UDim2.fromOffset(30, 30), Position = UDim2.fromOffset(10 + (Index - 1) * 28.86, 248)}, false, 0.12) end)
		Btn.MouseLeave:Connect(function() Util.Tween(Btn, {Size = UDim2.fromOffset(26, 26), Position = UDim2.fromOffset(12 + (Index - 1) * 28.86, 250)}, false, 0.12) end)
		Btn.MouseButton1Click:Connect(function() self:Set(Color) end)
	end
	Window:Bind(function(Theme, Instant)
		Util.Tween(self.Popup, {BackgroundColor3 = Theme.Panel:Lerp(Tone.Black, 0.25)}, Instant)
	end)
end

function ColorPicker:Refresh()
	local Hue = Color3.fromHSV(self.H, 1, 1)
	self.SV.BackgroundColor3 = Hue
	self.SVCursor.Position = UDim2.fromScale(self.S, 1 - self.V)
	self.SVFill.BackgroundColor3 = self.Color
	self.HueCursor.Position = UDim2.fromScale(self.H, 0.5)
	self.HueFill.BackgroundColor3 = Hue
	self.Preview.BackgroundColor3 = self.Color
	self.Dot.BackgroundColor3 = self.Color
	local Hex = ColorToHex(self.Color)
	self.HexLabel.Text = Hex
	if not self.HexBox:IsFocused() then self.HexBox.Text = Hex end
end

function ColorPicker:Set(Value, Silent)
	if typeof(Value) == "Color3" then
		local H, S, V = Value:ToHSV()
		if S > 0.001 and V > 0.001 then self.H = H end
		self.S, self.V = S, V
		self.Color = Value
		self:Refresh()
		self:Commit(Value, Silent)
	end
end

function ColorPicker:Get()
	return self.Color
end

function ColorPicker:Pointer(Mode, Pos)
	if Mode == "sv" then
		local At, Size = self.SV.AbsolutePosition, self.SV.AbsoluteSize
		self.S = math.clamp((Pos.X - At.X) / Size.X, 0, 1)
		self.V = 1 - math.clamp((Pos.Y - At.Y) / Size.Y, 0, 1)
	else
		local At, Size = self.Hue.AbsolutePosition, self.Hue.AbsoluteSize
		self.H = math.clamp((Pos.X - At.X) / Size.X, 0, 0.999)
	end
	self.Color = Color3.fromHSV(self.H, self.S, self.V)
	self:Refresh()
	local Now = os.clock()
	if Now - self.Last >= 0.04 then
		self.Last = Now
		self.Pending = false
		self:Commit(self.Color)
	else
		self.Pending = true
	end
end

function ColorPicker:Grab(Input, Mode)
	local Window = self.Window
	if Window.ActiveSlider == nil then
		local Owner = self
		Window.ActiveSlider = {
			Drag = function(_, Moved)
				if Util.Matches(Input, Moved) then Owner:Pointer(Mode, Moved.Position) end
			end,
			Release = function(_, Ended)
				if Util.Released(Input, Ended) then
					Window.ActiveSlider = nil
					if Owner.Pending then
						Owner.Pending = false
						Owner:Commit(Owner.Color)
					end
				end
			end,
		}
		Owner:Pointer(Mode, Input.Position)
	end
end

function ColorPicker:Reposition()
	local Window = self.Window
	local Scale = Window.BaseScale
	local Left, Top, Right, Bottom = Window:Bounds()
	local BoxPos, BoxSize = self.Swatch.AbsolutePosition, self.Swatch.AbsoluteSize
	local PixelW, PixelH = PopW * Scale, PopH * Scale
	local Low = Left + 8 + PixelW
	local EdgeX = math.clamp(BoxPos.X + BoxSize.X, Low, math.max(Right - 8, Low))
	local Y = BoxPos.Y + BoxSize.Y + 4 * Scale
	if Y + PixelH > Bottom - 8 then Y = BoxPos.Y - 4 * Scale - PixelH end
	Y = math.clamp(Y, Top + 8, math.max(Bottom - 8 - PixelH, Top + 8))
	self.Shell.Size = UDim2.fromOffset(PixelW, PixelH)
	self.Shell.AnchorPoint = Vector2.new(1, 0)
	self.Shell.Position = UDim2.fromOffset(EdgeX, Y)
	self.Popup.Size = UDim2.fromOffset(PopW, PopH)
	self.Popup.AnchorPoint = Vector2.new(1, 0)
	self.Popup.Position = UDim2.fromScale(1, 0)
end

function ColorPicker:Open()
	local Window = self.Window
	Window:CloseDropdown()
	Window.OpenDropdown = self
	self.Opened = true
	self:Refresh()
	self:Reposition()
	Window.Catcher.Visible = true
	self.Shell.Visible = true
	self.PopupScale.Scale = Window.BaseScale * 0.9
	Util.Pop(self.PopupScale, {Scale = Window.BaseScale}, 0.32)
	Util.Tween(self.SwatchLine, {Color = Window.Theme.Accent, Transparency = 0.3}, false)
end

function ColorPicker:Close()
	if self.Opened then
		self.Opened = false
		self.Window.OpenDropdown = nil
		self.Window.Catcher.Visible = false
		Util.Tween(self.PopupScale, {Scale = self.Window.BaseScale * 0.94}, false, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		task.delay(0.12, function() self.Shell.Visible = self.Opened end)
		Util.Tween(self.SwatchLine, {Color = Tone.White, Transparency = 0.88}, false)
	end
end

function ColorPicker:Switch()
	if self.Opened then self:Close() else self:Open() end
end

local Note = Class(Element)

function Note.new(Section, Options)
	local Self = setmetatable({}, Note)
	Self.Window = Section.Window
	Self.Text = Util.Label(Section.Frame, Options.Text or Options.Name or "", 12, Fonts.Regular, Tone.Gray, {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, TextWrapped = true, LayoutOrder = Section:Order(),
	})
	return Self
end

function Note:Set(Text)
	self.Text.Text = Text
end

local Stat = Class()

function Stat.new(Container, Options)
	local Self = setmetatable({}, Stat)
	local Window = Container.Window
	local Frame = Util.New("Frame", {BackgroundTransparency = 0.4, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 82), LayoutOrder = Util.Next(Container.Holder)}, Container.Holder)
	Util.Corner(Frame, 13)
	Window:Decorate(Frame, 1, true)
	Self.Value = Util.Label(Frame, Options.Value or "0", 24, Fonts.Tech, Window.Theme.Accent, {Position = UDim2.fromOffset(18, 12), Size = UDim2.new(1, -36, 0, 30), TextTruncate = Enum.TextTruncate.AtEnd})
	Window:Loc(Util.Label(Frame, Options.Name or "", 12, Fonts.Medium, Tone.Gray, {Position = UDim2.fromOffset(18, 50), Size = UDim2.new(1, -36, 0, 18), TextTruncate = Enum.TextTruncate.AtEnd}), Options.Name or "")
	Window:Bind(function(Theme, Instant)
		Util.Tween(Self.Value, {TextColor3 = Theme.Accent}, Instant)
	end)
	return Self
end

function Stat:SetValue(Text)
	self.Value.Text = tostring(Text)
end

local function RGB(Red, Green, Blue)
	return Color3.fromRGB(Red, Green, Blue)
end

local function Blob(Parent, X, Y, W, H, Color, Rot, Radius)
	local Obj = Util.New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(X, Y), Size = UDim2.fromOffset(W, H),
		BackgroundColor3 = Color, BorderSizePixel = 0, Rotation = Rot or 0,
	}, Parent)
	Util.Corner(Obj, Radius or math.min(W, H) / 2)
	return Obj
end

local ThemeArt = {
	Halloween = function(P)
		local Dark = RGB(58, 28, 66)
		Blob(P, 23, 7, 6, 9, RGB(76, 175, 80), 18, 2)
		Blob(P, 13, 26, 20, 24, RGB(255, 128, 20))
		Blob(P, 31, 26, 20, 24, RGB(255, 128, 20))
		Blob(P, 22, 26, 20, 28, RGB(255, 160, 40))
		Blob(P, 15, 23, 6, 6, Dark, 45, 1)
		Blob(P, 29, 23, 6, 6, Dark, 45, 1)
		Blob(P, 22, 32, 14, 6, Dark, 0, 3)
		Blob(P, 22, 30.5, 4, 3, RGB(255, 236, 170), 0, 1)
		Blob(P, 9, 30, 5, 4, RGB(255, 96, 80))
		Blob(P, 35, 30, 5, 4, RGB(255, 96, 80))
		Blob(P, 11, 17, 4, 7, RGB(255, 205, 130), 20)
	end,
	Christmas = function(P)
		Blob(P, 22, 39, 7, 7, RGB(130, 78, 44), 0, 2)
		Blob(P, 22, 31, 32, 11, RGB(30, 150, 78), 0, 5)
		Blob(P, 22, 23, 25, 11, RGB(44, 180, 92), 0, 5)
		Blob(P, 22, 15, 17, 10, RGB(72, 206, 112), 0, 5)
		Blob(P, 22, 7, 8, 8, RGB(255, 214, 64), 0, 1)
		Blob(P, 22, 7, 8, 8, RGB(255, 214, 64), 45, 1)
		Blob(P, 14, 32, 5, 5, RGB(255, 80, 96))
		Blob(P, 30, 31, 5, 5, RGB(90, 176, 255))
		Blob(P, 22, 24, 5, 5, RGB(255, 120, 150))
		Blob(P, 19, 16, 4, 4, RGB(255, 240, 150))
		Blob(P, 36, 12, 4, 4, RGB(255, 255, 255), 45, 1)
		Blob(P, 8, 14, 3, 3, RGB(255, 255, 255), 45, 1)
	end,
	Hacker = function(P)
		Blob(P, 22, 8, 3, 8, RGB(60, 255, 170), 0, 1)
		Blob(P, 22, 5, 7, 7, RGB(255, 80, 140))
		Blob(P, 5, 26, 5, 12, RGB(20, 160, 110), 0, 2)
		Blob(P, 39, 26, 5, 12, RGB(20, 160, 110), 0, 2)
		Blob(P, 22, 26, 34, 28, RGB(30, 200, 130), 0, 9)
		Blob(P, 22, 26, 28, 22, RGB(8, 40, 30), 0, 7)
		Blob(P, 15, 24, 7, 8, RGB(80, 255, 190))
		Blob(P, 29, 24, 7, 8, RGB(80, 255, 190))
		Blob(P, 16.5, 22, 2.5, 2.5, RGB(255, 255, 255))
		Blob(P, 30.5, 22, 2.5, 2.5, RGB(255, 255, 255))
		Blob(P, 22, 32, 10, 3, RGB(80, 255, 190), 0, 2)
	end,
	Classic = function(P)
		Blob(P, 22, 22, 11, 38, RGB(255, 214, 70), 0, 5)
		Blob(P, 22, 22, 38, 11, RGB(255, 214, 70), 0, 5)
		Blob(P, 22, 22, 22, 22, RGB(255, 232, 120), 45, 6)
		Blob(P, 18.5, 21, 3, 4, RGB(70, 44, 20))
		Blob(P, 25.5, 21, 3, 4, RGB(70, 44, 20))
		Blob(P, 22, 26.5, 6, 3, RGB(255, 120, 120), 0, 2)
		Blob(P, 7, 8, 6, 6, RGB(80, 200, 255), 45, 1)
		Blob(P, 37, 36, 7, 7, RGB(255, 120, 200), 45, 1)
		Blob(P, 37, 8, 4, 4, RGB(255, 255, 255), 45, 1)
		Blob(P, 7, 37, 4, 4, RGB(150, 255, 200), 45, 1)
	end,
	Purple = function(P)
		Blob(P, 22, 38, 26, 8, RGB(96, 54, 160), 0, 4)
		Blob(P, 22, 34, 18, 6, RGB(130, 80, 210), 0, 3)
		Blob(P, 22, 21, 34, 34, RGB(150, 84, 250))
		Blob(P, 22, 24, 26, 26, RGB(186, 130, 255))
		Blob(P, 13, 13, 5, 9, RGB(240, 222, 255), 30)
		Blob(P, 28, 21, 5, 5, RGB(255, 214, 90), 45, 1)
		Blob(P, 18, 28, 4, 4, RGB(255, 150, 220), 45, 1)
		Blob(P, 29, 29, 3, 3, RGB(255, 255, 255), 45, 1)
	end,
	Crimson = function(P)
		Blob(P, 22, 14, 18, 18, RGB(255, 80, 60), 45, 3)
		Blob(P, 22, 28, 32, 30, RGB(255, 80, 60))
		Blob(P, 22, 31, 22, 22, RGB(255, 140, 40))
		Blob(P, 22, 24, 12, 12, RGB(255, 140, 40), 45, 2)
		Blob(P, 22, 37, 12, 9, RGB(255, 224, 90))
		Blob(P, 17, 31, 3, 4, RGB(70, 24, 24))
		Blob(P, 27, 31, 3, 4, RGB(70, 24, 24))
		Blob(P, 22, 34.5, 5, 2.5, RGB(70, 24, 24), 0, 1)
		Blob(P, 38, 9, 5, 5, RGB(255, 200, 70), 45, 1)
		Blob(P, 7, 18, 4, 4, RGB(255, 200, 70), 45, 1)
	end,
}

local Section = Class()

function Section.new(Container, Options)
	local Self = setmetatable({}, Section)
	Self.Window, Self.Tab = Container.Window, Container.Tab
	Self.Open = true
	Self.Scope = Options.Scope
	Self.Frame = Util.New("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 0), LayoutOrder = Util.Next(Container.Holder)}, Container.Holder)
	Util.List(Self.Frame, 8)
	Self:BuildHeader(Options)
	return Self
end

function Section:BuildHeader(Options)
	local Window = self.Window
	local Head = Util.New("TextButton", {AutoButtonColor = false, Text = "", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 40), LayoutOrder = self:Order()}, self.Frame)
	local Mark = Icon.new(Options.Icon or "Grid", Head, 18):Place(Vector2.new(0, 0.5), UDim2.new(0, 2, 0.5, 0))
	Window:Bind(function(Theme, Instant) Mark:Tint(Theme.Accent, Instant) end)
	Window:NameTag(Head, Options.Name or "Section", Options.Desc, UDim2.new(0, 32, 0.5, 0), 220, 14, Fonts.Tech, Tone.White)
	local Pill = Util.New("Frame", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(28, 28), BackgroundColor3 = Tone.White, BackgroundTransparency = 0.93, BorderSizePixel = 0}, Head)
	Util.Corner(Pill, 9)
	Util.Stroke(Pill, Tone.White, 0.88)
	local Chevron = Icon.new("Chevron", Pill, 16):Place(Vector2.new(0.5, 0.5), UDim2.fromScale(0.5, 0.5))
	Head.MouseButton1Click:Connect(function()
		self.Open = not self.Open
		self.Window:CloseDropdown()
		Util.Pop(Chevron.Root, {Rotation = self.Open and 0 or -90}, 0.4)
		for _, Child in ipairs(self.Frame:GetChildren()) do
			if Child:IsA("GuiObject") and Child.LayoutOrder > 1 then Child.Visible = self.Open end
		end
	end)
end

function Section:Card(Height, Clickable)
	local Card = Util.New(Clickable and "TextButton" or "Frame", {BackgroundTransparency = 0.45, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, Height + (Height < 70 and RH or 0)), LayoutOrder = self:Order()}, self.Frame)
	if Clickable then
		Card.Text = ""
		Card.AutoButtonColor = false
	end
	Util.Corner(Card, 12)
	self.Window:Decorate(Card, 1, true)
	return Card
end

function Section:Order()
	return Util.Next(self.Frame)
end

function Section:AddToggle(Options) return Toggle.new(self, Options) end
function Section:AddSlider(Options) return Slider.new(self, Options) end
function Section:AddDropdown(Options) return Dropdown.new(self, Options) end
function Section:AddButton(Options) return Button.new(self, Options) end
function Section:AddKeybind(Options) return Keybind.new(self, Options) end
function Section:AddColorpicker(Options) return ColorPicker.new(self, Options) end
function Section:AddColorPicker(Options) return ColorPicker.new(self, Options) end
function Section:AddInput(Options) return TextField.new(self, Options) end
function Section:AddParagraph(Options) return Paragraph.new(self, type(Options) == "string" and {Content = Options} or Options) end
function Section:AddLabel(Options) return Note.new(self, type(Options) == "string" and {Text = Options} or Options) end

function Section:AddThemePicker(Desc)
	local Window = self.Window
	local Head = Util.New("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 26), LayoutOrder = self:Order()}, self.Frame)
	Window:NameTag(Head, "Theme", Desc or "Pick a color theme for the whole hub", UDim2.new(0, 2, 0.5, 0), 200, 13, Fonts.Medium, Tone.Light)
	local Grid = Util.New("Frame", {BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 0), LayoutOrder = self:Order()}, self.Frame)
	Util.New("UIGridLayout", {CellSize = UDim2.new(1 / 3, -6, 0, 88), CellPadding = UDim2.fromOffset(9, 9), SortOrder = Enum.SortOrder.LayoutOrder}, Grid)
	local Cards = {}
	for Index, Name in ipairs(ThemeOrder) do
		local Info = Themes[Name]
		local Btn = Util.New("TextButton", {AutoButtonColor = false, Text = "", BackgroundColor3 = Info.Panel, BackgroundTransparency = 0.4, BorderSizePixel = 0, LayoutOrder = Index}, Grid)
		Util.Corner(Btn, 13)
		Util.Stroke(Btn, Info.Accent, 0.6, 1)
		local Pick = Util.New("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1)}, Btn)
		Util.Corner(Pick, 13)
		local Ring = Util.Stroke(Pick, Info.Accent, 0, 2)
		Ring.Enabled = false
		local Art = Util.New("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 8), Size = UDim2.fromOffset(44, 44)}, Btn)
		ThemeArt[Name](Art)
		local Text = Util.Label(Btn, Name, 12, Fonts.Medium, Tone.Gray, {Position = UDim2.new(0, 0, 0, 58), Size = UDim2.new(1, 0, 0, 18), TextXAlignment = Enum.TextXAlignment.Center, TextTruncate = Enum.TextTruncate.AtEnd})
		local Badge = Util.New("Frame", {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -7, 0, 7), Size = UDim2.fromOffset(20, 20), BackgroundColor3 = Info.Accent, BorderSizePixel = 0, Visible = false, ZIndex = 3}, Btn)
		Util.Corner(Badge, 10)
		local Tick = Icon.new("Check", Badge, 14):Place(Vector2.new(0.5, 0.5), UDim2.fromScale(0.5, 0.5))
		Tick:Tint(Tone.Black, true)
		Cards[Name] = {Btn = Btn, Text = Text, Ring = Ring, Art = Art, Badge = Badge, Was = false}
		Btn.MouseEnter:Connect(function()
			if Name ~= Window.ThemeName then Util.Tween(Btn, {BackgroundTransparency = 0.25}, false, 0.12) end
		end)
		Btn.MouseLeave:Connect(function()
			if Name ~= Window.ThemeName then Util.Tween(Btn, {BackgroundTransparency = 0.4}, false, 0.12) end
		end)
		Btn.MouseButton1Click:Connect(function()
			Window:SetTheme(Name)
			Window:QueueSave("ui")
			Window:Notify(Window:T("Theme switched to") .. " " .. string.upper(Name))
		end)
	end
	Window:Bind(function(_, Instant)
		for Name, Card in pairs(Cards) do
			local Active = Name == Window.ThemeName
			Card.Ring.Enabled = Active
			Card.Badge.Visible = Active
			if Active and not Card.Was and not Instant then
				Card.Badge.Size = UDim2.fromOffset(6, 6)
				Util.Pop(Card.Badge, {Size = UDim2.fromOffset(20, 20)}, 0.4)
			end
			Card.Was = Active
			Util.Tween(Card.Btn, {BackgroundTransparency = Active and 0.1 or 0.4}, Instant)
			Util.Tween(Card.Text, {TextColor3 = Active and Tone.White or Tone.Gray}, Instant)
			Util.Tween(Card.Art, {Position = UDim2.new(0.5, 0, 0, Active and 5 or 8)}, Instant, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		end
	end)
end

local LangInfo = {
	English = {Code = "EN", Color = Color3.fromRGB(96, 165, 250)},
	["ไทย"] = {Code = "TH", Color = Color3.fromRGB(244, 114, 182)},
}

function Section:AddLanguagePicker()
	local Window = self.Window
	local Grid = Util.New("Frame", {BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 0), LayoutOrder = self:Order()}, self.Frame)
	Util.New("UIGridLayout", {CellSize = UDim2.new(0.5, -5, 0, 50), CellPadding = UDim2.fromOffset(10, 10), SortOrder = Enum.SortOrder.LayoutOrder}, Grid)
	local Cards = {}
	for Index, Lang in ipairs(Window.LangOrder) do
		local Info = LangInfo[Lang] or {Code = string.upper(Lang:sub(1, 2)), Color = Tone.Gray}
		local Btn = Util.New("TextButton", {AutoButtonColor = false, Text = "", BackgroundColor3 = Window.Theme.Panel, BackgroundTransparency = 0.45, BorderSizePixel = 0, LayoutOrder = Index}, Grid)
		Util.Corner(Btn, 13)
		Util.Stroke(Btn, Tone.White, 0.88, 1)
		local Pick = Util.New("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1)}, Btn)
		Util.Corner(Pick, 13)
		local Ring = Util.Stroke(Pick, Tone.White, 0, 2)
		Ring.Enabled = false
		local Badge = Util.New("Frame", {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 10, 0.5, 0), Size = UDim2.fromOffset(30, 30), BackgroundColor3 = Info.Color, BorderSizePixel = 0}, Btn)
		Util.Corner(Badge, 15)
		Util.Label(Badge, Info.Code, 12, Fonts.Bold, Color3.fromRGB(34, 22, 44), {Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center})
		local Name = Util.Label(Btn, Lang, 13, Fonts.Medium, Tone.Gray, {Position = UDim2.fromOffset(48, 0), Size = UDim2.new(1, -78, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd})
		local Tick = Icon.new("Check", Btn, 16):Place(Vector2.new(1, 0.5), UDim2.new(1, -12, 0.5, 0))
		Cards[Lang] = {Btn = Btn, Ring = Ring, Name = Name, Tick = Tick}
		Btn.MouseButton1Click:Connect(function()
			if Window.Lang ~= Lang then
				Window:SetLanguage(Lang)
				Window:QueueSave("ui")
				Window:Notify(Window:T("Language") .. ": " .. Lang)
			end
		end)
	end
	Window:Bind(function(Theme, Instant)
		for Lang, Card in pairs(Cards) do
			local Active = Lang == Window.Lang
			Card.Ring.Color = Theme.Accent
			Card.Ring.Enabled = Active
			Card.Tick.Root.Visible = Active
			Card.Tick:Tint(Theme.Accent, true)
			Util.Tween(Card.Btn, {BackgroundColor3 = Active and Theme.Accent or Theme.Panel, BackgroundTransparency = Active and 0.82 or 0.45}, Instant)
			Util.Tween(Card.Name, {TextColor3 = Active and Tone.White or Tone.Gray}, Instant)
		end
	end)
end

local Container = Class()

function Container:AddSection(Options)
	return Section.new(self, Options or {})
end

function Container:AddStat(Options)
	return Stat.new(self, Options or {})
end

local Column = Class(Container)

function Column.new(Tab, Cell)
	return setmetatable({Window = Tab.Window, Tab = Tab, Holder = Cell}, Column)
end

local Tab = Class(Container)

function Tab.new(Window, Options)
	local Self = setmetatable({}, Tab)
	Self.Window, Self.Tab = Window, Self
	Self.Name = Options.Name or "Tab"
	Self.IconName = Options.Icon or "Grid"
	Self.Title = Options.Title or Self.Name
	Self.Description = Options.Description or ""
	Self.Holder = Util.New("Frame", {BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 0), Visible = false}, Window.Content)
	Util.Pad(Self.Holder, 16, 4, 16, 16)
	Util.List(Self.Holder, 16)
	Self:BuildButton()
	return Self
end

function Tab:BuildButton()
	local Window = self.Window
	self.Button = Util.New("TextButton", {
		AutoButtonColor = false, Text = "", BackgroundTransparency = 1, BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, Profile.BtnH), LayoutOrder = #Window.Tabs + 1,
	}, Window.TabList)
	Util.Corner(self.Button, 13)
	self.Line = Util.Stroke(self.Button, Tone.White, 1, 1)
	self.Bar = Util.New("Frame", {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, -2, 0.5, 0), Size = UDim2.fromOffset(4, 0), BorderSizePixel = 0}, self.Button)
	Util.Corner(self.Bar, 2)
	self.Tile = Util.New("Frame", {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 9, 0.5, 0), Size = UDim2.fromOffset(32, 32), BackgroundColor3 = Tone.White, BackgroundTransparency = 0.92, BorderSizePixel = 0}, self.Button)
	Util.Corner(self.Tile, 10)
	self.Mark = Icon.new(self.IconName, self.Tile, 18):Place(Vector2.new(0.5, 0.5), UDim2.fromScale(0.5, 0.5))
	self.Text = Util.Label(self.Button, self.Name, 14, Fonts.Medium, Tone.Gray, {Position = UDim2.fromOffset(52, 0), Size = UDim2.new(1, -60, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd, Visible = Window.SideW > SideNarrow})
	Window:Loc(self.Text, self.Name)
	self.Button.MouseEnter:Connect(function()
		if Window.Current ~= self then Util.Tween(self.Button, {BackgroundColor3 = Tone.White, BackgroundTransparency = 0.95}, false, 0.12) end
	end)
	self.Button.MouseLeave:Connect(function()
		if Window.Current ~= self then Util.Tween(self.Button, {BackgroundTransparency = 1}, false, 0.12) end
	end)
	self.Button.MouseButton1Click:Connect(function() Window:SelectTab(self) end)
end

function Tab:Paint(Instant)
	local Active = self.Window.Current == self
	local Theme = self.Window.Theme
	self.Text.Font = Active and Fonts.Bold or Fonts.Medium
	Util.Tween(self.Button, {BackgroundColor3 = Theme.Accent, BackgroundTransparency = Active and 0.88 or 1}, Instant)
	Util.Tween(self.Line, {Color = Theme.Accent, Transparency = Active and 0.6 or 1}, Instant)
	Util.Tween(self.Text, {TextColor3 = Active and Tone.White or Tone.Gray}, Instant)
	Util.Tween(self.Bar, {BackgroundColor3 = Theme.Accent, Size = UDim2.fromOffset(4, Active and 24 or 0)}, Instant, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	Util.Tween(self.Tile, {BackgroundColor3 = Active and Theme.Accent or Tone.White, BackgroundTransparency = Active and 0 or 0.92}, Instant)
	self.Mark:Tint(Active and Color3.fromRGB(22, 14, 30) or Tone.Gray, Instant)
end

function Tab:AddColumns(Count, Stack)
	local Frame = Util.New("Frame", {BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 0), LayoutOrder = Util.Next(self.Holder)}, self.Holder)
	local Flow = Util.Flow(Frame, 12, Enum.VerticalAlignment.Top)
	local Row = {Layout = Flow, Count = Count, Stack = Stack == true, Cells = {}}
	local Columns = {}
	for Index = 1, Count do
		local Cell = Util.New("Frame", {BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1 / Count, -12 * (Count - 1) / Count, 0, 0), LayoutOrder = Index}, Frame)
		Util.List(Cell, 12)
		Row.Cells[Index] = Cell
		Columns[Index] = Column.new(self, Cell)
	end
	table.insert(self.Window.Rows, Row)
	self.Window:ApplyRows()
	return Columns
end

local Palette = Class()

function Palette.new(Window)
	local Self = setmetatable({Window = Window, Opened = false, Rows = {}}, Palette)
	Self:Build()
	return Self
end

function Palette:Build()
	local Window = self.Window
	self.Overlay = Util.New("TextButton", {
		Name = "Palette", AutoButtonColor = false, Text = "", BackgroundColor3 = Tone.Black, BackgroundTransparency = 1,
		BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), Visible = false, ZIndex = 90, Active = true,
	}, Window.Gui)
	self.Shell = Util.New("Frame", {AnchorPoint = Vector2.new(0.5, 0), BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromOffset(440, 0)}, self.Overlay)
	self.Card = Util.New("Frame", {AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.fromScale(0.5, 0), Size = UDim2.fromOffset(440, 0), AutomaticSize = Enum.AutomaticSize.Y, BorderSizePixel = 0, Active = true}, self.Shell)
	Util.Corner(self.Card, 16)
	Window:Decorate(self.Card, 1.2, false)
	self.CardScale = Util.New("UIScale", {}, self.Card)
	Util.List(self.Card, 0)
	Window:Bind(function(Theme, Instant)
		Util.Tween(self.Card, {BackgroundColor3 = Theme.Card:Lerp(Tone.Black, 0.3)}, Instant)
	end)
	local Input = Util.New("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 54), LayoutOrder = 1}, self.Card)
	local Mark = Icon.new("Search", Input, 18):Place(Vector2.new(0, 0.5), UDim2.new(0, 18, 0.5, 0))
	Window:Bind(function(Theme, Instant) Mark:Tint(Theme.Accent, Instant) end)
	self.Box = Util.New("TextBox", {
		BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(48, 0), Size = UDim2.new(1, -112, 1, 0),
		Font = Fonts.Medium, TextSize = 14, TextColor3 = Tone.White, PlaceholderText = "Search features...", PlaceholderColor3 = Tone.Muted,
		Text = "", ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left,
	}, Input)
	local Chip = Util.New("Frame", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -16, 0.5, 0), Size = UDim2.fromOffset(36, 20), BackgroundColor3 = Tone.White, BackgroundTransparency = 0.93, BorderSizePixel = 0}, Input)
	Util.Corner(Chip, 6)
	Util.Label(Chip, "ESC", 10, Fonts.Mono, Tone.Gray, {Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center})
	Util.New("Frame", {BackgroundColor3 = Tone.White, BackgroundTransparency = 0.95, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 1), LayoutOrder = 2}, self.Card)
	self.Results = Util.New("Frame", {BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 0), LayoutOrder = 3}, self.Card)
	Util.Pad(self.Results, 8, 8, 8, 4)
	Util.List(self.Results, 2)
	Window:Loc(Util.Label(self.Card, "Enter to open  ·  Esc to close", 10, Fonts.Regular, Tone.Muted, {LayoutOrder = 4, Size = UDim2.new(1, 0, 0, 28), TextXAlignment = Enum.TextXAlignment.Center}), "Enter to open  ·  Esc to close")
	self.Box:GetPropertyChangedSignal("Text"):Connect(function() self:Render() end)
	Window:Loc(self.Box, "Search features...", "PlaceholderText")
	self.Box.FocusLost:Connect(function(Enter)
		if Enter and self.Picked then self:Choose(self.Picked) end
	end)
	self.Overlay.MouseButton1Click:Connect(function() self:Close() end)
end

function Palette:Collect(Query)
	local Out = {}
	local Window = self.Window
	for _, Tab in ipairs(Window.Tabs) do
		if Query == "" or Tab.Name:lower():find(Query, 1, true) or Window:T(Tab.Name):lower():find(Query, 1, true) then
			table.insert(Out, {Title = Window:T(Tab.Name), Sub = Window:T("Page"), Tab = Tab})
		end
	end
	if Query ~= "" then
		for _, Feature in ipairs(Window.Features) do
			if Feature.Name:lower():find(Query, 1, true) or Window:T(Feature.Name):lower():find(Query, 1, true) then
				table.insert(Out, {Title = Window:T(Feature.Name), Sub = Window:T(Feature.Tab.Name), Tab = Feature.Tab})
			end
		end
	end
	return Out
end

function Palette:Render()
	for _, Obj in ipairs(self.Rows) do Obj:Destroy() end
	table.clear(self.Rows)
	local Theme = self.Window.Theme
	local Items = self:Collect(self.Box.Text:lower())
	self.Picked = Items[1]
	for Index = 1, math.min(#Items, 7) do
		local Item = Items[Index]
		local First = Index == 1
		local Btn = Util.New("TextButton", {
			AutoButtonColor = false, Text = "", BackgroundColor3 = First and Theme.Accent or Tone.White, BackgroundTransparency = First and 0.88 or 1,
			BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 40), LayoutOrder = Index,
		}, self.Results)
		Util.Corner(Btn, 9)
		local Mark = Icon.new(Item.Tab.IconName, Btn, 16):Place(Vector2.new(0, 0.5), UDim2.new(0, 14, 0.5, 0))
		Mark:Tint(First and Theme.Accent or Tone.Gray, true)
		Util.Label(Btn, Item.Title, 13, Fonts.Medium, Tone.White, {Position = UDim2.fromOffset(42, 0), Size = UDim2.new(1, -150, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd})
		Util.Label(Btn, Item.Sub, 11, Fonts.Regular, Tone.Gray, {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -14, 0, 0), Size = UDim2.new(0, 96, 1, 0), TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd})
		Btn.MouseEnter:Connect(function() Btn.BackgroundTransparency = First and 0.82 or 0.94 end)
		Btn.MouseLeave:Connect(function() Btn.BackgroundTransparency = First and 0.88 or 1 end)
		Btn.MouseButton1Click:Connect(function() self:Choose(Item) end)
		table.insert(self.Rows, Btn)
	end
	if #Items == 0 then
		table.insert(self.Rows, Util.Label(self.Results, self.Window:T("No results"), 12, Fonts.Regular, Tone.Gray, {Size = UDim2.new(1, 0, 0, 44), TextXAlignment = Enum.TextXAlignment.Center}))
	end
end

function Palette:Choose(Item)
	self:Close()
	self.Window:SelectTab(Item.Tab)
end

function Palette:Open()
	local Window = self.Window
	Window:CloseDropdown()
	Window.Minimized = false
	Window:Layout()
	local Scale = Window.BaseScale
	local Left, Top, Right = Window:Bounds()
	local CardWidth = math.min(440, (Right - Left) / Scale - 40)
	self.Opened = true
	self.Box.Text = ""
	self:Render()
	self.Shell.Size = UDim2.fromOffset(CardWidth * Scale, 0)
	self.Shell.Position = UDim2.fromOffset((Left + Right) / 2, Top + 62 * Scale)
	self.Card.Size = UDim2.fromOffset(CardWidth, 0)
	self.Overlay.Visible = true
	self.Overlay.BackgroundTransparency = 1
	self.CardScale.Scale = Scale * 0.9
	Util.Tween(self.Overlay, {BackgroundTransparency = 0.5}, false, 0.2)
	Util.Pop(self.CardScale, {Scale = Scale}, 0.4)
	task.defer(function() self.Box:CaptureFocus() end)
end

function Palette:Close()
	if self.Opened then
		self.Opened = false
		self.Box:ReleaseFocus()
		Util.Tween(self.Overlay, {BackgroundTransparency = 1}, false, 0.15)
		Util.Tween(self.CardScale, {Scale = self.Window.BaseScale * 0.94}, false, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		task.delay(0.16, function() self.Overlay.Visible = self.Opened end)
	end
end

local function Orb(Low, High, Colors, Transparency)
	return function(Layer)
		local Size = Rng:NextInteger(Low, High)
		local Obj = Util.New("Frame", {
			BackgroundColor3 = Colors[Rng:NextInteger(1, #Colors)], BackgroundTransparency = Transparency, BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(Size, Size),
		}, Layer)
		Util.Corner(Obj, Size)
		return Obj
	end
end

local function Spark(Colors)
	return function(Layer)
		local Obj = Util.New("Frame", {
			BackgroundColor3 = Colors[Rng:NextInteger(1, #Colors)], BackgroundTransparency = 0.5, BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(2, Rng:NextInteger(8, 14)),
		}, Layer)
		Util.Corner(Obj, 1)
		return Obj
	end
end

local function Digits(Color)
	return function(Layer)
		local Rows = {}
		for Index = 1, 14 do Rows[Index] = tostring(Rng:NextInteger(0, 1)) end
		return Util.New("TextLabel", {
			BackgroundTransparency = 1, BorderSizePixel = 0, Text = table.concat(Rows, "\n"), Font = Fonts.Mono, TextSize = 10,
			TextColor3 = Color, TextTransparency = 0.82, TextYAlignment = Enum.TextYAlignment.Top, Size = UDim2.fromOffset(12, 170),
		}, Layer)
	end
end

local Decor = Class()

function Decor.new(Window)
	local Self = setmetatable({Window = Window, Token = 0, Parts = {}, Wide = true}, Decor)
	Self.Back = Util.New("Frame", {Name = "DecorBack", BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 0, ClipsDescendants = true}, Window.Main)
	Self.Front = Util.New("Frame", {Name = "DecorFront", BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 15, ClipsDescendants = true}, Window.Main)
	return Self
end

function Decor:Track(Obj)
	table.insert(self.Parts, Obj)
	return Obj
end

function Decor:Build(Name)
	self.Token = self.Token + 1
	for _, Obj in ipairs(self.Parts) do Obj:Destroy() end
	table.clear(self.Parts)
	self.ClusterFrame = nil
	local Scene = Decor.Scenes[Name]
	if Scene then Scene(self, self.Window.Theme) end
end

function Decor:SetWide(Wide)
	self.Wide = Wide
	if self.ClusterFrame then self.ClusterFrame.Visible = Wide end
end

function Decor:Loop(Obj, Props, Duration, Reverse, Style, Wait)
	local Token = self.Token
	task.delay(Wait or 0, function()
		if Token == self.Token then
			TS:Create(Obj, TweenInfo.new(Duration, Style or Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, Reverse == true), Props):Play()
		end
	end)
end

function Decor:Drift(Layer, Count, Make, Rise, MinTime, MaxTime, Sway)
	local Token = self.Token
	for _ = 1, Count do
		local Obj = self:Track(Make(Layer))
		local X = Rng:NextNumber(0.03, 0.97)
		local Duration = Rng:NextNumber(MinTime, MaxTime)
		Obj.Visible = false
		Obj.Position = UDim2.fromScale(X, Rise and 1.05 or -0.08)
		task.delay(Rng:NextNumber(0, Duration), function()
			if Token == self.Token then
				Obj.Visible = true
				TS:Create(Obj, TweenInfo.new(Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1), {
					Position = UDim2.fromScale(X + Rng:NextNumber(-Sway, Sway), Rise and -0.1 or 1.05),
				}):Play()
			end
		end)
	end
end

function Decor:Cluster(List)
	local Frame = self:Track(Util.New("Frame", {
		BackgroundTransparency = 1, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, self.Window.SideW / 2, 0, 18),
		Size = UDim2.fromOffset(#List * 34, 28), Visible = self.Wide,
	}, self.Front))
	self.ClusterFrame = Frame
	for Index, Glyph in ipairs(List) do
		local Home = UDim2.fromOffset(17 + (Index - 1) * 34, 14)
		local Item = Util.New("TextLabel", {
			BackgroundTransparency = 1, BorderSizePixel = 0, Text = Glyph, Font = Fonts.Regular, TextSize = 4,
			AnchorPoint = Vector2.new(0.5, 0.5), Position = Home, Size = UDim2.fromOffset(30, 28),
		}, Frame)
		Util.Tween(Item, {TextSize = 21}, false, 0.5 + Index * 0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		self:Loop(Item, {Position = UDim2.fromOffset(17 + (Index - 1) * 34, 10)}, 1.2 + Index * 0.3, true)
		self:Loop(Item, {Rotation = Index % 2 == 0 and 8 or -8}, 1.6 + Index * 0.25, true)
	end
end

function Decor:Fly(Glyph, Duration, Wait, Y)
	local Token = self.Token
	local Bat = self:Track(Util.New("TextLabel", {
		BackgroundTransparency = 1, BorderSizePixel = 0, Text = Glyph, Font = Fonts.Regular, TextSize = 14, TextTransparency = 0.25,
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(-0.05, 0, 0, Y), Size = UDim2.fromOffset(20, 20),
	}, self.Front))
	task.delay(Wait, function()
		if Token == self.Token then
			TS:Create(Bat, TweenInfo.new(Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1), {Position = UDim2.new(1.05, 0, 0, Y)}):Play()
		end
	end)
	self:Loop(Bat, {Rotation = 14}, 0.35, true)
end

function Decor:Lights(Colors)
	local Count = 18
	for Index = 1, Count do
		local Bulb = self:Track(Util.New("Frame", {
			BackgroundColor3 = Colors[(Index - 1) % #Colors + 1], BackgroundTransparency = 0.2, BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new((Index - 0.5) / Count, 0, 0, 3), Size = UDim2.fromOffset(5, 5),
		}, self.Front))
		Util.Corner(Bulb, 3)
		self:Loop(Bulb, {BackgroundTransparency = 0.85}, Rng:NextNumber(0.6, 1.6), true, nil, Rng:NextNumber(0, 1))
	end
end

function Decor:Stars(Theme)
	for Index = 1, 18 do
		local Size = Rng:NextInteger(3, 5)
		local Star = self:Track(Util.New("Frame", {
			BackgroundColor3 = Index % 2 == 0 and Theme.Accent or Theme.Accent2, BackgroundTransparency = 0.8, BorderSizePixel = 0, Rotation = 45,
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(Rng:NextNumber(0.02, 0.98), Rng:NextNumber(0.1, 0.98)), Size = UDim2.fromOffset(Size, Size),
		}, self.Back))
		self:Loop(Star, {BackgroundTransparency = 0.25}, Rng:NextNumber(0.9, 2.2), true, nil, Rng:NextNumber(0, 2))
	end
end

function Decor:Scan(Theme)
	local Bar = self:Track(Util.New("Frame", {BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.88, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 2), Position = UDim2.fromScale(0, -0.02)}, self.Back))
	TS:Create(Bar, TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1), {Position = UDim2.fromScale(0, 1.02)}):Play()
end

function Decor:Tag(Text, Theme)
	local Token = self.Token
	local Tag = self:Track(Util.New("TextLabel", {
		BackgroundTransparency = 1, BorderSizePixel = 0, Text = Text, Font = Fonts.Mono, TextSize = 10, TextColor3 = Theme.Accent, TextTransparency = 0.35,
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(1, -9, 0.5, 0), Size = UDim2.fromOffset(240, 12), Rotation = 90,
	}, self.Front))
	task.spawn(function()
		local Glyphs = "01<>/[]{}#$%&*"
		while Token == self.Token do
			for Reveal = 0, #Text do
				local Out = {}
				for Index = 1, #Text do
					local Char = Text:sub(Index, Index)
					local Pick = Rng:NextInteger(1, #Glyphs)
					Out[Index] = (Index <= Reveal or Char == " ") and Char or Glyphs:sub(Pick, Pick)
				end
				Tag.Text = table.concat(Out)
				task.wait(0.05)
			end
			task.wait(3)
		end
	end)
end

Decor.Scenes = {
	Halloween = function(Self, Theme)
		Self:Drift(Self.Back, 16, Orb(2, 5, {Theme.Accent, Theme.Accent2}, 0.55), true, 7, 13, 0.05)
		Self:Cluster({"🦇", "🎃", "👻"})
		Self:Fly("🦇", 16, 0, 8)
		Self:Fly("🦇", 22, 7, 20)
	end,
	Christmas = function(Self, Theme)
		Self:Drift(Self.Back, 26, Orb(2, 5, {Tone.White}, 0.35), false, 8, 15, 0.06)
		Self:Cluster({"🎄", "⛄", "🎁"})
		Self:Lights({Theme.Accent, Theme.Accent2, Color3.fromRGB(250, 204, 21), Tone.White})
	end,
	Hacker = function(Self, Theme)
		Self:Drift(Self.Back, 9, Digits(Theme.Accent), false, 6, 11, 0)
		Self:Scan(Theme)
		Self:Tag("H A C K E R  //  ACCESS GRANTED", Theme)
	end,
	Classic = function(Self, Theme)
		Self:Stars(Theme)
		Self:Cluster({"🚀", "⭐"})
	end,
	Purple = function(Self, Theme)
		Self:Drift(Self.Back, 8, Orb(16, 44, {Theme.Accent, Theme.Accent2}, 0.93), true, 12, 20, 0.08)
		Self:Cluster({"🔮", "🌙"})
	end,
	Crimson = function(Self, Theme)
		Self:Drift(Self.Back, 14, Spark({Theme.Accent, Theme.Accent2}), true, 4, 8, 0.03)
		Self:Cluster({"🔥", "💀"})
	end,
}

local Window = Class()

function Window.new(Options)
	local Self = setmetatable({}, Window)
	Self.Name = Options.Name or "Yokid"
	Self.Tag = Options.Tag
	Self.FooterText = Options.Footer or ""
	Self.ToggleKey = Options.ToggleKey or Enum.KeyCode.RightControl
	Self.StatusText = Options.Status
	Self.Discord = Options.Discord
	Self.OnUnload = Options.OnUnload
	Self.Unloaded = false
	Self.ThemeName = Themes[Options.Theme] and Options.Theme or "Halloween"
	Self.Theme = Themes[Self.ThemeName]
	Self.Painters = {}
	Self.Maid = Maid.new()
	Self.Flags = {}
	Self.Elements = {}
	Self.Features = {}
	Self.Tabs = {}
	Self.Rows = {}
	Self.Sliders = {}
	Self.TipToken = 0
	Self.Locales = {}
	Self.LangOrder = {}
	for _, Lang in ipairs(Library.LangOrder) do
		Self.LangOrder[#Self.LangOrder + 1] = Lang
		Self.Locales[Lang] = {}
		for Key, Value in pairs(Library.Locales[Lang] or {}) do Self.Locales[Lang][Key] = Value end
	end
	Self.Lang = Self.Locales[Options.Language] and Options.Language or "English"
	Self.Localized = {}
	Self.ConfigFolder = Clean(Options.ConfigFolder or "Yokid")
	Self.MapName = Clean(Options.MapName or "Default")
	Self.AutoSave = Options.AutoSave ~= false
	Self.Loading = false
	Self.Dirty = {}
	Self.SideW = SideWide
	Self.Compact, Self.Minimized, Self.Maximized = false, false, false
	Self.UserScale = 1
	Self.Background = Backgrounds[1]
	Self.Notifications = true
	Self.Shown = true
	Self.Decorated = {}
	Self.BaseScale = 1
	Self.SizeW, Self.SizeH = BaseW, BaseH
	Self.PixelW, Self.PixelH = BaseW, BaseH
	Self:BuildGui()
	Self:BuildTopbar()
	Self:BuildBody()
	Self.Decor = Decor.new(Self)
	Self.Decor:Build(Self.ThemeName)
	Self.Palette = Palette.new(Self)
	Self.Toaster = Notifier.new(Self)
	Self:BuildTip()
	Self:BuildFab()
	Self:BindInput()
	Self:Layout()
	Self:SetVisible(true)
	return Self
end

function Window:Decorate(Frame, Thickness, Tint)
	local Line = Util.New("UIStroke", {Color = Tone.White, Transparency = 0, Thickness = Thickness or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, Frame)
	local Grad = Util.New("UIGradient", {Rotation = 35, Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(0.5, 0.88), NumberSequenceKeypoint.new(1, 0.62),
	})}, Line)
	Grad.Color = ColorSequence.new(self.Theme.Accent, self.Theme.Accent2)
	table.insert(self.Decorated, {Frame = Frame, Grad = Grad, Tint = Tint ~= false})
	if Tint ~= false then Frame.BackgroundColor3 = self.Theme.Panel:Lerp(Tone.Black, 0.3) end
	return Line
end

function Window:Hint(Parent, Text, Order)
	local Size = Profile.HintSize
	local Btn = Util.New("TextButton", {
		Text = "", AutoButtonColor = false, BackgroundColor3 = Tone.White, BackgroundTransparency = 0.9,
		BorderSizePixel = 0, Size = UDim2.fromOffset(Size, Size), LayoutOrder = Order or 2,
	}, Parent)
	Util.Corner(Btn, Size / 2)
	Util.Stroke(Btn, Tone.White, 0.78, 1)
	Util.Label(Btn, "?", 12, Fonts.Bold, Tone.Light, {Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center})
	if IsMobile then
		Btn.InputBegan:Connect(function(Input)
			if Util.IsPress(Input) then
				local Held, Done = false, false
				task.delay(0.35, function()
					if not Done then
						Held = true
						self:ShowTip(Btn, self:T(Text), true)
					end
				end)
				local Link
				Link = Input.Changed:Connect(function()
					local State = Input.UserInputState
					if State == Enum.UserInputState.End or State == Enum.UserInputState.Cancel then
						Done = true
						Link:Disconnect()
						if Held then
							self:HideTip(Btn)
						elseif self.TipOwner == Btn then
							self:HideTip()
						else
							self:ShowTip(Btn, self:T(Text), false)
						end
					end
				end)
			end
		end)
	else
		Btn.MouseEnter:Connect(function()
			Util.Tween(Btn, {BackgroundTransparency = 0.8}, false, 0.12)
			self:ShowTip(Btn, self:T(Text), true)
		end)
		Btn.MouseLeave:Connect(function()
			Util.Tween(Btn, {BackgroundTransparency = 0.9}, false, 0.12)
			self:HideTip(Btn)
		end)
	end
	return Btn
end

function Window:NameTag(Parent, Text, Desc, Position, MaxW, Size, Font, Color, Reserve)
	local Holder = Util.New("Frame", {
		BackgroundTransparency = 1, BorderSizePixel = 0, AnchorPoint = Vector2.new(0, 0.5), Position = Position,
		Size = UDim2.new(0, 0, 0, 26), AutomaticSize = Enum.AutomaticSize.X,
	}, Parent)
	Util.Flow(Holder, 8)
	local Label = Util.Label(Holder, Text, Size or 14, Font or Fonts.Medium, Color or Tone.Light, {
		LayoutOrder = 1, Size = UDim2.new(0, 0, 0, 26), AutomaticSize = Enum.AutomaticSize.X, TextTruncate = Enum.TextTruncate.AtEnd,
	})
	local Limit = Util.New("UISizeConstraint", {MaxSize = Vector2.new(MaxW or 220, 26)}, Label)
	if Reserve then
		local function Fit()
			local Room = Parent.AbsoluteSize.X / self.BaseScale - 16 - Reserve - ((Desc and Desc ~= "") and 28 or 0)
			Limit.MaxSize = Vector2.new(math.clamp(Room, 40, MaxW or 220), 26)
		end
		Parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(Fit)
		Fit()
	end
	self:Loc(Label, Text)
	if Desc and Desc ~= "" then self:Hint(Holder, Desc, 2) end
	return Holder, Label
end

function Window:BuildTip()
	self.Tip = Util.New("Frame", {Visible = false, BorderSizePixel = 0, ZIndex = 220, Size = UDim2.fromOffset(TipW, 40)}, self.Gui)
	Util.Corner(self.Tip, 12)
	self:Decorate(self.Tip, 1, false)
	self.TipScale = Util.New("UIScale", {}, self.Tip)
	self.TipText = Util.Label(self.Tip, "", 12, Fonts.Medium, Tone.Light, {
		Position = UDim2.fromOffset(12, 10), Size = UDim2.new(1, -24, 1, -20), TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 221,
	})
	self:Bind(function(Theme, Instant)
		Util.Tween(self.Tip, {BackgroundColor3 = Theme.Card:Lerp(Tone.Black, 0.3)}, Instant)
	end)
end

function Window:ShowTip(Btn, Text, Hold)
	local Camera = workspace.CurrentCamera
	if Camera then
		self.TipToken = self.TipToken + 1
		local Token = self.TipToken
		local Scale = self.BaseScale
		local Bounds = TextService:GetTextSize(Text, 12, Fonts.Medium, Vector2.new(TipW - 24, 1000))
		local Height = math.ceil(Bounds.Y) + 22
		local Viewport = Camera.ViewportSize
		local Pos, Size = Btn.AbsolutePosition, Btn.AbsoluteSize
		local PixelW, PixelH = TipW * Scale, Height * Scale
		local X = math.clamp(Pos.X + Size.X / 2 - PixelW / 2, 8, math.max(Viewport.X - PixelW - 8, 8))
		local Y = Pos.Y + Size.Y + 6 * Scale
		if Y + PixelH > Viewport.Y - 8 then Y = Pos.Y - 6 * Scale - PixelH end
		self.TipOwner = Btn
		self.TipText.Text = Text
		self.Tip.Size = UDim2.fromOffset(TipW, Height)
		self.Tip.Position = UDim2.fromOffset(X, Y)
		self.TipScale.Scale = Scale * 0.92
		self.Tip.Visible = true
		Util.Pop(self.TipScale, {Scale = Scale}, 0.3)
		if not Hold then
			task.delay(4, function()
				if self.TipToken == Token then self:HideTip() end
			end)
		end
	end
end

function Window:HideTip(Owner)
	if Owner == nil or self.TipOwner == Owner then
		self.TipToken = self.TipToken + 1
		self.TipOwner = nil
		if self.Tip then self.Tip.Visible = false end
	end
end

function Window:Listen(Obj)
	self:StopBinding()
	self.Binding = Obj
	Obj.Waiting = true
	Obj:Paint(false)
end

function Window:StopBinding()
	local Obj = self.Binding
	if Obj then
		self.Binding = nil
		Obj.Waiting = false
		Obj:Paint(false)
	end
end

function Window:SetToggleKey(Key)
	self.ToggleKey = Key
	if self.HintLabel then self.HintLabel.Text = self:HintText() end
end

function Window:T(Key)
	local Map = self.Locales[self.Lang]
	local Text = tostring(Key)
	return Map and Map[Text] or Text
end

function Window:Loc(Obj, Key, Prop)
	Prop = Prop or "Text"
	table.insert(self.Localized, {Obj = Obj, Key = tostring(Key), Prop = Prop})
	Obj[Prop] = self:T(Key)
	return Obj
end

function Window:Retext(Obj, Key, Prop)
	Prop = Prop or "Text"
	for _, Entry in ipairs(self.Localized) do
		if Entry.Obj == Obj and Entry.Prop == Prop then
			Entry.Key = tostring(Key)
			Obj[Prop] = self:T(Key)
			return Obj
		end
	end
	return self:Loc(Obj, Key, Prop)
end

function Window:ApplyPage()
	local Page = self.Current
	if Page then
		self.PageTitle.Text = self:T(Page.Title)
		self.PageDesc.Text = self:T(Page.Description)
	end
end

function Window:SetLanguage(Lang)
	if self.Locales[Lang] then
		self.Lang = Lang
		self:HideTip()
		local Alive = {}
		for _, Entry in ipairs(self.Localized) do
			if Entry.Obj.Parent then
				Entry.Obj[Entry.Prop] = self:T(Entry.Key)
				table.insert(Alive, Entry)
			end
		end
		self.Localized = Alive
		self:ApplyPage()
		if self.HintLabel then self.HintLabel.Text = self:HintText() end
		for _, Painter in ipairs(self.Painters) do Painter(self.Theme, true) end
		if self.Palette and self.Palette.Opened then self.Palette:Render() end
		if self.Current then
			self.Current.Holder.Position = UDim2.fromOffset(0, 10)
			Util.Tween(self.Current.Holder, {Position = UDim2.fromOffset(0, 0)}, false, 0.4, Enum.EasingStyle.Quint)
		end
	end
end

function Window:AddTranslations(Lang, Map)
	if not self.Locales[Lang] then
		self.Locales[Lang] = {}
		table.insert(self.LangOrder, Lang)
	end
	for Key, Value in pairs(Map) do self.Locales[Lang][Key] = Value end
	if Lang == self.Lang then self:SetLanguage(Lang) end
end

function Window:MapFile()
	return self.ConfigFolder .. "/" .. self.MapName .. "/" .. Clean(LocalPlayer.Name) .. ".json"
end

function Window:UIFile()
	return self.ConfigFolder .. "/SettingsUI.json"
end

function Window:WriteFile(Path, Data)
	if HasFiles() then
		return (pcall(function()
			if type(makefolder) == "function" and type(isfolder) == "function" then
				local Folder = ""
				for Part in Path:gmatch("([^/]+)/") do
					Folder = Folder == "" and Part or (Folder .. "/" .. Part)
					if not isfolder(Folder) then makefolder(Folder) end
				end
			end
			writefile(Path, HttpService:JSONEncode(Data))
		end))
	end
	return false
end

function Window:ReadFile(Path)
	if HasFiles() then
		local Ok, Data = pcall(function()
			if isfile(Path) then return HttpService:JSONDecode(readfile(Path)) end
			return nil
		end)
		if Ok and type(Data) == "table" then return Data end
	end
	return nil
end

function Window:Snapshot(Scope)
	local Out = {}
	for Flag, Obj in pairs(self.Elements) do
		local Value = self.Flags[Flag]
		if Obj.Scope == Scope and Obj.Persist ~= false and Value ~= nil then Out[Flag] = Encode(Value) end
	end
	return Out
end

function Window:Restore(Scope, Flags)
	self.Loading = true
	for Flag, Raw in pairs(Flags or {}) do
		local Obj = self.Elements[Flag]
		local Value = Decode(Raw)
		if Obj and Obj.Scope == Scope and Obj.Persist ~= false and Value ~= nil then
			pcall(function() Obj:Set(Value) end)
		end
	end
	self.Loading = false
end

function Window:SaveConfig(Silent)
	local Ok = self:WriteFile(self:MapFile(), {Map = self.MapName, Player = LocalPlayer.Name, Flags = self:Snapshot("map")})
	if not Silent then self:Notify(Ok and "Config saved" or "File system not supported") end
	return Ok
end

function Window:LoadConfig(Silent)
	local Data = self:ReadFile(self:MapFile())
	if Data then
		self:Restore("map", Data.Flags)
		if not Silent then self:Notify("Config loaded") end
		return true
	end
	if not Silent then self:Notify("No config found") end
	return false
end

function Window:SaveUI()
	return self:WriteFile(self:UIFile(), {Theme = self.ThemeName, Language = self.Lang, Flags = self:Snapshot("ui")})
end

function Window:LoadUI()
	local Data = self:ReadFile(self:UIFile())
	if Data then
		if Themes[Data.Theme] then self:SetTheme(Data.Theme) end
		if Data.Language and self.Locales[Data.Language] then self:SetLanguage(Data.Language) end
		self:Restore("ui", Data.Flags)
	end
end

function Window:SetMapName(Name)
	self.MapName = Clean(Name)
	if self.PathNote then self.PathNote:SetContent(self:MapFile()) end
end

function Window:Loop(Flag, Delay, Fn)
	local Run = 0
	return function(On)
		Run = Run + 1
		local Id = Run
		if On then
			task.spawn(function()
				while self.Flags[Flag] and Run == Id do
					local Ok, Err = pcall(Fn)
					if not Ok then warn("[Yokid] " .. tostring(Flag) .. ": " .. tostring(Err)) end
					task.wait(type(Delay) == "function" and Delay() or Delay)
				end
			end)
		end
	end
end

function Window:QueueSave(Scope)
	if self.Loading or not HasFiles() then return end
	if Scope == "map" and not self.AutoSave then return end
	self.Dirty[Scope] = true
	if not self.SaveQueued then
		self.SaveQueued = true
		task.delay(0.8, function()
			self.SaveQueued = false
			local Pending = self.Dirty
			self.Dirty = {}
			if Pending.ui then self:SaveUI() end
			if Pending.map then self:SaveConfig(true) end
		end)
	end
end

function Window:Bind(Painter)
	table.insert(self.Painters, Painter)
	Painter(self.Theme, true)
end

function Window:Register(Name, Tab)
	table.insert(self.Features, {Name = Name, Tab = Tab})
end

function Window:Mount()
	local Hosts = {}
	pcall(function() table.insert(Hosts, gethui()) end)
	pcall(function() table.insert(Hosts, game:GetService("CoreGui")) end)
	table.insert(Hosts, LocalPlayer:WaitForChild("PlayerGui"))
	for _, Host in ipairs(Hosts) do
		pcall(function()
			local Old = Host:FindFirstChild("Yokid")
			if Old then Old:Destroy() end
		end)
	end
	for _, Host in ipairs(Hosts) do
		if not self.Gui.Parent then
			pcall(function() self.Gui.Parent = Host end)
		end
	end
end

function Window:BuildGui()
	self.Gui = Util.New("ScreenGui", {Name = "Yokid", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling}, nil)
	self:Mount()
	self.Root = Util.New("Frame", {
		Name = "Root", BackgroundTransparency = 1, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(BaseW, BaseH),
	}, self.Gui)
	self.Aura = Util.New("Frame", {
		Name = "Aura", BackgroundTransparency = 1, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(1, 8, 1, 8),
	}, self.Root)
	Util.Corner(self.Aura, 20)
	self.AuraLine = Util.Stroke(self.Aura, Tone.White, 0.84, 4)
	self.Main = Util.New("Frame", {
		Name = "Main", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(BaseW, BaseH),
		BackgroundTransparency = 0.03, BorderSizePixel = 0, ClipsDescendants = true, Active = true,
	}, self.Root)
	Util.Corner(self.Main, 16)
	local Line = Util.New("UIStroke", {Color = Tone.White, Transparency = 0, Thickness = 1.2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, self.Main)
	local Glow = Util.New("UIGradient", {Rotation = 0, Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(0.5, 0.86), NumberSequenceKeypoint.new(1, 0.3),
	})}, Line)
	TS:Create(Glow, TweenInfo.new(9, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1), {Rotation = 360}):Play()
	local Shade = Util.New("Frame", {Name = "Shade", BackgroundColor3 = Tone.Black, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 0}, self.Main)
	Util.Corner(Shade, 16)
	Util.New("UIGradient", {Rotation = 90, Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(0.16, 0.72), NumberSequenceKeypoint.new(0.5, 0.92),
		NumberSequenceKeypoint.new(0.84, 0.72), NumberSequenceKeypoint.new(1, 0.26),
	})}, Shade)
	self.ScaleObj = Util.New("UIScale", {}, self.Main)
	self.Catcher = Util.New("TextButton", {AutoButtonColor = false, Text = "", BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), Visible = false, ZIndex = 95, Active = true}, self.Gui)
	self.Catcher.MouseButton1Click:Connect(function() self:CloseDropdown() end)
	self:Bind(function(Theme, Instant)
		local Minimal = self.Background == "Ultra Dark Minimal"
		Util.Tween(self.Main, {BackgroundColor3 = Minimal and Theme.Bg or Theme.Card:Lerp(Theme.Bg, 0.4), BackgroundTransparency = Minimal and 0 or 0.03}, Instant)
		Glow.Color = ColorSequence.new(Theme.Accent, Theme.Accent2)
		Util.Tween(self.AuraLine, {Color = Theme.Accent}, Instant)
		for _, Entry in ipairs(self.Decorated) do
			Entry.Grad.Color = ColorSequence.new(Theme.Accent, Theme.Accent2)
			if Entry.Tint then Util.Tween(Entry.Frame, {BackgroundColor3 = Theme.Panel:Lerp(Tone.Black, 0.3)}, Instant) end
		end
		for _, Obj in ipairs(self.GridLines or {}) do Util.Tween(Obj, {BackgroundColor3 = Theme.Accent}, Instant) end
	end)
end

function Window:BuildTopbar()
	self.Side = Util.New("Frame", {Name = "Side", BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Size = UDim2.new(0, self.SideW, 1, 0)}, self.Main)
	self.SideFill = Util.New("Frame", {BorderSizePixel = 0, Size = UDim2.new(0, self.SideW + 24, 1, 0)}, self.Side)
	Util.Corner(self.SideFill, 16)
	local Rule = Util.New("Frame", {BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromScale(1, 0), Size = UDim2.new(0, 1, 1, 0)}, self.Side)
	Util.New("UIGradient", {Rotation = 90, Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.66), NumberSequenceKeypoint.new(1, 1),
	})}, Rule)
	local Brand = Util.New("Frame", {Name = "Brand", BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, HeaderH)}, self.Side)
	Draggable.new(self.Maid, Brand, self.Root, nil, function() self:ClampMain() end)
	self.Logo = Util.New("ImageLabel", {
		AnchorPoint = Vector2.new(0, 0.5), 
		Position = UDim2.new(0, 18, 0.5, 0), 
		Size = UDim2.fromOffset(38, 38), 
		BackgroundTransparency = 1,
		Image = "rbxassetid://140190431279965",
		BorderSizePixel = 0
	}, Brand)
	Util.Corner(self.Logo, 12)
	self.BrandName = Util.Label(Brand, string.upper(self.Name), 17, Fonts.Tech, Tone.White, {Position = UDim2.fromOffset(68, self.Tag and 12 or 20), Size = UDim2.new(1, -76, 0, 22), TextTruncate = Enum.TextTruncate.AtEnd})
	local NameGrad = Util.New("UIGradient", {}, self.BrandName)
	if self.Tag then
		self.BrandTag = Util.Label(Brand, string.upper(self.Tag), 9, Fonts.Tech, Tone.Gray, {Position = UDim2.fromOffset(68, 36), Size = UDim2.new(1, -76, 0, 14)})
	end
	self.Header = Util.New("Frame", {Name = "Header", BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(self.SideW, 0), Size = UDim2.new(1, -self.SideW, 0, HeaderH)}, self.Main)
	Draggable.new(self.Maid, self.Header, self.Root, nil, function() self:ClampMain() end)
	local HeadLine = Util.New("Frame", {BorderSizePixel = 0, AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.new(1, 0, 0, 1)}, self.Header)
	Util.New("UIGradient", {Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.72), NumberSequenceKeypoint.new(1, 1),
	})}, HeadLine)
	self.TitleBlock = Util.New("Frame", {BackgroundTransparency = 1, Position = UDim2.fromOffset(22, 0), Size = UDim2.new(1, -280, 1, 0)}, self.Header)
	self.PageTitle = Util.Label(self.TitleBlock, "", Profile.TitleSize, Fonts.Tech, Tone.White, {Position = UDim2.fromOffset(0, Profile.TitleY), Size = UDim2.new(1, 0, 0, Profile.TitleH), TextTruncate = Enum.TextTruncate.AtEnd})
	self.PageDesc = Util.Label(self.TitleBlock, "", 12, Fonts.Medium, Tone.Gray, {Position = UDim2.fromOffset(0, Profile.DescY), Size = UDim2.new(1, 0, 0, 18), TextTruncate = Enum.TextTruncate.AtEnd})
	local Controls = Util.New("Frame", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, Profile.DotsX, 0.5, 0), Size = UDim2.fromOffset(Profile.DotsW, Profile.Dot)}, self.Header)
	Util.Flow(Controls, 8)
	local function Dot(Color, Order)
		local Btn = Util.New("TextButton", {Text = "", AutoButtonColor = false, BackgroundColor3 = Color, BackgroundTransparency = 0.1, BorderSizePixel = 0, Size = UDim2.fromOffset(Profile.Dot, Profile.Dot), LayoutOrder = Order}, Controls)
		Util.Corner(Btn, Profile.Dot / 2)
		Btn.MouseEnter:Connect(function() Util.Tween(Btn, {BackgroundTransparency = 0}, false, 0.15) end)
		Btn.MouseLeave:Connect(function() Util.Tween(Btn, {BackgroundTransparency = 0.1}, false, 0.15) end)
		return Btn
	end
	Dot(Color3.fromRGB(234, 179, 8), 1).MouseButton1Click:Connect(function()
		self.Minimized = not self.Minimized
		self:Layout(true)
	end)
	Dot(Color3.fromRGB(34, 197, 94), 2).MouseButton1Click:Connect(function()
		self.Maximized = not self.Maximized
		self.Root.Position = UDim2.fromScale(0.5, 0.5)
		self:Layout(true)
		self:Notify(self.Maximized and "Fullscreen" or "Windowed")
	end)
	Dot(Color3.fromRGB(239, 68, 68), 3).MouseButton1Click:Connect(function()
		self:SetVisible(false)
		self:Notify(self:T("UI Hidden") .. " - " .. self:HintText())
	end)
	local Find = Util.New("TextButton", {
		Text = "", AutoButtonColor = false, BackgroundColor3 = Tone.White, BackgroundTransparency = 0.94, BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, Profile.FindX, 0.5, 0), Size = UDim2.fromOffset(Profile.FindSize, Profile.FindSize),
	}, self.Header)
	Util.Corner(Find, 11)
	Util.Stroke(Find, Tone.White, 0.9, 1)
	local Glass = Icon.new("Search", Find, 18):Place(Vector2.new(0.5, 0.5), UDim2.fromScale(0.5, 0.5))
	Find.MouseEnter:Connect(function()
		Util.Tween(Find, {BackgroundTransparency = 0.88}, false, 0.15)
		Glass:Tint(Tone.White, false)
	end)
	Find.MouseLeave:Connect(function()
		Util.Tween(Find, {BackgroundTransparency = 0.94}, false, 0.15)
		Glass:Tint(Tone.Gray, false)
	end)
	Find.MouseButton1Click:Connect(function() self.Palette:Open() end)
	self.Status = Util.New("Frame", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -124, 0.5, 0), Size = UDim2.fromOffset(124, 30), BackgroundColor3 = Tone.Emerald, BackgroundTransparency = 0.88, BorderSizePixel = 0}, self.Header)
	Util.Corner(self.Status, 15)
	Util.Stroke(self.Status, Tone.Emerald, 0.7, 1)
	local Pulse = Util.New("Frame", {BackgroundColor3 = Tone.Emerald, BorderSizePixel = 0, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 14, 0.5, 0), Size = UDim2.fromOffset(8, 8)}, self.Status)
	Util.Corner(Pulse, 4)
	TS:Create(Pulse, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {BackgroundTransparency = 0.7}):Play()
	self:Loc(Util.Label(self.Status, self.StatusText or "Active", 12, Fonts.Medium, Color3.fromRGB(52, 211, 153), {Position = UDim2.fromOffset(30, 0), Size = UDim2.new(1, -34, 1, 0)}), self.StatusText or "Active")
	self:Bind(function(Theme, Instant)
		Util.Tween(self.SideFill, {BackgroundColor3 = Theme.Bg, BackgroundTransparency = 0.32}, Instant)
		Rule.BackgroundColor3 = Theme.Accent
		HeadLine.BackgroundColor3 = Theme.Accent
		local Seq = ColorSequence.new(Theme.Accent, Theme.Accent2)
		NameGrad.Color = Seq
	end)
end

function Window:HintText()
	if IsMobile then return self:T("Tap the top button to reopen") end
	return (self:T("{key} to Toggle UI"):gsub("{key}", function() return KeyLabel(self.ToggleKey) end))
end

function Window:BuildBody()
	self.SideBody = Util.New("Frame", {Name = "SideBody", BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(0, HeaderH), Size = UDim2.new(1, 0, 1, -HeaderH)}, self.Side)
	self.TabList = Util.New("ScrollingFrame", {
		BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.new(1, 0, 1, -74), CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 0, ScrollingDirection = Enum.ScrollingDirection.Y,
		ElasticBehavior = Enum.ElasticBehavior.Never,
	}, self.SideBody)
	Util.Pad(self.TabList, 10, 8, 10, 8)
	Util.List(self.TabList, 6)
	self.User = Util.New("Frame", {AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 10, 1, -10), Size = UDim2.new(1, -20, 0, 52), BackgroundColor3 = Tone.White, BackgroundTransparency = 0.94, BorderSizePixel = 0}, self.SideBody)
	Util.Corner(self.User, 14)
	Util.Stroke(self.User, Tone.White, 0.9, 1)
	self.Avatar = Util.New("ImageLabel", {
		AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 8, 0.5, 0), Size = UDim2.fromOffset(34, 34),
		BackgroundColor3 = Tone.Black, BackgroundTransparency = 0.4, BorderSizePixel = 0,
		Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150",
	}, self.User)
	Util.Corner(self.Avatar, 17)
	self.UserText = Util.New("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(50, 0), Size = UDim2.new(1, -56, 1, 0)}, self.User)
	Util.Label(self.UserText, LocalPlayer.DisplayName, 12, Fonts.Bold, Tone.White, {Position = UDim2.fromOffset(0, 9), Size = UDim2.new(1, 0, 0, 16), TextTruncate = Enum.TextTruncate.AtEnd})
	Util.Label(self.UserText, "@" .. LocalPlayer.Name, 10, Fonts.Medium, Tone.Gray, {Position = UDim2.fromOffset(0, 26), Size = UDim2.new(1, 0, 0, 14), TextTruncate = Enum.TextTruncate.AtEnd})
	self.Body = Util.New("Frame", {Name = "Body", BackgroundTransparency = 1, Position = UDim2.fromOffset(self.SideW, HeaderH), Size = UDim2.new(1, -self.SideW, 1, -HeaderH), ClipsDescendants = true}, self.Main)
	self.Content = Util.New("ScrollingFrame", {
		BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.new(1, 0, 1, -FootH),
		CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 4, ScrollingDirection = Enum.ScrollingDirection.Y,
		ElasticBehavior = Enum.ElasticBehavior.WhenScrollable, ScrollBarImageTransparency = 0.3, VerticalScrollBarInset = Enum.ScrollBarInset.Always,
	}, self.Body)
	local Footer = Util.New("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.new(1, 0, 0, FootH)}, self.Body)
	local FootLine = Util.New("Frame", {BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 1)}, Footer)
	Util.New("UIGradient", {Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.72), NumberSequenceKeypoint.new(1, 1),
	})}, FootLine)
	self:Loc(Util.Label(Footer, self.FooterText, 12, Fonts.Medium, Tone.Gray, {Position = UDim2.fromOffset(22, 0), Size = UDim2.new(0.6, -22, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd}), self.FooterText)
	self.HintLabel = Util.Label(Footer, self:HintText(), 10, Fonts.Tech, Tone.Gray, {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -44, 0, 0), Size = UDim2.new(0.4, 0, 1, 0), TextXAlignment = Enum.TextXAlignment.Right})
	self:Bind(function(Theme, Instant)
		Util.Tween(self.Content, {ScrollBarImageColor3 = Theme.Accent}, Instant)
		Util.Tween(FootLine, {BackgroundColor3 = Theme.Accent}, Instant)
		for _, Tab in ipairs(self.Tabs) do Tab:Paint(Instant) end
	end)
	self.Grip = Util.New("TextButton", {
		Name = "Resize", Text = "", AutoButtonColor = false, BackgroundTransparency = 1, BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -3, 1, -3), Size = UDim2.fromOffset(30, 30), ZIndex = 20,
	}, self.Main)
	local Dots = Icon.new("Grip", self.Grip, 14):Place(Vector2.new(0.5, 0.5), UDim2.fromScale(0.5, 0.5))
	self.Grip.MouseEnter:Connect(function() Dots:Tint(Tone.White, false) end)
	self.Grip.MouseLeave:Connect(function() Dots:Tint(Tone.Gray, false) end)
	Resizer.new(self, self.Grip)
	self.Maid:Add(self.Content:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
		self:CloseDropdown()
		self:HideTip()
	end))
end

function Window:ApplySide()
	local Narrow = self.SizeW < Profile.NarrowW
	local SideW = Narrow and SideNarrow or SideWide
	local ContentW = self.SizeW - SideW
	self.SideW = SideW
	self.Compact = ContentW < 700
	self.Side.Size = UDim2.new(0, SideW, 1, 0)
	self.SideFill.Size = UDim2.new(0, SideW + 24, 1, 0)
	self.Header.Position = UDim2.fromOffset(SideW, 0)
	self.Header.Size = UDim2.new(1, -SideW, 0, HeaderH)
	self.Body.Position = UDim2.fromOffset(SideW, HeaderH)
	self.Body.Size = UDim2.new(1, -SideW, 1, -HeaderH)
	self.Logo.AnchorPoint = Narrow and Vector2.new(0.5, 0.5) or Vector2.new(0, 0.5)
	self.Logo.Position = Narrow and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0, 18, 0.5, 0)
	self.BrandName.Visible = not Narrow
	if self.BrandTag then self.BrandTag.Visible = not Narrow end
	self.UserText.Visible = not Narrow
	self.Avatar.AnchorPoint = Narrow and Vector2.new(0.5, 0.5) or Vector2.new(0, 0.5)
	self.Avatar.Position = Narrow and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0, 8, 0.5, 0)
	for _, Page in ipairs(self.Tabs) do Page.Text.Visible = not Narrow end
	self.Status.Visible = ContentW >= 620
	self.PageDesc.Visible = ContentW >= 400
	self.TitleBlock.Size = UDim2.new(1, ContentW >= 620 and Profile.TitleGap or Profile.TitleGapNarrow, 1, 0)
	if self.Decor and self.Decor.ClusterFrame then
		self.Decor.ClusterFrame.Position = UDim2.new(0.5, SideW / 2, 0, 18)
	end
end

function Window:BuildFab()
	if not IsMobile then return end
	self.Fab = Util.New("TextButton", {
		Name = "Open", Text = "", AutoButtonColor = false, AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 6), Size = UDim2.fromOffset(112, 34), BorderSizePixel = 0, ZIndex = 150, Visible = false,
	}, self.Gui)
	Util.Corner(self.Fab, 17)
	self.FabLine = Util.Stroke(self.Fab, Tone.White, 0.35, 1.5)
	local Logo = Util.New("ImageLabel", {
		AnchorPoint = Vector2.new(0, 0.5), 
		Position = UDim2.new(0, 5, 0.5, 0), 
		Size = UDim2.fromOffset(24, 24), 
		BackgroundTransparency = 1,
		Image = "rbxassetid://140190431279965",
		BorderSizePixel = 0, 
		ZIndex = 151
	}, self.Fab)
	Util.Corner(Logo, 12)
	self.FabLabel = Util.Label(self.Fab, string.upper(self.Name), 13, Fonts.Tech, Tone.White, {Position = UDim2.fromOffset(34, 0), Size = UDim2.new(1, -40, 1, 0), TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 151})
	local LabelGrad = Util.New("UIGradient", {}, self.FabLabel)
	self:Bind(function(Theme, Instant)
		Util.Tween(self.Fab, {BackgroundColor3 = Theme.Bg, BackgroundTransparency = 0.06}, Instant)
		Util.Tween(self.FabLine, {Color = Theme.Accent}, Instant)
		local Seq = ColorSequence.new(Theme.Accent, Theme.Accent2)
		LabelGrad.Color = Seq
	end)
	self.Fab.MouseButton1Down:Connect(function() Util.Tween(self.Fab, {Size = UDim2.fromOffset(104, 31)}, false, 0.08) end)
	self.Fab.MouseButton1Up:Connect(function() Util.Pop(self.Fab, {Size = UDim2.fromOffset(112, 34)}, 0.4) end)
	self.Fab.MouseButton1Click:Connect(function() self:SetVisible(true) end)
end

function Window:ApplyFab()
	if self.FabLabel then self.FabLabel.Text = string.upper(self.Name) end
end

function Window:BindInput()
	self.Maid:Add(UIS.InputBegan:Connect(function(Key, Processed)
		if self.Binding then
			if Key.UserInputType == Enum.UserInputType.Keyboard then
				local Obj = self.Binding
				self:StopBinding()
				if Key.KeyCode ~= Enum.KeyCode.Escape and Key.KeyCode ~= Enum.KeyCode.Unknown then Obj:Set(Key.KeyCode) end
			end
			return
		end
		if self.TipOwner and Util.IsPress(Key) then
			local Pos, Size, At = self.TipOwner.AbsolutePosition, self.TipOwner.AbsoluteSize, Key.Position
			if At.X < Pos.X or At.X > Pos.X + Size.X or At.Y < Pos.Y or At.Y > Pos.Y + Size.Y then self:HideTip() end
		end
		if Key.KeyCode == Enum.KeyCode.Escape then self:CloseOverlays() end
		if not IsMobile and not Processed and Key.KeyCode == Enum.KeyCode.K and (UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.RightControl)) then
			self.Palette:Open()
		end
		if not Processed and Key.KeyCode == self.ToggleKey then self:SetVisible(not self.Shown) end
	end))
	self.Maid:Add(UIS.InputChanged:Connect(function(Input)
		if self.ActiveSlider then self.ActiveSlider:Drag(Input) end
	end))
	self.Maid:Add(UIS.InputEnded:Connect(function(Input)
		if self.ActiveSlider then self.ActiveSlider:Release(Input) end
	end))
	self.Maid:Add(RunService.Heartbeat:Connect(function(Dt)
		for _, Obj in ipairs(self.Sliders) do Obj:Step_(Dt) end
	end))
	self:HookCamera()
	self.Maid:Add(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		self:HookCamera()
		self:Layout()
	end))
end

function Window:HookCamera()
	if self.CameraConn then self.CameraConn:Disconnect() end
	local Camera = workspace.CurrentCamera
	if Camera then
		self.CameraConn = Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function() self:Layout() end)
	end
end

function Window:Layout(Animate)
	local Camera = workspace.CurrentCamera
	if Camera then
		self:CloseDropdown()
		local Viewport = Camera.ViewportSize
		local Margin = Profile.Margin
		local Room = Vector2.new(math.max(Viewport.X - Margin * 2, 1), math.max(Viewport.Y - Margin * 2, 1))
		local Scale, Width, Height
		if IsMobile then
			Scale = math.clamp(self.UserScale, 0.7, 1.3)
			Scale = math.max(math.min(Scale, Room.X / MinW, Room.Y / MinH), 0.3)
			local MaxW, MaxH = Room.X / Scale, Room.Y / Scale
			Width = math.min(self.CustomW or BaseW, MaxW)
			Height = math.min(self.CustomH or BaseH, MaxH)
			if self.Maximized then Width, Height = MaxW, MaxH end
		else
			Width = self.CustomW or (Viewport.X < 720 and CompactW or BaseW)
			Height = self.CustomH or BaseH
			local Fit = math.min(Room.X / Width, Room.Y / Height)
			Scale = math.max(math.min(self.UserScale, Fit), 0.3)
			if self.Maximized then Width, Height = Room.X / Scale, Room.Y / Scale end
		end
		self.BaseScale = Scale
		self.SizeW, self.SizeH = Width, Height
		self.Root.Position = UDim2.fromScale(0.5, 0.5)
		if self.Shown then self.ScaleObj.Scale = Scale end
		self:Apply(Animate)
	end
end

function Window:Apply(Animate)
	local Scale = self.BaseScale
	local Height = self.Minimized and HeaderH or self.SizeH
	local Instant = not Animate
	self.PixelW, self.PixelH = self.SizeW * Scale, Height * Scale
	Util.Tween(self.Main, {Size = UDim2.fromOffset(self.SizeW, Height)}, Instant, 0.4, Enum.EasingStyle.Quint)
	Util.Tween(self.Root, {Size = UDim2.fromOffset(self.PixelW, self.PixelH)}, Instant, 0.4, Enum.EasingStyle.Quint)
	if self.Minimized and Animate then
		task.delay(0.22, function()
			self.Body.Visible = not self.Minimized
			self.SideBody.Visible = not self.Minimized
		end)
	else
		self.Body.Visible = not self.Minimized
		self.SideBody.Visible = not self.Minimized
	end
	self:ApplySide()
	self.Grip.Visible = not self.Minimized and not self.Maximized
	if self.Decor then self.Decor:SetWide(self.SizeW >= 560) end
	self:ApplyRows()
	self:ClampMain()
end

function Window:ResizeTo(Width, Height, Origin, StartW, StartH)
	local Camera = workspace.CurrentCamera
	if Camera then
		local Viewport = Camera.ViewportSize
		local Scale = self.BaseScale
		Width = math.clamp(Width, MinW, math.max(MinW, (Viewport.X - 16) / Scale))
		Height = math.clamp(Height, MinH, math.max(MinH, (Viewport.Y - 16) / Scale))
		self.CustomW, self.CustomH = Width, Height
		self.Root.Position = UDim2.new(Origin.X.Scale, Origin.X.Offset + (Width - StartW) * Scale / 2, Origin.Y.Scale, Origin.Y.Offset + (Height - StartH) * Scale / 2)
		self.SizeW, self.SizeH = Width, Height
		self:Apply(false)
	end
end

function Window:ClampMain()
	local Camera = workspace.CurrentCamera
	if Camera then
		local Viewport = Camera.ViewportSize
		local LimitX = math.max((Viewport.X - self.PixelW) / 2 - 8, 0)
		local LimitY = math.max((Viewport.Y - self.PixelH) / 2 - 8, 0)
		local Pos = self.Root.Position
		self.Root.Position = UDim2.new(Pos.X.Scale, math.clamp(Pos.X.Offset, -LimitX, LimitX), Pos.Y.Scale, math.clamp(Pos.Y.Offset, -LimitY, LimitY))
	end
end

function Window:ClampFab()
end

function Window:ApplyRows()
	for _, Row in ipairs(self.Rows) do
		local Stacked = self.Compact and Row.Stack
		Row.Layout.FillDirection = Stacked and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal
		for _, Cell in ipairs(Row.Cells) do
			Cell.Size = Stacked and UDim2.new(1, 0, 0, 0) or UDim2.new(1 / Row.Count, -12 * (Row.Count - 1) / Row.Count, 0, 0)
		end
	end
end

function Window:Bounds()
	local Viewport = workspace.CurrentCamera.ViewportSize
	local Pos = self.Root.Position
	local Cx = Viewport.X * Pos.X.Scale + Pos.X.Offset
	local Cy = Viewport.Y * Pos.Y.Scale + Pos.Y.Offset
	return Cx - self.PixelW / 2, Cy - self.PixelH / 2, Cx + self.PixelW / 2, Cy + self.PixelH / 2
end

function Window:AddTab(Options)
	local Page = Tab.new(self, Options or {})
	table.insert(self.Tabs, Page)
	if not self.Current or (self.Current == self.SettingsTab and Page ~= self.SettingsTab) then self:SelectTab(Page) end
	Page:Paint(true)
	return Page
end

function Window:SelectTab(Tab)
	self:CloseDropdown()
	self:HideTip()
	self:StopBinding()
	local Changed = self.Current ~= Tab
	self.Current = Tab
	for _, Other in ipairs(self.Tabs) do
		Other.Holder.Visible = Other == Tab
		Other:Paint(false)
	end
	self:ApplyPage()
	self.Content.CanvasPosition = Vector2.zero
	Tab.Holder.Position = UDim2.fromOffset(0, Changed and 18 or 0)
	Util.Tween(Tab.Holder, {Position = UDim2.fromOffset(0, 0)}, false, 0.45, Enum.EasingStyle.Quint)
end

function Window:AddSettingsTab()
	if self.SettingsTab then return self.SettingsTab end
	local Settings = self:AddTab({Name = "Settings", Icon = "Gear", Title = "Settings", Description = "Customize your layout, color themes, performance, and overlay preferences"})
	self.SettingsTab = Settings
	Settings.Button.LayoutOrder = 9999
	local Columns = Settings:AddColumns(2, true)
	local Look = Columns[1]:AddSection({Name = "Appearance", Icon = "Palette", Desc = "Change how the hub looks", Scope = "ui"})
	Look:AddThemePicker("Pick a color theme for the whole hub")
	Look:AddDropdown({Name = "Background Style", Desc = "Glass, ultra dark or cyber grid backdrop", Flag = "bgStyle", Options = Backgrounds, Default = self.Background, Callback = function(Value) self:SetBackground(Value) end})
	local Lang = Columns[1]:AddSection({Name = "Language", Icon = "Globe", Desc = "Pick the language of the whole hub", Scope = "ui"})
	Lang:AddLanguagePicker()
	local Controls = Columns[1]:AddSection({Name = "Controls", Icon = "Keyboard", Desc = "Shortcuts for the hub", Scope = "ui"})
	Controls:AddKeybind({Name = "Toggle UI Key", Desc = "Tap the box, then press any key to open or close the hub", Flag = "toggleKey", Default = self.ToggleKey, Callback = function(Key)
		self:SetToggleKey(Key)
		self:Notify(self:T("Toggle key") .. ": " .. KeyLabel(Key))
	end})
	Controls:AddButton({Name = "Reset Toggle Key", Desc = "Set the toggle key back to Right Ctrl", Callback = function()
		self:Set("toggleKey", Enum.KeyCode.RightControl)
	end})
	local System = Columns[2]:AddSection({Name = "System Options", Icon = "Gear", Desc = "Performance and behavior", Scope = "ui"})
	System:AddToggle({Name = "Notifications Enabled", Desc = "Show small popups when something changes", Flag = "notifications", Default = true, Callback = function(Value) self.Notifications = Value end})
	System:AddToggle({Name = "Smooth Scrolling", Desc = "Soft bounce when you scroll to the edge", Flag = "smoothScroll", Default = true, Callback = function(Value) self:SetSmoothScrolling(Value) end})
	System:AddSlider({Name = "FPS Limit", Desc = "Cap the frame rate of the game", Flag = "fpsLimit", Min = 30, Max = 240, Default = 144, Suffix = "FPS", Callback = function(Value)
		pcall(function()
			if setfpscap then setfpscap(Value) end
		end)
	end})
	System:AddSlider({Name = "UI Scale", Desc = "Make the whole hub bigger or smaller", Flag = "uiScale", Min = Profile.ScaleMin, Max = Profile.ScaleMax, Default = 100, Suffix = "%", Callback = function(Value) self:SetScale(Value / 100) end})
	local Config = Columns[2]:AddSection({Name = "Config", Icon = "Save", Desc = "Save and load your settings for this map", Scope = "ui"})
	self.PathNote = Config:AddParagraph({Title = "Map Config", Content = self:MapFile()})
	Config:AddToggle({Name = "Auto Save", Desc = "Save changes automatically a moment after you change them", Flag = "autoSave", Default = self.AutoSave, Callback = function(Value) self.AutoSave = Value end})
	Config:AddButton({Name = "Save Config", Callback = function() self:SaveConfig() end})
	Config:AddButton({Name = "Load Config", Callback = function() self:LoadConfig() end})
	local Hub = Columns[2]:AddSection({Name = "Hub", Icon = "Info", Desc = "Community and unloading", Scope = "ui"})
	Hub:AddButton({Name = "Copy Discord Invite", Desc = "Copy the Discord invite link to your clipboard", Callback = function() self:CopyDiscord() end})
	Hub:AddButton({Name = "Unload UI", Desc = "Remove the hub from the game completely", Callback = function() self:Unload() end})
	self:LoadUI()
	return Settings
end

function Window:SetDiscord(Link)
	self.Discord = Link
end

function Window:CopyDiscord()
	local Link = self.Discord
	if type(Link) ~= "string" or Link == "" then
		self:Notify("No Discord link set")
		return false
	end
	if not Link:find("^https?://") then Link = "https://discord.gg/" .. Link:gsub("^/", "") end
	local Copy = (type(setclipboard) == "function" and setclipboard) or (type(toclipboard) == "function" and toclipboard) or nil
	if Copy and pcall(Copy, Link) then
		self:Notify("Discord link copied")
		return true
	end
	self:Notify("Clipboard not supported")
	return false
end

function Window:Unload()
	if self.Unloaded then return end
	pcall(function() self:SaveUI() end)
	if self.AutoSave then pcall(function() self:SaveConfig(true) end) end
	for _, Obj in pairs(self.Elements) do
		if Obj.State == true and Obj.Callback then pcall(Obj.Callback, false) end
	end
	table.clear(self.Flags)
	if self.OnUnload then pcall(self.OnUnload, self) end
	self:Destroy()
end

function Window:SetTheme(Name)
	if Themes[Name] then
		self.ThemeName = Name
		self.Theme = Themes[Name]
		for _, Painter in ipairs(self.Painters) do Painter(self.Theme, false) end
		if self.Decor then self.Decor:Build(Name) end
	end
end

function Window:SetBackground(Style)
	self.Background = Style
	if Style == "Cyber Grid Overlay" and not self.Grid then
		self.Grid = Util.New("Frame", {Name = "Grid", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 0, BorderSizePixel = 0}, self.Main)
		self.GridLines = {}
		for X = 0, 1600, 40 do
			table.insert(self.GridLines, Util.New("Frame", {BorderSizePixel = 0, BackgroundTransparency = 0.94, Position = UDim2.fromOffset(X, 0), Size = UDim2.new(0, 1, 1, 0)}, self.Grid))
		end
		for Y = 0, 1000, 40 do
			table.insert(self.GridLines, Util.New("Frame", {BorderSizePixel = 0, BackgroundTransparency = 0.94, Position = UDim2.fromOffset(0, Y), Size = UDim2.new(1, 0, 0, 1)}, self.Grid))
		end
	end
	if self.Grid then self.Grid.Visible = Style == "Cyber Grid Overlay" end
	if self.Decor then self.Decor.Back.Visible = Style ~= "Ultra Dark Minimal" end
	self:SetTheme(self.ThemeName)
end

function Window:SetSmoothScrolling(Enabled)
	self.Content.ElasticBehavior = Enabled and Enum.ElasticBehavior.WhenScrollable or Enum.ElasticBehavior.Never
end

function Window:SetScale(Factor)
	self.UserScale = Factor
	self:Layout()
end

function Window:SetVisible(Visible)
	self.Shown = Visible
	if Visible then
		if self.Fab then self.Fab.Visible = false end
		self.Aura.Visible = true
		self.Main.Visible = true
		self.Root.Position = UDim2.fromScale(0.5, 0.5)
		self.ScaleObj.Scale = self.BaseScale * 0.86
		Util.Pop(self.ScaleObj, {Scale = self.BaseScale}, 0.5)
	else
		self:CloseOverlays()
		Util.Tween(self.ScaleObj, {Scale = self.BaseScale * 0.9}, false, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		task.delay(0.18, function()
			if not self.Shown then
				self.Main.Visible = false
				self.Aura.Visible = false
				if self.Fab then
					self.Fab.Size = UDim2.fromOffset(80, 24)
					self.Fab.Visible = true
					Util.Pop(self.Fab, {Size = UDim2.fromOffset(112, 34)}, 0.45)
				end
			end
		end)
	end
end

function Window:CloseDropdown()
	if self.OpenDropdown then self.OpenDropdown:Close() end
end

function Window:CloseOverlays()
	self:CloseDropdown()
	self:HideTip()
	self:StopBinding()
	self.Palette:Close()
end

function Window:Notify(Message)
	if self.Notifications then self.Toaster:Show(self:T(Message)) end
end

function Window:Get(Flag)
	return self.Flags[Flag]
end

function Window:Set(Flag, Value)
	local Obj = self.Elements[Flag]
	if Obj then Obj:Set(Value) end
end

function Window:Destroy()
	self.Unloaded = true
	if self.Decor then self.Decor.Token = (self.Decor.Token or 0) + 1 end
	self.Maid:Clean()
	if self.CameraConn then self.CameraConn:Disconnect() end
	self.Gui:Destroy()
	for Index, Win in ipairs(Library.Windows) do
		if Win == self then
			table.remove(Library.Windows, Index)
			break
		end
	end
end

function Library:CreateWindow(Options)
	Options = Options or {}
	local Win = Window.new(Options)
	table.insert(self.Windows, Win)
	if Options.AutoSettings ~= false then Win:AddSettingsTab() end
	return Win
end

function Library:Destroy()
	for _, Win in ipairs(table.clone(self.Windows)) do Win:Destroy() end
	table.clear(self.Windows)
end

return Library
