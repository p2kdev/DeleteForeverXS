PACKAGE_VERSION=$(THEOS_PACKAGE_BASE_VERSION)

include $(THEOS)/makefiles/common.mk

export ARCHS = arm64 arm64e
export TARGET = iphone:clang:13.0:13.0

TWEAK_NAME = DeleteForeverXS
DeleteForeverXS_FILES = Tweak.xm
DeleteForeverXS_PRIVATE_FRAMEWORKS = PhotosUI
DeleteForeverXS_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 MobileSlideShow Camera"
