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

TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_SMP := true 
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_VARIANT := cortex-a9
ARCH_ARM_HAVE_TLS_REGISTER := true


TARGET_BOARD_PLATFORM := zte
TARGET_BOOTLOADER_BOARD_NAME := zx296702


TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true
TARGET_NO_KERNEL := false

BOARD_KERNEL_BASE := 0x50000000
TARGET_ZTE_BOOTLOADER := $(PRODUCT_OUT)/u-boot.bin
TARGET_ZTE_LOGO := true
TARGET_ZTE_KERNEL := $(PRODUCT_OUT)/uImage
TARGET_ZTE_RECOVERY_KERNEL := $(PRODUCT_OUT)/uImage
TARGET_OTA_UPDATE_DTB := true

TARGET_USERIMAGES_USE_EXT4 := true
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1073741824            
BOARD_USERDATAIMAGE_PARTITION_SIZE := 1073741824
BOARD_FLASH_BLOCK_SIZE := 4096

# camera config
USE_CAMERA_STUB := true
BOARD_HAVE_FRONT_CAM := false
BOARD_HAVE_BACK_CAM := false
BOARD_HAVE_MULTI_CAMERAS := false
BOARD_HAVE_FLASHLIGHT := false
BOARD_USE_USB_CAMERA := false

# audio config
BOARD_USES_GENERIC_AUDIO := true
BOARD_USES_I2S_AUDIO := false
BOARD_USES_PCM_AUDIO := false
BOARD_USES_SPDIF_AUDIO := false
BOARD_HAVE_BLUETOOTH := false

# tvout config
BOARD_USES_TVOUT := true

# opengl config
USE_OPENGL_RENDERER := true
BOARD_EGL_CFG := device/zte/zx296702/egl.cfg

# zteplayer config
USE_ZTE_PLAYER := true

# cursorlayer cofnig
BOARD_USES_CURSORLAYER := false

# Include an expanded selection of fonts 
EXTENDED_FONT_FOOTPRINT := true  

# wifi config
BOARD_WIFI_VENDOR := realtek
ifeq ($(BOARD_WIFI_VENDOR), realtek)
    WPA_SUPPLICANT_VERSION := VER_0_8_X
    BOARD_WPA_SUPPLICANT_DRIVER := NL80211
    BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_rtl
    BOARD_HOSTAPD_DRIVER := NL80211
    BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_rtl
    BOARD_WLAN_DEVICE := rtl8192cu
    #BOARD_WLAN_DEVICE := rtl8192du
    #BOARD_WLAN_DEVICE := rtl8192ce
    #BOARD_WLAN_DEVICE := rtl8192de
    #BOARD_WLAN_DEVICE := rtl8723as
    #BOARD_WLAN_DEVICE := rtl8723au
    #BOARD_WLAN_DEVICE := rtl8188es

    WIFI_DRIVER_MODULE_NAME   := wlan
    WIFI_DRIVER_MODULE_PATH   := "/system/lib/modules/wlan.ko"

    WIFI_DRIVER_MODULE_ARG    := ""
    WIFI_FIRMWARE_LOADER      := ""
    WIFI_DRIVER_FW_PATH_STA   := ""
    WIFI_DRIVER_FW_PATH_AP    := ""
    WIFI_DRIVER_FW_PATH_P2P   := ""
    WIFI_DRIVER_FW_PATH_PARAM := ""
endif

# add for enable VIEWRIGHT_STB_ENABLE in bionic
BUILD_WITH_VIEWRIGHT_STB := false

# sepolicy
BOARD_SEPOLICY_DIRS += build/target/board/generic/sepolicy
#BOARD_SEPOLICY_DIRS := device/zx296702/zx296702/sepolicy   

BOARD_SEPOLICY_UNION += \
	bootanim.te \
	device.te \
	domain.te \
	file.te \
	file_contexts \
	qemud.te \
	rild.te \
	shell.te \
	surfaceflinger.te \
	system_server.te

