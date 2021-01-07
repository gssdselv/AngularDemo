import { Component, OnInit } from '@angular/core';
import { PaginationService } from '../../service/pagination.service';

@Component({
  selector: 'app-pagination',
  templateUrl: './pagination.component.html',
  styleUrls: ['./pagination.component.css']
})
export class PaginationComponent implements OnInit {

  rowSize:number[]=[5,10,25,50,100];
  totalPages:number;
  itemsPerPage:number=10;
  totalNumberOfRequest:number;
  currentPage:number=1;
  startingRowNumber:number;
  endingRowNumber:number;
  pageInfo:string;
  pageSize:number=5;
  currentSize:number=5;
  startingPage:number=1;
  pageIndex:number=1;
  numbertoshow: number = 3;
  arrayPages : number[] = [];
  //currentPageOffset:number=0;
    constructor(
      private filterPaginationService:PaginationService) {


    }

    ngOnInit() {
      this.filterPaginationService.getTotalNumberOfRequest().subscribe(totalNumberOfRequest=>{
       this.totalNumberOfRequest=totalNumberOfRequest;
       this.totalPages=Math.ceil(totalNumberOfRequest / this.itemsPerPage)
       //this.currentPage=1;
       this.validatePageSize();
       this.generatePageInfo()

      })
    }

  counter()
  {
    this.arrayPages = [];
    for (let i = 1; i <= this.totalPages; i++) {
      this.arrayPages.push(i);
    }
    const metadePgs = Math.ceil(this.numbertoshow / 2);
    let i = this.currentPage - metadePgs;
    if (i < 0) {
      i = 0;
    }
    let f = i + this.numbertoshow;
    if (f > this.arrayPages.length) {
      f = this.arrayPages.length;
      i = f - this.numbertoshow;
      if (i < 0) {
        i = 0;
      }
    }
    return this.arrayPages.slice(i, f);
  }
  openSelectedPage(pageIndex:number){
    console.log("pageIndex "+pageIndex);
    if(Math.ceil(pageIndex-2)>0 && Math.ceil(pageIndex+2)<=this.totalPages){
    this.startingPage=Math.ceil(pageIndex-2);
    }

    this.currentPage=pageIndex
    //this.currentPageOffset=pageIndex-1;
    console.log("this.currentPage "+this.currentPage)
    this.filterPaginationService.currentPage=this.currentPage;
    this.filterPaginationService.itemsPerPage=this.itemsPerPage;
   this.filterPaginationService.setDataAccordingToCurrentPage();
   // this.filterPaginationService.setCurrentPage(pageIndex);
   // this.generatePageInfo()
  }

  setPageCount($event){
    this.startingPage=1;
    this.itemsPerPage=$event.target.value;
  //  this.totalNumberOfRequest=this.filterPaginationService.dataFilter.length;
   //this.totalPages=Math.ceil(this.totalNumberOfRequest / this.itemsPerPage)
  // this.validatePageSize();
   this.currentPage=1;
   //this.currentPageOffset=0;
   this.filterPaginationService.currentPage=this.currentPage;
   this.filterPaginationService.itemsPerPage=this.itemsPerPage;
  this.filterPaginationService.setDataAccordingToCurrentPage();
    //this.filterPaginationService.setItemsPerPage(this.itemsPerPage);
  //  this.generatePageInfo()
  }

  validatePageSize(){
    console.log("this.totalPages "+this.totalPages+"-"+this.pageSize)
    if(this.pageSize>=this.totalPages){

      this.currentSize=this.totalPages;
      console.log("this.currentSize 1"+this.currentSize)
     }
     else{
      this.currentSize=5;
      console.log("this.currentSize 2"+this.currentSize)
     }
     this.startingPage=1;
  }
  generatePageInfo(){

    if(this.totalNumberOfRequest==0){
      this.pageInfo="No Record Found";
    }else{
    this.startingRowNumber=Math.ceil(((this.currentPage-1)*this.itemsPerPage))+1;
    this.endingRowNumber=Math.ceil(this.currentPage*this.itemsPerPage)<this.totalNumberOfRequest?Math.ceil(this.currentPage*this.itemsPerPage):this.totalNumberOfRequest
    this.filterPaginationService.startingRowNumber=this.startingRowNumber;
    this.filterPaginationService.endingRowNumber=this.endingRowNumber;
    this.pageInfo=`Showing ${this.startingRowNumber} to ${this.endingRowNumber} of ${this.totalNumberOfRequest} entries`
    console.log("this.pageInfo" + this.pageInfo);
    }
  }
  }


