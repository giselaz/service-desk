using {itsm.servicedesk as sd} from '../db/schema';

service ServiceDeskService @(impl: './service.js') {
    @odata.draft.enabled
    entity Operations as projection on sd.Operation
    actions {
        action addComment( description : LargeString  ) returns Comments;
     };
    @readonly entity ServiceTypes as projection on sd.ServiceTypes;
    @readonly entity Statuses as projection on sd.Statuses;
    @readonly entity Urgencies as projection on sd.Urgencies;
    @readonly entity Priorities as projection on sd.Priorities;
    @(restrict:[{grant:'*',to: 'admin'},{grant:'READ',to:'viewer'},
    {grant:'READ',to:'agent'}])
    entity Categories as projection on sd.Categories;
    @(restrict:[{grant:'*',to: 'admin'},{grant:'READ',to:'viewer'},
    {grant:'READ',to:'agent'}])
    entity Companies as projection on sd.Companies;
    entity Comments as projection on sd.Comments;
     @(restrict:[{grant:'*',to: 'admin'},
    {grant:['*'],to:'agent',where:'createdBy = $user'}])
     entity Worklogs as projection on sd.Worklogs;

    @odata.singleton @cds.persistence.skip
  entity Configuration {
    key ID      : String;
    isAgent     : Boolean;
    isRequester : Boolean;
  }
}
extend projection ServiceDeskService.Operations with {

  virtual null as companyRemainingTime : String,
  virtual null as OverDue: Integer

};
annotate ServiceDeskService.Operations with @(restrict: [
  { grant: 'CREATE',                        to: 'viewer' },
  { grant: 'CREATE',                        to: 'agent' },
  { grant: ['READ','addComment']  ,         to: 'viewer', where: 'createdBy = $user' },
  { grant: ['READ','UPDATE'],               to: 'agent' ,where: 'assignedTo = $user'},
  { grant: '*',                             to: 'admin' },
]);

annotate ServiceDeskService.Operations with {
  status      @Common.Text: status.name      @Common.TextArrangement: #TextOnly;
  urgency     @Common.Text: urgency.name      @Common.TextArrangement: #TextOnly;
  priority    @Common.Text: priority.name     @Common.TextArrangement: #TextOnly;
  serviceType @Common.Text: serviceType.name  @Common.TextArrangement: #TextOnly;
};


