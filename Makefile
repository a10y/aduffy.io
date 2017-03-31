HUGO=hugo

build:
	$(HUGO) -t hucore

serve:
	$(HUGO) server --buildDrafts

push: build
	./deploy.sh
