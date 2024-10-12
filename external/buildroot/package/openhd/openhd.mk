################################################################################
#
# OpenHD
#
################################################################################

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

# Dependencies that are needed by OpenHD
OPENHD_DEPENDENCIES = libsodium gstreamer1 gst1-plugins-base libpcap host-pkgconf

# Poco version to build from source
POCO_VERSION = 1.13.2
POCO_SITE = https://github.com/pocoproject/poco/archive/refs/tags/poco-$(POCO_VERSION)-release.tar.gz

# Define the steps for downloading and extracting poco
define OPENHD_EXTRACT_POCO
	$(call step_start,extract)
	$(call host-wget,$(POCO_SITE),$(BUILD_DIR))
	tar -xvf $(BUILD_DIR)/poco-$(POCO_VERSION)-release.tar.gz -C $(BUILD_DIR)
	$(call step_end,extract)
endef

# Define the steps to configure poco with CMake
define OPENHD_CONFIGURE_POCO
	$(call step_start,configure)
	cd $(BUILD_DIR)/poco-poco-$(POCO_VERSION)-release && \
	cmake \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=$(STAGING_DIR)/usr \
		-DCMAKE_SYSROOT=$(STAGING_DIR) \
		-DPOCO_UNBUNDLED=ON \
		-DENABLE_TESTS=OFF
	$(call step_end,configure)
endef

# Define the steps to build poco
define OPENHD_BUILD_POCO
	$(call step_start,build)
	cd $(BUILD_DIR)/poco-poco-$(POCO_VERSION)-release && \
	$(MAKE)
	$(call step_end,build)
endef

# Define the steps to install poco
define OPENHD_INSTALL_POCO
	$(call step_start,install)
	cd $(BUILD_DIR)/poco-poco-$(POCO_VERSION)-release && \
	$(MAKE) install
	$(call step_end,install)
endef

# Integrate poco's steps into the OpenHD package build process
OPENHD_POST_EXTRACT_HOOKS += OPENHD_EXTRACT_POCO
OPENHD_POST_CONFIGURE_HOOKS += OPENHD_CONFIGURE_POCO
OPENHD_POST_BUILD_HOOKS += OPENHD_BUILD_POCO
OPENHD_POST_INSTALL_TARGET_HOOKS += OPENHD_INSTALL_POCO

# Additional configuration options for the CMake build of OpenHD
OPENHD_CONF_OPTS = \
	-DENABLE_USB_CAMERAS=OFF \
	-DCMAKE_TOOLCHAIN_FILE=$(BR2_TOOLCHAIN_FILE) \
	-DCMAKE_SYSROOT=$(STAGING_DIR) \
	-DCMAKE_PREFIX_PATH=$(STAGING_DIR)/usr \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DPOCO_DIR=$(STAGING_DIR)/usr/lib/cmake/Poco

# Use Buildroot's CMake package infrastructure to handle the build
$(eval $(cmake-package))
