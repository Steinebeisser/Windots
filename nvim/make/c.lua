local function nob_makeprg()
    if vim.loop.os_uname().sysname == "Windows_NT" then
        if vim.fn.filereadable("nob.exe") == 1 then
            return ".\\nob.exe"
        else
            return "gcc nob.c -o nob.exe && .\\nob.exe"
        end
    else
        if vim.fn.executable("./nob") == 1 then
            return "./nob"
        else
            return "cc -o nob nob.c && ./nob"
        end
    end
end

vim.bo.makeprg = nob_makeprg()
