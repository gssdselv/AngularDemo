import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class SessionStorageService {

  constructor() { }
  public isAuthenticated = new BehaviorSubject(false);
  isAuthenticatedObservable = this.isAuthenticated.asObservable();

  public setSessionStorageValue(key: string, value: string): void {
    sessionStorage.setItem(key, value);
  }

  public getSessionStorageValue(key: string): string {
    return sessionStorage.getItem(key);
  }

  public setIsAuthenticated(isAuthenticated: boolean): void {
    this.setSessionStorageValue("isAuthenticated", String(isAuthenticated));
    this.setBehaviouralFlag();
  }

  private setBehaviouralFlag() {
    this.isAuthenticated.next(sessionStorage.getItem("isAuthenticated") == "true" ? true : false);
  }

  public getIsAuthenticated(): boolean {
    this.setBehaviouralFlag();
    return this.isAuthenticated.value;
  }

  public clearSessionStorage(): void {
    sessionStorage.clear();
  }

}
