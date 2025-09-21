# Note, this script is only used for local dev tests, this is not the script used for building the official radarr package

mkdir -p /${PWD}/../_output_debian

docker build -f docker-build/Dockerfile -t radarr-packager ./docker-build

docker run --rm -v /${PWD}/../_output_linux:/data/radarr_bin:ro -v /${PWD}:/data/build -v /${PWD}/../_output_debian:/data/output radarr-packager
