--!A cross-platform build utility based on Lua
--
toolchain("cosmocc")
    set_homepage("https://justine.lol/cosmopolitan/index.html")
    set_description("Cosmopolitan Toolchain" )

    set_kind("standalone")


    set_toolset("cc", "gcc@$(projectdir)/cosmocc/bin/cosmocc")
    set_toolset("cxx", "gcc@cosmocc", "gcc@$(projectdir)/cosmocc/bin/cosmoc++" )
    set_toolset("ld", "gcc@$(projectdir)/cosmocc/bin/cosmocc", "gcc@$(projectdir)/cosmocc/bin/cosmoc++")
    set_toolset("sh", "gcc@$(projectdir)/cosmocc/bin/cosmocc", "gcc@$(projectdir)/cosmocc/bin/cosmoc++")
    set_toolset("ar", "gcc@$(projectdir)/cosmocc/bin/cosmoarar")
    -- set_toolset("strip", "strip") -- aarch64-unknown-cosmo-strip or x86_64-unknown-cosmo-strip ?
    set_toolset("mm", "gcc@$(projectdir)/cosmocc/bin/cosmocc")
    set_toolset("mxx", "gcc@$(projectdir)/cosmocc/bin/cosmocc", "gcc@$(projectdir)/cosmocc/bin/cosmoc++")
    set_toolset("as", "gcc@$(projectdir)/cosmocc/bin/cosmocc")

    on_check(function (toolchain)
        import("lib.detect.find_tool")
        local cosmocc=find_tool("cosmocc", {paths={"cosmocc/bin"},check = function (tool) os.runv(tool,{"--version"},{shell = true}) end})
--         print(cosmocc)
        return cosmocc
    end)


    on_load(function (toolchain)


--      @see https://github.com/jart/cosmopolitan/tree/master/tool/cosmocc#gotchas
        if((is_host("windows"))and(is_subhost("windows")))then
            cprint('${bright color.error}I guess you should run it with WSL/MSYS/cygwin/mingw')
            os.exit()
        end

        toolchain:set("bindir","cosmocc/bin")
        -- toolchain:set()

--         import("lib.detect.find_tool")
--         local toolchain_exist = find_tool("cosmocc", {paths={"cosmocc/bin"},check = function (tool) os.runv(tool,{"--version"},{shell=true}) end})
--         if(not toolchain_exist)
--             import("net.http")
--             import("utils.progress")



--             print("cosmocc not found, now downloading...")
--             http.download("https://cosmo.zip/pub/cosmocc/cosmocc.zip","cosmocc.zip")
--             import("utils.archive")
--             archive.extract("cosmocc.zip","cosmocc")
--             print("cosmocc downloaded.")
--         end



        if (os.arch()=="x86_64")then
            toolchain:set("strip","gcc@$(projectdir)/cosmocc/bin/x86_64-unknown-cosmo-strip")
        elseif (os.arch()=="aarch64")then
            toolchain:set("strip","gcc@$(projectdir)/cosmocc/bin/aarch64-unknown-cosmo-strip")
        end 
        

    end)

toolchain_end()
