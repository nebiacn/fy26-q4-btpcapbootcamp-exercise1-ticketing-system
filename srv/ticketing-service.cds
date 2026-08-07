using { ticketing.system as db } from '../db/schema';

service Catalog {
    entity Categories as projection on db.Categories;
    entity Agents as projection on db.Agents;
    entity Tickets as projection on db.Tickets actions {
        action closeTicket(resolutionComment: String) returns Tickets;
        action reassignTicket(agentID : UUID) returns Tickets;
    };
    entity Comments as projection on db.Comments;
}