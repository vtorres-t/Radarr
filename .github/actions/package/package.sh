#!/bin/bash

outputFolder=_output
artifactsFolder=_artifacts
uiFolder="$outputFolder/UI"
framework="${FRAMEWORK:=net9.0}"

rm -rf $artifactsFolder
mkdir $artifactsFolder

for runtime in _output/*
do
  name="${runtime##*/}"
  folderName="$runtime/$framework"
  radarrFolder="$folderName/Radarr"
  archiveName="Radarr.$BRANCH.$RADARR_VERSION.$name"

  if [[ "$name" == 'UI' ]]; then
    continue
  fi
    
  echo "Creating package for $name"
  
  echo "Clean UI"
  rm -rf $uiFolder/*.map

  echo "Copying UI"
  cp -r $uiFolder $radarrFolder
  

  
  echo "Setting permissions"
  find $radarrFolder -name "ffprobe" -exec chmod a+x {} \;
  find $radarrFolder -name "Radarr" -exec chmod a+x {} \;
  find $radarrFolder -name "Radarr.Update" -exec chmod a+x {} \;
  

  echo "Packaging Artifact"
  if [[ "$name" == *"linux"* ]]; then
    tar -zcf "./$artifactsFolder/$archiveName.tar.gz" -C $folderName Radarr
	fi
    
  if [[ "$name" == *"win"* ]]; then
    if [ "$RUNNER_OS" = "Windows" ]
      then
        (cd $folderName; 7z a -tzip "../../../$artifactsFolder/$archiveName.zip" ./Radarr)
      else
      (cd $folderName; zip -rq "../../../$artifactsFolder/$archiveName.zip" ./Radarr)
    fi
	fi
done
