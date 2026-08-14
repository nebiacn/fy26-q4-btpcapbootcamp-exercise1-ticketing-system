using TicketingService as service from '../../srv/ticketing-service';

annotate service.Tickets with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'Ticket',
                Value : ticketNumber,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Subject',
                Value : subject,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Description',
                Value : description,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Status',
                Value : status_name,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Priority',
                Value : priority_name,
            },
            {
                $Type : 'UI.DataField',
                Value : agent_ID,
                Label : 'Asignee',
            },
            {
                $Type : 'UI.DataField',
                Value : category_name,
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
            Label : 'Ticket Comments',
            ID : 'TicketComments',
            Target : 'comments/@UI.LineItem#TicketComments',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : ticketNumber,
        },
        {
            $Type : 'UI.DataField',
            Value : subject,
        },
        {
            $Type : 'UI.DataField',
            Value : status_name,
        },
        {
            $Type : 'UI.DataField',
            Value : priority_name,
        },
        {
            $Type : 'UI.DataField',
            Value : category_name,
        },
        {
            $Type : 'UI.DataField',
            Value : agent.name,
        },
    ],
    UI.SelectionFields : [
        status_name,
        priority_name,
        category_name,
        agent_ID,
    ],
    UI.HeaderInfo : {
        Title : {
            $Type : 'UI.DataField',
            Value : ticketNumber,
        },
        TypeName : 'Ticket',
        TypeNamePlural : 'Tickets',
        Description : {
            $Type : 'UI.DataField',
            Value : subject,
        },
    },
    UI.Identification : [
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'TicketingService.closeTicket',
            Label : 'closeTicket',
        },
    ],
);

annotate service.Tickets with {
    ticketNumber @Common.Label : 'Ticket Number';
    subject @Common.Label : 'Subject';
    description @Common.Label : 'Description';
    status @(   
        Common.Label : 'Status',
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Statuses',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : status_name,
                    ValueListProperty : 'name',
                },
            ],
        },
        Common.ValueListWithFixedValues : true,
    );    
    priority @(   
        Common.Label : 'Priority',
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Priorities',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : priority_name,
                    ValueListProperty : 'name',
                },
            ],
        },
        Common.ValueListWithFixedValues : true,
    );    
    category @(   
        Common.Label : 'Category',
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Categories',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : category_name,
                    ValueListProperty : 'name',
                },
            ],
        },
        Common.ValueListWithFixedValues : true,
    );
    agent @(
        Common.Label : 'Assigned Agent',
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Agents',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : agent_ID,
                    ValueListProperty : 'ID',
                    
                },       
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',                                    
                    ValueListProperty : 'email',
                },
            ],
        },
        Common.ValueListWithFixedValues : true,
        Common.ExternalID : agent.name,
    )
};


annotate service.Agents with {
    name @Common.Label : 'Name';
    email @Common.Label : 'Email'
};

annotate service.Comments with @(
    UI.LineItem #TicketComments : [
        {
            $Type : 'UI.DataField',
            Value : createdAt,
        },
        {
            $Type : 'UI.DataField',
            Value : ticket.comments.text,
        },
    ]
);

annotate service.Comments with {
    text @Common.Label : 'Comment'
};

