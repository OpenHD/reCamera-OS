################################################################################
#
# OpenHD
#
################################################################################

# The Git repository from which to clone the source code
OPENHD_SITE = https://github.com/OpenHD/OpenHD.git
OPENHD_SITE_METHOD = git
OPENHD_GIT_SUBMODULES = YES

# The specific commit or tag to checkout
OPENHD_VERSION = 9689685031b0b0506e4c5e10927b78df43f55d0f

# Enable Git submodules if the project requires them
OPENHD_GIT_SUBMODULES = YES

# Subdirectory inside the Git repo, if needed (if OpenHD is not in the root)
OPENHD_SUBDIR = OpenHD

# No need to install to the staging directory, only target
OPENHD_INSTALL_STAGING = NO
OPENHD_INSTALL_TARGET = YES

# Additional configuration options for the CMake build
OPENHD_CONF_OPTS = -DENABLE_USB_CAMERAS=OFF

# List of dependencies that must be built before OpenHD
OPENHD_DEPENDENCIES = libsodium gstreamer1 gst1-plugins-base libpcap host-pkgconf poco

# Define the CMake build commands to correctly set Poco_DIR or CMAKE_PREFIX_PATH
define OPENHD_BUILD_CMDS
    $(TARGET_CONFIGURE_OPTS) \
    cmake -DCMAKE_INSTALL_PREFIX=$(TARGET_DIR) \
          -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_PREFIX_PATH=/usr/lib/cmake/Poco \
          $(OPENHD_CONF_OPTS) \
          $(@D)
endef

# Use Buildroot's CMake package infrastructure to handle the build
$(eval $(cmake-package))
