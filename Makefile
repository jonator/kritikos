.PHONY: help mix_test build run push deploy

APP_NAME := $(shell grep 'app:' mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g')
APP_VSN := v$(shell grep 'version:' mix.exs | cut -d '"' -f2)
BUILD := $(shell git rev-parse --short HEAD)
SECRET := `mix phx.gen.secret`

include ./rel/secrets.env
export $(shell sed 's/=.*//' ./rel/secrets.env)

help:
	@echo "$(APP_NAME):$(APP_VSN)-$(BUILD)"
    @perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

mix_test:
	mix test

build:
	docker build --force-rm --build-arg secret=$(SECRET) \
		--build-arg db_pass=$(POSTGRES_PASSWORD) \
		--build-arg mailgun_api_key=$(MAILGUN_API_KEY) \
		--build-arg stripe_api_key=$(STRIPE_API_KEY) \
		-t jator/$(APP_NAME):release-$(APP_VSN) \
		-t jator/$(APP_NAME):latest \
		-t $(APP_NAME):latest .

run:
	docker run -p 8080:8080 \
		--rm -it $(APP_NAME):latest

push:
	docker push jator/$(APP_NAME):release-$(APP_VSN)

deploy: help mix_test build push
