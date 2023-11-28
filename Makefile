.PHONY: all
.PHONY: docker-build-all docker-push-all docker-manifest-rm

REGISTRY?=xfan1024/qemu-user-static
TAG?=ubuntu-23.04

all: docker-build-all

define docker-build

.PHONY: docker-build-list-$(1)

docker-build-list += docker-build-$(1)
docker-build-$(1):
	docker buildx build . -f Dockerfile.ubuntu \
		--platform linux/$(1) \
		--build-arg BASE_IMAGE=$(2) \
		--build-arg TARGETARCH=$(1) \
		-t $(REGISTRY):$(TAG)-$(1) \
		-t $(REGISTRY):latest-$(1)

.PHONY: docker-push-$(1)
docker-push-list += docker-push-$(1)
docker-push-$(1): docker-manifest-rm
	docker push $(REGISTRY):$(TAG)-$(1)

tag-list += $(REGISTRY):$(TAG)-$(1)

endef

$(eval $(call docker-build,x86_64,ubuntu:23.04))
$(eval $(call docker-build,armhf,ubuntu:23.04))
$(eval $(call docker-build,aarch64,ubuntu:23.04))
$(eval $(call docker-build,riscv64,riscv64/ubuntu:23.04))

docker-build-all: $(docker-build-list)
docker-push-all: $(docker-push-list)
	-docker manifest rm $(REGISTRY):$(TAG)
	-docker manifest rm $(REGISTRY):latest
	docker manifest create $(REGISTRY):$(TAG) $(tag-list)
	docker manifest push $(REGISTRY):$(TAG)
	docker manifest create $(REGISTRY):latest $(tag-list)
	docker manifest push $(REGISTRY):latest
