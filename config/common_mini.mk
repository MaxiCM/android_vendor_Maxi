# Inherit common MaxiCM stuff
$(call inherit-product, vendor/maxi/config/common.mk)

PRODUCT_SIZE := mini

# Include MaxiCM audio files
include vendor/maxi/config/maxi_sounds.mk

# Default notification/alarm sounds
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.notification_sound=Argon.ogg \
    ro.config.alarm_alert=Helium.ogg

