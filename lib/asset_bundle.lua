require "lib.option"

AssetBundle = {
    root = "/assets",
    files = {}
}

function AssetBundle:load(onFileLoading)
    local onFileLoading = onFileLoading or function(path)
        print("[AssetBundle]: loading " .. path)
    end

    local function enumerate(path)
        local tree = {}

        local contents = love.filesystem.getDirectoryItems(path)
        for _, v in pairs(contents) do
            local newPath = path .. "/" .. v
            local type = love.filesystem.getInfo(newPath).type
            if type == "file" then
                onFileLoading(newPath)
                local data = self.loadFile(newPath)
                if data:is_some() then
                    tree[self.cutExtension(v)] = data:unwrap()
                end
            end
            if type == "directory" then
                tree[v] = enumerate(newPath)
            end
        end

        return tree
    end

    self.files = enumerate(self.root)
end

function AssetBundle.loadFile(path)
    local filedata = love.filesystem.newFileData(path)
    local ext = filedata:getExtension()
    if (ext == "png") then
        local img = love.graphics.newImage(path)
        img:setFilter("nearest", "nearest")
        return
            Some(img)
    end
    return None
end

function AssetBundle.cutExtension(filename)
    return string.match(filename, '(.+)%.(.+)')
end
