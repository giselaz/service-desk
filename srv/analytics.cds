using {itsm.servicedesk as sd} from '../db/schema';
@path: 'analytics'
@requires: 'authenticated-user'
service Analytics
{
    @readonly entity Operations as projection on sd.Operation;
    @readonly entity ServiceTypes as projection on sd.ServiceTypes;
    @readonly entity Statuses as projection on sd.Statuses;
    @readonly entity Urgencies as projection on sd.Urgencies;
    @readonly entity Priorities as projection on sd.Priorities;
    @readonly entity Categories as projection on sd.Categories;
    @readonly  entity Companies as projection on sd.Companies;
    @readonly entity Comments as projection on sd.Comments;
    @readonly entity Worklogs as projection on sd.Worklogs;
}