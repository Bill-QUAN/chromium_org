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

LOCAL_PATH := $(LOCAL_PATH)

#$(call inherit-product, build/target/product/core_base.mk)


DEVICE_PACKAGE_OVERLAYS := $(LOCAL_PATH)/overlay

PRODUCT_BOOT_JARS += \
	zte.frameworks.pppoe \
	McspCompCommun \
	McspCfgmanager \
	MCSPLog \
	McspEvt \
	ZTEDisplaySetting \
	McspCfgDispatcher \
	MCPorting

#########################################################################
#
#                          Init
#
#########################################################################
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/root/init.zx296702.rc:root/init.zx296702.rc \
	$(LOCAL_PATH)/root/ueventd.zx296702.rc:root/ueventd.zx296702.rc \
	$(LOCAL_PATH)/root/remote.conf:system/etc/remote.conf \
	$(LOCAL_PATH)/root/fstab.zx296702:root/fstab.zx296702 \
	$(LOCAL_PATH)/root/audio_policy.conf:system/etc/audio_policy.conf

#########################################################################
#
#                          cursorlayer
#
#########################################################################
ifeq ($(BOARD_USES_CURSORLAYER), true)
PRODUCT_COPY_FILES += \
	hardware/zte/$(TARGET_BOOTLOADER_BOARD_NAME)/libcursorlayer/cursorimage/cursor_24x24.8bp:system/bin/cursor_24x24.8bp \
	hardware/zte/$(TARGET_BOOTLOADER_BOARD_NAME)/libcursorlayer/cursorimage/cursor_24x24.tab:system/bin/cursor_24x24.tab \
	hardware/zte/$(TARGET_BOOTLOADER_BOARD_NAME)/libcursorlayer/cursorimage/cursor_16x16.tab:system/bin/cursor_16x16.tab \
	hardware/zte/$(TARGET_BOOTLOADER_BOARD_NAME)/libcursorlayer/cursorimage/cursor_16x16.8bp:system/bin/cursor_16x16.8bp
endif

#########################################################################
#
#                          keymaps
#
#########################################################################
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/Vendor_0001_Product_0001.kl:system/usr/keylayout/Vendor_0001_Product_0001.kl

#########################################################################
#
#                          net
#
#########################################################################
PRODUCT_PACKAGES += \
	wpa_supplicant.conf \
	hostapd_wps \
	wpa_supplicant_overlay.conf \
	p2p_supplicant_overlay.conf

# support miracast
PRODUCT_PACKAGES += p2p_supplicant.conf

PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/net/eth0_ap.sh:system/etc/eth0_ap.sh \
	$(LOCAL_PATH)/net/ppp0_ap.sh:system/etc/ppp0_ap.sh

PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/net/wpa_supplicant_overlay.conf:system/etc/wifi/wpa_supplicant_overlay.conf \
	$(LOCAL_PATH)/net/p2p_supplicant_overlay.conf:system/etc/wifi/p2p_supplicant_overlay.conf

PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/net/iwlist:root/sbin/iwlist \
	$(LOCAL_PATH)/net/iwconfig:root/sbin/iwconfig \
	$(LOCAL_PATH)/net/RT2870STA.dat:system/etc/wlan/RT2870STA.dat

#########################################################################
#
#                          pppoe
#
#########################################################################
PRODUCT_PACKAGES += \
	zte.frameworks.pppoe \
	libpppoe \
	droidlogic.external.pppoe \
	droidlogic.external.pppoe.xml \
	pppoe \
	libpppoejni \
	pcli \
	pppoe_wrapper \
	droidlogic \
	PPPoE

PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/pppoe/ppp.conf:system/etc/ppp.conf \
	$(LOCAL_PATH)/pppoe/ppp.connect:system/etc/ppp.connect \
	$(LOCAL_PATH)/pppoe/ppp.disconnect:system/etc/ppp.disconnect \
	$(LOCAL_PATH)/pppoe/pppoe.dailer.conf:system/etc/pppoe.dailer.conf \
	$(LOCAL_PATH)/pppoe/eth_off.sh:system/etc/eth_off.sh

#########################################################################
#
#                          Filesystem
#
#########################################################################
PRODUCT_PACKAGES += \
	make_ext4fs \
	setup_fs

# NTFS
PRODUCT_PACKAGES += ntfs-3g

# exfat-fuse
PRODUCT_PACKAGES += \
	fsck.exfat \
	mkfs.exfat \
	mount.exfat

#########################################################################
#
#                          Audio
#
#########################################################################
PRODUCT_PACKAGES += \
	audio_policy.zx296702 \
	audio.primary.zx296702 \
	audio.a2dp.default \
	libaudioutils


# The OpenGL ES API level that is natively supported by this device.
# This is a 16.16 fixed point number
PRODUCT_PROPERTY_OVERRIDES := \
	ro.opengles.version=131072

# libhwui flags
PRODUCT_PROPERTY_OVERRIDES += \
	debug.hwui.render_dirty_regions=false

# Set default USB interface
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
	persist.sys.usb.config=mtp

PRODUCT_PROPERTY_OVERRIDES += \
	ro.sf.lcd_density=160 \
    wifi.interface=wlan0

# Set default locale
PRODUCT_PROPERTY_OVERRIDES += \
	ro.product.locale.language=zh \
    ro.product.locale.region=CN

PRODUCT_AAPT_CONFIG := normal hdpi

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

# These are the hardware-specific features
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.software.app_widgets.xml:system/etc/permissions/android.software.app_widgets.xml \
	frameworks/native/data/etc/android.hardware.ethernet.xml:system/etc/permissions/android.hardware.ethernet.xml \
    $(LOCAL_PATH)/root/media_codecs.xml:system/etc/media_codecs.xml

#########################################################################
#
#                          dropbear
#
#########################################################################
PRODUCT_PACKAGES += \
	dropbearkey \
	dropbear \
	dropbearkey_convert

PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/dropbear/passwd:system/etc/passwd \
	$(LOCAL_PATH)/dropbear/authorized_keys:system/etc/authorized_keys \
	$(LOCAL_PATH)/dropbear/dropbear_rsa_host_key:system/etc/dropbear_rsa_host_key \
	$(LOCAL_PATH)/dropbear/dropbear_dss_host_key:system/etc/dropbear_dss_host_key

#########################################################################
#
#                          display
#
#########################################################################
PRODUCT_PACKAGES += \
	libdisplay_jni \
	libTVOut

