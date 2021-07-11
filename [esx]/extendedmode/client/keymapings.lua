RegisterCommand('openmenu',function()
    TriggerEvent('esx_keymapings:openMenu')
end)

RegisterCommand('cancelActions',function()
    TriggerEvent('esx_keymapings:cancelActions')
end)

RegisterKeyMapping('openmenu', 'Abrir menus', 'keyboard', 'e')

RegisterKeyMapping('cancelActions', 'Cancelar acciones (Las que sean posibles de hacerlo)', 'keyboard', 'x')
