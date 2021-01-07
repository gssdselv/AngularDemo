import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { DashboardComponent } from './component/dashboard/dashboard.component';
import { InvestigationReportComponent } from './component/dashboard/investigation-report/investigation-report.component';
import { ProjectListComponent } from './component/dashboard/project-list/project-list.component';
import { PaginationComponent } from '../framework/component/pagination/pagination.component';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { OktaAuthGuard } from '../application-management/okta-auth.guard';
import { CallbackComponent } from '../application-management/callback/callback.component';



@NgModule({
  declarations: [
    DashboardComponent,
    InvestigationReportComponent,
    ProjectListComponent,
    PaginationComponent
  ],
  imports: [
    CommonModule,
    FormsModule,
    RouterModule.forRoot([
      { path: '', component: DashboardComponent, pathMatch: 'full', canActivate: [OktaAuthGuard] },
    ])
  ]
})
export class AptProjectModule { }
