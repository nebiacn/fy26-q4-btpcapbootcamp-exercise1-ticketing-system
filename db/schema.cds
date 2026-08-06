namespace ticketing.system;

using {
    managed,
    cuid,
} from '@sap/cds/common';

type TicketStatus : String enum {
    open = 'OPEN';
    inProgress = 'IN_PROGRESS';
    resolved = 'RESOLVED';
    closed = 'CLOSED';
}

type Priority : String enum {
    low = 'LOW';
    medium = 'MEDIUM';
    high = 'HIGH';
    urgent = 'URGENT';
}

entity Categories : cuid, managed {
    name : String(111);    
}

entity Agents : cuid, managed {
    name : String(111);
    email : String(111);    
}

entity Tickets : cuid, managed {
    ticketNumber : String(111);
    subject : String(111);
    description : String(111);
    status : TicketStatus;
    priority : Priority;
    category : Association to Categories;
    agent : Association to Agents;
    comments : Composition of many Comments
                on comments.ticket = $self;
}

entity Comments : cuid, managed {
    ticket : Association to Tickets;
    text : String;
}