#!/bin/bash

DATA="/mnt/d/Steam/steamapps/common/Skyrim Special Edition/Data"
mkdir -p Source/Scripts
cp "$DATA/Source/Scripts/"*Smalls* Source/Scripts/
mkdir -p Scripts
cp "$DATA/Smalls.esp" .
