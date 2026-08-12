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
                Value : status,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Priority',
                Value : priority,
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
            Label : 'Ticket Number',
            Value : ticketNumber,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Subject',
            Value : subject,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Status',
            Value : status,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Priority',
            Value : priority,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Category',
            Value : category_name,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Assigned Agent',
            Value : agent.name,
        },
    ],
    UI.SelectionFields : [
        status,
        priority,
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
);

annotate service.Tickets with {
    category @(
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
        Common.Label : 'Category',
    )
};

annotate service.Tickets with {
    agent @(
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
        Common.Label : 'Assigned Agent',
        Common.ExternalID : agent.name,

    )
};

annotate service.Tickets with {
    status @Common.Label : 'Status'
};

annotate service.Tickets with {
    priority @Common.Label : 'Priority'
};

annotate service.Tickets with {
    ticketNumber @Common.Label : 'Ticket Number'
};

annotate service.Tickets with {
    subject @Common.Label : 'Subject'
};

annotate service.Agents with {
    name @Common.Label : 'Name'
};

annotate service.Agents with {
    email @Common.Label : 'Email'
};

annotate service.Comments with {
    text @Common.Label : 'Comment'
};

annotate service.Comments with @(
    UI.LineItem #TicketComments : [
        {
            $Type : 'UI.DataField',
            Value : ticket.ticketNumber,
            Label : 'Ticket',
        },
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

