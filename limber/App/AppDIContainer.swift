//
//  AppDIContainer.swift
//  limber
//
//  Created by 양승완 on 8/28/25.
//


struct AppDIContainer {
  let timerRepo: TimerRepositoryProtocol
  let focusTypeRepo: FocusTypeRepositoryProtocol
  let timerRetrospectRepo: TimerRetrospectRepoProtocol
  let timerHistoryRepo: TimerHistoryRepositoryProtocol
  
  init() {
    self.timerRepo = TimerRepository()
    self.focusTypeRepo = FocusTypeRepository()
    self.timerRetrospectRepo = TimerRetrospectRepo()
    self.timerHistoryRepo = TimerHistoryRepository()
  }
}
