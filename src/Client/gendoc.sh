#!/bin/bash
appledoc \
--project-name "DeviceHive.iOS" \
--project-company "DataArt" \
--company-id "com.dataart" \
--output "./docs" \
--create-html \
--logformat xcode \
--keep-intermediate-files \
--no-repeat-first-par \
--no-warn-invalid-crossref \
--ignore "*.m" \
--ignore "ThirdParty" \
--ignore "*ViewController" \
--ignore "*MO" \
.

# --keep-undocumented-objects \
# --keep-undocumented-members \
