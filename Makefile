export FULL_VERSION_RELEASE="$$(cat ./VERSION)"
export FULL_VERSION="$$(cat ./VERSION)-regen-dh"
export TESTS_FOLDER=$$(TEMP_VAR=$${TESTS_REPORT:-$${PWD}/target/test-reports}; echo $${TEMP_VAR})
export NAME=ovpn1

.PHONY: build build-release build-local build-dev build-test install clean test run

all: build

build:
	@echo "Making production version ${FULL_VERSION} of DockOvpn"
	docker build --build-arg CACHE_DATE="$(date)" -t ainghazal/openvpn  . --no-cache
	#docker push ainghazal/openvpn:latest

build-release:
	@echo "Making manual release version ${FULL_VERSION_RELEASE} of DockOvpn"
	docker build -t ainghazal/openvpn:${FULL_VERSION_RELEASE} -t ${FULL_VERSION} -t alekslitvinenk/openvpn:latest . --no-cache
	docker push ainghazal/openvpn:latest
	# Note: This is by design that we don't push ${FULL_VERSION} to repo

build-local:
	@echo "Making version of DockOvpn for testing on local machine"
	docker build --build-arg CACHE_DATE="$(date)" -t ainghazal/openvpn:local . --no-cache


install:
	@echo "Installing DockOvpn ${FULL_VERSION}"

clean:
	@echo "Remove firectory with generated reports"
	rm -rf ${TESTS_FOLDER}
	@echo "Remove shared volume with configs"
	docker volume rm Dockovpn_data

run:
	docker run --cap-add=NET_ADMIN \
	-p 1194:1194/udp -p 8080:8080/tcp \
	-e HOST_ADDR=localhost \
	--rm \
	--name ${NAME} \
	--env-file=.env \
	ainghazal/openvpn

shell:
	docker exec -it ${NAME} /bin/bash
