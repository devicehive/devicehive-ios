#!/bin/bash
appledoc \
--project-name "DeviceHive Framework" \
--project-company "DataArt Apps" \
--company-id "com.dataart" \
--output "./docs" \
--create-html \
--logformat xcode \
--keep-intermediate-files \
--no-repeat-first-par \
--no-warn-invalid-crossref \
--ignore "Impl" \
../Source/DeviceHiveFramework/DeviceHive

# --keep-undocumented-objects \
# --keep-undocumented-members \
