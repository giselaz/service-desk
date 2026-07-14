using ServiceDeskService as service from '../../srv/service';
annotate service.Operations with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'title',
                Value : title,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Service Type',
                Value : serviceType_code,
            },
             {
                $Type : 'UI.DataField',
                Label : 'Category',
                Value : category_ID,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Status',
                Value : status_code,
                Criticality: status.criticality,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Urgency',
                Value : urgency_code,
                Criticality: urgency.criticality,

            },
            {
                $Type : 'UI.DataField',
                Label : 'Priority',
                Value : priority_code,
                Criticality: priority.criticality,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Assigned User',
                Value : assignedTo,
            },
             {
                $Type : 'UI.DataField',
                Label : 'Requester User',
                Value : createdBy,
            },
            {
                $Type : 'UI.DataField',
                Value : company_ID,
                Label : 'Company',
            },
            {
                $Type : 'UI.DataField',
                Label : 'Client Remaining Time',
                Value : companyRemainingTime,
            },
        ],
    },
    
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Description',
            ID : 'Description',
            Target : '@UI.Identification',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet2',
            Label : 'Comments',
            Target : 'comments/@UI.LineItem',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Worklogs',
            ID : 'Worklogs',
            Target : 'worklogs/@UI.LineItem#Worklogs',
             @UI.Hidden: { $edmJson: { $Not: { $Path: '/Configuration/isAgent' } } }
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'title',
            Value : title,
        },
        {
            $Type : 'UI.DataField',
            Label : 'service Type',
            Value : serviceType.name,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Description',
            Value : description,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Category',
            Value : category.name,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Status',
            Value : status_code,
            Criticality: status.criticality,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Urgency',
            Value : urgency_code,
            Criticality: urgency.criticality,
        },
    ],
    UI.SelectionFields : [
        status_code,
    ],
    UI.FieldGroup #Description : {
        $Type : 'UI.FieldGroupType',
        Data : [
        ],
    },
);


annotate service.Operations with {
    category @(
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Categories',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : category_ID,
                    ValueListProperty : 'ID',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'name',
                },
            ],
        },
        Common.Text : category.name,
        Common.TextArrangement : #TextOnly
    )
};


annotate ServiceDeskService.Operations with @(UI.HeaderInfo: {
  TypeName      : 'Ticket',
  TypeNamePlural: 'Tickets',
  Title         : { Value: title },
  Description   : { Value: status_code },
  TypeImageUrl : 'sap-icon://request',
});

annotate service.Comments with @(UI.LineItem: [
  { $Type: 'UI.DataField', Value: description, Label: 'Comment'},
  { $Type: 'UI.DataField', Value: createdBy,   Label: 'Author'  },
  { $Type: 'UI.DataField', Value: createdAt,   Label: 'When'    }
],);

annotate ServiceDeskService.Operations with {
  description @(
    UI.MultiLineText: true,
    Common.FieldControl : #Mandatory,
);
};

annotate ServiceDeskService.Operations with @(UI.Identification: [
  {
    $Type : 'UI.DataFieldForAction',
    Label : 'Add Comment',
    Action: 'ServiceDeskService.addComment',
    Criticality : #Positive,
    @UI.Hidden: { $edmJson: { $Not: { $Path: '/Configuration/isRequester' } } }

  },
    {
        $Type : 'UI.DataField',
        Value : description,
        Label : 'Description',
    },
]);

annotate ServiceDeskService.Operations actions {
  addComment @(Common.SideEffects #afterComment: { TargetEntities: [ comments ] });
};
annotate service.Operations with {
    serviceType @Common.FieldControl : #Mandatory
};

annotate service.Operations with {
    urgency @Common.FieldControl : #Mandatory
};

annotate service.Operations with {
    title @(
        Common.FieldControl : #Mandatory,
        );
};

annotate ServiceDeskService.Operations with actions {
  addComment ( description @UI.MultiLineText: true );
};
annotate ServiceDeskService.Operations with {
  priority   @UI.Hidden: { $edmJson: { $Not: { $Path: '/Configuration/isAgent' } } };
  assignedTo @UI.Hidden: { $edmJson: { $Not: { $Path: '/Configuration/isAgent' } } };
  companyRemainingTime @UI.Hidden: { $edmJson: { $Not: { $Path: '/Configuration/isAgent' } } };
};
annotate service.Operations with {
    status @Common.Label : 'Status'
};

annotate service.Worklogs with @(
    UI.LineItem #Worklogs : [
        {
            $Type : 'UI.DataField',
            Value : createdBy,
        },
        {
            $Type : 'UI.DataField',
            Value : description,
            Label : 'description',
        },
        {
            $Type : 'UI.DataField',
            Value : durationInHours,
            Label : 'Duration in Hours',
        },
        {
            $Type : 'UI.DataField',
            Value : startedAt,
            Label : 'startedAt',
        },
    ]
);

annotate service.Operations with {
    company @(
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Companies',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : company_ID,
                    ValueListProperty : 'ID',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'name',
                },
            ],
        },
        Common.ExternalID : company.name,
        Common.FieldControl : #Mandatory,
    )
};



