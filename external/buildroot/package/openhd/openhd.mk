################################################################################
#
# OpenHD
#
################################################################################
$(info Building the OpenHD package...)

# The Git repository from which to clone the source code
OPENHD_SITE = https://github.com/openhd/OpenHD.git
OPENHD_SITE_METHOD = git
OPENHD_GIT_SUBMODULES = YES

# Set the version to the latest commit of the default branch
OPENHD_VERSION = 2.6-evo

# Enable Git submodules if the project requires them
OPENHD_GIT_SUBMODULES = YES

# Subdirectory inside the Git repo, if needed (if OpenHD is not in the root)
OPENHD_SUBDIR = OpenHD

# Install to both the staging directory and target, for linking and runtime
OPENHD_INSTALL_STAGING = YES
OPENHD_INSTALL_TARGET = YES

# List of dependencies that must be built before OpenHD
OPENHD_DEPENDENCIES = poco libsodium gstreamer1 gst1-plugins-base libpcap host-pkgconf

# Additional configuration options for the CMake build
OPENHD_CONF_OPTS = \
    -DENABLE_USB_CAMERAS=OFF \
    -DCMAKE_TOOLCHAIN_FILE=$(BR2_TOOLCHAIN_FILE) \
    -DCMAKE_SYSROOT=$(STAGING_DIR) \
    -DCMAKE_PREFIX_PATH=$(STAGING_DIR)/usr \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DPoco_DIR=$(STAGING_DIR)/usr/lib/cmake/Poco  # Tell CMake where to find Poco

# Use Buildroot's CMake package infrastructure to handle the build
$(eval $(cmake-package))
