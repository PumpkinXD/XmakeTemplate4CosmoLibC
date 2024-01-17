--!A cross-platform build utility based on Lua
--
toolchain("cosmocc")

    set_homepage("https://justine.lol/cosmopolitan/index.html")
    set_description("Cosmopolitan Toolchain" )

    set_kind("standalone")


    set_toolset("cc", "cosmocc")
    set_toolset("cxx", "cosmocc", "cosmoc++" )
    set_toolset("ld", "cosmoc++", "cosmocc")
    set_toolset("sh", "cosmoc++", "cosmocc")
    set_toolset("ar", "cosmoarar")
    -- set_toolset("strip", "strip") -- aarch64-unknown-cosmo-strip or x86_64-unknown-cosmo-strip ?
    set_toolset("mm", "cosmocc")
    set_toolset("mxx", "cosmocc", "cosmoc++")
    set_toolset("as", "cosmocc")

    on_check(function (toolchain)
        import("lib.detect.find_tool")
        local cosmocc=find_tool("cosmocc", {check = function (tool) os.runv(tool,{"--version"},{shell= true }) end})
        return cosmocc
    end)


    on_load(function (toolchain)




--      @see https://github.com/jart/cosmopolitan/tree/master/tool/cosmocc#gotchas
        if((is_host("windows"))and(is_subhost("windows")))then
            cprint('${bright red}I guess you should run it with WSL/MSYS/cygwin/mingw')
            os.exit()
        end

        if (os.arch()=="x86_64")then
            toolchain:set("strip","x86_64-unknown-cosmo-strip")
        elseif (os.arch()=="aarch64")then
            toolchain:set("strip","aarch64-unknown-cosmo-strip")
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