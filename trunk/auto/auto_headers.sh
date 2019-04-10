#!/bin/bash

# output variables:
# SRS_AUTO_HEADERS_H: the auto generated header file.

SRS_AUTO_HEADERS_H="${SRS_OBJS}/srs_auto_headers.hpp"

# write user options to headers
echo "// auto generated by configure" > $SRS_AUTO_HEADERS_H
echo "#ifndef SRS_AUTO_HEADER_HPP" >> $SRS_AUTO_HEADERS_H
echo "#define SRS_AUTO_HEADER_HPP" >> $SRS_AUTO_HEADERS_H
echo "" >> $SRS_AUTO_HEADERS_H

echo "#define SRS_AUTO_BUILD_TS \"`date +%s`\"" >> $SRS_AUTO_HEADERS_H
echo "#define SRS_AUTO_BUILD_DATE \"`date \"+%Y-%m-%d %H:%M:%S\"`\"" >> $SRS_AUTO_HEADERS_H
echo "#define SRS_AUTO_UNAME \"`uname -a`\"" >> $SRS_AUTO_HEADERS_H
echo "#define SRS_AUTO_USER_CONFIGURE \"${SRS_AUTO_USER_CONFIGURE}\"" >> $SRS_AUTO_HEADERS_H
echo "#define SRS_AUTO_CONFIGURE \"${SRS_AUTO_CONFIGURE}\"" >> $SRS_AUTO_HEADERS_H
echo "" >> $SRS_AUTO_HEADERS_H

function srs_define_macro()
{
    macro=$1 && file=$2
    echo "#define $macro" >> $file
    echo "#define ${macro}_BOOL true" >> $file
}

function srs_define_macro_value()
{
    macro=$1 && value=$2 && file=$3
    echo "#define $macro $value" >> $file
    echo "#define ${macro}_BOOL true" >> $file
}

function srs_undefine_macro()
{
    macro=$1 && file=$2
    echo "#undef $macro" >> $file
    echo "#define ${macro}_BOOL false" >> $file
}

# export the preset.
if [ $SRS_OSX = YES ]; then
    srs_define_macro "SRS_OSX" $SRS_AUTO_HEADERS_H
fi
if [ $SRS_X86_X64 = YES ]; then
    srs_define_macro "SRS_X86_X64" $SRS_AUTO_HEADERS_H
fi
if [ $SRS_ARM_UBUNTU12 = YES ]; then
    srs_define_macro "SRS_ARM_UBUNTU12" $SRS_AUTO_HEADERS_H
fi
if [ $SRS_MIPS_UBUNTU12 = YES ]; then
    srs_define_macro "SRS_MIPS_UBUNTU12" $SRS_AUTO_HEADERS_H
fi
if [ $SRS_PI = YES ]; then
    srs_define_macro "SRS_PI" $SRS_AUTO_HEADERS_H
fi
if [ $SRS_CUBIE = YES ]; then
    srs_define_macro "SRS_CUBIE" $SRS_AUTO_HEADERS_H
fi
if [ $SRS_EXPORT_LIBRTMP_PROJECT != NO ]; then
    echo "#define SRS_EXPORT_LIBRTMP" >> $SRS_AUTO_HEADERS_H
else
    echo "#undef SRS_EXPORT_LIBRTMP" >> $SRS_AUTO_HEADERS_H
fi

echo "" >> $SRS_AUTO_HEADERS_H

#####################################################################################
# generate auto headers file, depends on the finished of options.sh
#####################################################################################
# write to source file
if [ $SRS_CROSS_BUILD = YES ]; then
    __TOOL_CHAIN="cc=$SrsArmCC gcc=$SrsArmGCC g++=$SrsArmCXX ar=$SrsArmAR ld=$SrsArmLD randlib=$SrsArmRANDLIB" && echo "$__TOOL_CHAIN"
    srs_define_macro_value "SRS_AUTO_EMBEDED_TOOL_CHAIN" "\"$__TOOL_CHAIN\"" $SRS_AUTO_HEADERS_H
else
    srs_undefine_macro "SRS_AUTO_EMBEDED_TOOL_CHAIN" $SRS_AUTO_HEADERS_H
fi
echo "" >> $SRS_AUTO_HEADERS_H

# auto headers in depends.
if [ $SRS_KAFKA = YES ]; then
    srs_define_macro "SRS_AUTO_KAFKA" $SRS_AUTO_HEADERS_H
else
    srs_undefine_macro "SRS_AUTO_KAFKA" $SRS_AUTO_HEADERS_H
fi

if [ $SRS_NGINX = YES ]; then
    srs_define_macro "SRS_AUTO_NGINX" $SRS_AUTO_HEADERS_H
else
    srs_undefine_macro "SRS_AUTO_NGINX" $SRS_AUTO_HEADERS_H
fi

if [ $SRS_HDS = YES ]; then
    srs_define_macro "SRS_AUTO_HDS" $SRS_AUTO_HEADERS_H
else
    srs_undefine_macro "SRS_AUTO_HDS" $SRS_AUTO_HEADERS_H
fi

if [ $SRS_MEM_WATCH = YES ]; then
    srs_define_macro "SRS_AUTO_MEM_WATCH" $SRS_AUTO_HEADERS_H
else
    srs_undefine_macro "SRS_AUTO_MEM_WATCH" $SRS_AUTO_HEADERS_H
fi

if [ $SRS_UTEST = YES ]; then
    srs_define_macro "SRS_AUTO_UTEST" $SRS_AUTO_HEADERS_H
else
    srs_undefine_macro "SRS_AUTO_UTEST" $SRS_AUTO_HEADERS_H
fi

# whether compile ffmpeg tool
if [ $SRS_FFMPEG_TOOL = YES ]; then
    srs_define_macro "SRS_AUTO_FFMPEG_TOOL" $SRS_AUTO_HEADERS_H
else
    srs_undefine_macro "SRS_AUTO_FFMPEG_TOOL" $SRS_AUTO_HEADERS_H
fi

# whatever the FFMPEG tools, if transcode and ingest specified,
# srs always compile the FFMPEG tool stub which used to start the FFMPEG process.
if [ $SRS_FFMPEG_STUB = YES ]; then
    srs_define_macro "SRS_AUTO_FFMPEG_STUB" $SRS_AUTO_HEADERS_H
else
    srs_undefine_macro "SRS_AUTO_FFMPEG_STUB" $SRS_AUTO_HEADERS_H
fi

if [ $SRS_GPERF = YES ]; then
    srs_define_macro "SRS_AUTO_GPERF" $SRS_AUTO_HEADERS_H
else
    srs_undefine_macro "SRS_AUTO_GPERF" $SRS_AUTO_HEADERS_H
fi
if [ $SRS_GPERF_MC = YES ]; then
    srs_define_macro "SRS_AUTO_GPERF_MC" $SRS_AUTO_HEADERS_H
else
    srs_undefine_macro "SRS_AUTO_GPERF_MC" $SRS_AUTO_HEADERS_H
fi
if [ $SRS_GPERF_MD = YES ]; then
    srs_define_macro "SRS_AUTO_GPERF_MD" $SRS_AUTO_HEADERS_H
else
    srs_undefine_macro "SRS_AUTO_GPERF_MD" $SRS_AUTO_HEADERS_H
fi
if [ $SRS_GPERF_MP = YES ]; then
    srs_define_macro "SRS_AUTO_GPERF_MP" $SRS_AUTO_HEADERS_H
else
    srs_undefine_macro "SRS_AUTO_GPERF_MP" $SRS_AUTO_HEADERS_H
fi
if [ $SRS_GPERF_CP = YES ]; then
    srs_define_macro "SRS_AUTO_GPERF_CP" $SRS_AUTO_HEADERS_H
else
    srs_undefine_macro "SRS_AUTO_GPERF_CP" $SRS_AUTO_HEADERS_H
fi

#####################################################################################
# for embeded.
#####################################################################################
if [ $SRS_CROSS_BUILD = YES ]; then
    srs_define_macro "SRS_AUTO_EMBEDED_CPU" $SRS_AUTO_HEADERS_H
else
    srs_undefine_macro "SRS_AUTO_EMBEDED_CPU" $SRS_AUTO_HEADERS_H
fi

# arm
if [ $SRS_ARM_UBUNTU12 = YES ]; then
    srs_define_macro "SRS_AUTO_ARM_UBUNTU12" $SRS_AUTO_HEADERS_H
else
    srs_undefine_macro "SRS_AUTO_ARM_UBUNTU12" $SRS_AUTO_HEADERS_H
fi

# mips
if [ $SRS_MIPS_UBUNTU12 = YES ]; then
    srs_define_macro "SRS_AUTO_MIPS_UBUNTU12" $SRS_AUTO_HEADERS_H
else
    srs_undefine_macro "SRS_AUTO_MIPS_UBUNTU12" $SRS_AUTO_HEADERS_H
fi

echo "" >> $SRS_AUTO_HEADERS_H
# for log level compile settings
if [ $SRS_LOG_VERBOSE = YES ]; then
    srs_define_macro "SRS_AUTO_VERBOSE" $SRS_AUTO_HEADERS_H
else
    srs_undefine_macro "SRS_AUTO_VERBOSE" $SRS_AUTO_HEADERS_H
fi
if [ $SRS_LOG_INFO = YES ]; then
    srs_define_macro "SRS_AUTO_INFO" $SRS_AUTO_HEADERS_H
else
    srs_undefine_macro "SRS_AUTO_INFO" $SRS_AUTO_HEADERS_H
fi
if [ $SRS_LOG_TRACE = YES ]; then
    srs_define_macro "SRS_AUTO_TRACE" $SRS_AUTO_HEADERS_H
else
    srs_undefine_macro "SRS_AUTO_TRACE" $SRS_AUTO_HEADERS_H
fi

# prefix
echo "" >> $SRS_AUTO_HEADERS_H
echo "#define SRS_AUTO_PREFIX \"${SRS_PREFIX}\"" >> $SRS_AUTO_HEADERS_H

echo "" >> $SRS_AUTO_HEADERS_H

#####################################################################################
# generated the contributors from AUTHORS.txt
#####################################################################################
SRS_CONSTRIBUTORS=`cat ../AUTHORS.txt|grep "*"|awk '{print $2}'`
echo "#define SRS_AUTO_CONSTRIBUTORS \"\\" >> $SRS_AUTO_HEADERS_H
for CONTRIBUTOR in $SRS_CONSTRIBUTORS; do
    echo "${CONTRIBUTOR} \\" >> $SRS_AUTO_HEADERS_H
done
echo "\"" >> $SRS_AUTO_HEADERS_H

# new empty line to auto headers file.
echo "" >> $SRS_AUTO_HEADERS_H

#####################################################################################
# auto header EOF.
#####################################################################################
echo "#endif" >> $SRS_AUTO_HEADERS_H
echo "" >> $SRS_AUTO_HEADERS_H

