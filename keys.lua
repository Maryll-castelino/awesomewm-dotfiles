-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- Declarative object management
local ruled = require("ruled")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

apps = require("apps")

-- Initialize widgets
require("widgets.exit-screen.exit-screen")
local volume = require("widgets.volume.volume")
menubar.utils.terminal = terminal
awesome.register_xproperty("WM_CLASS","string")
-- menubar:set_xproperty("WM_CLASS", "menubar")



-- require("widgets.brightness")

local brightness = require("widgets.brightness.brightness")

-- "Mod4" is the Super key
modkey = "Mod4"
-- "Mod1" is the Alt key
altkey = "Mod1"

-- {{{ Mouse bindings
awful.mouse.append_global_mousebindings({
    awful.button({}, 3, function() mymainmenu:toggle() end),
    -- awful.button({}, 4, awful.tag.viewprev),
    -- awful.button({}, 5, awful.tag.viewnext)
})
-- }}}

-- {{{ Key bindings

-- General Awesome keys
awful.keyboard.append_global_keybindings({
    awful.key({ modkey }, "x", 
        function() 
            exit_screen_show() 
        end, 
        {description = "Show logout screen", group = "custom"}),
    awful.key({modkey}, "o",  
        function() 
            _G.screen.primary.right_panel:toggle() 
        end, 
        {description = 'toggle notification center',group = 'Awesome'}), 
    -- keyboard volume keys
    awful.key({}, 'XF86AudioRaiseVolume', 
        function() 
            volume.inc() 
        end, 
        {description = 'volume up', group = 'hotkeys'}),
    awful.key({}, 'XF86AudioLowerVolume', 
        function() 
            volume.dec() 
        end, 
        {description = 'volume down', group = 'hotkeys'}),
    awful.key({}, 'XF86AudioMute', 
        function() 
            volume.toggle() 
        end, 
        {description = 'toggle mute', group = 'hotkeys'}),
    -- brightness keys
    awful.key({}, "XF86MonBrightnessUp", 
        function() 
            brightness.inc() 
        end,
        {description = "increase brightness", group = "custom"}),
    awful.key({}, "XF86MonBrightnessDown", 
        function()
            brightness.dec() 
        end, 
        {description = "decrease brightness", group = "custom"}),
    -- brightness keys end
    -- Media Keys
    awful.key({}, "XF86AudioPlay", function()
        awful.util.spawn("playerctl play-pause", false)
    end),
    awful.key({}, "XF86AudioNext", function()
        awful.util.spawn("playerctl next", false)
    end),
    awful.key({}, "XF86AudioPrev", function()
        awful.util.spawn("playerctl previous", false)
    end),
    awful.key({modkey}, "s", 
        hotkeys_popup.show_help,
        {description = "show help", group = "awesome"}),
    awful.key({modkey, "Shift"}, "s", 
        function(c) 
            awful.spawn.with_shell("flameshot gui")
        end,
        {description = "flameshot", group = "launcher"}),
    awful.key({modkey, "Control"}, "r", 
        awesome.restart,
        {description = "reload awesome", group = "awesome"}),
    awful.key({modkey, "Shift"}, "q", 
        awesome.quit,
        {description = "quit awesome", group = "awesome"}),
    awful.key({modkey}, "Return", 
        function() 
            awful.spawn(terminal) 
        end,
        {description = "open a terminal", group = "launcher"}),
    awful.key({modkey}, "f", 
        function() 
            awful.spawn.with_shell("nautilus") 
        end,
        {description = "open file manager", group = "launcher"}),
    awful.key({modkey}, "r", 
        function()
            awful.util.spawn("rofi -show drun")
        end, 
        {description = "rofi run prompt", group = "launcher"}),
    awful.key({modkey},"p", 
        function() 
            menubar.refresh()
            menubar.show() 
        end,
        {description = "show the menubar", group = "launcher"}),
    awful.key({modkey}, "b", 
        function() 
            awful.spawn(browser) 
        end,
        {description = "open a browser", group = "launcher"}),
    awful.key({modkey}, "c",
        function()
            awful.util.spawn("/usr/lib/brave-bin/brave --profile-directory=Default --app-id=peoigcfhkflakdcipcclkneidghaaphd", {floating = false})
        end,
        {description = "open csTimer", group = "launcher"}),
    awful.key({modkey}, "g",
        function()
            awful.util.spawn("gmtool admin start vpn-proxy")
        end,
        {description = "start vpn-proxy vm", group = "launcher"})
})

-- Tags related keybindings
awful.keyboard.append_global_keybindings(
    {
        awful.key({modkey}, "Left", 
            awful.tag.viewprev,
            {description = "view previous", group = "tag"}),
        awful.key({modkey}, "Right", 
            awful.tag.viewnext,
            {description = "view next", group = "tag"}),
        awful.key({modkey}, "Escape", 
            awful.tag.history.restore,
            {description = "go back", group = "tag"}),
        awful.key({altkey}, "Tab", function()
                awesome.emit_signal("bling::window_switcher::turn_on")
            end, {description = "Window Switcher", group = "bling"}),
    })

-- Focus related keybindings
awful.keyboard.append_global_keybindings(
    {
        awful.key({modkey}, "j", 
            function() 
                awful.client.focus.byidx(1) 
            end,
            {description = "focus next by index", group = "client"}),
        awful.key({modkey}, "k", 
            function()
                awful.client.focus.byidx(-1)
            end, 
            {description = "focus previous by index", group = "client"}),
        awful.key({modkey, "Control"}, "j",
            function() 
                awful.screen.focus_relative(1) 
            end,
            {description = "focus the next screen", group = "screen"}),
        awful.key({modkey, "Control"}, "k",
            function() 
                awful.screen.focus_relative(-1) 
            end,
            {description = "focus the previous screen", group = "screen"}),
        awful.key({modkey, "Control"}, "n", 
            function()
                local c = awful.client.restore()
                -- Focus restored client
                if c then
                    c:activate{raise = true, context = "key.unminimize"}
                end
            end, 
            {description = "restore minimized", group = "client"})
    })

-- Layout related keybindings
awful.keyboard.append_global_keybindings(
    {
        awful.key({modkey, "Shift"}, "j",
            function() 
                awful.client.swap.byidx(1) 
            end, 
            {description = "swap with next client by index", group = "client"}), 
        awful.key({modkey, "Shift"}, "k",
            function() 
                awful.client.swap.byidx(-1) 
            end, 
            {description = "swap with previous client by index",group = "client"}), 
        awful.key({modkey}, "u", 
            awful.client.urgent.jumpto,
            {description = "jump to urgent client", group = "client"}),
        awful.key({modkey}, "l", 
            function() 
                awful.tag.incmwfact(0.05) 
            end, 
            {description = "increase master width factor",group = "layout"}),
        awful.key({modkey}, "h", 
            function() 
                awful.tag.incmwfact(-0.05) 
            end, 
            {description = "decrease master width factor",group = "layout"}), 
        awful.key({modkey, "Shift"}, "h",
            function() 
                awful.tag.incnmaster(1, nil, true) 
            end, 
            {description = "increase the number of master clients",group = "layout"}), 
        awful.key({modkey, "Shift"}, "l",
            function() 
                awful.tag.incnmaster(-1, nil, true) 
            end, 
            {description = "decrease the number of master clients",group = "layout"}), 
        awful.key({modkey, "Control"}, "h",
            function() 
                awful.tag.incncol(1, nil, true) 
            end, 
            {description = "increase the number of columns",group = "layout"}), 
        awful.key({modkey, "Control"}, "l",
            function() 
                awful.tag.incncol(-1, nil, true) 
            end, 
            {description = "decrease the number of columns",group = "layout"}), 
        awful.key({modkey}, "space", 
            function() 
                awful.layout.inc(1) 
            end,
            {description = "select next", group = "layout"}),
        awful.key({modkey, "Shift"}, "space",
            function() 
                awful.layout.inc(-1) 
            end,
            {description = "select previous", group = "layout"})
    })

awful.keyboard.append_global_keybindings(
    {
        awful.key {
            modifiers = {modkey},
            keygroup = "numrow",
            description = "only view tag",
            group = "tag",
            on_press = function(index)
                local screen = awful.screen.focused()
                local tag = screen.tags[index]
                if tag then tag:view_only() end
            end
        }, awful.key {
            modifiers = {modkey, "Control"},
            keygroup = "numrow",
            description = "toggle tag",
            group = "tag",
            on_press = function(index)
                local screen = awful.screen.focused()
                local tag = screen.tags[index]
                if tag then awful.tag.viewtoggle(tag) end
            end
        }, awful.key {
            modifiers = {modkey, "Shift"},
            keygroup = "numrow",
            description = "move focused client to tag",
            group = "tag",
            on_press = function(index)
                if client.focus then
                    local tag = client.focus.screen.tags[index]
                    if tag then client.focus:move_to_tag(tag) end
                end
            end
        }, awful.key {
            modifiers = {modkey, "Control", "Shift"},
            keygroup = "numrow",
            description = "toggle focused client on tag",
            group = "tag",
            on_press = function(index)
                if client.focus then
                    local tag = client.focus.screen.tags[index]
                    if tag then client.focus:toggle_tag(tag) end
                end
            end
        }, awful.key {
            modifiers = {modkey},
            keygroup = "numpad",
            description = "select layout directly",
            group = "layout",
            on_press = function(index)
                local t = awful.screen.focused().selected_tag
                if t then t.layout = t.layouts[index] or t.layout end
            end
        }
    })

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings(
        {
            awful.button({}, 1,
                         function(c)
                c:activate{context = "mouse_click"}
            end), awful.button({modkey}, 1, function(c)
                c:activate{context = "mouse_click", action = "mouse_move"}
            end), awful.button({modkey}, 3, function(c)
                c:activate{context = "mouse_click", action = "mouse_resize"}
            end)
        })
end)

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings(
        {
            -- awful.key({modkey,}, "w", 
            -- function(c) 
            --     -- mymainmenu:show() 
            --     c.fullscreen = not c.fullscreen
            --     c:raise()
            -- end,
            -- {description = "show main menu", group = "awesome"}),
            -- awful.key({altkey}, "Tab", function()
            --     awesome.emit_signal("bling::window_switcher::turn_on")
            -- end, {description = "Window Switcher", group = "bling"}),
            awful.key({modkey, "Shift"}, "f", function(c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end, {description = "toggle fullscreen", group = "client"}),
            awful.key({modkey}, "q", function(c) c:kill() end,
                      {description = "close", group = "client"}),
            awful.key({modkey, "Control"}, "space", function(c)
                awful.client.floating.toggle(c)
                if c.floating then
                    awful.titlebar.show(c)
                else
                    awful.titlebar.hide(c)
                end
                -- c.ontop = not c.ontop
            end, {description = "toggle floating", group = "client"}),
            awful.key({modkey, "Shift"}, "t", awful.titlebar.toggle),
            awful.key({modkey, "Control"}, "Return",
                      function(c) c:swap(awful.client.getmaster()) end,
                      {description = "move to master", group = "client"}),
            -- awful.key({modkey}, "o", function(c) c:move_to_screen() end,
            --           {description = "move to screen", group = "client"}),
            awful.key({modkey}, "t", function(c)
                c.ontop = not c.ontop
            end, {description = "toggle keep on top", group = "client"}),
            awful.key({modkey}, "n", function(c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
            end, {description = "minimize", group = "client"}),
            awful.key({modkey}, "m", function(c)
                c.maximized = not c.maximized
                c:raise()
            end, {description = "(un)maximize", group = "client"}),
            awful.key({modkey, "Control"}, "m", function(c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end, {description = "(un)maximize vertically", group = "client"}),
            awful.key({modkey, "Shift"}, "m", function(c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
            end, {description = "(un)maximize horizontally", group = "client"})
        })
end)

-- }}}

