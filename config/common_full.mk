# Inherit common MaxiCM stuff
$(call inherit-product, vendor/maxi/config/common.mk)

# Include CM audio files
include vendor/maxi/config/cm_sounds.mk

# Optional MaxiCM packages
PRODUCT_PACKAGES += \
    Galaxy4 \
    HoloSpiralWallpaper \
    LiveWallpapers \
    LiveWallpapersPicker \
    MagicSmokeWallpapers \
    NoiseField \
    PhaseBeam \
    VisualizationWallpapers \
    PhotoTable \
    SoundRecorder \
    PhotoPhase

# Extra tools in MaxiCM
PRODUCT_PACKAGES += \
    vim \
    zip \
    unrar \
    curl
