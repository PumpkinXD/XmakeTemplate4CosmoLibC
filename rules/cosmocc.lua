rule("cosmolibc.c.binary")
    set_extensions(".c")
    -- set_sourcekinds("cosmocc")

    on_load(function (target)

        -- set default output binary
        target:set("kind", "binary") 
        
    end)




    on_buildcmd_file(function (target, batchcmds, sourcefile, opt)--?
        --print(target)
        cprint('${blue}rule:on_buildcmd_file')
        cprint('${yellow}'..sourcefile)
--         print(sourcefile)
--         local cosmocc="cosmocc/bin/cosmocc"
--         local objectfile = target:objectfile(sourcefile)
--         table.insert(target:objectfiles(), objectfile)
--         batchcmds:show_progress(opt.progress, "${color.build.object}compiling.cosmolibc.c %s", sourcefile)
--         -- local include=target.includes
--         -- print(include)
-- --         batchcmds:vrunv(cosmocc, {"-c","-std=c11","-o", objectfile,"-Iinclude", sourcefile},{shell=true})
-- --         batchcmds:compile(cosmocc, {"-c","-std=c11","-o", objectfile,"-Iinclude", sourcefile},{shell=true})
--         batchcmds:add_depfiles(sourcefile)
--         batchcmds:set_depmtime(os.mtime(objectfile))
--         batchcmds:set_depcache(target:dependfile(objectfile))
    end)

--     on_build_file(function (target, sourcefile, opt)
--             cprint('${blue}rule:on_build_file')
--             print(sourcefile)
--         end)

--
--     on_build(function (target)
--     cprint('${blue}rule:on_build')
--     end)



--     on_link(function (target)
--
--         cprint('${blue}rule:on_link')
--         import("core.base.option")
--         import("core.theme.theme")
--         import("core.project.config")
--         import("core.project.depend")
--         import("core.tool.compiler")
--         import("private.utils.progress")
--
--
--         -- print(target)
--         local cosmocc="cosmocc/bin/cosmocc"
--         print(target:objectfiles())
--
--         -- os.vrunv(cosmocc,{},{shell=true})
--         os.exit()
--     end)

rule_end()
