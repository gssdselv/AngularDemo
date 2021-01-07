import { Injectable } from '@angular/core';
import { Observable, Subject } from 'rxjs';
import { AppcookieService } from 'src/app/application-management/appcookie.service';

@Injectable({
  providedIn: 'root'
})
export class PaginationService {

  dataFilter:any[]=[];
  startingRowNumber:number=1;
  endingRowNumber:number;
  screenType:string='';
  //userId:number=this.appCookieService.currentUserId;
  //roleName:string=this.appCookieService.RoleName;
  //roleId:number=this.appCookieService.currentRoleId;
  currentPage:number=1;

  itemsPerPage:number=10;

  constructor() {

     }

private inputEVentCapture=new Subject<any>();
private itemsPerPageChange=new Subject<any>();
private currentPageNumberChange=new Subject<any>();

private totalNumberOfRequestnumber=new Subject<number>();

private totalNumberOfRequest=new Subject<number>();
private currentPageData=new Subject<any[]>();

initializePageCountForFilter(){
  this.currentPage=1;
  this.itemsPerPage=1;
 this.setDataAccordingToCurrentPage();
}

setValueToApplyFilter(value:String){
    this.setCurrentPage(1);
    this.inputEVentCapture.next(value);
  }

  getValueToApplyFilter(): Observable<any>{
    return this.inputEVentCapture.asObservable();
  }
setItemsPerPage(value:number){
  this.setCurrentPage(1)
  this.itemsPerPageChange.next(value);
}
setCurrentPage(value:number){
this.currentPageNumberChange.next(value);
  }

  getValuesToSetItemsPerPage():Observable<any>{
    return this.itemsPerPageChange.asObservable();
  }
  getValuesTogetCurrentPage():Observable<any>{
    return this.currentPageNumberChange.asObservable();
  }
  SetTotalNumberOfRequest(value:number){
    console.log("bewlow set "+value)
    this.totalNumberOfRequest.next(value);
  }
  getTotalNumberOfRequest():Observable<any>{
    return this.totalNumberOfRequest.asObservable();
  }
  setDataAccordingToCurrentPage(){
    this.currentPageData.next();
  }
  getDataAccordingToCurrentPage():Observable<any>{
    return this.currentPageData.asObservable();
  }


  /*filterTableBody(module:any[],filterBy:any){

    this.dashboardDataFilter=this.ng2SearchPipe.transform(module,filterBy);
    this.SetTotalNumberOfRequest(this.dashboardDataFilter.length)
    console.log("this.dashboardDataFilter in serv "+this.dashboardDataFilter)
    return this.dashboardDataFilter;
  }*/


}
