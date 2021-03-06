cmake_minimum_required(VERSION 3.2)

project(Welle.Io VERSION 0.0.0 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 14)

add_definitions(-Wall)
add_definitions(-g)
add_definitions(-DDABLIN_AAC_FAAD2)

if(MINGW)
    add_definitions(-municode)
endif()

if(NOT CMAKE_BUILD_TYPE)
   set(CMAKE_BUILD_TYPE "Release")
   message(STATUS "Build type not specified: defaulting to release.")
endif(NOT CMAKE_BUILD_TYPE)
set(CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE} CACHE STRING "")

#enable_testing()

list(INSERT CMAKE_MODULE_PATH 0 ${CMAKE_SOURCE_DIR}/cmake/Modules)

if(NOT DEFINED BUILD_WELLE_IO)
    set(BUILD_WELLE_IO ON)
endif()

if(NOT DEFINED KISS_FFT)
    set(KISS_FFT OFF)
endif()

if(NOT DEFINED PROFILING)
    set(PROFILING OFF)
endif()

if(NOT APPLE)
  if(NOT DEFINED BUILD_WELLE_CLI)
    set(BUILD_WELLE_CLI ON)
  endif()
endif()

include(GNUInstallDirs)

if(BUILD_WELLE_IO)
    set(CMAKE_AUTOMOC ON)
    set(CMAKE_AUTORCC ON)

    find_package(Qt5 COMPONENTS Widgets Quick Multimedia Charts Qml REQUIRED)
endif()

if(PROFILING)
    add_definitions(-DWITH_PROFILING)
endif()

find_package(ALSA)
if(ALSA_FOUND)
    add_definitions(-DHAVE_ALSA)
endif()

if(KISS_FFT)
    add_definitions(-DKISSFFT)
    set(fft_sources src/libs/kiss_fft/kiss_fft.c)
    set(KISS_INCLUDE_DIRS src/libs/kiss_fft)
else()
    find_package(FFTW3f REQUIRED)
    set(fft_sources "")
    set(KISS_INCLUDE_DIRS "")
endif()

if(BUILD_WELLE_CLI)
    find_package(Lame REQUIRED)
endif()

find_package(Threads REQUIRED)
find_package(Faad REQUIRED)
find_package(MPG123 REQUIRED)

if (RTLSDR)
    find_package(LibRTLSDR REQUIRED)
endif()

if (AIRSPY)
    find_package(LibAIRSPY REQUIRED)
endif()

if (SOAPYSDR)
  find_package(SoapySDR NO_MODULE REQUIRED)
  # Note: SoapySDRConfig.cmake sets C++11 standard so it needs to be reset to C++14
  set(CMAKE_CXX_STANDARD 14)
endif()

include_directories(
    src
    src/backend
    src/output
    src/various
    src/input
    src/gui
    src/libs/fec
    ${FFTW3F_INCLUDE_DIRS}
    ${KISS_INCLUDE_DIRS}
    ${FAAD_INCLUDE_DIRS}
    ${LIBRTLSDR_INCLUDE_DIRS}
    ${SoapySDR_INCLUDE_DIRS}
)

set(backend_sources
    src/backend/dab-audio.cpp
    src/backend/decoder_adapter.cpp
    src/backend/dab_decoder.cpp
    src/backend/dabplus_decoder.cpp
    src/backend/charsets.cpp
    src/backend/dab-constants.cpp
    src/backend/mot_manager.cpp
    src/backend/pad_decoder.cpp
    src/backend/eep-protection.cpp
    src/backend/fib-processor.cpp
    src/backend/fic-handler.cpp
    src/backend/msc-handler.cpp
    src/backend/freq-interleaver.cpp
    src/backend/ofdm-decoder.cpp
    src/backend/ofdm-processor.cpp
    src/backend/phasereference.cpp
    src/backend/phasetable.cpp
    src/backend/tii-decoder.cpp
    src/backend/protTables.cpp
    src/backend/radio-receiver.cpp
    src/backend/tools.cpp
    src/backend/uep-protection.cpp
    src/backend/viterbi.cpp
    src/various/Socket.cpp
    src/various/Xtan2.cpp
    src/various/channels.cpp
    src/various/fft.cpp
    src/various/profiling.cpp
    src/various/wavfile.c
    src/libs/fec/decode_rs_char.c
    src/libs/fec/encode_rs_char.c
    src/libs/fec/init_rs_char.c
)

set(welle_io_sources
    src/welle-gui/main.cpp
    src/welle-gui/audio_output.cpp
    src/welle-gui/mot_image_provider.cpp
    src/welle-gui/gui_helper.cpp
    src/welle-gui/radio_controller.cpp
    src/welle-gui/debug_output.cpp
    src/welle-gui/waterfallitem.cpp
)

set(welle_cli_sources
    src/welle-cli/welle-cli.cpp
    src/welle-cli/alsa-output.cpp
    src/welle-cli/webradiointerface.cpp
    src/welle-cli/webprogrammehandler.cpp
    src/welle-cli/tests.cpp
)

set(input_sources
    src/input/input_factory.cpp
    src/input/null_device.cpp
    src/input/raw_file.cpp
    src/input/rtl_tcp.cpp
)

if(LIBRTLSDR_FOUND)
    add_definitions (-DHAVE_RTLSDR)
    set(input_sources  ${input_sources} src/input/rtl_sdr.cpp)
endif()

if(LIBAIRSPY_FOUND)
    add_definitions (-DHAVE_AIRSPY)
    set(input_sources  ${input_sources} src/input/airspy_sdr.cpp)
endif()

if(SoapySDR_FOUND)
    add_definitions (-DHAVE_SOAPYSDR)
    set(input_sources  ${input_sources} src/input/soapy_sdr.cpp)
endif()

if(NOT GIT_COMMIT_HASH)
  execute_process(
    COMMAND git rev-parse --short HEAD
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE GIT_COMMIT_HASH
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )
endif()

if(GIT_COMMIT_HASH)
  add_definitions("-DGITHASH=\"${GIT_COMMIT_HASH}\"")
endif()

if(NOT GIT_DESCRIBE)
  execute_process(
    COMMAND git describe --tags --long
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE GIT_DESCRIBE
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )
endif()

if(GIT_DESCRIBE)
  add_definitions("-DGITDESCRIBE=\"${GIT_DESCRIBE}\"")
endif()

if(BUILD_WELLE_IO)
    set(executableName welle-io)
    add_executable (${executableName} ${welle_io_sources} ${backend_sources} ${input_sources} ${fft_sources} ${EXTRA_MOCS} src/welle-gui/resources.qrc)

    target_link_libraries (${executableName}
      ${LIBRTLSDR_LIBRARIES}
      ${LIBAIRSPY_LIBRARIES}
      ${FFTW3F_LIBRARIES}
      ${FAAD_LIBRARIES}
      ${SoapySDR_LIBRARIES}
      ${MPG123_LIBRARIES}
      Threads::Threads
      Qt5::Core Qt5::Widgets Qt5::Multimedia Qt5::Charts Qt5::Qml Qt5::Quick
    )

    INSTALL (TARGETS ${executableName} RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
endif()

if(BUILD_WELLE_CLI)
    set(cliExecutableName welle-cli)
    add_executable (${cliExecutableName} ${welle_cli_sources} ${backend_sources} ${input_sources} ${fft_sources})

    if(CMAKE_BUILD_TYPE MATCHES Debug)
      SET_TARGET_PROPERTIES(${cliExecutableName} PROPERTIES COMPILE_FLAGS "-O2 -fno-omit-frame-pointer -fsanitize=address")
      SET_TARGET_PROPERTIES(${cliExecutableName} PROPERTIES LINK_FLAGS "-fno-omit-frame-pointer -fsanitize=address")
    endif(CMAKE_BUILD_TYPE MATCHES Debug)

    target_link_libraries (${cliExecutableName}
      ${LIBRTLSDR_LIBRARIES}
      ${LIBAIRSPY_LIBRARIES}
      ${FFTW3F_LIBRARIES}
      ${FAAD_LIBRARIES}
      ${ALSA_LIBRARIES}
      ${LAME_LIBRARIES}
      ${SoapySDR_LIBRARIES}
      ${MPG123_LIBRARIES}
      Threads::Threads
    )

    INSTALL (TARGETS ${cliExecutableName} RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

    add_custom_command(
            TARGET ${cliExecutableName} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_SOURCE_DIR}/src/welle-cli/index.html
                    ${CMAKE_CURRENT_BINARY_DIR}/index.html)
    add_custom_command(
            TARGET ${cliExecutableName} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_SOURCE_DIR}/src/welle-cli/index.js
                    ${CMAKE_CURRENT_BINARY_DIR}/index.js)
endif()

INSTALL (FILES ${PROJECT_SOURCE_DIR}/welle-io.desktop DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/applications)

INSTALL (FILES ${PROJECT_SOURCE_DIR}/src/welle-gui/icon/16x16/welle-io.png DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/16x16/apps)
INSTALL (FILES ${PROJECT_SOURCE_DIR}/src/welle-gui/icon/24x24/welle-io.png DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/24x24/apps)
INSTALL (FILES ${PROJECT_SOURCE_DIR}/src/welle-gui/icon/32x32/welle-io.png DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/32x32/apps)
INSTALL (FILES ${PROJECT_SOURCE_DIR}/src/welle-gui/icon/48x48/welle-io.png DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/48x48/apps)
INSTALL (FILES ${PROJECT_SOURCE_DIR}/src/welle-gui/icon/128x128/welle-io.png DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/128x128/apps)
INSTALL (FILES ${PROJECT_SOURCE_DIR}/src/welle-gui/icon/256x256/welle-io.png DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/256x256/apps)

INSTALL (
  FILES
    ${PROJECT_SOURCE_DIR}/src/welle-cli/index.html
    ${PROJECT_SOURCE_DIR}/src/welle-cli/index.js
  DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/welle-io/html/
)

configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/cmake_uninstall.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
    IMMEDIATE @ONLY)

add_custom_target(uninstall
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)
