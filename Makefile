NAME  = ucsfthesis
DEST_SITE = $(shell kpsewhich --var-value TEXMFLOCAL)
DEST_USER = $(shell kpsewhich --var-value TEXMFHOME)

install:
	mkdir -p $(DEST_USER)/tex/latex/$(NAME)
	cp $(NAME).cls $(DEST_USER)/tex/latex/$(NAME)

uninstall:
	rm -rf $(DEST_USER)/tex/latex/$(NAME)

install-site:
	sudo mkdir -p $(DEST_SITE)/tex/latex/$(NAME)
	sudo cp $(NAME).cls $(DEST_SITE)/tex/latex/$(NAME)

uninstall-site:
	sudo rm -rf $(DEST_SITE)/tex/latex/$(NAME)
