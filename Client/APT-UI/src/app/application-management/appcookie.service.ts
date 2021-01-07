import { Injectable } from '@angular/core';
import { CookieService } from 'ngx-cookie-service';
@Injectable({
  providedIn: 'root'
})
export class AppcookieService {

  constructor(private cookieService:CookieService) { }
  get Token() : string {
    return this.cookieService.get("Token");
  }
  set Token(val: string) {
    this.cookieService.set("Token", val)
  }
  get Email() : string {
    return this.cookieService.get("Email");
  }
  set Email(val: string) {
    this.cookieService.set("Email", val)
  }

  ClearUserDetails(): void{
    this.Token = null;
    sessionStorage.clear();
  }


}
