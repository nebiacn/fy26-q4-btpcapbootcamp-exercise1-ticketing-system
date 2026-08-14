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

type Email : String(111);

entity Categories : managed {
    key name : String(111);    
}

entity Agents : cuid, managed {
    name : String(111);
    email : Email;    
}

entity Tickets : cuid, managed {
    ticketNumber : String(111);
    subject : String(111);
    description : String(1000);
    status : TicketStatus default 'OPEN';
    priority : Priority default 'LOW';
    category : Association to Categories;
    agent : Association to Agents;
    comments : Composition of many Comments
                on comments.ticket = $self;
}

@readonly
entity Comments : cuid, managed {
    ticket : Association to Tickets;
    text : String(1000);
}