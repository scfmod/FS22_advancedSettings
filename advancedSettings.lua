
local AdvancedSettings = {
    isOpen = false
}

function AdvancedSettings:loadMap()
    g_settingsScreen.pageEnablingPredicates[g_settingsScreen.pageSettingsAdvanced] = function() return true end
    g_settingsScreen.pageEnablingPredicates[g_settingsScreen.pageSettingsHDR] = function() return true end
    g_settingsScreen:updatePages()
end

function AdvancedSettings:keyEvent(unicode, sym, modifier, isDown)
    if AdvancedSettings.isOpen or not isDown then
        return
    end

    if sym == 291 then
        g_gui:showGui("SettingsScreen")
		-- g_settingsScreen:showGeneralSettings()
        g_settingsScreen:goToPage(g_settingsScreen.pageSettingsAdvanced)
    end
end

function AdvancedSettings.onSaveChangesBackCallback(self, func, yes)
    if yes then
        self.settingsModel:applyChanges(SettingsModel.SETTING_CLASS.SAVE_ALL)
    else
        self.settingsModel:reset()
    end

    self:changeScreen()
end

function AdvancedSettings.changeScreen()
    g_gui:showGui()
end

function AdvancedSettings.onOpen()
    AdvancedSettings.isOpen = true
end

function AdvancedSettings.onClose()
    AdvancedSettings.isOpen = false
end

function AdvancedSettings.onApplySettings(self, func)
    self.settingsModel:applyChanges(SettingsModel.SETTING_CLASS.SAVE_ALL)
    self:setMenuButtonInfoDirty()
end

SettingsScreen.onSaveChangesBackCallback = Utils.overwrittenFunction(
    SettingsScreen.onSaveChangesBackCallback,
    AdvancedSettings.onSaveChangesBackCallback
)

SettingsScreen.changeScreen = Utils.overwrittenFunction(
    SettingsScreen.changeScreen,
    AdvancedSettings.changeScreen
)

SettingsScreen.onOpen = Utils.prependedFunction(
    SettingsScreen.onOpen,
    AdvancedSettings.onOpen
)

SettingsScreen.onClose = Utils.appendedFunction(
    SettingsScreen.onClose,
    AdvancedSettings.onClose
)


SettingsAdvancedFrame.onApplySettings = Utils.overwrittenFunction(
    SettingsScreen.onApplySettings,
    AdvancedSettings.onApplySettings
)


addModEventListener(AdvancedSettings)