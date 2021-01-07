import { Component, OnInit } from '@angular/core';
import { ProjectList } from 'src/app/apt-project/model/projectList';

@Component({
  selector: 'app-project-list',
  templateUrl: './project-list.component.html',
  styleUrls: ['./project-list.component.css']
})
export class ProjectListComponent implements OnInit {
projectList:ProjectList[]=[]
  constructor() { }

  ngOnInit(): void {
  }

}
