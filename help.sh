echo "[+] Installing keystone + bindings" >&2
pushd /tmp
git clone --quiet https://github.com/keystone-engine/keystone.git
mkdir -p keystone/build && cd keystone/build
sed -i "s/make -j8/make -j${NB_CPU}/g" ../make-share.sh
../make-share.sh
sudo make install
cd ../bindings/python
sudo make install install3
popd
echo "[+] Done" >&2
