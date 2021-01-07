import { Injectable } from '@angular/core';
import { Observable, Observer } from 'rxjs';
import { Router } from '@angular/router';
import { OktaAuth } from '@okta/okta-auth-js';
import { environment } from 'src/environments/environment';
import { SessionStorageService } from './session-storage.service';
import { AppcookieService } from './appcookie.service';
@Injectable({
  providedIn: 'root'
})
export class OktaAuthService {

  CLIENT_ID = environment.CLIENT_ID;
  ISSUER = environment.ISSUER;
  LOGIN_REDIRECT_URI = environment.LOGIN_REDIRECT_URI;
  LOGOUT_REDIRECT_URI = environment.LOGOUT_REDIRECT_URI;

  oktaAuth = new OktaAuth({
    clientId: this.CLIENT_ID,
    issuer: this.ISSUER,
    redirectUri: this.LOGIN_REDIRECT_URI,
    pkce: false
  });

  $isAuthenticated: Observable<boolean>;
  private observer: Observer<boolean>;
  constructor(private router: Router,private sessionStorageService:SessionStorageService,
    private appcookieService:AppcookieService) {

    this.$isAuthenticated = new Observable((observer: Observer<boolean>) => {
      this.observer = observer;
      this.isAuthenticated().then(val => {
        observer.next(val);
      });
    });
  }

  async isAuthenticated() {

    // Checks if there is a current accessToken in the TokenManger.
    //return !!(await this.oktaAuth.tokenManager.get('accessToken'));
    const val = await this.oktaAuth.tokenManager.get("accessToken");

    //return !!(await this.oktaAuth.tokenManager.get('accessToken'));
    if (val != undefined) {

      this.sessionStorageService.setIsAuthenticated(true);


      this.appcookieService.Token = val.value;

      return true;
    } else {
      this.sessionStorageService.setIsAuthenticated(false);

      return false;
    }

  }

  login(originalUrl) {

    // Save current URL before redirect
    sessionStorage.setItem('okta-app-url', originalUrl || this.router.url);

    // Launches the login redirect.
    this.oktaAuth.token.getWithRedirect({
      scopes: ['openid', 'email', 'profile']
    });
  }

  async handleAuthentication() {

    const tokenContainer = await this.oktaAuth.token.parseFromUrl();

    this.oktaAuth.tokenManager.add('idToken', tokenContainer.tokens.idToken);
    this.oktaAuth.tokenManager.add('accessToken', tokenContainer.tokens.accessToken);

    if (await this.isAuthenticated()) {
      if (!this.$isAuthenticated) {
        this.isAuthenticated().then((val) => {
          this.observer.next(val);
        });
      }
    }
    if (tokenContainer.tokens.accessToken != undefined) {
      this.sessionStorageService.setIsAuthenticated(true);
      this.appcookieService.Token =
        tokenContainer.tokens.accessToken.accessToken;
      const userDetails = await this.oktaAuth.getUser();
      console.log("usedet"+userDetails);
      this.appcookieService.Email  = (await this.oktaAuth.getUser()).email;

    } else {
      this.sessionStorageService.setIsAuthenticated(false);
    }

    // Retrieve the saved URL and navigate back
    const url = sessionStorage.getItem('okta-app-url');
    this.router.navigateByUrl(url);
  }

  async logout() {
    this.appcookieService.ClearUserDetails();
    await this.oktaAuth.signOut({
      postLogoutRedirectUri: this.LOGOUT_REDIRECT_URI
    });
  }
}
