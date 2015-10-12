# Inherit common MaxiCM stuff
$(call inherit-product, vendor/maxi/config/common_full.mk)

# Required MaxiCM packages
PRODUCT_PACKAGES += \
    LatinIME

# Include MaxiCM LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/maxi/overlay/dictionaries

# Default notification/alarm sounds
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.notification_sound=Ceres.ogg \
    ro.config.alarm_alert=Carbon.ogg

ifeq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
    PRODUCT_COPY_FILES += \
        vendor/maxi/prebuilt/common/bootanimation/480.zip:system/media/bootanimation.zip
endif

$(call inherit-product, vendor/maxi/config/telephony.mk)
