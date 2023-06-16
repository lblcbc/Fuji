//
//  NetworkModel.swift
//  Fuji
//
//  Created by Maximilian Samne on 20.03.23.
//

import Foundation
import Network

class NetworkModel: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    @Published var connected: Bool = false
    
    init() {
        print("init() - NETWORKMODEL: init started")
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.connected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
