# Inherit common MaxiCM stuff
$(call inherit-product, vendor/maxi/config/common_mini.mk)

# Required MaxiCM packages
PRODUCT_PACKAGES += \
    LatinIME

ifeq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
    PRODUCT_COPY_FILES += \
        vendor/maxi/prebuilt/common/bootanimation/800.zip:system/media/bootanimation.zip
endif
