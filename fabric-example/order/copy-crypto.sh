#!/bin/sh

mkdir -p ./crypto-config/peerOrganizations/org1.example.com
mkdir -p ./crypto-config/peerOrganizations/org2.example.com
mkdir -p ./crypto-config/peerOrganizations/org3.example.com
mkdir -p ./crypto-config/peerOrganizations/org4.example.com

rm -rf ./crypto-config/peerOrganizations/org1.example.com/*
rm -rf ./crypto-config/peerOrganizations/org2.example.com/*
rm -rf ./crypto-config/peerOrganizations/org3.example.com/*
rm -rf ./crypto-config/peerOrganizations/org4.example.com/*

cp -rf ../org1/crypto-config/peerOrganizations/org1.example.com/msp ./crypto-config/peerOrganizations/org1.example.com 
cp -rf ../org2/crypto-config/peerOrganizations/org2.example.com/msp ./crypto-config/peerOrganizations/org2.example.com 
cp -rf ../org3/crypto-config/peerOrganizations/org3.example.com/msp ./crypto-config/peerOrganizations/org3.example.com 
cp -rf ../org4/crypto-config/peerOrganizations/org4.example.com/msp ./crypto-config/peerOrganizations/org4.example.com 
