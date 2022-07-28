
####################################
function(backend NAME DIR TARGET)
	message(STATUS "In target ${TARGET}: include ${NAME} backend")
	target_compile_definitions (${TARGET} PRIVATE -D${NAME}_BUILD)
	if (NOT "${DIR}" STREQUAL "")
		file (GLOB BACKEND_SRC	${SRCDIR}/generator/${DIR}/*.cpp ${SRCDIR}/generator/${DIR}/*.hh)
		target_sources (${TARGET} PRIVATE ${BACKEND_SRC})
		target_include_directories (${TARGET} PRIVATE ${SRCDIR}/generator/${DIR})
	endif()
endfunction()

####################################
function (scan_backends TARGET FLAG)
	string (FIND "${C_BACKEND}" ${FLAG} POS)
	if (${POS} GREATER -1)
		backend (C c ${TARGET})
	endif()
	string (FIND "${CPP_BACKEND}" ${FLAG} POS)
	if (${POS} GREATER -1)
		backend (CPP cpp ${TARGET})
	endif()
	string (FIND "${CSHARP_BACKEND}" ${FLAG} POS)
	if (${POS} GREATER -1)
		backend (CSHARP csharp ${TARGET})
	endif()
	string (FIND "${DLANG_BACKEND}" ${FLAG} POS)
	if (${POS} GREATER -1)
		backend (DLANG dlang ${TARGET})
	endif()
	string (FIND "${FIR_BACKEND}" ${FLAG} POS)
	if (${POS} GREATER -1)
		backend (FIR "" ${TARGET})
	endif()
	string (FIND "${INTERP_BACKEND}" ${FLAG} POS)
	if (${POS} GREATER -1)
		backend (INTERP interpreter ${TARGET})
	endif()
	string (FIND "${JAVA_BACKEND}" ${FLAG} POS)
	if (${POS} GREATER -1)
		backend (JAVA java ${TARGET})
	endif()	
	string (FIND "${JULIA_BACKEND}" ${FLAG} POS)
	if (${POS} GREATER -1)
		backend (JULIA julia ${TARGET})
	endif()	
	string (FIND "${OLDCPP_BACKEND}" ${FLAG} POS)
	if (${POS} GREATER -1)
		backend (OCPP "" ${TARGET})
	endif()
	string (FIND "${RUST_BACKEND}" ${FLAG} POS)
	if (${POS} GREATER -1)
		backend (RUST rust ${TARGET})
	endif()
	string (FIND "${SOUL_BACKEND}" ${FLAG} POS)
	if (${POS} GREATER -1)
		backend (SOUL soul ${TARGET})
	endif()
	string (FIND "${WASM_BACKEND}" ${FLAG} POS)
	if (${POS} GREATER -1)
		backend (WASM wasm ${TARGET})
	endif()
	string (FIND "${LLVM_BACKEND}" ${FLAG} POS)
	if (${POS} GREATER -1)
		backend (LLVM llvm ${TARGET})
		target_compile_definitions (${TARGET} PRIVATE -D${LLVM_VERSION})
		target_include_directories (${TARGET} PRIVATE ${SRCDIR}/generator/c ${SRCDIR}/generator/cpp  ${LLVM_INCLUDE_DIRS})
	endif()
endfunction()

####################################
# Manual LLVM scan
macro (llvm_config)
	if ( NOT DEFINED LLVM_CONFIG)
		set (LLVM_CONFIG llvm-config)
	endif()
	find_program (LC ${LLVM_CONFIG})
	if (${LC} STREQUAL LC-NOTFOUND)
		message (FATAL_ERROR "Cannot find program ${LLVM_CONFIG} (llvm-config or derived expected)")
	endif()
	execute_process (COMMAND ${LLVM_CONFIG} --version OUTPUT_VARIABLE LLVM_VERSION)
	string ( STRIP ${LLVM_VERSION} LLVM_PACKAGE_VERSION )
	message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")

	execute_process (COMMAND ${LLVM_CONFIG} --includedir OUTPUT_VARIABLE LLVM_INCLUDE)
	string ( STRIP ${LLVM_INCLUDE} LLVM_INCLUDE_DIRS )
	execute_process (COMMAND ${LLVM_CONFIG} --ldflags OUTPUT_VARIABLE LLVM_LDFLAGS_TMP)
	string ( STRIP ${LLVM_LDFLAGS_TMP} LLVM_LD_FLAGS )
	execute_process (COMMAND ${LLVM_CONFIG}  --libs OUTPUT_VARIABLE LLVM_LIBS_TMP)
	string ( STRIP ${LLVM_LIBS_TMP} LLVM_LIBS_TMP2 )
	string ( REPLACE "C:\\Program Files\\LLVM\\lib\\" "" LLVM_LIBS ${LLVM_LIBS_TMP2})
	execute_process (COMMAND ${LLVM_CONFIG}  --system-libs OUTPUT_VARIABLE LLVM_SYS_LIBS_TMP)
	string ( STRIP ${LLVM_SYS_LIBS_TMP} LLVM_SYS_LIBS)
	
    string ( APPEND LLVM_LIBS " ${LLVM_SYS_LIBS}")
    string ( REPLACE " " ";" LLVM_LIBS ${LLVM_LIBS} )
endmacro()

####################################
# cmake LLVM scan
macro (llvm_cmake)
	find_package(LLVM REQUIRED CONFIG)
	if (COMMAND llvm_map_components_to_libnames)
		message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
		message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")
		# Find the libraries that correspond to the LLVM components that we wish to use
		llvm_map_components_to_libnames(LLVM_LIBS all)
#		list(REMOVE_ITEM LLVM_LIBS LTO)
	else()
		llvm_config()
	endif()
endmacro()


####################################
macro (include_llvm)
	set (INCLUDE_LLVM off)
	if (LLVM_BACKEND)
		string (FIND "${LLVM_BACKEND}" "STATIC"  POS)
		if (${POS} GREATER -1 AND INCLUDE_STATIC)
			set (INCLUDE_LLVM on)
		endif()
		string (FIND "${LLVM_BACKEND}" "DYNAMIC" POS)
		if (${POS} GREATER -1 AND INCLUDE_DYNAMIC)
			set (INCLUDE_LLVM on)
		endif()
		string (FIND "${LLVM_BACKEND}" "COMPILER"  POS)
		if (${POS} GREATER -1)
			set (INCLUDE_LLVM on)
		endif()
	endif()
endmacro()

#include_llvm()

###########
function(ENABLE_LLVM var)

    find_package(LLVM REQUIRED CONFIG)

    message(STATUS "This is BINARY dir " ${PROJECT_BINARY_DIR})
    message(STATUS "This is SOURCE dir " ${PROJECT_SOURCE_DIR})
    message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
    message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

    # Set your project compile flags.
    # E.g. if using the C++ header files
    # you will need to enable C++11 support
    # for your compiler.
    target_include_directories(${var} PUBLIC ${LLVM_INCLUDE_DIRS})
    #LLVM_VERSION
    target_compile_definitions(${var} PUBLIC ${LLVM_DEFINITIONS} -DLLVM_VERSION="6.0.0")


    # Find the libraries that correspond to the LLVM components
    # that we wish to use
    llvm_map_components_to_libnames(llvm_libs support core irreader ExecutionEngine
        MCJIT Passes Interpreter x86CodeGen x86AsmParser linker
        DlltoolDriver ObjCARCOpts
        )
    #llvm_map_components_to_libnames(llvm_libs all)
    message(STATUS "llvm_libs: ${llvm_libs}")
    target_link_libraries(${var} PUBLIC ${llvm_libs})
endfunction()
