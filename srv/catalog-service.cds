using { ticketing.system as db } from '../db/schema';

service Catalog {
    entity Categories as projection on db.Categories;
    entity Agents as projection on db.Agents;
    entity Tickets as projection on db.Tickets;
    entity Comments as projection on db.Comments;
}