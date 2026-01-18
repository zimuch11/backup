#!/bin/bash

if [ "$#" -lt 1 ]; then
    echo "Blad uzycia"
    echo "Uzycie: $0 <katalog_do_backupu> [maski_wykluczen...]"
    exit 1
fi

SOURCE_DIR="$1"
shift
EXCLUDES=$@

# Ścieżka do Pulpitu w OneDrive
DESKTOP="/c/Users/Asus/OneDrive/Desktop"

# Tworzenie folderu docelowego jeśli nie istnieje
mkdir -p "$DESKTOP"

DATE=$(date +"%Y-%m-%d_%H-%M")
BACKUP_NAME="/c/Users/Asus/OneDrive/Desktop/backup_$DATE.tar.gz"

# Budowanie wykluczeń jako tablica
EXCLUDE_PARAMS=()
for pattern in $EXCLUDES; do
    EXCLUDE_PARAMS+=(--exclude="$pattern")
done

echo "Tworzenie backupu na Pulpicie..."

# Tworzenie archiwum
tar -czf "$BACKUP_NAME" "${EXCLUDE_PARAMS[@]}" -C "$SOURCE_DIR" .

if [ $? -ne 0 ]; then
    echo "Blad podczas tworzenia backupu!"
    exit 2
fi

echo "Backup zapisany:"
echo "$BACKUP_NAME"
