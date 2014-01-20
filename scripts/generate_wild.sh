genisoimage -o wild.iso -b isolinux.bin -c boot.catalog -no-emul-boot -boot-load-size 4 -boot-info-table -R -m '.git*' $1
