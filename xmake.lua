--
--  xmake template for cosmopolitan libc project (c11/cpp14)
--  @version 0.0.2
--  @auther PumpkinXD
--  @license CC0 1.0 Universal
--


includes("toolchains/cosmocc.lua")


target("main.com")
    set_kind("binary")
    set_toolchains("cosmocc")
    set_plat("unknown")
    set_arch("unknown") -- for now(2023-12-26) APE supports amd64 and aarch64, remove this comment when riscv64 and loong64 are supported
--     set_extension("com") -- Causing "cosmocc: fatal error: build/.objs/main/unknown/unknown/release/src/main.c.o: linker input missing concomitant build/.objs/main/unknown/unknown/release/src/.aarch64/main.c.o file" Error
    set_languages("c11","cxx14") -- c11 and cpp14 https://xmake.io/#/manual/project_target?id=targetset_languages
    add_includedirs("include")
    add_files("src/*.c")
--     add_files("src/*.cpp") -- Causing "cannot match add_files("src/*.cpp") in target(main.com)" Warning if c++ source file(s) are not exist inside "src"


    on_build_file(function (target, sourcefile, opt)

        import("core.base.option")
        import("core.theme.theme")
        import("core.project.config")
        import("core.project.depend")
        import("core.project.project")
        import("core.tool.compiler")
        import("utils.progress")

        local objectfile = target:objectfile(sourcefile)
        local dependfile = target:dependfile(objectfile)
        local sourcefiles = target:sourcefiles()

        depend.on_changed(function ()
            progress.show(opt.progress, "${color.build.object}compiling.cosmocc.$(mode) %s", sourcefile)
            if (not is_host("windows"))then
                compiler.compile(sourcefile, objectfile, {target = target})
            else 
                
                local sourcefile_cygwin=path.cygwin_path(sourcefile)
                local objectfile_cygwin=path.cygwin_path(objectfile)
                --local include_path_cygwin???

                local tool,args = compiler.compargv(sourcefile_cygwin, objectfile_cygwin, {target = target})
                -- local cmd=compiler.compcmd(sourcefile_cygwin, objectfile_cygwin, {target = target})
                -- print(cmd)
                -- local tool_cygwin=path.cygwin_path(tool)
                -- os.runv("sh "..tool_cygwin,args,{shell=true})
                os.runv(tool,args,{shell=true})
                -- print(tool_cygwin)
                -- print(args)
                -- os.execv("sh ".."cosmocc/bin/cosmocc",args)

            end
        end,
        {dependfile = dependfile, lastmtime = os.mtime(dependfile), files = sourcefiles, changed = target:is_rebuilt()})

    end)

    on_link(function (target,opt)

        import("core.base.option")
        import("core.theme.theme")
        import("core.project.config")
        import("core.project.depend")
        import("core.project.project")
        import("core.tool.linker")
        import("utils.progress")

        local targetfile  = target:targetfile()
        local dependfile  = target:dependfile(targetfile)
        local objectfiles = target:objectfiles()

        depend.on_changed(function ()
            progress.show(opt.progress, "${color.build.target}linking.$(mode) %s", targetfile)
            if (not is_host("windows"))then
                linker.link(target:get("kind"), "cc", objectfiles, target:targetfile(), {target = target})
            else

                local objectfiles_cygwin={}
                local targetfile_cygwin=path.cygwin_path(targetfile)
                for k,v in ipairs(objectfiles)do 
                    local objectfile_cygwin=path.cygwin_path(v)
                    table.insert(objectfiles_cygwin,objectfile_cygwin)
                end

                local tool,args=linker.linkargv(target:get("kind"), "cc", objectfiles_cygwin, targetfile_cygwin, {target = target})
                os.mkdir("$(buildir)/unknown/unknown/$(mode)")
                os.execv(tool,args,{shell=true })

            end 

        end,
        {dependfile = dependfile, lastmtime = os.mtime(target:targetfile()), files = objectfiles, changed = target:is_rebuilt()})

    end)



target_end()



--
-- If you want to known more usage about xmake, please see https://xmake.io
--
-- ## FAQ
--
-- You can enter the project directory firstly before building project.
--
--   $ cd projectdir
--
-- 1. How to build project?
--
--   $ xmake
--
-- 2. How to configure project?
--
--   $ xmake f -p [macosx|linux|iphoneos ..] -a [x86_64|i386|arm64 ..] -m [debug|release]
--
-- 3. Where is the build output directory?
--
--   The default output directory is `./build` and you can configure the output directory.
--
--   $ xmake f -o outputdir
--   $ xmake
--
-- 4. How to run and debug target after building project?
--
--   $ xmake run [targetname]
--   $ xmake run -d [targetname]
--
-- 5. How to install target to the system directory or other output directory?
--
--   $ xmake install
--   $ xmake install -o installdir
--
-- 6. Add some frequently-used compilation flags in xmake.lua
--
-- @code
--    -- add debug and release modes
--    add_rules("mode.debug", "mode.release")
--
--    -- add macro definition
--    add_defines("NDEBUG", "_GNU_SOURCE=1")
--
--    -- set warning all as error
--    set_warnings("all", "error")
--
--    -- set language: c99, c++11
--    set_languages("c99", "c++11")
--
--    -- set optimization: none, faster, fastest, smallest
--    set_optimize("fastest")
--
--    -- add include search directories
--    add_includedirs("/usr/include", "/usr/local/include")
--
--    -- add link libraries and search directories
--    add_links("tbox")
--    add_linkdirs("/usr/local/lib", "/usr/lib")
--
--    -- add system link libraries
--    add_syslinks("z", "pthread")
--
--    -- add compilation and link flags
--    add_cxflags("-stdnolib", "-fno-strict-aliasing")
--    add_ldflags("-L/usr/local/lib", "-lpthread", {force = true})
--
-- @endcode
--

