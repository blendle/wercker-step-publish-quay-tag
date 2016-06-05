#!/bin/sh

main() {
  if [ -z "$WERCKER_PUBLISH_QUAY_TAG_CURRENT" ]; then
    WERCKER_PUBLISH_QUAY_TAG_CURRENT="$WERCKER_GIT_COMMIT"
  fi

  if [ -z "$WERCKER_PUBLISH_QUAY_TAG_TAG" ]; then
    WERCKER_PUBLISH_QUAY_TAG_TAG=latest
  fi

  if [ "$WERCKER_PUBLISH_QUAY_TAG_IF" != "$WERCKER_PUBLISH_QUAY_TAG_EQ" ]; then
    info "$WERCKER_PUBLISH_QUAY_TAG_IF did not match $WERCKER_PUBLISH_QUAY_TAG_EQ, skipping step..."
  else
    imageID=$(curl --silent --header "Authorization: Bearer $WERCKER_PUBLISH_QUAY_TAG_TOKEN" "https://quay.io/api/v1/repository/$WERCKER_PUBLISH_QUAY_TAG_REPOSITORY/tag/$WERCKER_PUBLISH_QUAY_TAG_CURRENT/images" | awk -F'"id": "' '{print $2}' | awk -F'"' '{print $1}')

    curl_with_flags --data "{ \"image\": \"$imageID\" }" \
                    --header "Content-Type: application/json" \
                    --header "Authorization: Bearer $WERCKER_PUBLISH_QUAY_TAG_TOKEN" \
                    "https://quay.io/api/v1/repository/$WERCKER_PUBLISH_QUAY_TAG_REPOSITORY/tag/$WERCKER_PUBLISH_QUAY_TAG_TAG" \
                      || fail "failed publishing image: quay.io/$WERCKER_PUBLISH_QUAY_TAG_REPOSITORY:$WERCKER_PUBLISH_QUAY_TAG_TAG"
  fi
}

info() {
  printf "%b%b%b\n" "\e[1;37m" "$1" "\e[m"
}

fail() {
  printf "%b%b%b\n" "\e[1;31m" "failed: $1" "\e[m"
  echo "$1" > "$WERCKER_REPORT_MESSAGE_FILE"
  exit 1
}

curl_with_flags() {
  curl --fail --silent --output /dev/null --request PUT "$@"
}

main
