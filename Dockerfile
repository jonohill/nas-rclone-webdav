FROM golang:1.24.2-alpine AS go_build

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest && \
    xcaddy build \
        --with github.com/ggicci/caddy-jwt

FROM curlimages/curl AS download

ARG TARGETPLATFORM

WORKDIR /tmp

# renovate: datasource=github-releases depName=DarthSim/overmind
ARG OVERMIND_VERSION=v2.5.1
RUN ARCH="${TARGETPLATFORM#*/}"; \
    curl --fail -L -o /tmp/overmind.gz \
        https://github.com/DarthSim/overmind/releases/download/${OVERMIND_VERSION}/overmind-${OVERMIND_VERSION}-linux-${ARCH}.gz && \
    gunzip /tmp/overmind.gz && \
    chmod +x /tmp/overmind

# renovate: datasource=github-releases depName=cloudflare/cloudflared
ARG CLOUDFLARED_VERSION=2025.2.1
RUN ARCH="${TARGETPLATFORM#*/}"; \
    curl --fail -L -o /tmp/cloudflared \
        "https://github.com/cloudflare/cloudflared/releases/download/${CLOUDFLARED_VERSION}/cloudflared-linux-${ARCH}" && \
    chmod +x /tmp/cloudflared


FROM alpine:3.21.3

RUN apk add --no-cache \
        bash \
        rclone \
        tmux

COPY --from=go_build /go/caddy /usr/local/bin/caddy
COPY --from=download /tmp/overmind /usr/local/bin/overmind
COPY --from=download /tmp/cloudflared /usr/local/bin/cloudflared

COPY root /

ENTRYPOINT [ "/init.sh" ]
