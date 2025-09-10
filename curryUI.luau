local uis = cloneref(game:GetService("UserInputService"))
local rs = cloneref(game:GetService("RunService"))
local coregui = cloneref(game:GetService("CoreGui"))
local tween_service = cloneref(game:GetService("TweenService"))

local drag = function(obj, latency)
    --// too lazy to implement my own dragging
    obj = obj
    latency = latency or 0.06

    toggled = nil
    input = nil
    start = nil

    function updateInput(input)
        local Delta = input.Position - start
        local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
        tween_service:Create(obj, TweenInfo.new(latency), {Position = Position}):Play()
    end

    obj.InputBegan:Connect(function(inp)
        if (inp.UserInputType == Enum.UserInputType.MouseButton1) then
            toggled = true
            start = inp.Position
            startPos = obj.Position
            inp.Changed:Connect(function()
                if (inp.UserInputState == Enum.UserInputState.End) then
                    toggled = false
                end
            end)
        end
    end)

    obj.InputChanged:Connect(function(inp)
        if (inp.UserInputType == Enum.UserInputType.MouseMovement) then
            input = inp
        end
    end)

    uis.InputChanged:Connect(function(inp)
        if (inp == input and toggled) then
            updateInput(inp)
        end
    end)
end

local curry = {}

    function curry:stroke(obj)
        local item = Instance.new("UIStroke", obj)
        item.Color = Color3.fromRGB(223, 223, 223)
        item.Transparency = 0.66
        item.Thickness = 0.85
        item.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    end

    function curry:radius(obj, val)
        local item = Instance.new("UICorner", obj)
        item.CornerRadius = UDim.new(0, val)
    end

    function curry:padleft(obj)
        local item = Instance.new("UIPadding", obj)
        item.PaddingLeft = UDim.new(0, 9)
    end

    function curry:padtop(obj)
        local item = Instance.new("UIPadding", obj)
        item.PaddingTop = UDim.new(0, 9)
    end

    function curry:itemlist(obj)
        local item = Instance.new("UIListLayout", obj)
        item.HorizontalAlignment = Enum.HorizontalAlignment.Center
        item.VerticalAlignment = Enum.VerticalAlignment.Top
        item.FillDirection = Enum.FillDirection.Vertical
        item.Padding = UDim.new(0, 9)
    end

    function curry:list(obj, type)
        local item = Instance.new("UIListLayout", obj)
        item.HorizontalAlignment = type
        item.VerticalAlignment = Enum.VerticalAlignment.Center
        item.FillDirection = Enum.FillDirection.Horizontal
        item.Padding = UDim.new(0, 9)
    end

function curry:start()
    for i,v in coregui:GetChildren() do
        if v.Name == "int999" then
            v:Destroy()
        end
    end

    local interface = Instance.new("ScreenGui", coregui)
    interface.ResetOnSpawn = false
    interface.Name = "int999"

    local inter = {}

    function inter:Window(wtitle)
        local window = Instance.new("Frame", interface)
        window.BorderSizePixel = 0
        window.BackgroundColor3 = Color3.fromRGB(28, 27, 27)
        window.Size = UDim2.new(0, 430, 0, 525)
        window.Transparency = 0.08
        window.ClipsDescendants = true
        curry:radius(window, 14)
        curry:stroke(window)
        drag(window, 0.0067)

        local title = Instance.new("TextLabel", window)
        title.Size = UDim2.new(1, 0, 0, 32)
        title.Position = UDim2.new(0, 0, 0, 25)
        title.BackgroundTransparency = 1
        title.TextColor3 = Color3.fromRGB(187, 182, 182)
        title.Text = wtitle
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextSize = 26
        title.TextTransparency = 0.34
        title.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        curry:padleft(title)

        local tabholderframe = Instance.new("Frame", window)
        tabholderframe.Size = UDim2.new(1, 0, 0, 40)
        tabholderframe.Position = UDim2.new(0.215, 0, 0, 25)
        tabholderframe.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        tabholderframe.Transparency = 0.4
        curry:stroke(tabholderframe)
        curry:radius(tabholderframe, 8)
        curry:list(tabholderframe, Enum.HorizontalAlignment.Left)
        curry:padleft(tabholderframe)

        local pagesholder = Instance.new("Frame", window)
        pagesholder.Size = UDim2.new(1, 0, 0, 435)
        pagesholder.Position = UDim2.new(0, 0, 0, 70)
        pagesholder.BackgroundColor3 = Color3.fromRGB(152, 152, 152)
        pagesholder.Transparency = 1
        curry:list(pagesholder, Enum.HorizontalAlignment.Center)

        local pages = {}

        function pages:Page(name)
            local pagebtn = Instance.new("TextButton", tabholderframe)
            pagebtn.Size = UDim2.new(0, 73, 0, 24)
            pagebtn.BackgroundTransparency =  0.79 --0.79
            pagebtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            pagebtn.TextColor3 = Color3.fromRGB(128, 128, 128)
            pagebtn.Text = name
            pagebtn.TextSize = 15
            pagebtn.FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
            curry:stroke(pagebtn)
            curry:radius(pagebtn, 4)

            local page = Instance.new("ScrollingFrame", pagesholder)
            page.Size = UDim2.new(1, 0, 1, 0)
            page.BackgroundTransparency = 1
            page.Visible = false
            page.Position = UDim2.new(0.0095, 0, 0.0143, 0)
            page.ScrollBarThickness = 0
            page.AutomaticCanvasSize = Enum.AutomaticSize.Y
            page.CanvasSize = UDim2.new(0, 0, 0, 0)
            curry:itemlist(page)
            curry:padtop(page)

            --// tab logic

            pagebtn.MouseButton1Down:Connect(function()
                for i, v in pagesholder:GetChildren() do
                    if v:IsA("ScrollingFrame") then
                        v.Visible = false
                    end
                end
                page.Visible = true

                for _, g in tabholderframe:GetChildren() do 
                    if g:IsA("TextButton") then
                        tween_service:Create(g, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.In), { TextColor3 = Color3.fromRGB(128, 128, 128)}):Play() 
                    end
                    tween_service:Create(pagebtn, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.In), { TextColor3 = Color3.fromRGB(217, 217, 217)}):Play() 
                end
            end)

            local items = {}

            function items:button(options)
                -- options.name = "gang" or options.name
                local btn = Instance.new("TextButton", page)
                btn.Size = UDim2.new(0.88, 0, 0, 34)
                btn.BackgroundTransparency =  0.79 --0.79
                btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                btn.TextColor3 = Color3.fromRGB(233,233,233)
                btn.Text = options.name
                btn.TextSize = 15
                btn.TextXAlignment = Enum.TextXAlignment.Left
                btn.FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                curry:padleft(btn)
                curry:stroke(btn)
                curry:radius(btn, 4)

                btn.MouseButton1Down:Connect(function()
                    if typeof(options.callback) == "function" then
                        pcall(options.callback)
                    end
                end)
            end

            function items:toggle(options)
                local togged = false
                local toggle = Instance.new("TextButton", page)
                toggle.Size = UDim2.new(0.88, 0, 0, 34)
                toggle.BackgroundTransparency =  0.79 --0.79
                toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                toggle.TextColor3 = Color3.fromRGB(233,233,233)
                toggle.Text = options.name
                toggle.TextSize = 15
                toggle.TextXAlignment = Enum.TextXAlignment.Left
                toggle.FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                curry:padleft(toggle)
                curry:stroke(toggle)
                curry:radius(toggle, 4)

                local state = Instance.new("Frame", toggle)
                state.Size = UDim2.new(0, 15, 0, 15)
                state.Position = UDim2.new(0.94, 0, 0, 10)
                state.BackgroundColor3 = Color3.fromRGB(251, 141, 141)
                state.Transparency = 0.4
                curry:stroke(state)
                curry:radius(state, 20)

                toggle.MouseButton1Down:Connect(function()
                    togged = not togged

                    if togged then
                        tween_service:Create(state, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.In), { BackgroundColor3 = Color3.fromRGB(167, 251, 141)}):Play()
                    else
                        tween_service:Create(state, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.In), { BackgroundColor3 = Color3.fromRGB(251, 141, 141)}):Play()   
                    end
                    
                    options.callback(togged)
                end)
            end
            return items
        end

        return pages
    end

    return inter
end

return curry
