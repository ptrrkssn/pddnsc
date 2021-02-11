# Makefile for ddns-updater


# NetworkManager scripts:
NMDIR=/etc/NetworkManager/dispatcher.d

# dhclient exit-hooks scripts:
DHDIR=/etc/dhcp/dhclient-exit-hooks.d

BSDPKGS=p5-Net-IP p5-Net-DNS bind-tools perl
APTPKGS=libnet-ip-perl libnet-dns-perl dnsutils
RPMPKGS=perl-Net-IP perl-Net-DNS bind-utils
SOLPKGS=perl bind


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
	@$(MAKE) install-deps-`uname -s`

install-deps-FreeBSD:
	pkg install $(BSDPKGS)

install-deps-Linux:
	@if [ -f /usr/bin/apt ]; then \
		apt-get install -y $(APTPKGS); \
	else \
		yum install -y $(RPMPKGS); \
	fi

install-deps-Darwin:
	@echo Nothing to do

install-deps-SunOS:
	pkg install $(SOLPKGS)
	perl -MCPAN -e 'install Net::IP'
	perl -MCPAN -e 'install Sys::Hostname::Long'

check:
	perl -cw pddnsc
	./pddnsc -h
