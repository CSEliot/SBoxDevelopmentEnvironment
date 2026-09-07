# TODO: Do nothing if /Dev/sbox-public/ already exists and echo as much.

echo "Cloning /CSEliot/sbox-public/ into ../../1-Engine-Builds/Dev/sbox-public ..."

git clone https://github.com/CSEliot/sbox-public ../../1-Engine-Builds/Dev/sbox-public

echo "Cloning success? Running repo setup ..."

../../1-Engine-Builds/Dev/sbox-public/setup-community-fork.sh

echo "Repo Setup Success? Done."
