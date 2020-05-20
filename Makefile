.PHONY: help build run push deploy

APP_NAME ?= `grep 'app:' mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g'`
APP_VSN ?= v`grep 'version:' mix.exs | cut -d '"' -f2`
BUILD ?= `git rev-parse --short HEAD`
SECRET ?= `mix phx.gen.secret`

help:
	@echo "$(APP_NAME):$(APP_VSN)-$(BUILD)"
    @perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build:
	docker build --rm --build-arg secret=$(SECRET) \
		-t $(APP_NAME):release-$(APP_VSN) \
		-t jator/$(APP_NAME):latest \
		-t $(APP_NAME):latest .

run:
	docker run -p 8080:8080 \
		--rm -it $(APP_NAME):latest

push:
	docker push jator/$(APP_NAME):release-$(APP_VSN)

deploy: help build push
	ssh root@kritikos.app 'sed -i "s|jator/kritikos:release-.*|jator/kritikos:release-$(APP_VSN)|g" ./docker-compose.yaml && docker-compse up -d'
