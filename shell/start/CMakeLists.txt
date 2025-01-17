cmake_minimum_required(VERSION 3.12)

project(startmenu-plugin)

set(GRESOURCE_DEPENDENCIES "")

find_package(PkgConfig REQUIRED)

pkg_check_modules(GARCON REQUIRED garcon-1)
pkg_check_modules(GARCON_GTK3 REQUIRED garcon-gtk3-1)
pkg_check_modules(GDK REQUIRED gdk-3.0)
pkg_check_modules(GIO REQUIRED gio-2.0)
pkg_check_modules(GLIB REQUIRED glib-2.0)
pkg_check_modules(GTK3 REQUIRED gtk+-3.0)
pkg_check_modules(XFCE4PANEL REQUIRED libxfce4panel-2.0)
pkg_check_modules(XFCE4UTIL REQUIRED libxfce4util-1.0)

find_program(GLIB_COMPILE_RESOURCES glib-compile-resources REQUIRED)

execute_process(
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/src/res
    COMMAND ${GLIB_COMPILE_RESOURCES} --generate-dependencies resources.xml
    OUTPUT_VARIABLE GRESOURCE_DEPENDENCIES)

string(REPLACE "\n" ";" GRESOURCE_DEPENDENCIES ${GRESOURCE_DEPENDENCIES})
list(POP_BACK GRESOURCE_DEPENDENCIES)
list(TRANSFORM GRESOURCE_DEPENDENCIES PREPEND "src/res/")

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/src/resources.c
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/src/res
    COMMAND ${GLIB_COMPILE_RESOURCES}
    ARGS
        --target=../resources.c
        --generate
        resources.xml
    VERBATIM
    MAIN_DEPENDENCY src/res/resources.xml
    DEPENDS
    ${GRESOURCE_DEPENDENCIES})

add_custom_target(
    project-resources
    DEPENDS src/resources.c)

include_directories(
    ${GARCON_INCLUDE_DIRS}
    ${GARCON_GTK3_INCLUDE_DIRS}
    ${GDK_INCLUDE_DIRS}
    ${GIO_INCLUDE_DIRS}
    ${GLIB_INCLUDE_DIRS}
    ${GTK3_INCLUDE_DIRS}
    ${XFCE4PANEL_INCLUDE_DIRS}
    ${XFCE4UTIL_INCLUDE_DIRS})

link_directories(
    ${GARCON_LIBRARY_DIRS}
    ${GARCON_GTK3_LIBRARY_DIRS}
    ${GDK_LIBRARY_DIRS}
    ${GIO_LIBRARY_DIRS}
    ${GLIB_LIBRARY_DIRS}
    ${GTK3_LIBRARY_DIRS}
    ${XFCE4PANEL_LIBRARY_DIRS}
    ${XFCE4UTIL_LIBRARY_DIRS})

add_library(startmenu-plugin MODULE
    src/action.h
    src/action.c
    src/placeslist.h
    src/placeslist.c
    src/plugin.h
    src/plugin.c
    src/programslist.h
    src/programslist.c
    src/resources.c
    src/startbutton.h
    src/startbutton.c
    src/startmenu.h
    src/startmenu.c
    src/startmenuitem.h
    src/startmenuitem.c
    src/util.h
    src/util.c)

add_dependencies(startmenu-plugin project-resources)

target_link_libraries(startmenu-plugin
    PRIVATE ${GARCON_LIBRARIES}
    PRIVATE ${GARCON_GTK3_LIBRARIES}
    PRIVATE ${GDK_LIBRARIES}
    PRIVATE ${GIO_LIBRARIES}
    PRIVATE ${GLIB_LIBRARIES}
    PRIVATE ${GTK3_LIBRARIES}
    PRIVATE ${XFCE4PANEL_LIBRARIES}
    PRIVATE ${XFCE4UTIL_LIBRARIES})
