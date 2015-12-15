PRODUCT_BRAND ?= maxi

ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/maxi/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

ifeq ($(TARGET_BOOTANIMATION_HALF_RES),true)
PRODUCT_BOOTANIMATION := vendor/maxi/prebuilt/common/bootanimation/halfres/$(TARGET_BOOTANIMATION_NAME).zip
else
PRODUCT_BOOTANIMATION := vendor/maxi/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip
endif
endif

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

ifneq ($(TARGET_BUILD_VARIANT),user)
# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0
endif

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Backup Tool
ifneq ($(WITH_GMS),true)
PRODUCT_COPY_FILES += \
    vendor/maxi/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/maxi/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/maxi/prebuilt/common/bin/50-cm.sh:system/addon.d/50-cm.sh \
    vendor/maxi/prebuilt/common/bin/blacklist:system/addon.d/blacklist
endif

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/maxi/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# init.d support
PRODUCT_COPY_FILES += \
    vendor/maxi/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/maxi/prebuilt/common/bin/sysinit:system/bin/sysinit

# MaxiCM Tweaks
PRODUCT_COPY_FILES += \
    vendor/maxi/prebuilt/common/etc/init.d/Zipaling:system/etc/init.d/Zipaling \
    vendor/maxi/prebuilt/common/etc/init.d/06removecache:system/etc/init.d/06removecache \
    vendor/maxi/prebuilt/common/etc/init.d/16sqlite_optimize:system/etc/init.d/16sqlite_optimize \
    vendor/maxi/prebuilt/common/etc/init.d/81GPU_rendering:system/etc/init.d/81GPU_rendering \
    vendor/maxi/prebuilt/common/etc/init.d/RamBooster:system/etc/init.d/RamBooster \
    vendor/maxi/prebuilt/common/etc/init.d/net_buffer:system/etc/init.d/net_buffer \
    vendor/maxi/prebuilt/common/etc/init.d/Zram:system/etc/init.d/Zram \
    vendor/maxi/prebuilt/common/etc/init.d/Lagfixer:system/etc/init.d/Lagfixer \
    vendor/maxi/prebuilt/common/etc/init.d/LoopySmoothness:system/etc/init.d/LoopySmoothness \

ifneq ($(TARGET_BUILD_VARIANT),user)
# userinit support
PRODUCT_COPY_FILES += \
    vendor/maxi/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit
endif

# MaxiCM-specific init file
PRODUCT_COPY_FILES += \
    vendor/maxi/prebuilt/common/etc/init.local.rc:root/init.maxi.rc

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/maxi/prebuilt/common/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/maxi/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/maxi/prebuilt/common/lib/content-types.properties:system/lib/content-types.properties

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# This is MaxiCM!
PRODUCT_COPY_FILES += \
    vendor/maxi/config/permissions/com.cyanogenmod.android.xml:system/etc/permissions/com.cyanogenmod.android.xml
    
#Add prebuilt libjni_latinimegoogle.so to enable gesture typing in LatinIME
PRODUCT_COPY_FILES += \
    vendor/maxi/prebuilt/common/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so

# T-Mobile theme engine
include vendor/maxi/config/themes_common.mk

# Required MaxiCM packages
PRODUCT_PACKAGES += \
    Development \
    BluetoothExt \
    Profiles

# Optional MaxiCM packages
PRODUCT_PACKAGES += \
    VoicePlus \
    Basic \
    libemoji 
    
# SuperSU
PRODUCT_COPY_FILES += \
    vendor/maxi/prebuilt/common/SuperSU.zip:system/addon.d/SuperSU.zip \
    vendor/maxi/prebuilt/common/etc/init.d/99SuperSUDaemon:system/etc/init.d/99SuperSUDaemon

# Custom CM packages
PRODUCT_PACKAGES += \
    Launcher3 \
    Trebuchet \
    AudioFX \
    CMFileManager \
    Eleven \
    LockClock \
    CMHome \
    CMSettingsProvider
    
# MaxiCM packages
PRODUCT_PACKAGES += \
   MaxiSetupWizard \
   OTAUpdates \
   MaxiWallpapers

# CM Platform Library
PRODUCT_PACKAGES += \
    org.cyanogenmod.platform-res \
    org.cyanogenmod.platform \
    org.cyanogenmod.platform.xml

# CM Hardware Abstraction Framework
PRODUCT_PACKAGES += \
    org.cyanogenmod.hardware \
    org.cyanogenmod.hardware.xml

# Extra tools in MaxiCM
PRODUCT_PACKAGES += \
    libsepol \
    e2fsck \
    mke2fs \
    tune2fs \
    bash \
    nano \
    htop \
    powertop \
    lsof \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    mkfs.f2fs \
    fsck.f2fs \
    fibmap.f2fs \
    ntfsfix \
    ntfs-3g \
    gdbserver \
    micro_bench \
    oprofiled \
    sqlite3 \
    strace

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# These packages are excluded from user builds
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
    procmem \
    procrank \
    su
endif

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.root_access=0

PRODUCT_PACKAGE_OVERLAYS += vendor/maxi/overlay/common

PRODUCT_VERSION_MAJOR = 5
PRODUCT_VERSION_MINOR = 1
PRODUCT_VERSION_MAINTENANCE = 0-RC0

# Set MAXI_BUILDTYPE from the env RELEASE_TYPE, for jenkins compat

ifndef MAXI_BUILDTYPE
    ifdef RELEASE_TYPE
        # Starting with "MAXI_" is optional
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^MAXI_||g')
        MAXI_BUILDTYPE := $(RELEASE_TYPE)
    endif
endif

# Filter out random types, so it'll reset to UNOFFICIAL
ifeq ($(filter RELEASE NIGHTLY SNAPSHOT EXPERIMENTAL OFFICIAL,$(MAXI_BUILDTYPE)),)
    MAXI_BUILDTYPE :=
endif

ifdef MAXI_BUILDTYPE
    ifneq ($(MAXI_BUILDTYPE), SNAPSHOT)
        ifdef MAXI_EXTRAVERSION
            # Force build type to EXPERIMENTAL
            MAXI_BUILDTYPE := EXPERIMENTAL
            # Remove leading dash from MAXI_EXTRAVERSION
            MAXI_EXTRAVERSION := $(shell echo $(MAXI_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to MAXI_EXTRAVERSION
            MAXI_EXTRAVERSION := -$(MAXI_EXTRAVERSION)
        endif
    else
        ifndef MAXI_EXTRAVERSION
            # Force build type to EXPERIMENTAL, SNAPSHOT mandates a tag
            MAXI_BUILDTYPE := EXPERIMENTAL
        else
            # Remove leading dash from MAXI_EXTRAVERSION
            MAXI_EXTRAVERSION := $(shell echo $(MAXI_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to MAXI_EXTRAVERSION
            MAXI_EXTRAVERSION := -$(MAXI_EXTRAVERSION)
        endif
    endif
else
    # If MAXI_BUILDTYPE is not defined, set to UNOFFICIAL
    MAXI_BUILDTYPE := UNOFFICIAL
    MAXI_EXTRAVERSION :=
endif

ifeq ($(MAXI_BUILDTYPE), UNOFFICIAL)
    ifneq ($(TARGET_UNOFFICIAL_BUILD_ID),)
        MAXI_EXTRAVERSION := -$(TARGET_UNOFFICIAL_BUILD_ID)
    endif
endif

ifeq ($(MAXI_BUILDTYPE), RELEASE)
    ifndef TARGET_VENDOR_RELEASE_BUILD_ID
        MAXI_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(MAXI_BUILD)
    else
        ifeq ($(TARGET_BUILD_VARIANT),user)
            MAXI_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(MAXI_BUILD)
        else
            MAXI_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(MAXI_BUILD)
        endif
    endif
else
    ifeq ($(PRODUCT_VERSION_MINOR),0)
        MAXI_VERSION := $(PRODUCT_VERSION_MAJOR)-$(shell date -u +%Y%m%d)-$(MAXI_BUILDTYPE)$(MAXI_EXTRAVERSION)-$(MAXI_BUILD)
    else
        MAXI_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date -u +%Y%m%d)-$(MAXI_BUILDTYPE)$(MAXI_EXTRAVERSION)-$(MAXI_BUILD)
    endif
endif

PRODUCT_PROPERTY_OVERRIDES += \
  ro.maxi.version=$(MAXI_VERSION) \
  ro.maxi.releasetype=$(MAXI_BUILDTYPE) \
  ro.modversion=$(MAXI_VERSION) \
  ro.ota.version= $(shell date -u +%Y%m%d) \
  ro.ota.romname=MaxiCM

-include vendor/cm-priv/keys/keys.mk

MAXI_DISPLAY_VERSION := $(MAXI_VERSION)

ifneq ($(PRODUCT_DEFAULT_DEV_CERTIFICATE),)
ifneq ($(PRODUCT_DEFAULT_DEV_CERTIFICATE),build/target/product/security/testkey)
  ifneq ($(MAXI_BUILDTYPE), UNOFFICIAL)
    ifndef TARGET_VENDOR_RELEASE_BUILD_ID
      ifneq ($(MAXI_EXTRAVERSION),)
        # Remove leading dash from MAXI_EXTRAVERSION
        MAXI_EXTRAVERSION := $(shell echo $(MAXI_EXTRAVERSION) | sed 's/-//')
        TARGET_VENDOR_RELEASE_BUILD_ID := $(MAXI_EXTRAVERSION)
      else
        TARGET_VENDOR_RELEASE_BUILD_ID := $(shell date -u +%Y%m%d)
      endif
    else
      TARGET_VENDOR_RELEASE_BUILD_ID := $(TARGET_VENDOR_RELEASE_BUILD_ID)
    endif
    MAXI_DISPLAY_VERSION=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)
  endif
endif
endif

# CM SDK

ifndef CM_PLATFORM_SDK_VERSION
  # This is the canonical definition of the SDK version, which defines
  # the set of APIs and functionality available in the platform.  It
  # is a single integer that increases monotonically as updates to
  # the SDK are released.  It should only be incremented when the APIs for
  # the new release are frozen (so that developers don't write apps against
  # intermediate builds).
  CM_PLATFORM_SDK_VERSION := 3
endif

ifndef CM_PLATFORM_REV
  # For internal SDK revisions that are hotfixed/patched
  # Reset after each CM_PLATFORM_SDK_VERSION release
  # If you are doing a release and this is NOT 0, you are almost certainly doing it wrong
  CM_PLATFORM_REV := 0
endif

# CyanogenMod Platform SDK Version
PRODUCT_PROPERTY_OVERRIDES += \
  ro.cm.build.version.plat.sdk=$(CM_PLATFORM_SDK_VERSION)

# CyanogenMod Platform Internal
PRODUCT_PROPERTY_OVERRIDES += \
  ro.cm.build.version.plat.rev=$(CM_PLATFORM_REV)

# by default, do not update the recovery with system updates
PRODUCT_PROPERTY_OVERRIDES += persist.sys.recovery_update=false

PRODUCT_PROPERTY_OVERRIDES += \
  ro.maxi.display.version=$(MAXI_DISPLAY_VERSION)

-include $(WORKSPACE)/build_env/image-auto-bits.mk

-include vendor/cyngn/product.mk

$(call prepend-product-if-exists, vendor/extra/product.mk)
