#!/bin/bash

if [ "$#" -lt 1 ]; then
    echo "Blad uzycia"
    exit 1
fi

# Parametry
SOURCE_DIR=$1
shift
EXCLUDES=$@

# Ścieżka do Pulpitu
DESKTOP="/c/Users/Asus/OneDrive/Desktop"

# Data
DATE=$(date +"%Y-%m-%d_%H-%M")
BACKUP_NAME="$DESKTOP/backup_$DATE.tar.gz"

# Budowanie wykluczeń
EXCLUDE_PARAMS=""
for pattern in $EXCLUDES; do
    EXCLUDE_PARAMS+=" --exclude=$pattern"
done

echo "Tworzenie backupu na Pulpicie..."

# Tworzenie archiwum
tar -czf "$BACKUP_NAME" $EXCLUDE_PARAMS -C "$SOURCE_DIR" .

# Sprawdzenie błędu
if [ $? -ne 0 ]; then
    echo "Blad podczas tworzenia backupu!"
    exit 2
fi

echo "Backup zapisany:"
echo "$BACKUP_NAME"

