//
//  Wallet.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 25.01.2023.
//

import Foundation

extension User {
    var walletArray: [Wallet] {
        if let wallets = wallets?.sortedArray(using: [NSSortDescriptor(key: "createDate", ascending: true)]) as? [Wallet] {
            return wallets
        } else {
            return []
        }
    }
}
