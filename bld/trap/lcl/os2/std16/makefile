#pmake: lcl os_os2 cpu_i86 trap
#
# Create the OS/2 STD16.DLL
#

tree_depth = 5

host_cpu = i86
host_os  = os2

target_cpu = x86

srv          = lcl
name         = std16
which        = TRAP
core_entries = 1

extra_objs = &
    accmisc.obj &
    os2v1acc.obj &
    os2path.obj &
    os2rfx.obj &
    loadstd.obj &
    misc7086.obj &
    x86cpu.obj &
    supp.obj &
    core.obj

!include $(trap_dir)/lcl/os2/os2.mif
!include $(trap_dir)/lcl/lcl.mif
!include $(trap_dir)/master.mif
