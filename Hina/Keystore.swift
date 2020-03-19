//
//  KeyStore.swift
//  Hina
//
//  Created by Jerry Zhou on 3/18/20.
//  Copyright © 2020 Jerry Zhou. All rights reserved.
//

import Foundation

let userDefaults = UserDefaults.standard
let keystoreKey = "keystore"

func getKeystore() -> [String] {
    return userDefaults.array(forKey: keystoreKey) as? [String] ?? []
}

func setKeystore(_ keystore: [String]) {
    userDefaults.set(keystore, forKey: keystoreKey)
}

func delKeyFromKeystore(at: Int) {
    var keystore = getKeystore()
    if keystore.count > at {
        keystore.remove(at: at)
        setKeystore(keystore)
    }
}

func addKeyToKeystore(_ key: String) {
    var keystore = getKeystore()
    keystore.append(key)
    setKeystore(keystore)
}
