#!/usr/bin/env bash

if [[ $SIGNING_KEY_URI && ${SIGNING_KEY_URI} && $RELEASE_SIGNING_PROPERTIES_URI && ${RELEASE_SIGNING_PROPERTIES_URI} && $JSON_KEY_URI && ${JSON_KEY_URI} && $DOWNLOAD_LOCATION && ${DOWNLOAD_LOCATION} && $KEYSTORE_NAME && ${KEYSTORE_NAME} ]]
then
    echo "Keystore detected - downloading..."
    # we're using curl instead of wget because it will not
    # expose the sensitive uri in the build logs:
    echo ${DOWNLOAD_LOCATION}${KEYSTORE_NAME}
    curl -L -o ${DOWNLOAD_LOCATION}${KEYSTORE_NAME} ${SIGNING_KEY_URI}
    curl -L -o ${DOWNLOAD_LOCATION}release-signing.properties ${RELEASE_SIGNING_PROPERTIES_URI}
    curl -L -o ./key.json ${JSON_KEY_URI}
else
    echo "Keystore uri not set.  .APK artifact will not be signed."
fi
