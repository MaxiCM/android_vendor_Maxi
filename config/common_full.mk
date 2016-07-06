# Inherit common MaxiCM stuff
$(call inherit-product, vendor/maxi/config/common.mk)

PRODUCT_SIZE := full

# Include MaxiCM audio files
include vendor/maxi/config/maxi_sounds.mk

# Optional MaxiCM packages
PRODUCT_PACKAGES += \
    LiveWallpapers \
    LiveWallpapersPicker \
    NoiseField \
    PhotoTable \
    SoundRecorder \
    PhotoPhase \
    Screencast

# Extra tools in MaxiCM
PRODUCT_PACKAGES += \
    7z \
    lib7z \
    bash \
    bzip2 \
    curl \
    powertop \
    unrar \
    unzip \
    vim \
    wget \
    zip
