local function bxor(a, b)
    local r = 0
    local bit = 1
    while a > 0 or b > 0 do
        local aa = a - math.floor(a/2)*2
        local bb = b - math.floor(b/2)*2
        if aa ~= bb then r = r + bit end
        a = math.floor(a/2)
        b = math.floor(b/2)
        bit = bit * 2
    end
    return r
end

-- Default password bytes
local DefaultPassword = {70,117,99,107,89,111,117,83,116,117,112,105,100,66,105,116,99,104}

-- Table length helper
local function tlen(t)
    local c = 0
    for _ in t do c = c + 1 end
    return c
end

-- Manual mod
local function mod(a,b)
    return a - math.floor(a/b)*b
end

-- Read file fully
local function readFile(path)
    local f, size = OpenFile(path, "r")
    if not f then
        error("Failed to open file: "..tostring(path))
    end
    local content = ReadFile(f, size)
    CloseFile(f)
    return content
end

-- Decrypt hex → Lua string (Lua 5.0.2 compatible)
local function decryptHex(hex, password)
    local plen = tlen(password)

    -- Remove spaces just in case
    hex = string.gsub(hex, "%s+", "")
    local n = string.len(hex)

    -- Make sure hex length is even
    if mod(n,2) ~= 0 then
        error("Invalid hex string length: must be even")
    end

    -- Reverse hex in **byte chunks** (2 chars per byte)
    local byteCount = n / 2
    local rev = {}
    for i = 1, byteCount do
        rev[byteCount - i + 1] = string.sub(hex, (i-1)*2+1, (i-1)*2+2)
    end

    -- Convert reversed hex → bytes
    local bytes = {}
    for i = 1, byteCount do
        local b = tonumber(rev[i], 16)
        if not b then error("Invalid hex byte at position "..i) end
        bytes[tlen(bytes)+1] = b
    end

    -- XOR decrypt with password
    local dec = {}
    for j = 1, tlen(bytes) do
        local keyIndex = mod(j-1, plen) + 1
        dec[tlen(dec)+1] = bxor(bytes[j], password[keyIndex])
    end

    -- bytes → string
    local out = {}
    for j = 1, tlen(dec) do
        out[tlen(out)+1] = string.char(dec[j])
    end

    return table.concat(out)
end

-- Load encrypted file and run
-- Optional second argument: password table (defaults to DefaultPassword)
function _G.LoadGSC(path, password)
    password = password or DefaultPassword
    local hex = readFile(path)
    hex = string.gsub(hex, "%s+", "")
    local decrypted = decryptHex(hex, password)
    local fn, err = loadstring(decrypted)
    if not fn then
        error("Decrypted code error: "..tostring(err))
    end
    return fn()
end