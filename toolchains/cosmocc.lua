--!A cross-platform build utility based on Lua
--
toolchain("cosmocc")
    set_homepage("https://justine.lol/cosmopolitan/index.html")
    set_description("Cosmopolitan Toolchain" )

    set_kind("standalone")


    set_toolset("cc", "gcc@cosmocc")
    set_toolset("cxx", "gcc@cosmocc", "gcc@cosmoc++" )
    set_toolset("ld", "gcc@cosmocc", "gcc@cosmoc++")
    set_toolset("sh", "gcc@cosmocc", "gcc@cosmoc++")
    set_toolset("ar", "gcc@cosmoarar")
    -- set_toolset("strip", "strip") -- aarch64-unknown-cosmo-strip or x86_64-unknown-cosmo-strip ?
    set_toolset("mm", "gcc@cosmocc")
    set_toolset("mxx", "gcc@cosmocc", "gcc@cosmoc++")
    set_toolset("as", "gcc@cosmocc")

    on_check(function (toolchain)
        import("lib.detect.find_tool")
        local cosmocc=find_tool("cosmocc", {paths={"cosmocc/bin"},check = function (tool) os.runv(tool,{"--version"},{shell= true }) end})
--         print(cosmocc)
        return cosmocc
    end)


    on_load(function (toolchain)
        local cc
        local ar




--      @see https://github.com/jart/cosmopolitan/tree/master/tool/cosmocc#gotchas
        if((is_host("windows"))and(is_subhost("windows")))then
            cprint('${bright red}I guess you should run it with WSL/MSYS/cygwin/mingw')
            os.exit()
        end

        toolchain:set("bindir","cosmocc/bin")

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
            toolchain:set("strip","gcc@x86_64-unknown-cosmo-strip")
        elseif (os.arch()=="aarch64")then
            toolchain:set("strip","gcc@aarch64-unknown-cosmo-strip")
        end 

        -- copyed from gcc toolchain
        -- local march
        -- if march then
        --     toolchain:add("cxflags", march)
        --     toolchain:add("mxflags", march)
        --     toolchain:add("asflags", march)
        --     toolchain:add("ldflags", march)
        --     toolchain:add("shflags", march)
        --     end 
        

    end)

    -- on_build_file(function () 
        
    -- end)
    -- on_link(function (target) 
        
    -- end)






toolchain_end()



-- rule("cosmolibc.c")
--     set_extensions(".c")
--     set_sourcekinds("cosmocc")
--     on_buildcmd_file(function (target, batchcmds, sourcefile, opt)
--         --print(target)
--         print(sourcefile)
--         local objectfile = target:objectfile(sourcefile)
--         table.insert(target:objectfiles(), objectfile)
--         batchcmds:show_progress(opt.progress, "${color.build.object}compiling.cosmolibc.c %s", sourcefile)
--         -- local include=target.includes
--         -- print(include)
--         batchcmds:vrunv("cosmocc/bin/cosmocc", {"-c","-std=c11","-o", objectfile,"-Iinclude", sourcefile},{shell=true})
--         -- batchcmds:compile(sourcefile, objectfile)
--         -- batchcmds:set_depcache(target:dependfile(objectfile))
--     end)
--     on_link(function (target)
--         -- print(target)
--         print(target:objectfiles())
--     end)

-- rule_end()
