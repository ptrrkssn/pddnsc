# Makefile for ddns-updater


# NetworkManager scripts:
NMDIR=/etc/NetworkManager/dispatcher.d

# dhclient exit-hooks scripts:
DHDIR=/etc/dhcp/dhclient-exit-hooks.d


all:
	@echo "Valid make targets: clean, push and install" ; exit 1

clean:
	-@find . -type f -a \( -name '*~' -o -name '\#*' \) -print0 | xargs -0 rm -vf

push:	clean
	git add -A && git commit -a && git push

install:
	cp ddns-updater /sbin
	test -d $NMDIR && cp script.sh $NMDIR/90-ddns-update
	test -d $DHDIR && cp script.sh $DHDIR/ddns-update

install-deps:
	$(MAKE) `uname -s`

install-deps-FreeBSD:
	pkg install p5-Net-IP
	pkg install p5-Net-DNS
	pkg install bind-tools

install-deps-Linux:
	@exit 1

install-deps-SunOS:
	pkg install perl
	perl -MCPAN -e 'install Net::IP'
	perl -MCPAN -e 'install Sys::Hostname::Long'
