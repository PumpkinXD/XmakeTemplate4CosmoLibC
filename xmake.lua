--
--  xmake template for c11
--  ver:0.0.1
--
--

toolchain("cosmocc")
    set_kind("standalone")
    on_load(function (toolchain)

        if((is_host("windows"))and(is_subhost("windows")))then
        cprint('${bright red}I guess you should run it with WSL/MSYS/cygwin/mingw\nbtw I don\'t know would it work with git-bash4windows')
        os.exit()
        end

        import("lib.detect.find_program")
        local cosmocc_exist=find_program("cosmocc",{paths={"cosmocc/bin"},check="--version"})
        if(not cosmocc_exist) then
            import("net.http")
            print("cosmocc not found, now downloading...")
            http.download("https://cosmo.zip/pub/cosmocc/cosmocc.zip","cosmocc.zip")
            import("utils.archive")
            archive.extract("cosmocc.zip","cosmocc")
            print("cosmocc downloaded.")
        end
        toolchain:set("bindir","cosmocc/bin")--TODO:Use lib.detect.find_path
        toolchain:set("toolset","cc","gcc@cosmocc")
        toolchain:set("toolset","cxx","gcc@cosmocc")
        toolchain:set("toolset","ld","gcc@cosmocc")
        --toolchain:set("toolset","cxx","g++@cosmoc++") -- Causing "error: cannot runv(cosmoc++ -c -o build/.objs/main.com/unknown/unknown/release/src/<c++ source>.cpp.o src/<c++ source>.cpp), No such file or directory"

        --toolchain:set("toolset","ld","gcc@cosmocc","g++@cosmoc++") -- Same as above


    end)
toolchain_end()


target("main.com")
    set_kind("binary")
    set_toolchains("cosmocc")
    set_plat("unknown")
    set_arch("unknown")
    set_languages("c11","cxx14") -- c11 and cpp14


    add_includedirs("include")
    add_files("src/*.c")
--     add_files("src/*.cpp") -- Causing "cannot match add_files("src/*.cpp") in target(main.com)" if c++ source file(s) are not exist inside "src"

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

