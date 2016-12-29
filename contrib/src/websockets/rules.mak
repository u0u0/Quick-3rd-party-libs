# websockets

WEBSOCKETS_VERSION = 1.4-chrome43-firefox-36
WEBSOCKETS_URL := https://github.com/warmcat/libwebsockets/archive/v$(WEBSOCKETS_VERSION).tar.gz

$(TARBALLS)/libwebsockets-$(WEBSOCKETS_VERSION).tar.gz:
	$(call download,$(WEBSOCKETS_URL))

.sum-websockets: libwebsockets-$(WEBSOCKETS_VERSION).tar.gz
	$(warning $@ not implemented)
	touch $@

websockets: libwebsockets-$(WEBSOCKETS_VERSION).tar.gz .sum-websockets
	$(UNPACK)
	$(APPLY) $(SRC)/websockets/remove-werror.patch
ifdef HAVE_ANDROID
	$(APPLY) $(SRC)/websockets/android.patch
endif
	$(MOVE)

DEPS_websockets = zlib $(DEPS_zlib)
DEPS_websockets = openssl $(DEPS_openssl)

.websockets: websockets .zlib .openssl toolchain.cmake
	cd $< && $(HOSTVARS) CFLAGS="$(CFLAGS) $(EX_ECFLAGS)" $(CMAKE) -DLWS_WITH_SSL=ON -DLWS_WITHOUT_SERVER=ON -DLWS_WITHOUT_TEST_SERVER=ON -DLWS_WITHOUT_TEST_SERVER_EXTPOLL=ON -DLWS_WITHOUT_TEST_PING=ON -DLWS_IPV6=ON -DLWS_WITHOUT_DAEMONIZE=ON $(make_option)
	cd $< && $(MAKE) VERBOSE=1 install
	touch $@
