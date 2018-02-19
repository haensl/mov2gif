src_dir := $(shell pwd)
bin_dir := /usr/local/bin
man_dir := /usr/share/man/man1

install:
	@if ! [ -f $(bin_dir)/mov2gif ]; then ln -s $(src_dir)/mov2gif.sh $(bin_dir)/mov2gif ; fi
	@if ! [ -f $(man_dir)/mov2gif.1.gz ]; then ln -s $(src_dir)/man/mov2gif.1.gz $(man_dir)/mov2gif.1
