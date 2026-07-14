using { managed ,cuid,sap.common.CodeList } from '@sap/cds/common';
namespace itsm.servicedesk;
entity Operation: cuid, managed {
    title:  String(255) @mandatory;
    serviceType: Association to ServiceTypes @mandatory;
    description:  LargeString @mandatory;
    status: Association to  Statuses default 'NEW'; @mandatory
    urgency: Association to  Urgencies;
    priority: Association to  Priorities;
    assignedTo: String(255);
    comments: Composition of many Comments on comments.operation = $self;
    worklogs: Composition of many Worklogs on worklogs.operation = $self;
    category: Association to  Categories;
    dueDate: Date;
    closedAt: Timestamp;
    company: Association to Companies;
}

entity ServiceTypes: CodeList {
    key code : String(20);
}
entity Statuses: CodeList {
    key code : String(20);
     criticality : Integer;
}
entity Urgencies: CodeList {
    key code: String(20); 
    criticality : Integer;
}
entity Priorities: CodeList {
    key code: String(20);
     criticality : Integer;
}

entity Categories: cuid, managed {
    name:  String(100) @mandatory;
    description:  String(250);
}

entity Comments: cuid, managed {
    description:  LargeString @mandatory;
    operation: Association to Operation; 
}

entity Worklogs: cuid, managed {
    description:  LargeString @mandatory;
    operation: Association to Operation; 
    startedAt: Timestamp @mandatory;
    durationInHours: Decimal(5,2) @mandatory @assert.range: [0.01, 24];
}

entity Companies: cuid, managed { 
    name:  String(100) @mandatory;
    description:  String(250);
    timeToSpend: Integer @mandatory;
    remainingTime: Integer @mandatory;
}

