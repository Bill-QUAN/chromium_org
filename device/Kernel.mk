#
# Copyright (C) 2011 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

ifneq ($(strip $(TARGET_NO_KERNEL)),true)

USE_PREBUILT_KERNEL := false

INSTALLED_KERNEL_TARGET := $(PRODUCT_OUT)/kernel

ifeq ($(USE_PREBUILT_KERNEL),true)

TARGET_PREBUILT_KERNEL := $(LOCAL_PATH)/kernel

$(INSTALLED_KERNEL_TARGET): $(TARGET_PREBUILT_KERNEL) | $(ACP)
	@echo "Kernel installed"
	$(transform-prebuilt-to-target)
	@echo "cp kernel modules"

else

KERNEL_ARCH := arm
KERNEL_ROOTDIR := kernel3.14
KERNEL_DEFCONFIG := zx_defconfig
KERNEL_DEVICETREE := zx296702-ad1
KERNEL_OUT := $(ANDROID_PRODUCT_OUT)/obj/KERNEL_OBJ
KERNEL_CONFIG := $(KERNEL_OUT)/.config
INTERMEDIATES_KERNEL := $(KERNEL_OUT)/arch/arm/boot/uImage
KERNEL_LOADADDR := 0x50008000
KERNEL_DTB := $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/dts/$(KERNEL_DEVICETREE).dtb
BOARD_MKBOOTIMG_ARGS := --second $(KERNEL_DTB)
TARGET_ZTE_INT_KERNEL := $(KERNEL_OUT)/arch/arm/boot/uImage
TARGET_ZTE_INT_RECOVERY_KERNEL := $(KERNEL_OUT)/arch/arm/boot/uImage_recovery

MALI_OUT := $(ANDROID_PRODUCT_OUT)/obj/hardware/arm/gpu/mali
UMP_OUT  := $(ANDROID_PRODUCT_OUT)/obj/hardware/arm/gpu/ump
WIFI_OUT := $(ANDROID_PRODUCT_OUT)/obj/hardware/wifi

#PREFIX_CROSS_COMPILE := arm-linux-androideabi-
PREFIX_CROSS_COMPILE := /opt/linaro-tool/android-toolchain-eabi/bin/arm-eabi-

define cp-modules
endef

$(KERNEL_OUT):
	mkdir -p $(KERNEL_OUT)

$(KERNEL_CONFIG): $(KERNEL_OUT)
	$(MAKE) -C $(KERNEL_ROOTDIR) O=$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) $(KERNEL_DEFCONFIG)

$(INTERMEDIATES_KERNEL): $(KERNEL_OUT) $(KERNEL_CONFIG)
	@echo " make uImage" 
	$(MAKE) -C $(KERNEL_ROOTDIR) O=$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) uImage LOADADDR=$(KERNEL_LOADADDR) -j8
	$(MAKE) -C $(KERNEL_ROOTDIR) O=$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) modules

$(KERNEL_DTB): $(INTERMEDIATES_KERNEL)
	$(MAKE) -C $(KERNEL_ROOTDIR) O=$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) dtbs

$(INSTALLED_KERNEL_TARGET): $(INTERMEDIATES_KERNEL) $(KERNEL_DTB) | $(ACP)
	$(hide) $(ACP) $(INTERMEDIATES_KERNEL) $(ANDROID_PRODUCT_OUT)/kernel
	$(hide) $(ACP) $(KERNEL_DTB) $(ANDROID_PRODUCT_OUT)
	#$(cp-modules)

endif
endif
