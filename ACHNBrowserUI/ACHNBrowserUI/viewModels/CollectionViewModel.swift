//
//  CollectionViewModel.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine

class CollectionViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var villagers: [Villager] = []
    @Published var critters: [Item] = []
    
    struct SavedData: Codable {
        let items: [Item]
        let villagers: [Villager]
        let critters: [Item]
    }
    
    private let filePath: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init() {
        do {
            filePath = try FileManager.default.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false).appendingPathComponent("collection")
            if let data = try? Data(contentsOf: filePath) {
                decoder.dataDecodingStrategy = .base64
                let savedData = try decoder.decode(SavedData.self, from: data)
                self.items = savedData.items
                self.villagers = savedData.villagers
                self.critters = savedData.critters
            }
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func toggleItem(item: Item) {
        if items.contains(item) {
            items.removeAll(where: { $0 == item })
        } else {
            items.append(item)
        }
        save()
    }
    
    func toggleCritters(critter: Item) {
        if critters.contains(critter) {
            critters.removeAll(where: { $0 == critter })
        } else {
            critters.append(critter)
        }
        save()
    }
    
    func toggleVillager(villager: Villager) {
        if villagers.contains(villager) {
            villagers.removeAll(where: { $0 == villager })
        } else {
            villagers.append(villager)
        }
        save()
    }
    
    private func save() {
        do {
            let savedData = SavedData(items: items, villagers: villagers, critters: critters)
            let data = try encoder.encode(savedData)
            try data.write(to: filePath, options: .atomicWrite)
        } catch let error {
            print("Error while saving collection: \(error.localizedDescription)")
        }
        encoder.dataEncodingStrategy = .base64
    }
}
