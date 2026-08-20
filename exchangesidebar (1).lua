--==============================================================--
-- 🧩 Sidebar Button - Exchange System
--    (Buka UI langsung, bukan simulasi chat)
--==============================================================--

print("(Loaded) Sidebar Button - Exchange System")

--========================--
-- Button Definition
--========================--

local exchangeButton = {
    active = true,
    buttonAction = "trigger_exchange_command", -- Nama action unik
    buttonTemplate = "BaseEventButton",
    counter = 0,
    counterMax = 0,
    itemIdIcon = 14186, -- Ganti ID item icon sesuai selera
    name = "ExchangeButton",
    order = 55, -- Order 55 = pas di bawah/dekat tombol Online (Order 50)
    rcssClass = "daily_challenge",
    text = "`oExchange``" -- Teks tombol sidebar
}

--========================--
-- Register Button
--========================--

addSidebarButton(json.encode(exchangeButton))

--========================--
-- Send Button to Players
--========================--

local function sendExchangeButton(player)
    if not player then return end
    player:sendVariant({
        "OnEventButtonDataSet",
        exchangeButton.name,
        1, -- Angka 1 ini yang bikin langsung nongol di game tanpa start event
        json.encode(exchangeButton)
    })
end

-- Kirim ke semua player yang lagi online pas script di-load/reload
for _, plr in ipairs(getServerPlayers() or {}) do
    sendExchangeButton(plr)
end

-- Callback saat player login baru
onPlayerLoginCallback(sendExchangeButton)

-- Callback saat player pindah/masuk world
onPlayerEnterWorldCallback(function(world, player)
    sendExchangeButton(player)
end)

--==============================================================--
-- Handle Button Click (buka UI langsung)
--==============================================================--

onPlayerActionCallback(function(world, player, data)
    local action = data["action"]

    if action == exchangeButton.buttonAction then
        -- Panggil langsung fungsi dialog dari ItemExchangePO.lua (lebih
        -- reliable daripada simulasi chat command via sendPlayerMessage,
        -- yang cuma nampilin teks tanpa beneran ngejalanin command).
        if OpenExchangeMenu then
            OpenExchangeMenu(player)
        else
            -- Fallback kalau ItemExchangePO.lua belum ke-load / fungsinya belum ada
            world:sendPlayerMessage(player, "/exchange")
        end
        return true
    end

    return false
end)
