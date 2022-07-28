cmake_minimum_required(VERSION 3.5)

project(stu_faust LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread")

add_compile_options(-DINTERP_BUILD -DLLVM_BUILD -DCPP_BUILD -DC_BUILD)

set(FAUST_LIBS)
set(FAUST_DEFINITIONS)

include (cmake/misc/llvm.cmake)

include_directories(${LLVM_INCLUDE_DIRS})

include_directories(arch/)
include_directories(compiler/)
include_directories(compiler/errors)
include_directories(compiler/tlib)
include_directories(compiler/signals)
include_directories(compiler/boxes)
include_directories(compiler/extended)
include_directories(compiler/documentator)
include_directories(compiler/draw)
include_directories(compiler/draw/schema)
include_directories(compiler/draw/device)
include_directories(compiler/normalize)
include_directories(compiler/propagate)
include_directories(compiler/patternmatcher)
include_directories(compiler/transform)

include_directories(compiler/generator)
include_directories(compiler/generator/fir)
include_directories(compiler/generator/llvm)
include_directories(compiler/generator/c)
include_directories(compiler/generator/cpp)
include_directories(compiler/parallelize)
include_directories(compiler/utils)

include_directories(compiler/evaluate)
include_directories(compiler/parser)
include_directories(compiler/generator)
include_directories(compiler/generator/interpreter)

file(GLOB_RECURSE SRC_COMPILERS  compiler/*.h compiler/*.hh compiler/*.cpp )
#list(REMOVE_ITEM tests freeverb.dsp) #delete an item

add_executable(
    faust
    ${SRC_COMPILERS}
    #main.cpp
)
ENABLE_LLVM(faust)
