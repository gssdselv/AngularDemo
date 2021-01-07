import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { CallbackComponent } from './callback/callback.component';
import { HeaderComponent } from './header/header.component';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';



@NgModule({
  declarations: [CallbackComponent, HeaderComponent],
  imports: [
    CommonModule,
    FormsModule,
    RouterModule.forRoot([

      { path: 'callback', component: CallbackComponent, pathMatch: 'full' },
    ])
  ],

  exports:[HeaderComponent]
})
export class ApplicationManagementModule { }
