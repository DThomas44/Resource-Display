-- While my mod has nothing to do with music, this approach allows it to be a 100% clientside mod

local resourceDisplay_initialize -- extended functions

if onClient() then


resourceDisplay_initialize = MusicCoordinator.initialize
function MusicCoordinator.initialize(...)
    resourceDisplay_initialize(...)

    if not GameSettings().infiniteResources then
        Player():registerCallback("onPreRenderHud", "resourceDisplay_onPreRenderHud")
    end
end

function MusicCoordinator.resourceDisplay_onPreRenderHud()
    local player = Player()
    local faction = player
    if player.craft and player.craft.allianceOwned then
        faction = Alliance()
    end
    if player.state ~= PlayerStateType.Fly and player.state ~= PlayerStateType.Interact then return end

    local y = 10
    if not faction.infiniteResources and player.state == PlayerStateType.Fly then
        local resources = {faction:getResources()}
        local material, rect
        for i = 1, #resources do
            material = Material(i-1)
            y = y + 18
            rect = Rect(5, y, 295, y + 16)
            if faction.isAlliance then
                drawTextRect("[A]  /* Alliance resource prefix */"%_t..material.name, rect, -1, -1, material.color, 15, 0, 0, 2)
            else
                drawTextRect(material.name, rect, -1, -1, material.color, 15, 0, 0, 2)
            end
            drawTextRect(createMonetaryString(resources[i]), rect, 1, -1, material.color, 15, 0, 0, 2)
        end
        y = y + 18
        rect = Rect(5, y, 295, y + 16)
        local color = ColorRGB(1, 1, 1)
        if faction.isAlliance then
            drawTextRect("[A]  /* Alliance resource prefix */"%_t.."Credits"%_t, rect, -1, -1, color, 15, 0, 0, 2)
        else
            drawTextRect("Credits"%_t, rect, -1, -1, color, 15, 0, 0, 2)
        end
        drawTextRect("¢"..createMonetaryString(faction.money), rect, 1, -1, color, 15, 0, 0, 2)
    else
        y = y + NumMaterials() * 18
    end
    -- cargo
    local ship = getPlayerCraft()
    y = y + 18
    rect = Rect(5, y, 295, y + 16)
    color = ColorRGB(0.8, 0.8, 0.8)
    drawTextRect("Cargo Hold"%_t, rect, -1, -1, color, 15, 0, 0, 2)
    if ship and ship.maxCargoSpace then
        drawTextRect(math.ceil(ship.occupiedCargoSpace).."/"..math.floor(ship.maxCargoSpace), rect, 1, -1, color, 15, 0, 0, 2)
    else
        drawTextRect("-", rect, 1, -1, color, 15, 0, 0, 2)
    end
end


end