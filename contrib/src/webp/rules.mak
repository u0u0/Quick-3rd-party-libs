# webp

WEBP_VERSION := 0.4.3
WEBP_URL := http://downloads.webmproject.org/releases/webp/libwebp-$(WEBP_VERSION).tar.gz

$(TARBALLS)/libwebp-$(WEBP_VERSION).tar.gz:
	$(call download,$(WEBP_URL))

.sum-webp: libwebp-$(WEBP_VERSION).tar.gz

webp: libwebp-$(WEBP_VERSION).tar.gz .sum-webp
	$(UNPACK)
ifdef HAVE_ANDROID
	$(APPLY) $(SRC)/webp/android.patch
endif
	$(UPDATE_AUTOCONFIG)
	$(MOVE)

.webp: webp
	cd $< && $(HOSTVARS) ./configure $(HOSTCONF)
	cd $< && $(MAKE) install
	touch $@
