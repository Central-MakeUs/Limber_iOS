//
//  AppDIContainer.swift
//  limber
//
//  Created by 양승완 on 8/28/25.
//


struct AppDIContainer {
  let networkManager: NetworkManagerP
  let timerRepo: TimerRepositoryProtocol
  let focusTypeRepo: FocusTypeRepositoryProtocol
  let timerRetrospectRepo: TimerRetrospectRepoProtocol
  let timerHistoryRepo: TimerHistoryRepositoryProtocol
  
  init() {
    self.networkManager = NetworkManager()
    self.timerRepo = TimerRepository(networkManager: networkManager)
    self.focusTypeRepo = FocusTypeRepository(networkManager: networkManager)
    self.timerRetrospectRepo = TimerRetrospectRepo(networkManager: networkManager)
    self.timerHistoryRepo = TimerHistoryRepository(networkManager: networkManager)
  }
}
