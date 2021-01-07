import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';

import { RouterModule } from '@angular/router';
import { OktaAuthGuard } from './application-management/okta-auth.guard';
import { CallbackComponent } from './application-management/callback/callback.component';
import { ApplicationManagementModule } from './application-management/application-management.module';
import { HeaderComponent } from './application-management/header/header.component';
import { FormsModule } from '@angular/forms';
import { FrameworkModule } from './framework/framework.module';
import { AptProjectModule } from './apt-project/apt-project.module';
@NgModule({
  declarations: [
    AppComponent,

  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
FrameworkModule,
ApplicationManagementModule,
AptProjectModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
