git update-index --assume-unchanged SmartReceipts/Ads/GADConstants.m
git update-index --assume-unchanged SmartReceipts/Supporting\ Files/Secrets.swift
git update-index --assume-unchanged SmartReceipts/ServiceAccount.json
gpg -d secrets.tar.gpg | tar xv || true
